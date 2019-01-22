pragma solidity 0.5.0;

contract WriteWei {

  /**
   * An IPFS address tied to a balance that can be paid to.
   **/
  struct Document {
    uint256 index;
    string cid;
    address author;
    uint256 timestamp;
    uint256 weiValue;
    bool isDeleted;
  }

  Document[] public documents;

  /**
   * Author balances
   **/
  mapping (address => uint256) public authorBalances;

  event DocumentUpdated(uint256 index);
  event BalanceUpdated(address payable target);

  /**
   * Create a new document entry using an IPFS cid
   **/
  function createDocument(string memory _cid) public {
    documents.push(Document({
      index: documents.length,
      cid: _cid,
      author: msg.sender,
      timestamp: block.timestamp,
      weiValue: 0,
      isDeleted: false
    }));
    emit DocumentUpdated(documents.length - 1);
  }

  /**
   * Delete a document entry from the blockchain. Marks isDeleted true and
   * clears the cid
   **/
  function deleteDocument(uint256 index) public {
    require(index < documents.length);
    require(msg.sender == documents[index].author);
    documents[index].isDeleted = true;
    documents[index].cid = '';
    emit DocumentUpdated(index);
  }

  /**
   * Send ether to the author of a document
   **/
  function payDocument(uint256 index) public payable {
    require(index < documents.length);
    documents[index].weiValue += msg.value;
    authorBalances[documents[index].author] += msg.value;
    emit DocumentUpdated(index);
    emit BalanceUpdated(documents[index].author);
  }

  /**
   * Withdraw the balance from contract to author
   **/
  function withdraw() public {
    uint256 balance = authorBalances[msg.sender];
    authorBalances[msg.sender] = 0;
    msg.sender.transfer(balance);
    emit BalanceUpdated(msg.sender);
  }

  /**
   * The number of documents
   **/
  function documentCount() public view returns (uint256) {
    return documents.length;
  }

}
