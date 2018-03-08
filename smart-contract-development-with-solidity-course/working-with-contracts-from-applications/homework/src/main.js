//this function will be called when the whole page is loaded
$ = jQuery = require('jquery');
require('../node_modules/bootstrap/dist/js/bootstrap');
const toastr = require('toastr');

window.addEventListener('load', () => {
    if (typeof web3 === 'undefined') {
        //if there is no web3 variable
        toastr.error("Error! Are you sure that you are using metamask?");
    } else {
        toastr.success("Welcome to our DAPP!");
        init(POKEMON_ABI, POKEMON_ADDRESS);
    }
});

let contractInstance;

const { POKEMON_ABI, POKEMON_ADDRESS } = require('./contract-constants');
const { POKEMON_NAMES } = require('./pokemon-names');
let acc;

function init(abi, address) {
    const Contract = web3.eth.contract(abi);
    contractInstance = Contract.at(address);
    updateAccount();
}

function updateAccount() {
    //in metamask, the accounts array is of size 1 and only contains the currently selected account. The user can select a different account and so we need to update our account variable
    acc = web3.eth.accounts[0];
}

function openPokemonsModal(title) {
    const modal = document.getElementById('pokemonsModal');
    //const header = modal.querySelector('h1');
    //header.innerHTML = title;
    console.log(modal);
}

function setModalContent(content) {
    setTimeout(() => {
        const body = document.querySelector('.modal-body');
        body.innerHTML = '';

        content.forEach(c => {
            const pokeDiv = document.createElement('div');
            pokeDiv.innerHTML = c;
            body.appendChild(pokeDiv);
        });
    }, 1000)
}

function claimPokemonCatch(event) {
    updateAccount();

    const pokemonIndex = document.getElementById('pokemon-index-input').value;
    if (Number.isNaN(Number(pokemonIndex))) {
        toastr.error('passed pokemon index must be a number');
        return;
    }

    contractInstance.catchPokemon(pokemonIndex, { from: acc }, (err, res) => {
        if (err) {
            toastr.error('Error occured when trying to claim pokemon catch');
            return;
        }

        toastr.success(`Pokemon with index ${pokemonIndex} claimed as catch`);
    });
}

function seePokemons() {
    updateAccount();

    //TODO
    const targetAddress = document.getElementById('see-pokemons-input').value;
    if (!targetAddress || !targetAddress.length) {
        toastr.error('cannot check an empty address!');
        return;
    }

    contractInstance.getPokemonsByPerson(targetAddress, { from: acc }, (err, res) => {
        if (err) {
            toastr.error('Error occured while retrieving pokemons!');
            return;
        }

        const ownedPokemons = res.map(index => POKEMON_NAMES[index]);
        alert(`${targetAddress} owns: ${ownedPokemons}`);
    });
}

function seeOwners() {
    const pokemonIndex = document.getElementById('pokemon-index-input').value;
    if (Number.isNaN(Number(pokemonIndex))) {
        toastr.error('passed pokemon index must be a number');
        return;
    }

    contractInstance.getPokemonHolders(pokemonIndex, { from: acc }, (err, res) => {
        if (err) {
            toastr.error('Error occured when to see pokemons owners');
            return;
        }

        const targetPokemon = POKEMON_NAMES[parseInt(pokemonIndex)];
        alert(`${targetPokemon} is owned by: ${res}`);
    });
}

const claimPokemonButton = document.getElementById('claim-pokemon-btn');
claimPokemonButton.addEventListener('click', claimPokemonCatch);
const seePokemonsButton = document.getElementById('see-pokemons-btn');
seePokemonsButton.addEventListener('click', seePokemons);
const seeOwnersButton = document.getElementById('see-owners-btn');
seeOwnersButton.addEventListener('click', seeOwners);