pragma solidity ^0.4.10;

contract Admined {
    address public admin;
    
    function Admined() public {
        admin = msg.sender;
    }
    
    modifier onlyAdmin {
        if (msg.sender != admin){
            revert();
        } else {
            _;
        }
    }
    
    function transferAdminship(address _newAdmin) public onlyAdmin {
        admin = _newAdmin;
    }
}

contract Token {
    mapping (address => uint256) public balanceOf;
    string public tokenName;
    string public tokenSymbol;
    
    uint256 totalSupply;
    uint8 public decimal;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    function Token(uint _initalSupply, string _tokenName, string _tokenSymbol, uint8 _decimalUnits) public {
        balanceOf[msg.sender] = _initalSupply;
        totalSupply = _initalSupply;
        
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        decimal = _decimalUnits;
    }
    
    function transfer(address _to, uint256 _amount) public {
        if (balanceOf[msg.sender] < _amount) {
            revert();
        }
        
        // overflow check
        if (balanceOf[_to] + _amount < balanceOf[_to]) {
            revert();
        }
        
        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;
        Transfer(msg.sender, _to, _amount);
    }
}

contract AssetToken is Admined, Token {
    
    function AssetToken(uint _initalSupply, string _tokenName, string _tokenSymbol, uint8 _decimalUnits, address _admin)
     Token(_initalSupply, _tokenName, _tokenSymbol, _decimalUnits) public {
         
        if (_admin != 0){
            admin = admin;
        }
    }
    
    function mintToken(address _target, uint256 _amount) public onlyAdmin {
        balanceOf[_target] += _amount;
        totalSupply += _amount;
        
        Transfer(this, _target, _amount);
    } 
}
