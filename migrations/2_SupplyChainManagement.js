const SupplyChainManagement = artifacts.require("SupplyChainManagement");

module.exports = function(deployer) {
  deployer.deploy(SupplyChainManagement);
};
