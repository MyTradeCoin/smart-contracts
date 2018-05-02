const Configurator = artifacts.require('SetupTge')

const Token = artifacts.require('MYTCToken')

const crowdsale = artifacts.require('Tge')

const Presale = artifacts.require('PreTge')

contract('Tge - common test', function (accounts) {
  before(config);
  beforeEach(async function () {
    token = await Token.new();
    crowdsale = await Crowdsale.new();
    await token.setSaleAgent(crowdsale.address);
    await crowdsale.setToken(token.address);
    await crowdsale.setStart(this.start);
    await crowdsale.setPeriod(this.period);
    // await crowdsale.setPrice(this.price);
    // await crowdsale.setHardcap(this.hardcap);
    // await crowdsale.setMinInvestedLimit(this.minInvestedLimit);
    // await crowdsale.setWallet(this.wallet);
  });

  it('crowdsale should be a saleAgent for token', async function () {
    const owner = await token.saleAgent();
    console.log("this is contract address: ", crowdsale.address);
    owner.should.equal(crowdsale.address);
  });

});

// contract('Tge', function(accounts) {
//   it("should assert true", function(done) {
//     var tge = Tge.deployed();
//     assert.isTrue(true);
//     done();
//   });
// });
function config() {
  // variables list based on info from README
  this.start = unixTime('01 Mar 2018 00:00:00 GMT');
  this.period = 15;
  this.price = tokens(33334);
  this.hardcap = ether(8500);
  this.minInvestedLimit = ether(0.1);
  this.wallet = '0xa86780383E35De330918D8e4195D671140A60A74';

  // variables for additional testing convinience
  this.end = this.start + duration.days(this.period);
  this.beforeStart = this.start - duration.seconds(10);
  this.afterEnd = this.end + duration.seconds(1);
}