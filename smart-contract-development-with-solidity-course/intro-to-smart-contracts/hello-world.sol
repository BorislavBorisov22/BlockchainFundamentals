pragma solidity ^0.4.18;

contract Greeting {
    string greeting;

    function Greeting(string _greeting) public {
        greeting = _greeting;
    }

    function greet() public view returns(string) {
        return greeting;
    }
}
