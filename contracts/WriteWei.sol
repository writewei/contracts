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
    uint256 updatedTimestamp;
    uint256 weiValue;
  }

  Document[] public documents;

  struct DocumentUpdate {
    uint256 documentIndex;
    string oldCid;
    string newCid;
    uint256 timestamp;
  }

  /**
   * Document balances by index
   *
   * Documents are not added here until initial payment occurs
   **/
  mapping (uint256 => uint256) public documentBalances;

  /**
   * Descending list of document indexes by total value
   **/
  uint256[] documentsByValue;

  /**
   * Infinite list of document updates, load from end
   **/
  DocumentUpdate[] documentUpdates;

  /**
   * Create a new document entry using an IPFS cid
   **/
  function createDocument(string memory _cid) public {
    documents.push(Document({
      index: documents.length,
      cid: _cid,
      author: msg.sender,
      timestamp: block.timestamp,
      updatedTimestamp: block.timestamp,
      weiValue: 0
    }));
  }

  /**
   * Update the cid for a document
   **/
  function updateDocument(uint256 index, string memory _cid) public {
    require(index < documents.length);
    require(msg.sender == documents[index].author);
    documentUpdates.push(DocumentUpdate({
      documentIndex: index,
      oldCid: documents[index].cid,
      newCid: _cid,
      timestamp: block.timestamp
    }));
    documents[index].cid = _cid;
  }

  /**
   * Send ether to the author of a document
   **/
  function payDocument(uint256 index) public payable {
    require(index < documents.length);
    documents[index].weiValue += msg.value;
    documentBalances[index] += msg.value;
  }

  /**
   * Withdraw the balance from a document to the author
   **/
  function withdrawDocumentBalance(uint256 index) public {
    require(index < documents.length);
    documentBalances[index] = 0;
    documents[index].author.transfer(documentBalances[index]);
  }

  /**
   * The number of document update entries
   **/
  function documentUpdateCount() public view returns (uint256) {
    return documentUpdates.length;
  }

  /**
   * The number of documents
   **/
  function documentCount() public view returns (uint256) {
    return documents.length;
  }

}
