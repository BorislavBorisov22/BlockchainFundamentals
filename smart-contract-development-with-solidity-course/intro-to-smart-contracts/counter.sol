pragma solidity ^0.4.18;

contract Counter {
    uint256 value;
    uint256 times;

    function Counter() public {
        value = 0;
        times = 0;
    }

    function incrementBy(uint256 _value) public returns (uint256 , uint256) {
        value += _value;
        times++;

        return (value, times);
    }
}
