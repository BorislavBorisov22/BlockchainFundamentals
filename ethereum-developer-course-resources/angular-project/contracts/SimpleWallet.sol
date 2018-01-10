pragma solidity ^0.4.16;


contract SimpleWallet {
    address owner;
    mapping(address => bool) isAllowedToSendFunds;

    event Deposit(address _sender, uint _amount);
    event Withdraw(address _sender, uint _amount, address _beneficiary);

    function SimpleWallet() {
        owner = msg.sender;
    }

    modifier isAllowedToSend {
        if (msg.sender != owner && !isAllowedToSendFunds[msg.sender]) {
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

    function sendFunds(uint _amount, address _receiver) isAllowedToSend public returns (uint) {
        if (this.balance >= _amount) {
            bool sendSuccess = _receiver.send(_amount);
            if (!sendSuccess) {
                revert();
            }

            Withdraw(msg.sender, _amount, _receiver);
        } else {
            revert();
        }
    }

    function allowAdressToSendMoney(address _address) ownerOnly public {
        isAllowedToSendFunds[_address] = true;
    }

    function disallowAdressToSendMoney(address _address) ownerOnly public {
        isAllowedToSendFunds[_address] = false;
    }

    function isAddressAllowedToSend() public constant returns (bool) {
        return isAllowedToSendFunds[msg.sender] || msg.sender == owner;
    }

    function killWaller() ownerOnly public {
        selfdestruct(owner);
    }
}
