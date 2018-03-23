const ICO = artifacts.require('../contracts/ICO.sol')
const { duration, increaseTime, increseTimeTo } = require('./helpers/increaseTime');
const assertRevert = require('./helpers/assertRevert');

contract('DDNSCore', ([owner, wallet, anotherAccount]) => {
    let sut;
    let events = [];

    before(() => {
        web3.eth.defaultAccount = owner;
    });

    beforeEach(async() => {
        sut = await ICO.new();
    });

    it('expect contract to be in presale when contract deployed', async () => {
        const result = await sut.isInPresale({ from: owner });
        assert(result === true);
    });

    it('expect isInPresale to return false when contract passed presale phase', async() => {
        await increaseTime(duration.weeks(14));
        const result = await sut.isInPresale({ from: owner });
        assert(!result);
    });


    it('expect contract to be in stage sale when presale ends', async () => {
        await increaseTime(duration.weeks(14));
        const result = await sut.isStageSale();
        assert(result === true);
    });

    it('expect isStageSale to return false when stage sale phase passed', async () => {
        await increaseTime(duration.weeks(30));
        const result = await sut.isStageSale();
        assert(!result);
    });

    it('expect sale to be over after both presale and stage phases have passed', async() => {
        await increaseTime(duration.weeks(30));
        const result = await sut.isSaleOver();
        assert(result === true);
    });

    it('expect isSaleOver to return false when presale has  not passed', async () => {
        const result = await sut.isSaleOver();
        assert(!result);
    });

    it('expect isSaleOver to return false when presale has not passed', async () => {
        await increaseTime(duration.weeks(14));
        const result = await sut.isSaleOver();
        assert(!result);
    });


    it('expect to buy token at price 1 eth per token in presale phase', async () => {
        const price = web3.toWei(2, 'ether');
        await sut.buyToken({ from: owner, value: price });

        const tokens = await sut.ownerToTokens(owner);
        assert(Number(tokens.toString()) === 2);
    });

    it('expect ot buy tokens at price 2 eth per token in stage phase', async () => {
        await increaseTime(duration.weeks(14));
        const price = web3.toWei(2, 'ether');
        await sut.buyToken({ from: owner, value: price });

        const tokens = await sut.ownerToTokens(owner);
        assert(Number(tokens.toString()) === 1);
    });

    it('expect to be able to transfer tokens correctly when sale is over', async () => {
        const price = web3.toWei(2, 'ether');
        await sut.buyToken({ from: owner, value: price });
        await increaseTime(duration.weeks(30));

        await sut.transferToken(1, anotherAccount, { from: owner });

        const senderTokens = await sut.ownerToTokens(owner);
        const receiverTokens = await sut.ownerToTokens(anotherAccount);

        assert(Number(senderTokens.toString()) === 1);
        assert(Number(receiverTokens.toString()) === 1);
    });

    it('expect to throw when user tries to send more tokens than he owns', async () => {
        const price = web3.toWei(2, 'ether');
        await sut.buyToken({ from: owner, value: price });
        await increaseTime(duration.weeks(30));

        const result = sut.transferToken(5, anotherAccount, { from: owner });

        await assertRevert(result);
    });


    it('expect to throw when user tries to send tokens while still token is in sale', async () => {
        const price = web3.toWei(2, 'ether');
        const result = sut.buyToken({ from: owner, value: price });
        assertRevert(result);
    });
});
