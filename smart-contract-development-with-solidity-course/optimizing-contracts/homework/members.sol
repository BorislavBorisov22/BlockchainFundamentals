pragma solidity ^0.4.19;

contract Members {
    // removed struct beacuse we would already know the address 
    // as it is the key of the mapping
    uint joinedAt; //timestamp
    
    address owner;
    
    mapping(address => uint) public members;
    
    function Members() public {
        owner = msg.sender;
    }
    
    // ectract seperate init function
    // as it would be cheaper this operations are not part of the construtor
    function init(address[] addresses) public  {
        require(msg.sender == owner);
        for(uint i = 0; i < addresses.length; i++) {
            members[addresses[i]] = now;
        }
    }
}