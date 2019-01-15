pragma solidity 0.5.0;

contract WriteWei {

  struct Article {
    uint256 index;
    string cid;
    address author;
  }

  Article[] articles;

  function addArticle(string memory _cid) public {
    articles.push(Article({
      index: articles.length,
      cid: _cid,
      author: msg.sender
    }));
  }
}
