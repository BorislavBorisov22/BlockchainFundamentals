const ICO = artifacts.require('../contracts/ICO.sol')
const { duration, increaseTimeTo } = require('./helpers/increaseTime');

contract('DDNSCore', ([owner, wallet, anotherAccount]) => {
    let sut;
    let events = [];

    before(() => {
        web3.eth.defaultAccount = owner;
    });

    beforeEach(async() => {
        sut = await ICO.new();
    });

    it('expect to buy token at price 1 eth per token in presale state', async() => {

    });
});