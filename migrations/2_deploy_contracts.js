var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");
var Tracking = artifacts.require("./TraceabilityOfFairTrade.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.deploy(Tracking);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
};
