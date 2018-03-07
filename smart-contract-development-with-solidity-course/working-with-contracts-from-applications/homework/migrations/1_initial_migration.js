var Migrations = artifacts.require("./Migrations.sol");
const Pokemon = require('./Pokemon.sol');

module.exports = function(deployer) {
    deployer.deploy(Migrations);
};