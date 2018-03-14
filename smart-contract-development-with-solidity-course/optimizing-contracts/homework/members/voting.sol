
pragma solidity ^0.4.20;

library VotingLib {
    struct Proposal {
        address receiver;
        uint amount;
        uint votes;
        bool closed;
        mapping(address => bool) memberVoted;
    }
    
    function vote(Proposal storage self, address voter, uint importancePoints) internal {
        require(!self.memberVoted[voter]);
        self.votes += importancePoints;
        self.memberVoted[voter] = true;
    }
    
    function close(Proposal storage self) internal {
        self.closed = true;
    }
    
    function isApproved(Proposal storage self, uint totalImportancePoints) internal view returns(bool) {
        return self.closed && self.votes >= (totalImportancePoints / 2);
    }
}

contract Voting {
    using VotingLib for VotingLib.Proposal;
    
    address owner;
    
    uint totalImportancePoints;
    mapping (address => uint) memberToImportancePoints;
    mapping (address => VotingLib.Proposal) proposals;
    
    function Votin() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyMember {
        require(memberToImportancePoints[msg.sender] > 0);
        _;
    }
    
    function init(address[] addresses, uint[] importancePoints) public onlyOwner {
        require(addresses.length >= importancePoints.length);
        
        for (uint index = 0; index < addresses.length; index++) {
            totalImportancePoints += importancePoints[index];
            memberToImportancePoints[addresses[index]] = importancePoints[index];
        }
    }
    
    function propose(address receiver, uint amount) public onlyOwner {
        require(address(this).balance >= amount);
        
        proposals[receiver] = VotingLib.Proposal(receiver, amount, 0, false);
    }
    
    function vote(address voteFor) public onlyMember {
        proposals[voteFor].vote(msg.sender, memberToImportancePoints[msg.sender]);
    }
    
    function withdraw() public {
        require(proposals[msg.sender].isApproved(totalImportancePoints));
        require(proposals[msg.sender].amount <= address(this).balance);
        
        msg.sender.transfer(proposals[msg.sender].amount);
    }
}