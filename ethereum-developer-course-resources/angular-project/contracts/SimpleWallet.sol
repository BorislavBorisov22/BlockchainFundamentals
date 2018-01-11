pragma solidity ^0.4.16;


contract SimpleWallet {

    struct WithdrawStruct {
        address to;
        uint amount;
    }

    struct Senders {
        bool isAllowed;
        uint sendsCount;
        mapping(uint => WithdrawStruct) withdraws;
    }

    address owner;
    mapping(address => Senders) isAllowedToSendFunds;

    event Deposit(address _sender, uint _amount);
    event Withdraw(address _sender, uint _amount, address _beneficiary);

    function SimpleWallet() {
        owner = msg.sender;
    }

    modifier isAllowedToSend {
        if (msg.sender != owner && !isAllowedToSendFunds[msg.sender].isAllowed) {
            revert();
        } else {
            _;
        }
    }

    modifier ownerOnly {
        if (msg.sender != owner) {
            revert();
        } else {
            _;
        }
    }

    function donate() payable {
        Deposit(msg.sender, msg.value);
    }

    function sendFunds(uint _amount, address _receiver) isAllowedToSend public returns (uint) {
        if (this.balance >= _amount) {
            bool sendSuccess = _receiver.send(_amount);
            if (!sendSuccess) {
                revert();
            }

            isAllowedToSendFunds[msg.sender].sendsCount++;
            isAllowedToSendFunds[msg.sender].withdraws[isAllowedToSendFunds[msg.sender].sendsCount].to = _receiver;
            isAllowedToSendFunds[msg.sender].withdraws[isAllowedToSendFunds[msg.sender].sendsCount].amount = _amount;            
            Withdraw(msg.sender, _amount, _receiver);
        } else {
            revert();
        }
    }

    function allowAdressToSendFunds(address _address) ownerOnly public {
        isAllowedToSendFunds[_address].isAllowed = true;
    }

    function disallowAdressToSendFunds(address _address) ownerOnly public {
        isAllowedToSendFunds[_address].isAllowed = false;
    }

    function isAddressAllowedToSend(address _address) public constant returns (bool) {
        return isAllowedToSendFunds[_address].isAllowed || _address == owner;
    }

    function killWaller() ownerOnly public {
        selfdestruct(owner);
    }

    function getOwner() constant returns (address) {
        return owner;
    }
}
