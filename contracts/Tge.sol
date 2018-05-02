pragma solidity ^0.4.18;

import "./CommonSale.sol";

contract Tge is CommonSale {

  //Team wallet address
  address public teamTokensWallet;
  
  //Bounty and advisors wallet address
  address public bountyTokensWallet;

  //Reserved tokens wallet address
  address public reservedTokensWallet;
  
  //Team percentage
  uint public teamTokensPercent;
  
  //Bounty and advisors percentage
  uint public bountyTokensPercent;

  //Reserved tokens percentage
  uint public reservedTokensPercent;
  
  //Lock period in days for team's wallet
  uint public lockPeriod;  

  /**
      * event for TGE finalization logging
      * @param finalizer account who trigger finalization
      * @param saleEnded time of log
      */
  event TgeFinalized(address indexed finalizer, uint256 saleEnded);

  /**
    * sets lock period in days for team's wallet
    * @param newLockPeriod new lock period in days
    */
  function setLockPeriod(uint newLockPeriod) public onlyOwner {
    lockPeriod = newLockPeriod;
  }

  /**
    * sets percentage for team's wallet
    * @param newTeamTokensPercent new percentage for team's wallet
    */
  function setTeamTokensPercent(uint newTeamTokensPercent) public onlyOwner {
    teamTokensPercent = newTeamTokensPercent;
  }

  /**
    * sets percentage for bounty's wallet
    * @param newBountyTokensPercent new percentage for bounty's wallet
    */
  function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
    bountyTokensPercent = newBountyTokensPercent;
  }

  /**
    * sets percentage for reserved wallet
    * @param newReservedTokensPercent new percentage for reserved wallet
    */
  function setReservedTokensPercent(uint newReservedTokensPercent) public onlyOwner {
    reservedTokensPercent = newReservedTokensPercent;
  }

  /**
    * sets address for team's wallet
    * @param newTeamTokensWallet new address for team's wallet
    */
  function setTeamTokensWallet(address newTeamTokensWallet) public onlyOwner {
    teamTokensWallet = newTeamTokensWallet;
  }

  /**
    * sets address for bountys's wallet
    * @param newBountyTokensWallet new address for bountys's wallet
    */
  function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
    bountyTokensWallet = newBountyTokensWallet;
  }

  /**
    * sets address for reserved wallet
    * @param newReservedTokensWallet new address for reserved wallet
    */
  function setReservedTokensWallet(address newReservedTokensWallet) public onlyOwner {
    reservedTokensWallet = newReservedTokensWallet;
  }

  /**
    * Mints remaining tokens and finishes minting when sale is successful
    * No further tokens will be minted ever
    */
  function endSale() public whenNotPaused saleIsFinished onlyOwner {    
    uint remainingPercentage = bountyTokensPercent.add(teamTokensPercent).add(reservedTokensPercent);
    uint tokensGenerated = token.totalSupply();
    uint totalTokenSupply = tokensGenerated.mul(percentRate).div(percentRate.sub(remainingPercentage));
    uint foundersTokens = totalTokenSupply.mul(teamTokensPercent).div(percentRate);
    uint reservedTokens = totalTokenSupply.mul(reservedTokensPercent).div(percentRate);
    uint bountyTokens = totalTokenSupply.mul(bountyTokensPercent).div(percentRate); 
    mintTokens(reservedTokensWallet, reservedTokens);
    mintTokens(teamTokensWallet, foundersTokens);
    mintTokens(bountyTokensWallet, bountyTokens);   
    token.lock(teamTokensWallet, lockPeriod);      
    token.finishMinting();
    TgeFinalized(msg.sender, now);
  }

}