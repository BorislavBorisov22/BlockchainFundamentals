const fs = require('fs');
const path = require('path');
const solc = require('solc');
const Web3 = require('web3');

const deployHelloWorldContract = (owner) => {
    const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
    const contractCode = fs.readFileSync(path.join(__dirname, './helloworld.sol')).toString();
    const compiledCode = solc.compile(contractCode);

    const abiDefinition = JSON.parse(compiledCode.contracts[':HelloWorld'].interface);

    const contract = web3.eth.contract(abiDefinition);
    const byteCode = compiledCode.contracts[':HelloWorld'].bytecode;
    const deployedContract = contract.new({ from: owner, data: byteCode, gas: 470000, gasPrice: 1 },
        (error, contract) => {
            if (!error) {
                console.log('Success deploying contract!');
            }
        });

    return deployedContract;
};

module.exports = deployHelloWorldContract;