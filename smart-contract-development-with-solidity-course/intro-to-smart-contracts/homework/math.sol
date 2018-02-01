pragma solidity ^0.4.18;

contract Math {

    int public value;

    function Math() public {
        value = 0;
    }

    function add(int _numberToAdd) public returns (int) {
        value += _numberToAdd;
        return value;
    }

    function subtract(int _numberToSubtract) public returns (int) {
        value -= _numberToSubtract;
        return value;
    }

    function multiply(int _numberToMultiply) public returns (int) {
        value *= _numberToMultiply;
        return value;
    }

    function divide(int _numberToDivide) public returns (int) {
        value /= _numberToDivide;
        return value;
    }

    function power(uint _power) public returns (int) {
        bool isPowerEven = _power % 2 == 0;
        bool isValueNegative = value < 0;

        value = isValueNegative ? value * (-1) : value;
        uint castedNumber = uint(value);

        uint poweredNumber = castedNumber ** _power;
        value = isValueNegative && !isPowerEven ?
            int(poweredNumber) * (-1) :
             int(poweredNumber);
    }

    function getState() public view returns (int) {
        return value;
    }

    function resetState() public {
        value = 0;
    }
}
