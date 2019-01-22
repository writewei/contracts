const WriteWei = artifacts.require('WriteWei');
const assert = require('assert');
const BN = require('bn.js');

contract('WriteWei', accounts => {
  it('should create a document', async () => {
    const _contract = await WriteWei.deployed();
    const contract = new web3.eth.Contract(_contract.abi, _contract.address);
    const documentCid = 'QmaafpMEtK4ts455XJ2EyWXxuLzgi2hR8jNUjH2CMToXdn';
    const author = accounts[0];
    await contract.methods.createDocument(documentCid).send({
      from: author,
      gas: 300000
    });
    const documentIndex = await contract.methods.documentCount().call() - 1;
    const createdDocument = await contract.methods.documents(documentIndex).call();
    assert.equal(createdDocument.cid, documentCid);
    assert.equal(createdDocument.author, author);
  });

  it('should pay a document', async () => {
    const _contract = await WriteWei.deployed();
    const contract = new web3.eth.Contract(_contract.abi, _contract.address);
    const documentCid = 'QmaafpMEtK4ts455XJ2EyWXxuLzgi2hR8jNUjH2CMToXdn';
    const author = accounts[0];
    const paymentValue = 1000;
    await contract.methods.createDocument(documentCid).send({
      from: author,
      gas: 300000
    });
    const documentIndex = await contract.methods.documentCount().call() - 1;
    const oldAuthorBalance = await contract.methods.authorBalances(author).call();
    await contract.methods.payDocument(documentIndex).send({
      from: accounts[1],
      value: paymentValue,
      gas: 300000
    });
    const authorBalance = await contract.methods.authorBalances(author).call();
    assert.equal(authorBalance - oldAuthorBalance, paymentValue);
  });

  it('should delete a document', async () => {
    const _contract = await WriteWei.deployed();
    const contract = new web3.eth.Contract(_contract.abi, _contract.address);
    const documentCid = 'QmaafpMEtK4ts455XJ2EyWXxuLzgi2hR8jNUjH2CMToXdn';
    const author = accounts[0];
    await contract.methods.createDocument(documentCid).send({
      from: author,
      gas: 300000
    });
    const documentIndex = await contract.methods.documentCount().call() - 1;
    // Should fail from another account
    await assert.rejects(contract.methods.deleteDocument(documentIndex).send({
      from: accounts[1],
      gas: 300000
    }));
    // Author should delete
    await contract.methods.deleteDocument(documentIndex).send({
      from: author,
      gas: 300000
    });
    const createdDocument = await contract.methods.documents(documentIndex).call();
    assert.equal(createdDocument.isDeleted, true);
    assert.equal(createdDocument.cid, '');
  });
});
