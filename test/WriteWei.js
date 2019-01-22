const WriteWei = artifacts.require('WriteWei');
const assert = require('assert');
const BN = require('bn.js');

contract('WriteWei', accounts => {
  it('should create a document', async () => {
    const _contract = await WriteWei.deployed();
    const contract = new web3.eth.Contract(_contract.abi, _contract.address);
    await contract.methods.createDocument('test');
  });
});
