pragma solidity ^0.4.18;

contract OwnerIncrement {
    uint public state;
    address public owner;
    uint public lastModified;

    function OwnerIncrement() public {
        owner = msg.sender;
        lastModified = 0;
    }
    
    function increment() public returns(uint) {
        if (msg.sender == owner && now - lastModified >= 15) {
            state++;
            lastModified = now;
        }
        
        return state;
    }
}
