pragma solidity ^0.4.17;

import "./owned.sol";

contract Killable is Owned {
    
    function kill() public OwnerOnly {
        selfdestruct(owner);
    }
}