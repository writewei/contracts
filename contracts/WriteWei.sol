pragma solidity 0.5.0;

contract WriteWei {

  /**
   * An updateable markdown document stored on IPFS.
   **/
  struct Document {
    uint256 index;
    string cid;
    address author;
    uint256 timestamp;
    uint256 updatedTimestamp;
    uint256 weiValue;
  }

  Document[] documents;

  /**
   * Document balances by index
   *
   * Documents are not added here until initial payment occurs
   **/
  mapping (uint256 => uint256) documentBalances;

  /**
   * Descending list of document indexes by total value
   **/
  uint256[] documentsByValue;

  /**
   * Descending list of document indexes by last modified
   **/
  uint256[] documentsByTime;


  function publishDocuments(string memory _cid) public {
    documents.push(Document({
      index: documents.length,
      cid: _cid,
      author: msg.sender,
      timestamp: block.timestamp,
      updatedTimestamp: block.timestamp,
      weiValue: 0
    }));
  }

  function updateDocument(uint256 index, string memory _cid) public {
    require(index < documents.length);
    require(msg.sender == documents[index].author);
    documents[index].cid = _cid;
  }

  function payDocument(uint256 index) public payable {
    require(index < documents.length);
    documents[index].weiValue += msg.value;
    documentBalances[index] += msg.value;
  }

  function withdrawDocumentBalance(uint256 index, address payable receiver) public {
    require(index < documents.length);
    documentBalances[index] = 0;
    receiver.transfer(documentBalances[index]);
  }

}
