pragma solidity ^0.4.18;

contract Faucet {
    
    address public owner;
    uint public sendAmount = 1 ether;
    
    function Faucet() public payable {
        owner = msg.sender;
    }
    
    // fallback function
    function() public payable { }
    
    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }
    
    modifier hasEnoughAmount(uint amount) {
        require(this.balance >= amount);
        _;
    }
    
    event WithDrawal(uint amount, address widthdrawedBy);
    
    function getBalance() public view returns (uint) {
        return this.balance;
    }
    
    function changeSendAmount(uint _newSendAmount) public ownerOnly {
        sendAmount = _newSendAmount;
    }
    
    function sendAmountToAddress(address _to) public hasEnoughAmount(sendAmount) {
        uint oldBalance = this.balance;
        _to.transfer(sendAmount);
        
        assert(oldBalance == this.balance + sendAmount);
    }
    
    function withdraw(uint _amount) public ownerOnly hasEnoughAmount(_amount) {
        uint oldBalance = this.balance;
        owner.transfer(_amount);
        assert(oldBalance == this.balance + _amount);
        
        WithDrawal(_amount, owner);
    }
    
    function destory() public ownerOnly {
        selfdestruct(owner);
    }
}
