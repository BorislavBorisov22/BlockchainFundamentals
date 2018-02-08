pragma solidity ^0.4.18;

contract Ownership {
    address public owner;
    
    function Ownership() public {
        owner = msg.sender;
    }
    
    event OwnershipTransferred(address oldOwner, address newOwner);
    
    function transferOwnership(address newOwner) public {
        if (msg.sender == owner) {
            address oldOwner = owner;
            owner = newOwner;
            OwnershipTransferred(oldOwner, newOwner);
        }
    }
}
