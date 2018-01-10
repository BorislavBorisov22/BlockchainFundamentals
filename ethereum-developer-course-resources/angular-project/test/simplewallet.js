const SimpleWallet = artifacts.require('./SimpleWallet.sol');

contract('SimpleWallet', (accounts) => {
    it('owner should be allowed to send funds', (done) => {
        SimpleWallet.deployed()
            .then(instance => {
                return instance.isAddressAllowedToSend(accounts[0], { from: accounts[0] });
            })
            .then(isAllowed => {
                assert.equal(isAllowed, true, "Owner should be allowed to send funds!");
            })
            .then(done, done);
    });

    it('other account should not be allowed to send funds', (done) => {
        SimpleWallet.deployed()
            .then(instance => {
                return instance.isAddressAllowedToSend(accounts[1], { from: accounts[0] });
            })
            .then(isAllowed => {
                assert.equal(isAllowed, false, 'other account should not be allowed to send funds!');
            })
            .then(done, done);
    });

    it('adding account to allowed', (done) => {
        let instance;
        SimpleWallet.deployed()
            .then(contractInstance => {
                instance = contractInstance;
                return instance.allowAdressToSendFunds(accounts[1], { from: accounts[0] });
            })
            .then(() => {
                return instance.isAddressAllowedToSend(accounts[1], { from: accounts[0] });
            })
            .then(isAllowed => {
                assert.equal(isAllowed, true, 'account should be allowed to send funds when owner has allowed him to!');
            })
            .then(done, done);
    });
});