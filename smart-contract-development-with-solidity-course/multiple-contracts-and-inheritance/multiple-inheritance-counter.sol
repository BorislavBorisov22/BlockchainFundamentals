pragma solidity ^0.4.17;

contract Owned {
    address public owner;

    function Owned() public {
        owner = msg.sender;
    }

    modifier OwnerOnly {
        require(msg.sender == owner);
        _;
    }

    function transfer(address to) public {
        owner = to;
    }
}

contract SafeMath {

    function add(uint a, uint b) public pure returns(uint) {
        uint result = a + b;
        assert(result >= a);
        return result;
    }

    function mutiply(uint a, uint b) public pure returns(uint) {
        uint result = a * b;
        assert(result >= a);
        return result;
    }

    function subtract(uint a, uint b) public pure returns(uint) {
        assert(b >= a);
        return a - b;
    }
}

contract Counter is Owned, SafeMath {
    uint state;
    uint lastModified = now;

    function changeState() public returns(uint) {
        state = add(state, now % 256);
        state = mutiply(state, subtract(now, lastModified));
        state = subtract(state, block.gaslimit);
    }
}