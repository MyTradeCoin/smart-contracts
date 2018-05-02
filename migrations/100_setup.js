var MYTCToken = artifacts.require("MYTCToken.sol")

module.exports = function(deployer) {
  deployer.deploy(MYTCToken);
};
