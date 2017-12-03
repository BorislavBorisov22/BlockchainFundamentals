pragma solidity ^0.4.10;

contract Coin {
    
    address public owner;
    uint public totalSupply;
    
    mapping(address => uint) public balances;
    
    function Coin(uint _totalSupply) public {
        owner = msg.sender;
        totalSupply = _totalSupply;
        balances[owner] += totalSupply;
    }
    
    event Transfer(address indexed _to, address indexed _from, uint value);
    event NewCoinLog(address _to, uint amout, uint _totalSupply);
    
    modifier onlyOwner(){
        if (msg.sender != owner) {
            revert();
        }else {
            // _; means that if check passes code will procede down.
            _;
        }
    }
    
    function getBalance(address _address) public constant returns (uint){
        return balances[_address];
    }
    
    function transfer(address _to, uint _amount) public returns (bool) {
        if (balances[msg.sender] < _amount || balances[_to] + _amount < balances[_to]) {
            revert();
        }
        
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        
        Transfer(_to, msg.sender, _amount);
        
        return true;
    }
    
    function mint(uint _amount) public onlyOwner returns (bool) {
        if (_amount < 0) revert();
        
        totalSupply += _amount;
        balances[owner] += _amount;
        
        NewCoinLog(owner, _amount, totalSupply);
    }
    
    function disable() onlyOwner public {
        selfdestruct(owner);
    }
}
