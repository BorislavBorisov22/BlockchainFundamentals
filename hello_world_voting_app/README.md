## Usage

### Usage of voting system
1. Installing dependencies
```bash
npm/yarn install
```
2. Running the in-memory test blockchain
```bash
npm run blockchain
```
3. Deploying our contract
```bash
npm run contract:deploy
```
4. Copy the address of the deployed contract from the terminal running the test blockchain and replace the current contract address variable's value with the copied one

5. Run the following command and your application will be ready and running on localhost:8080
```bash
npm start
```
2. Open another terminal and copy code below
```javascript
cd hello_world_voting
node
var fs = require('fs');
var http = require('http');
var Web3 = require('web3');
var solc = require('solc');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
code = fs.readFileSync('Voting.sol').toString();
compiledCode = solc.compile(code);
abiDefinition = JSON.parse(compiledCode.contracts[':Voting'].interface);
VotingContract = web3.eth.contract(abiDefinition);
byteCode = compiledCode.contracts[':Voting'].bytecode;
deployedContract = VotingContract.new(['Rama','Nick','Jose'],{data: byteCode, from: web3.eth.accounts[0], gas: 4700000});
deployedContract.address;

```
3. copy output and paste it in hello_world_voting/index.js at 5-th line.
Open index.html and you have test decentralized voting system working with etherium;
