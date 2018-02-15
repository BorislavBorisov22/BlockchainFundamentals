pragma solidity ^0.4.18;

contract State {
    
    address public owner;
    struct LastIncrementIfo {
        uint counter;
        uint timestamp;
        address contributor;
    }
    
    LastIncrementIfo public lastIncrementInfo;
    
    enum ContractState { Locked, Unlocked, Restricted }
    ContractState public currentState;
    
    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }
    
    modifier canFunctionBeCalled {
        require(currentState != ContractState.Locked);
        require((currentState == ContractState.Unlocked) || (msg.sender == owner));
        _;
    }
    
    function State() public {
        owner = msg.sender;
        currentState = ContractState.Locked;
    }
    
    function changeState(ContractState newState) public ownerOnly {
        currentState = newState;
    }
    
    function increment() public canFunctionBeCalled {
        lastIncrementInfo.contributor = msg.sender;
        lastIncrementInfo.counter++;
        lastIncrementInfo.timestamp = now;
    }
}
