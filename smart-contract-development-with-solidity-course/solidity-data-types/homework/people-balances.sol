pragma solidity ^0.4.19;

contract PeopleBalances {
    
    struct TokenHolder {
        bool hasHeldTokens;
        uint tokensCount;
    }
    
    uint public exchangeRate = 5;
    uint crowdSaleTimespan = 5 minutes;
    
    uint contractInitTime;
    address owner;
    
    mapping(address => TokenHolder) ownerToToken;
    address[] tokenHolders;
    
    function PeopleBalance() public {
        contractInitTime = now;
        owner = msg.sender;
    }
    
    modifier onCrowdsale {
        require(now - contractInitTime < crowdSaleTimespan);
        _;
    }
    
    modifier open {
        require(now - contractInitTime >= crowdSaleTimespan);
        _;
    }
    
    modifier ownerOnly {
        require(owner == msg.sender);
        _;
    }
    
    function exchangeToken() public payable onCrowdsale {
        if (msg.value > 0) {
            if (!ownerToToken[msg.sender].hasHeldTokens) {
                tokenHolders.push(msg.sender);
                ownerToToken[msg.sender].hasHeldTokens = true;
            }
        
            uint tokensCount = msg.value * 5;
            ownerToToken[msg.sender].tokensCount += tokensCount;
        }
    }
    
    function sendTokens(uint amount, address to) public open {
        require(to != address(0));
        require(ownerToToken[msg.sender].tokensCount >= amount);
        
        if (!ownerToToken[to].hasHeldTokens) {
            ownerToToken[to].hasHeldTokens = true;
            tokenHolders.push(to);
        }
        
        ownerToToken[to].tokensCount += amount;
        ownerToToken[msg.sender].tokensCount -= amount;
    }
    
    function withDraw() public ownerOnly {
        require(now - contractInitTime >= 1 years);
        
        owner.transfer(this.balance);
    }
}
