pragma solidity ^0.4.10;

contract CrowdFund {
    
    address public beneficiary;
    uint public goal;
    uint public deadline;
    
    mapping (address => uint) funders;
    address[] totalFundersArr;
    
    function CrowdFund(address _address, uint _goal, uint _deadline) public {
        beneficiary = _address;
        goal = _goal;
        deadline = now + _deadline;
    }
    
    event Contribution(uint _amount, uint _totalAmountRemaining);
    
    modifier beneficiaryOnly() {
        if (msg.sender != beneficiary) {
            revert();
        } else {
            _;
        }
    }
    
    function currentFunding() public constant returns (uint) {
        return this.balance;
    }
    
    function totalFunders() public constant returns (uint) {
        return totalFundersArr.length;
    }
    
    function contribute() public payable {
        if (funders[msg.sender] == 0) {
            totalFundersArr.push(msg.sender);
        }
        
        funders[msg.sender] += msg.value;
        Contribution(msg.value, goal - this.balance);
    }
    
    function payout() public {
        if (now > deadline && this.balance >= goal) {
            beneficiary.transfer(this.balance);
        }
    }
    
    function refund() public {
        if (now > deadline && this.balance < goal) {
            msg.sender.transfer(funders[msg.sender]);
            funders[msg.sender] = 0;
        }
    }
    
    function disable() public beneficiaryOnly {
        if (this.balance != 0) {
            revert();
        }
        
        selfdestruct(beneficiary);
    }
}
