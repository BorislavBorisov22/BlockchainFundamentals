const SimpleWallet = artifact.require('./SimpleWallet.sol');

module.exports = function(deployer) {
    deployer.deply(SimpleWallet);
};