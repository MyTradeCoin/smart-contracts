import ether from './helpers/ether';
import {increaseTimeTo, duration} from './helpers/increaseTime';

const BigNumber = web3.BigNumber

const should = require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(web3.BigNumber))
  .should();

const Token = artifacts.require('MYTCToken.sol')
const PreTge = artifacts.require('PreTge.sol')

contract('pretge contract tests', function(accounts) {

  let token;
  let pretge;
  before(setUpVars);
  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by testrpc
    //await advanceBlock();
  });
  beforeEach(async function () {
    token = await Token.new();
    console.log("token: " + token);
    pretge = await PreTge.new();

    await pretge.setToken(token.address);
    await pretge.addStage(20,this.salePrice);
    await pretge.setSoftcap(this.softcap);
    await pretge.setStart(this.start);
    await pretge.setPeriod(this.period);
    await pretge.setMinInvestment(this.minInvestedLimit);
    await token.setSaleAgent(pretge.address);  

  });

  it('sale agent in token must be the current sales contract address', async function () {
    const owner = await token.saleAgent();
    owner.should.equal(pretge.address);
  });

  it('token should start with a totalSupply of 0', async function () {
    const totalSupply = await token.totalSupply();
    assert.equal(totalSupply, 0);
  });

  it('should reject investments before sale', async function () {
    
    console.log('Now' + Date.now());
    console.log('start'+ this.start);
    //attempt to make transaction when start date has been moved forward
    await pretge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.rejectedWith('revert');
  });

  it('should allow investments after sale begins', async function () {
    //set time after sale to begin sale
    console.log('Increase time after start date')
    await increaseTimeTo(this.start + 86400);
    await pretge.sendTransaction({value: this.minInvestedLimit, from: accounts[1]}).should.be.fulfilled;

  });

  
});

//set up variables in the contract for testing
function setUpVars() {
  this.softcap = 3;//in ethers
  this.WalletPercent = 50;
  this.minInvestedLimit = ether(0.1);
  this.salePrice = 10000;

  this.start = 1533124800; //Aug 1st, 2018 GMT
  this.period = 30; // 30 days
  this.end = this.start + (this.period * 86400);//start plus period in UNIX days
  this.beforeSale = 1532952000; //-1 day from start
  this.afterSale = this.start + 86400; //+1 day after start
}
