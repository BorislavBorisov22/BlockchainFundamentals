pragma solidity ^0.4.17;

contract Owned {

    address owner;

    function Owned() public {
        owner = msg.sender;
    }

    modifier OwnerOnly {
        require(msg.sender == owner);
        _;
    }

    function transfer(address to) public OwnerOnly {
        owner = to;
    }
}