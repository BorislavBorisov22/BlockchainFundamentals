pragma solidity ^0.4.19;

contract PeopleBalances {
    
    struct TokenHolder {
        bool hasHeldTokens;
        uint tokensCount;
    }
    
    uint public constant exchangeRate = 5;
    uint public constant tokenPrice = (1 ether) / exchangeRate;
    uint public crowdSaleTimespan = 5 minutes;
    uint public withdrawalTimespan = 1 years;
    
    uint public contractInitTime;
    address public owner;
    
    mapping(address => TokenHolder) ownerToToken;
    address[] public tokenHolders;
    
    function PeopleBalances() public {
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
            
            // multiplying by 1 ether so if we buy for example tokens for 1 wei we would have tokenCount 5 which would mean 0.0000000000000000000001 tokens, 
            // and for 1 ether we would have tokenCount 1000000000000000000 which would mean 1 token 
            uint tokensCount = (msg.value * (1 ether)) / tokenPrice;
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
    
    function getTokenBalance(address adr) public view returns (uint) {
        return ownerToToken[adr].tokensCount;
    }
    
    function withDraw() public ownerOnly {
        require(now - contractInitTime >= withdrawalTimespan);
        
        owner.transfer(this.balance);
    }
    
    function contractBalance() public view returns (uint) {
        return this.balance;
    } 
    
    function hasBeenTokenOwner(address adr) public view returns(bool) {
        return ownerToToken[adr].hasHeldTokens;
    }
}
