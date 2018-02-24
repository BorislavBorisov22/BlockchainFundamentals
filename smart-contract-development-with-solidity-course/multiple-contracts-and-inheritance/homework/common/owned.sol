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