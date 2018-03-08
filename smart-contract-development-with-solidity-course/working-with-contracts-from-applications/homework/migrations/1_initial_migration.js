var Migrations = artifacts.require("./Migrations.sol");
const Pokemons = artifacts.require('./Pokemons.sol');

module.exports = function(deployer) {
    // deployer.deploy(Migrations);
    deployer.deploy(Pokemons);
};