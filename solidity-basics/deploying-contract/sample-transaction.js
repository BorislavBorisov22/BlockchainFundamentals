const Web3 = require('web3');
const solc = require('solc');
const deployContract = require('./deploy-contract');

const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

const getBalanceInEther = (web3, account) => {
    if (!(web3 && account)) {
        throw new Error('Both web3Object and account must be provided to function');
    }

    const balanceInEther = web3.fromWei(web3.eth.getBalance(account), 'ether').toNumber();
    return balanceInEther;
};

const aliceAccount = web3.eth.accounts[0];
const bobAccount = web3.eth.accounts[1];


// transaction from alice to bob :)
web3.eth.sendTransaction({ from: aliceAccount, to: bobAccount, value: web3.toWei(10, 'ether') });

const contract = deployContract(bobAccount);
console.log(contract, 'deployed contract');
// const resultString = contract.sayHi();