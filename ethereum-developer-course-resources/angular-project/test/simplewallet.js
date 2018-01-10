const SimpleWallet = artifacts.require('./SimpleWallet.sol');

contract('SimpleWallet', (accounts) => {
    it('owner should be allowed to send funds', (done) => {
        SimpleWallet.deployed()
            .then(instance => {
                return instance.isAddressAllowedToSend({ from: accounts[0] });
            })
            .then(isAllowed => {
                assert.equal(isAllowed, true, "Owner should be allowed to send funds!");
            })
            .then(done, done);
    });
});