pragma solidity ^0.4.18;

contract Consensus {
    
    address[] public owners;
    
    struct Proposal {
        uint amount;
        address receiver;
        uint startedAt;
    }
    
    Proposal public currentProposal;
    uint public nextToApprove = 0;
    
    function Consensus(address[] _owners) public payable {
        owners = _owners;
    }
    
    modifier ownerOnly {
        bool ownerFound = false;
        for (uint i = 0; i < owners.length; ++i) {
            if (owners[i] == msg.sender) {
                ownerFound = true;
                break;
            }
        }
        
        require(ownerFound);
        _;
    }
    
    modifier hasEnoughAmount(uint amount) {
        require(this.balance >= amount);
        _;
    }
    
    modifier canPropose {
        require(now - currentProposal.startedAt >= 5 minutes);
        _;
    }
    
    function() public payable { }
    
    function createProposal(address _receiver, uint _amount) public hasEnoughAmount(_amount) canPropose {
        currentProposal = Proposal({
            receiver: _receiver,
            amount: _amount,
            startedAt: now
        });
        
        nextToApprove = 0;
    }
    
    function approve() public ownerOnly {
        require(now - currentProposal.startedAt <= 5 minutes);
        require(owners[nextToApprove] == msg.sender);
        require(currentProposal.amount <= this.balance);
        
        nextToApprove++;
        if (nextToApprove >= owners.length) {
            currentProposal.receiver.transfer(currentProposal.amount);
            delete currentProposal;
        }
    }
    
    function getBalance() public view returns (uint) {
        return this.balance;
    }
}
