pragma solidity ^0.4.17;

library MembersData {

    struct Member {
        uint lastDonation;
        address adr;
        uint donatedAmount;
        uint lastDonationValue;
    }

    struct Data {
        uint membersCount;
        mapping(address => Member) members;
        mapping(address => uint) approvalsCount;
        mapping(address => mapping(address => bool)) memberApprovals;
        mapping(address => bool) approvedMembers;
    }

    modifier isMember(Data storage data, address adr) {
        require(data.approvedMembers[adr]);
        _;
    }

    function addNewMemeber(Data storage data, address newMemberAddress) internal {
        data.members[newMemberAddress] = Member({
            adr: newMemberAddress,
            lastDonation: 0,
            lastDonationValue: 0,
            donatedAmount: 0
        });

        data.approvedMembers[newMemberAddress] = true;
    }

    function voteForMember(Data storage data, address memberToAdd) public isMember(data, msg.sender) returns (bool success) {
        require(!data.memberApprovals[memberToAdd][msg.sender]);
        require(!data.approvedMembers[memberToAdd]);

        data.memberApprovals[memberToAdd][msg.sender] = true;
        data.approvalsCount[memberToAdd]++;

        if (data.approvalsCount[memberToAdd] >= data.membersCount / 2) {
            addNewMemeber(data, memberToAdd);
            // delete previous approvals of that member
        }

        return true;
    }

    function _removeOwner(Data storage data, address memberToRemove) internal {
         delete data.members[memberToRemove];
        // delete all approvals from the past;
        delete data.approvalsCount[memberToRemove];
    }

    function removeMember(Data storage data, address memberToRemove) public isMember(data, msg.sender) isMember(data, memberToRemove) {
        require(now - data.members[memberToRemove].lastDonation > 1 hours);

        _removeOwner(data, memberToRemove);
    }

    function donate(Data storage data, uint amount) public isMember(data, msg.sender) {
        data.members[msg.sender].donatedAmount += amount;
        data.members[msg.sender].lastDonation = now;
        data.members[msg.sender].lastDonationValue = amount;
    }
}