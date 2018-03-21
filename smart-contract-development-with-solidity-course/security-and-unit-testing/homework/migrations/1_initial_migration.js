var Migrations = artifacts.require("./Migrations.sol");
const ICO = artifacts.require('./ICO.sol');

module.exports = function(deployer) {
    deployer.deploy(ICO);
};