const fs = require('fs');
const http = require('http');
const Web3 = require('web3');
const solc = require('solc');
const path = require('path');

const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const code = fs.readFileSync(path.join(__dirname, './voting/Voting.sol')).toString();
const compiledCode = solc.compile(code);
const abiDefinition = JSON.parse(compiledCode.contracts[':Voting'].interface);

const VotingContract = web3.eth.contract(abiDefinition);
const byteCode = compiledCode.contracts[':Voting'].bytecode;
const deployedContract = VotingContract.new(['Rama', 'Nick', 'Jose'], { data: byteCode, from: web3.eth.accounts[0], gas: 4700000 });

console.log(abiDefinition, 'abiDefinition');
console.log(deployedContract.address, 'address');
console.log(web3.eth.accounts, 'available accounts');