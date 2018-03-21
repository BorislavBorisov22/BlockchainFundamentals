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
    
    mapping(address => uint) ownerToTokens;
    
    function HomeworkCoin() public {
        icoStartedAt = now;
    }
    
    
    function isInPresale() public {
        return icoStartedAt + presaleDuration < now;
    }
    
    function isStageSale() public {
        return icoStartedAt + presaleDuration + stageDuration
    }
    
    function isSaleOver() public return (bool) {
        return !(isInPresale() || isInStageSale());
    }
    
    
    
    
}