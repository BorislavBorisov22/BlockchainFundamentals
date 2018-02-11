pragma solidity ^0.4.18;

contract ServiceAuction {

    address public owner;

    uint public servicePrice = 1 ether;
    uint public servicePurchaseInterval = 2 minutes;
    uint public serviceLastBoughTime = 0;
    
    uint public lastBalanceWithdrawTime = 0;
    uint public balanceWithdrawPeriod = 1 hours;
    uint public maxBalanceWithdrawalPerTime = 5 ether;

    function ServiceAuction() public payable {
        owner = msg.sender;
    }

    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }

    modifier canWithdraw(uint _amount) {
        require(_amount <= maxBalanceWithdrawalPerTime);
        require(now - lastBalanceWithdrawTime >= balanceWithdrawPeriod);
        _;
    }

    modifier canBuyService {
        require(now - serviceLastBoughTime >= servicePurchaseInterval);
        _;
    }

    modifier hasEnoughToBuyService(uint _amount) {
        require(_amount >= servicePrice);
        _;
    }
    
    event ServiceBought(address buyer, uint boughtAt);

    function withdraw(uint _amount) public ownerOnly canWithdraw(_amount) {
        uint oldBalance = this.balance;
        owner.transfer(_amount);
        assert(oldBalance == this.balance + _amount);
        
        lastBalanceWithdrawTime = now;
    }

    function buyService() public payable hasEnoughToBuyService(msg.value) {
        uint change = calculateChange(msg.value, servicePrice);
        if (change > 0) {
            msg.sender.transfer(change);
        }
        
        serviceLastBoughTime = now;
        ServiceBought(msg.sender, serviceLastBoughTime);
    }

    function calculateChange(uint _amount, uint _price) internal pure returns (uint) {
        return _amount - _price;
    }
    
    function getBalance() public view returns (uint) {
        return this.balance;
    }
}
