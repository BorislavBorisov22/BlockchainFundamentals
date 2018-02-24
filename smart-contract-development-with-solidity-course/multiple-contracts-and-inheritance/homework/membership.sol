pragma solidity ^0.4.17;

import "./common/killable.sol";
import "./libraries/members-operator.sol";

contract Membership is Killable {
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