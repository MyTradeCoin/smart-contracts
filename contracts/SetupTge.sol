pragma solidity ^0.4.18;

import "./MYTCToken.sol";
import "./PreTge.sol";
import "./Tge.sol";
import "./zeppelin/Ownable.sol";

contract SetupTge is Ownable {

  //TGE and MYTC token
  Tge public tge;
  MYTCToken public token;   

  /**
    * deploys TGE with MYTC sale details
    */
  function deploy() public onlyOwner {
    
    tge = new Tge();
    token = new MYTCToken();    

    tge.setToken(token);
    tge.addStage(2,2000);
    tge.addStage(5,1000);
    tge.setSoftcap(3);
    tge.setSlaveWalletPercent(50);
    tge.setReservedTokensPercent(25);
    tge.setTeamTokensPercent(18);
    tge.setBountyTokensPercent(3);
    tge.setMasterWallet(0x9767e590113FE8Db09d75b483D85529971D5f4EE);
    tge.setSlaveWallet(0x63EaF07A017742c47D90d08B00552d4D03541F3F);
    tge.setReservedTokensWallet(0xa8975045141D1E4cEBbA8DF4061b7d738F01DF5e);
    tge.setTeamTokensWallet(0x2150C0a297f5a7456FdD618586Db51F6Da75f833);
    tge.setBountyTokensWallet(0xb283C324333fB8473f20856EfD40Fe1129aF3B70);
    tge.setTotalTokenSupply(300000000000000000000000000);   
    tge.setStart(1525244400);
    tge.setPeriod(3);
    tge.setLockPeriod(15);
    tge.setMinInvestment(100000000000000000);
    address admin = 0xcc9A682a0155820b03A8AF8c7f390D3053C87B32;
    token.transferOwnership(admin);
    tge.transferOwnership(admin);
  }

}