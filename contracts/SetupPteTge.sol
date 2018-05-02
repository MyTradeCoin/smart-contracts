pragma solidity ^0.4.18;

import "./MYTCToken.sol";
import "./PreTge.sol";
import "./Tge.sol";
import "./zeppelin/Ownable.sol";

contract SetupPreTge is Ownable {   

  //PreTGE and MYTC token
  PreTge public preTge;
  MYTCToken public token;

  /**
    * deploys preTGE with MYTC sale details
    */
  function deploy() public onlyOwner {    

    preTge = new PreTge();
    //use MYTC token contract address here
    token = MYTCToken(0x5De65F0BDE35B49e877d6dDD39b2dBFc3d252ec8);

    preTge.setToken(token);
    preTge.addStage(5,3000);
    preTge.setSoftcap(3);
    preTge.setSlaveWalletPercent(50);
    preTge.setMasterWallet(0x9767e590113FE8Db09d75b483D85529971D5f4EE);
    preTge.setSlaveWallet(0x63EaF07A017742c47D90d08B00552d4D03541F3F);    
    preTge.setStart(1525241700);
    preTge.setPeriod(3);
    preTge.setMinInvestment(100000000000000000);
    //use TGE contract here
    preTge.setMainsale(0x2A6Ec010371FFE0dD1cda0399C16Ea67e37fA2f0);
    address admin = 0xcc9A682a0155820b03A8AF8c7f390D3053C87B32;
    preTge.transferOwnership(admin);
  }

}
