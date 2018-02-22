pragma solidity ^0.4.17;

contract Master {
    address owner;
    
    mapping(address => Agent) public agents;
    mapping(address => Agent) public queriedOrders;
    
    function Master() public {
        owner = msg.sender;
    }
    
    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }
    
    function createAgent() public ownerOnly returns(address) {
        Agent agent = new Agent(this);
        agents[agent] = agent;
        return agent;
    }
    
    function approveAgent(address agentAddress) public ownerOnly returns(address) {
        Agent agent = Agent(agentAddress);
        agents[agentAddress] = agent;
    }
    
    function queryAgent(address agentAddress) public{
        agents[agentAddress].order();
        queriedOrders[agentAddress] = agents[agentAddress];
    }
    
    function isAgentReady(address agentAddress) public returns(bool) {
        return agents[agentAddress].isReady();
    }
}

contract Agent {
    uint last = 0;
    
    address owner;
    
    function Agent(address _owner) public {
        owner = _owner;
    }
    
    modifier ownerOnly {
        require(owner == msg.sender);
        _;
    }
    
    function order() ownerOnly public {
         last = now;
    }
    
    function isReady() ownerOnly public returns(bool) {
        return now - last >= 15 seconds;
    }
}