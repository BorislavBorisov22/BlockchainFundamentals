pragma solidity 0.4.20;

//this contract is optimized, don't touch it.
contract Ownable {
    address public owner;
    
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    
    function Ownable() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}

//The objective is to have a contract that has members. The members are added by the owner and hold information about their address, timestamp of being added to the contract and amount of funds donated. Each member can donate to the contract.
//Many anti-patterns have been used to create them.
//Some logical checks have been missed in the implementation.
//Objective: lower the publish/execution gas costs as much as you can and fix the logical checks.

library MemberLibrary {
    struct Member {
        address adr;
        uint joinedAt;
        uint fundsDonated;
    }
    
    function donated(Member storage member, uint value) public {
        member.fundsDonated += value;
    }
    
    function get(Member storage member) internal view returns (address, uint, uint) {
        return (member.adr, member.joinedAt, member.fundsDonated);
    }
}

contract Membered is Ownable{
    using MemberLibrary for MemberLibrary.Member;
    
    mapping(address => MemberLibrary.Member) members;
    
    modifier onlyMember {
        require(members[msg.sender].joinedAt > 0);
        _;
    }
    
    function addMember(address adr) public onlyOwner {
        MemberLibrary.Member memory newMember = MemberLibrary.Member(adr, now, 0);
        
        members[adr] = newMember;
    }
    
    function donate() public onlyMember payable {
        require(msg.value > 0);
        
        members[msg.sender].donated(msg.value);
    }
}