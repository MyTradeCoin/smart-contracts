import ether from './helpers/ether';
import {increaseTimeTo, duration} from './helpers/increaseTime';
import tokens from './helpers/tokens';
import unixTime from './helpers/unixTime';
import {advanceBlock} from './helpers/advanceToBlock';

const BigNumber = web3.BigNumber

const should = require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();

const Token = artifacts.require('MYTCToken.sol')
const Tge = artifacts.require('Tge.sol')


contract('Tge contract tests', function (accounts) {
  let token;
  let tge;
  before(setUpVars);
  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by testrpc
    //await advanceBlock();
  });
  beforeEach(async function () {
    token = await Token.new();
    tge = await Tge.new();

    await tge.setToken(token.address);
    await tge.addStage(100,this.salePrice);
    await tge.setSoftcap(this.softcap);
    await tge.setSlaveWalletPercent(this.WalletPercent);
    await tge.setReservedTokensPercent(this.ReservedTokensPercent);
    await tge.setTeamTokensPercent(this.TeamTokensPercent);
    await tge.setBountyTokensPercent(this.BountyTokensPercent);
    await tge.setReservedTokensWallet(this.ReservedTokensWallet);
    await tge.setTeamTokensWallet(this.TeamTokensWallet);
    await tge.setBountyTokensWallet(this.BountyTokensWallet);
    await tge.setStart(this.start);
    await tge.setPeriod(this.period);
    await tge.setLockPeriod(this.lockPeriod);
    await tge.setMinInvestment(this.minInvestedLimit);
    await tge.setTotalTokenSupply(this.tokensLimit);    
    await token.setSaleAgent(tge.address);  

  });

  it('sale agent in token must be the current sales contract address', async function () {
    const owner = await token.saleAgent();
    owner.should.equal(tge.address);
  });

  it('should return mintingFinished as false when init', async function () {
    const mintingFinished = await token.mintingFinished();
    assert.equal(mintingFinished, false);
  });

  it('token should start with a totalSupply of 0', async function () {
    const totalSupply = await token.totalSupply();
    assert.equal(totalSupply, 0);
  });

  it('token should return mintingFinished false after construction', async function () {
    const mintingFinished = await token.mintingFinished();
    assert.equal(mintingFinished, false);
  });

  it('lastSaleDate() should return start + duration', async function () {
    const end = await tge.lastSaleDate();
    console.log("end date:" + end);
    end.should.bignumber.equal(this.end);
  });

  it('should not allowed investments before sale', async function () {
    
    console.log('Now' + Date.now());
    console.log('start'+ this.start);
    //attempt to make transaction when start date has been moved forward
    await tge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.rejectedWith('revert');
  });  

  it('should not allow investments if address not added to whitelist', async function () {
    //set time after sale to begin sale
    console.log('Increase time after start date')
    await increaseTimeTo(this.start + 86400);
    await tge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.rejectedWith('revert');

  });

  it('should allow investments after sale begins', async function () {
    await tge.addToWhiteList(accounts[1]);
    await tge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.fulfilled;

  });

  it('should allow direct investments after sale begins', async function () {
    await tge.setDirectMintAgent(accounts[1], {from: accounts[0]});
    await tge.directMint(accounts[2], this.minInvestedLimit, {from: accounts[1]}).should.be.fulfilled;
  });

  it('verifies investor balance after purchase', async function () {
    await tge.addToWhiteList(accounts[1]);
    await tge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.fulfilled;
    const salePrice = new BigNumber(this.salePrice);
    var minted = this.minInvestedLimit.mul(salePrice);
    var balanceOf = await token.balanceOf(accounts[1]);
    console.log('balance'+ balanceOf);
    balanceOf.should.be.bignumber.equal(minted);
    
  });

  it('verifies number of coins minted after investment', async function () {
    await tge.addToWhiteList(accounts[1]);
    await tge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.fulfilled;
    const salePrice = new BigNumber(this.salePrice);
    var minted = this.minInvestedLimit.mul(salePrice);
    var totalSupply = await token.totalSupply();
    totalSupply.should.be.bignumber.equal(minted);
    
  });

  it('verifies correct number of tokens where minted to the right address destination', async function () {
    await token.setSaleAgent(accounts[1]);
    const expectedTokens = 350;

    const result = await token.mint(accounts[2], expectedTokens, {from: accounts[1]});

    const balance0 = await token.balanceOf(accounts[2]);
    assert.equal(balance0, expectedTokens);

    const totalSupply = await token.totalSupply();
    assert.equal(totalSupply, expectedTokens);
  });

  it('verifies transaction fails if mints from non-owner or sale agent accounts', async function () {
    await token.setSaleAgent(accounts[1]);
    await token.mint(accounts[2], 100, {from: accounts[2]}).should.be.rejectedWith('revert');
  });

  it('verifies sale mints only from sale agent', async function () {
    await token.setSaleAgent(accounts[1]);
    //use sale agent
    await token.mint(accounts[2], 200, {from: accounts[1]});
    const balance = await token.balanceOf(accounts[2]);

    console.log('current balance: ' + balance);
    assert.equal(balance, 200);
    
  });

  it('verifies transfer fails during sale period', async function () {
    await tge.addToWhiteList(accounts[1]);
    await tge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.fulfilled;
    const transferred = new BigNumber(1);
    const salePrice = new BigNumber(this.salePrice);
    const minted = this.minInvestedLimit.mul(salePrice);
    var transferredValue = minted.mul(transferred);
    await token.transfer(accounts[2], transferredValue, {from: accounts[1]}).should.be.rejectedWith('revert');

  });

  it('verifies transaction fails when trying to transfer to 0x0', async function () {
    await tge.addToWhiteList(accounts[1]);
    await tge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.fulfilled;
    await token.transfer(0x0, 100, {from: accounts[1]}).should.be.rejectedWith('revert');
  });

  it('verifies transaction fails when trying to transfer more than current balance', async function () {
    await tge.addToWhiteList(accounts[1]);
    await tge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.fulfilled;
    await token.transfer(accounts[2], this.minInvestedLimit * 2, {from: accounts[1]}).should.be.rejectedWith('revert');
  });

  it('should fail to call endSale when sale is not finished', async function () {
    await tge.endSale({from: accounts[0]}).should.be.rejectedWith('revert');;
  });

  it('should fail to call endSale when sale is paused', async function () {
    await tge.pause();
    await tge.endSale({from: accounts[0]}).should.be.rejectedWith('revert');;
  });

  it('verify token calculation for marketing wallet', async function () {
    console.log('simulate sales transactions');
    await tge.addToWhiteList(accounts[1]);
    await tge.addToWhiteList(accounts[2]);
    await tge.sendTransaction({value: ether(3), from: accounts[1]});
    await tge.sendTransaction({value: ether(7), from: accounts[2]});

    const owner = await tge.owner();
    await tge.endSale({from: owner});
    const totalSupply = await token.totalSupply();
 
    const firstInvestorTokens = await token.balanceOf(accounts[1]);
    const secondInvestorTokens = await token.balanceOf(accounts[2]);

    const bountyTokens = await token.balanceOf(this.BountyTokensWallet);
    const expectedBountyBalance = totalSupply.mul(this.BountyTokensPercent / 100);
    expectedBountyBalance.should.be.bignumber.equal(bountyTokens);
  });

  it('verify token calculation for team wallet', async function () {
    console.log('simulate sales transactions');
    await tge.addToWhiteList(accounts[1]);
    await tge.addToWhiteList(accounts[2]);
    await tge.sendTransaction({value: ether(3), from: accounts[1]});
    await tge.sendTransaction({value: ether(7), from: accounts[2]});

    const owner = await tge.owner();
    await tge.endSale({from: owner});
    const totalSupply = await token.totalSupply();

    const teamTokens = await token.balanceOf(this.TeamTokensWallet);

    const expectedTeamBalance = totalSupply.mul(this.TeamTokensPercent / 100);
    expectedTeamBalance.should.be.bignumber.equal(teamTokens);
    

  });

  it('verify token calculation for reserved wallets', async function () {
    console.log('simulate sales transactions');
    await tge.addToWhiteList(accounts[1]);
    await tge.addToWhiteList(accounts[2]);
    await tge.sendTransaction({value: ether(3), from: accounts[1]});
    await tge.sendTransaction({value: ether(7), from: accounts[2]});
    const totalSupplyBeforeSale = await token.totalSupply();
    const owner = await tge.owner();
    await tge.endSale({from: owner});
    const totalSupply = await token.totalSupply();

    const reservedTokens = await token.balanceOf(this.ReservedTokensWallet); 
    const bountyTokens = await token.balanceOf(this.BountyTokensWallet);
    const teamTokens = await token.balanceOf(this.TeamTokensWallet);
    const expectedReservedBalance = totalSupply.sub((bountyTokens.add(teamTokens).add(totalSupplyBeforeSale)));

    expectedReservedBalance.should.be.bignumber.equal(reservedTokens);

  });

  //END OF SALE
  it('should reject investments after sale ends', async function () {
    console.log('Increase time after end date');
    await increaseTimeTo(this.end);
    await tge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.rejectedWith('revert');
  });

  it('should reject direct investments after sale ends', async function () {

    await tge.directMint(accounts[2], this.minInvestedLimit, {from: accounts[0]}).should.be.rejectedWith('revert');
  });

  it('should reject calling finishMinting from accounts different to owner', async function () {

    await tge.endSale({from: accounts[2]}).should.be.rejectedWith('revert');
  });

  it('should fail to mint after call to finishMinting', async function () {
    await token.setSaleAgent(accounts[1]);
    await token.finishMinting({from: accounts[1]}).should.be.fulfilled;
    const mintingFinished = await token.mintingFinished({from: accounts[1]});
    assert.equal(mintingFinished, true);
    await token.mint(accounts[2], 100, {from: accounts[1]}).should.be.rejectedWith('revert');
  });

});



//set up variables in the contract for testing
function setUpVars() {
  this.softcap = 3;//in ethers
  this.TeamTokensPercent = 18;
  this.BountyTokensPercent = 3;
  this.ReservedTokensPercent = 25;
  this.WalletPercent = 50;
  this.BountyTokensWallet = '0xb283C324333fB8473f20856EfD40Fe1129aF3B70';
  this.ReservedTokensWallet = '0xa8975045141D1E4cEBbA8DF4061b7d738F01DF5e';
  this.TeamTokensWallet = '0x2150C0a297f5a7456FdD618586Db51F6Da75f833';
  this.lockPeriod = 15 // in days
  this.minInvestedLimit = ether(0.1);
  this.salePrice = 2000;
  this.tokensLimit = 100000000000000000000000;//100000 tokens

  this.start = 1535803200; //Sept 1st, 2018 GMT
  this.period = 30; // 30 days
  this.end = this.start + (this.period * 86400);//start plus period in UNIX days
  this.beforeSale = 1535630400; //-1 day from start
  this.afterSale = this.start + 86400; //+1 day after start
}