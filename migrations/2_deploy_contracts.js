const WriteWei = artifacts.require('WriteWei');

module.exports = function(deployer, _, accounts) {
  deployer.deploy(WriteWei);
};
