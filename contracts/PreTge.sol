pragma solidity ^0.4.18;

import "./CommonSale.sol";
import "./Tge.sol";

contract PreTge is CommonSale {

  //TGE 
  Tge public tge;

  /**
      * event for PreTGE finalization logging
      * @param finalizer account who trigger finalization
      * @param saleEnded time of log
      */
  event PreTgeFinalized(address indexed finalizer, uint256 saleEnded);

  /**
    * sets TGE to pass agent when sale is finished
    * @param newMainsale adress of TGE contract
    */
  function setMainsale(address newMainsale) public onlyOwner {
    tge = Tge(newMainsale);
  }

  /**
    * sets TGE as new sale agent when sale is finished
    */
  function setTgeAsSaleAgent() public whenNotPaused saleIsFinished onlyOwner {
    token.setSaleAgent(tge);
    PreTgeFinalized(msg.sender, now);
  }
}
