import ether from './helpers/ether';
import duration from './helpers/increaseTime';
import tokens from './helpers/tokens';
import unixTime from './helpers/unixTime';

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
  beforeEach(async function () {
    token = await Token.new();
    console.log("token: " + token);
    tge = await Tge.new();

    await tge.setToken(token.address);
    await tge.addStage(2,2000);
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
    await token.setSaleAgent(tge.address);  

  });

  it('sale agent in token must be the current sales contract address', async function () {
    const owner = await token.saleAgent();
    owner.should.equal(tge.address);
  });

  it('lastSaleDate() should return start + duration', async function () {
    const end = await tge.lastSaleDate();
    console.log("end date:" + end);
    end.should.bignumber.equal(this.end);
  });

});



//set up variables in the contract for testing
function setUpVars() {
  this.softcap = 3;//in ethers
  this.TeamTokensPercent = 18;
  this.BountyTokensPercent = 5;
  this.ReservedTokensPercent = 25;
  this.WalletPercent = 50;
  this.BountyTokensWallet = '0xb283C324333fB8473f20856EfD40Fe1129aF3B70';
  this.ReservedTokensWallet = '0xa8975045141D1E4cEBbA8DF4061b7d738F01DF5e';
  this.TeamTokensWallet = '0x2150C0a297f5a7456FdD618586Db51F6Da75f833';
  this.lockPeriod = 15 // in days
  this.minInvestedLimit = ether(0.1);

  this.start = 1531008000; //July 8th, 2018 GMT
  this.period = 30; // 30 days
  this.end = this.start + (this.period * 86400);//start plus period in UNIX days
  this.beforeSale = 1530921600; //-1 day from start
  this.afterSale = this.end + 86400; //+1 day after start
}