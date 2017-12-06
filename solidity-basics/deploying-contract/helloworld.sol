pragma solidity ^0.4.0;

contract HelloWorld
{
    string public message;

    function helloWorld() {
        message = "Hello world";
    }

    function sayHi() constant returns (string) {
        return message;
    }
}
