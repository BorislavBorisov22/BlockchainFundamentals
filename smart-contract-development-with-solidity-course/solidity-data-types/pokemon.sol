pragma solidity ^0.4.19;

contract PokemonContract {
    enum Pokemon {
        Pikachu,
        Charizard,
        Mewto,
        Eeve,
        Mew,
        Squirtle,
        Bulbasaur,
        Vulpix,
        Entei,
        Lapras
    }
    
    uint public constant catchClaimInterval = 15 seconds;
    
    struct PokemonOwner {
        uint lastCatchClaim;
        bool[10] ownedPokemons;
    }
    
    address[][10] public pokemonsByOwners;
    mapping(address => PokemonOwner) public addressToPokemonOwner;
    
    function claimCatch(Pokemon caughtPokemon) public returns (bool success) {
        require(now - addressToPokemonOwner[msg.sender].lastCatchClaim >= catchClaimInterval);
        
        addressToPokemonOwner[msg.sender].lastCatchClaim = now;
        if (addressToPokemonOwner[msg.sender].ownedPokemons[uint(caughtPokemon)]) {
            return false;
        }
        
        addressToPokemonOwner[msg.sender].ownedPokemons[uint(caughtPokemon)] = true;
        pokemonsByOwners[uint(caughtPokemon)].push(msg.sender);
    }
    
    function getPokemonOwners(Pokemon pokemon) public view returns (address[]) {
        return pokemonsByOwners[uint(pokemon)];
    }
    
    function getOwnersPokemons(address adr) public view returns (bool[10]) {
        return addressToPokemonOwner[adr].ownedPokemons;
    }
}
