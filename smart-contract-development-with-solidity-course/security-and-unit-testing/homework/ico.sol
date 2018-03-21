pragma solidity 0.4.21;

library SafeMath {
	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
		if (_a == 0) {
			return 0;
		}
		uint256 c = _a * _b;
		assert(c / _a == _b);
		return c;
	}

	function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
		uint256 c = _a / _b;
		return c;
	}

	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
		assert(_b <= _a);
		return _a - _b;
	}

	function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
		uint256 c = _a + _b;
		assert(c >= _a);
		return c;
	}
}

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
        owner.transfer(address(this).balance);
    }
}

contract HomeworkCoin is Owned {
    using SafeMath for uint;
    
    uint public constant presaleDuration = 1 years / 4;
    uint public constant stageDuration = 1 years / 4;
    uint public constant tokenPresalePrice = 1 ether;
    uint public constant tokenStagePrice = 2 ether;
    
    uint public icoStartedAt = 0;
    
    mapping(address => uint) public ownerToTokens;

    event TokenTransfer(address from, address to, uint amount);

    modifier hasEnoughFunds(address adr, uint amount) {
        require(ownerToTokens[adr] >= amount);
        _;
    }

    modifier saleOver {
        require(isSaleOver());
        _;
    }

    function HomeworkCoin() public {
        icoStartedAt = now;
    }
    
    
    function isInPresale() public view returns(bool) {
        return icoStartedAt + presaleDuration >= now;
    }
    
    function isStageSale() public view returns(bool) {
        return !isInPresale() && icoStartedAt + presaleDuration + stageDuration >= now;
    }
    
    function isSaleOver() public view returns (bool) {
       return !(isInPresale() || isStageSale());
    }

    function transferToken(uint amount, address receiver) public hasEnoughFunds(msg.sender, amount) saleOver {
        ownerToTokens[msg.sender].sub(amount);
        ownerToTokens[receiver].add(amount);

       emit TokenTransfer(msg.sender, receiver, amount);
    }

    function buyToken() public payable {
        require(!isSaleOver());

        uint tokenPrice = getTokenCurrentPrice();
        uint tokensCount = msg.value.div(tokenPrice);

        ownerToTokens[msg.sender] = tokensCount;
    }

    function getTokenCurrentPrice() internal view returns(uint) {
        return isInPresale() ? tokenPresalePrice : tokenStagePrice;
    }
}