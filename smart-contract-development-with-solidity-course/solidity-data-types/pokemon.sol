pragma solidity ^0.4.20;

contract Pokemon {
    string[10] public pokemons = ["Pikachu",
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
    
    struct PokemonOwner {
        address adr;
        uint lastClaimed;
        mapping(string => bool) ownsPokemon;
        uint pokemonsCount;
    }
    
    uint claimInterval = 15 seconds;
    mapping(address => PokemonOwner) public pokemonOwners;
    address[] public allOwners;
    mapping(address => bool) public uniqueOwners;
    
    function Pokemon() public payable {}
    
    modifier canClaim(address claimant) {
        require(now - pokemonOwners[claimant].lastClaimed >= claimInterval);
        _;
    }
    
    modifier validPokemon(string name) {
        bool isValid = false;
        for (uint i =0; i < 10; i++) {
            if (keccak256(name) == keccak256(pokemons[i])) {
                isValid = true;
                break;
            }
        }
        
        require(isValid);
        _;
    }
    
    function() public payable { }
    
    function claimPokemonCatch(string caughtPokemon) public canClaim(msg.sender) validPokemon(caughtPokemon) {
        require(!pokemonOwners[msg.sender].ownsPokemon[caughtPokemon]);
        pokemonOwners[msg.sender].ownsPokemon[caughtPokemon] = true;
        pokemonOwners[msg.sender].pokemonsCount++;
        if (!uniqueOwners[msg.sender]) {
            uniqueOwners[msg.sender] = true;
            allOwners.push(msg.sender);
        }
    }
}
