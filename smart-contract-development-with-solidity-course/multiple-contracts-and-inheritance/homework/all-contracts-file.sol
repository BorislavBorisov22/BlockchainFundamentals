pragma solidity ^0.4.17;

contract Owned {
    address owner;
    
    function Owned() public {
        owner = msg.sender;
    }
    
    modifier OwnerOnly {
        require(owner == msg.sender);
        _;
    }
    
    function transferOwnership(address newOwner) public OwnerOnly {
        owner = newOwner;
    }
    
    function withdraw() public OwnerOnly {
        owner.transfer(this.balance);
    }
}

contract Killable is Owned {
    function kill() public OwnerOnly {
        selfdestruct(owner);
    }   
}


library MembersOperator {
    using SafeMath for uint;
    
    struct Member {
        uint lastDonationAmount;
        uint totalDonationAmount;
        uint timeOfLastDonation;
    }
    
    struct Data {
        mapping(address => Member) members;
        mapping(address => bool) approvedMembers;
        mapping(address => mapping(address => bool)) addressApprovals;
        mapping(address => uint) approvalsCount;
        uint totalMembersCount;
    }
    
    function voteForMember(Data storage self, address voter, address votedFor) internal {
        require(self.approvedMembers[voter]);
        // require that the voting address hasn't already voted for the proposed member
        require(!self.addressApprovals[votedFor][voter]);
        // required that the votedForPerson is not already a member
        require(!self.approvedMembers[votedFor]);
        
        self.addressApprovals[votedFor][voter] = true;
        self.approvalsCount[votedFor] = self.approvalsCount[votedFor].add(1);
        
        // if half of the members voted for the new member then approve him and add him as one
        if (self.approvalsCount[votedFor] > self.totalMembersCount / 2) {
            _addMember(self, votedFor);
        }
    }
    
    function isMember(Data storage self, address adr) internal view returns(bool) {
        return self.approvedMembers[adr];
    }
    
    function removeMember(Data storage self, address removeProposer, address addressToRemove) internal {
        // check if the one proposing removal is also a member
        require(self.approvedMembers[removeProposer]);
        // check if the proposed address is a member at all
        require(self.approvedMembers[addressToRemove]);
        // check if the address hasnt donated in the last hours so he can be removed
        require(now - self.members[addressToRemove].timeOfLastDonation >= 1 hours);
        
        _removeMember(self, addressToRemove);
        
        // should practically never happen but that's what asserts are for;
        assert(self.totalMembersCount >= 0);
    }
    
    function addDonation(Data storage self, address donator, uint amount) internal {
        // only members donations are saved as info
        require(self.approvedMembers[donator]);
        
        //   uint lastDonationAmount;
        // uint totalDonationAmount;
        // uint timeOfLastDonation;
        
        self.members[donator].lastDonationAmount = amount;
        self.members[donator].totalDonationAmount = self.members[donator].totalDonationAmount.add(amount);
        self.members[donator].timeOfLastDonation = now;
    }
    
    function getMemberInfo(Data storage self, address member) internal view
        returns (uint lastDonation, uint totalDonations, uint timeOfLastDonation) {
            lastDonation = self.members[member].lastDonationAmount;
            totalDonations = self.members[member].totalDonationAmount;
            timeOfLastDonation = self.members[member].timeOfLastDonation;
            
            return (lastDonation, totalDonations, timeOfLastDonation);
        }
    
    function _removeMember(Data storage self, address adr) internal {
        self.approvedMembers[adr] = false;
        delete self.members[adr];
        self.totalMembersCount = self.totalMembersCount.sub(1);
    }
    
    function _addMember(Data storage self, address memeberToAdd) internal {
        self.approvedMembers[memeberToAdd] = true;
        self.totalMembersCount = self.totalMembersCount.add(1);
    }
}

contract Membership is Killable {
    using SafeMath for uint;
    using MembersOperator for MembersOperator.Data;
    
    MembersOperator.Data membersData;
    
    function Membership() public {
        // adding owner to members list
        membersData._addMember(msg.sender);
    }
    
    function() public payable { }
    
    function voteForNewMember(address newMember) public {
        membersData.voteForMember(msg.sender, newMember);
    }
    
    function donate() public payable {
        membersData.addDonation(msg.sender, msg.value);
    }
    
    function removeMember(address memberToRemove) public {
        membersData.removeMember(msg.sender, memberToRemove);
    }
    
    function isMember(address adr) public view returns(bool) {
        return membersData.isMember(adr);
    }
    
    function getMemberInfo(address adr) public view returns (uint lastDonation, uint totalDonations, uint timeOfLastDonation){
        return membersData.getMemberInfo(adr);
    }
    
    function totalMembersCount() public view returns(uint) {
        return membersData.totalMembersCount;
    }
}