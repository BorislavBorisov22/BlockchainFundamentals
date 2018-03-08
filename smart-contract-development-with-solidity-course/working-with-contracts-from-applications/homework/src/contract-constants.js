const POKEMON_ABI = [{
        "anonymous": false,
        "inputs": [{
                "indexed": true,
                "name": "by",
                "type": "address"
            },
            {
                "indexed": true,
                "name": "pokemon",
                "type": "uint8"
            }
        ],
        "name": "LogPokemonCaught",
        "type": "event"
    },
    {
        "constant": false,
        "inputs": [{
            "name": "pokemon",
            "type": "uint8"
        }],
        "name": "catchPokemon",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [{
            "name": "person",
            "type": "address"
        }],
        "name": "getPokemonsByPerson",
        "outputs": [{
            "name": "",
            "type": "uint8[]"
        }],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [{
            "name": "pokemon",
            "type": "uint8"
        }],
        "name": "getPokemonHolders",
        "outputs": [{
            "name": "",
            "type": "address[]"
        }],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    }
];

// place deployed contract address here
const POKEMON_ADDRESS = '0xd8c3389311ae0e7b657a8186d2dade4036091cc8';

module.exports = {
    POKEMON_ABI,
    POKEMON_ADDRESS
};