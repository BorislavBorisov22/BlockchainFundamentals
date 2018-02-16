pragma solidity ^0.4.20;

contract Pokemon {
    bytes32[] public constant = [
        "Pikachu",
        "Charizard",
        "Mewto",
        "Eeve",
        "Mew",
        "Squirtle",
        "Bulbasaur",
        "Vulpix",
        "Entei",
        "Lapras"
    ];
    
    struct Owners {
        mapping(bytes32 => bool);
        uint lastClaimed;
    }
    
    mapping(address => mapping(bytes32 => bool)) public people;
    
    function Pokemon() public payable {
        
    }
    
    function claimPokemonCaught(bytes32 pokemonCaught) public isValidPokemon(pokemonCaught)
}