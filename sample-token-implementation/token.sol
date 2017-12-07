pragma solidity ^0.4.10;

interface tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
}

contract Owned {
    
    address owner;
    
    function Owned() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}

contract TokenERC20 is Owned{
    
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    
    uint256 public totalSupply;
    
    uint256 public buyPrice;
    uint256 public sellPrice;
    uint public minBalanceForAccounts;
    
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping(address => uint256)) public allowance;
    mapping (address => bool) public frozen;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _amount);
    event FrozenFunds(address indexed _fronzenAddress);
    event Burn(address indexed _from, uint256 _amount);
    
    function TokenERC20(string _name, string _symbol, uint256 _initialSupply, address _centralMinter) public {
        name = _name;
        symbol = _symbol;
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        
        owner = msg.sender;
        balanceOf[msg.sender] = _initialSupply;
        
        if (_centralMinter != 0x0){
            owner = _centralMinter;
        }
    }
    
    function _transfer(address _from, address _to, uint256 _amount) internal {
        // check if adress exists
        require (_from != 0x0);
        // check if sender has enough supply
        require(balanceOf[_from] >= _amount);
        // check for overflow
        require(balanceOf[_to] + _amount > balanceOf[_to]);
        
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        
        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;
        
        Transfer(_from, _to, _amount);
        
        // used for static analysys in code -> this should never fail :)
        assert(previousBalances == balanceOf[_from] + balanceOf[_to]);
    }
    
    function transfer(address _to, uint256 _amount) public {
        require(!frozen[msg.sender]);
        _transfer(msg.sender, _to, _amount);   
        
        if (balanceOf[msg.sender] < minBalanceForAccounts) {
            balanceOf[msg.sender] = minBalanceForAccounts;
        }
    }
    
    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        require(_amount <= allowance[_from][msg.sender]);
        
        _transfer(_from, _to, _amount);
        allowance[_from][msg.sender] -= _amount;
        
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != 0x0);
        require(_value <= balanceOf[msg.sender]);
        
        allowance[msg.sender][_spender] += _value;
        return true;
    }
    
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
        
        return false;
    }
    
    function burn(uint256 _amount) public returns (bool success) {
        require(balanceOf[msg.sender] >= _amount);
        require(balanceOf[msg.sender] > balanceOf[msg.sender] - _amount);
        
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        
        Burn(msg.sender, _amount);
        return true;
    }
    
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);
        require(allowance[_from][msg.sender] >= _value);
        
        allowance[_from][msg.sender] -= _value;
        balanceOf[_from] -= _value;
        totalSupply -= _value;
        
        Burn(_from, _value);
        
        return true;
    }
    
    function mintToken(address _target, uint256 _mintedAmout) public {
        balanceOf[_target] += _mintedAmout;
        totalSupply += _mintedAmout;
        
        Transfer(0, owner, _mintedAmout);
        Transfer(owner, _target, _mintedAmout);
    }
    
    function freezeAccount(address _target) public onlyOwner {
        frozen[_target] = true;
        FrozenFunds(_target);
    }
    
    function setPrice(uint256 _buyPrice, uint256 _sellPrice) public onlyOwner {
        buyPrice = _buyPrice;
        sellPrice = _sellPrice;
    }
    
    function buy() public payable returns (uint256) {
        uint256 amount = msg.value / buyPrice;
        
        require(balanceOf[this] >= amount);
        balanceOf[msg.sender] += amount;
        balanceOf[this] -= amount;
        
        Transfer(this, msg.sender, amount);
        return amount;
    }
    
    function sell(uint256 _amount) public returns (uint256 revenue) {
        require(balanceOf[msg.sender] >= _amount);
        
        _transfer(msg.sender, this, _amount);
        
        revenue = _amount * sellPrice;
        require(msg.sender.send(revenue));
        
        Transfer(msg.sender, this, _amount);
        return revenue;
    }
    
    function setMinBalanceForAccounts(uint minBalanceInFinney) public onlyOwner {
        minBalanceForAccounts = minBalanceInFinney * 1 finney;
    }
    
    function giveReward() public {
        balanceOf[block.coinbase] += 1;
    }
}
