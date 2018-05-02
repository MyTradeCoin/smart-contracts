pragma solidity ^0.4.18;

import "./StagedCrowdsale.sol";
import "./MYTCToken.sol";

contract CommonSale is StagedCrowdsale {

  //Our MYTC token
  MYTCToken public token;  

  //slave wallet percentage
  uint public slaveWalletPercent = 50;

  //total percent rate
  uint public percentRate = 100;

  //min investment value in wei
  uint public minInvestment;
  
  //bool to check if wallet is initialized
  bool public slaveWalletInitialized;

  //bool to check if wallet percentage is initialized
  bool public slaveWalletPercentInitialized;

  //master wallet address
  address public masterWallet;

  //slave wallet address
  address public slaveWallet;
  
  //Agent for direct minting
  address public directMintAgent;

  // How much ETH each address has invested in crowdsale
  mapping (address => uint256) public investedAmountOf;

  // How much tokens crowdsale has credited for each investor address
  mapping (address => uint256) public tokenAmountOf;

  // Crowdsale contributors
  mapping (uint => address) public contributors;

  // Crowdsale unique contributors number
  uint public uniqueContributors;  

  /**
      * event for token purchases logging
      * @param purchaser who paid for the tokens
      * @param value weis paid for purchase
      * @param purchaseDate time of log
      */
  event TokenPurchased(address indexed purchaser, uint256 value, uint256 purchaseDate);

  /**
      * event for token mint logging
      * @param to tokens destination
      * @param tokens minted
      * @param mintedDate time of log
      */
  event TokenMinted(address to, uint tokens, uint256 mintedDate);

  /**
      * event for token refund
      * @param investor refunded account address
      * @param amount weis refunded
      * @param returnDate time of log
      */
  event InvestmentReturned(address indexed investor, uint256 amount, uint256 returnDate);
  
  modifier onlyDirectMintAgentOrOwner() {
    require(directMintAgent == msg.sender || owner == msg.sender);
    _;
  }  

  /**
    * sets MYTC token
    * @param newToken new token
    */
  function setToken(address newToken) public onlyOwner {
    token = MYTCToken(newToken);
  }

  /**
    * sets minimum investement threshold
    * @param newMinInvestment new minimum investement threshold
    */
  function setMinInvestment(uint newMinInvestment) public onlyOwner {
    minInvestment = newMinInvestment;
  }  

  /**
    * sets master wallet address
    * @param newMasterWallet new master wallet address
    */
  function setMasterWallet(address newMasterWallet) public onlyOwner {
    masterWallet = newMasterWallet;
  }

  /**
    * sets slave wallet address
    * @param newSlaveWallet new slave wallet address
    */
  function setSlaveWallet(address newSlaveWallet) public onlyOwner {
    require(!slaveWalletInitialized);
    slaveWallet = newSlaveWallet;
    slaveWalletInitialized = true;
  }

  /**
    * sets slave wallet percentage
    * @param newSlaveWalletPercent new wallet percentage
    */
  function setSlaveWalletPercent(uint newSlaveWalletPercent) public onlyOwner {
    require(!slaveWalletPercentInitialized);
    slaveWalletPercent = newSlaveWalletPercent;
    slaveWalletPercentInitialized = true;
  }

  /**
    * sets direct mint agent
    * @param newDirectMintAgent new agent
    */
  function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
    directMintAgent = newDirectMintAgent;
  }  

  /**
    * mints directly from network
    * @param to invesyor's adress to transfer the minted tokens to
    * @param investedWei number of wei invested
    */
  function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
    calculateAndMintTokens(to, investedWei);
    TokenPurchased(to, investedWei, now);
  }

  /**
    * splits investment into master and slave wallets for security reasons
    */
  function createTokens() public whenNotPaused payable {
    require(msg.value >= minInvestment);
    uint masterValue = msg.value.mul(percentRate.sub(slaveWalletPercent)).div(percentRate);
    uint slaveValue = msg.value.sub(masterValue);
    masterWallet.transfer(masterValue);
    slaveWallet.transfer(slaveValue);
    calculateAndMintTokens(msg.sender, msg.value);
    TokenPurchased(msg.sender, msg.value, now);
  }

  /**
    * Calculates and records contributions
    * @param to invesyor's adress to transfer the minted tokens to
    * @param weiInvested number of wei invested
    */
  function calculateAndMintTokens(address to, uint weiInvested) internal {
    //calculate number of tokens
    uint stageIndex = currentStage();
    Stage storage stage = stages[stageIndex];
    uint tokens = weiInvested.mul(stage.price);
    //if we have a new contributor
    if(investedAmountOf[msg.sender] == 0) {
        contributors[uniqueContributors] = msg.sender;
        uniqueContributors += 1;
    }
    //record contribution and tokens assigned
    investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(weiInvested);
    tokenAmountOf[msg.sender] = tokenAmountOf[msg.sender].add(tokens);
    //mint and update invested values
    mintTokens(to, tokens);
    totalInvested = totalInvested.add(weiInvested);
    stage.invested = stage.invested.add(weiInvested);
    //check if cap of staged is reached
    if(stage.invested >= stage.hardcap) {
      stage.closed = now;
    }
  }

  /**
    * Mint tokens
    * @param to adress destination to transfer the tokens to
    * @param tokens number of tokens to mint and transfer
    */
  function mintTokens(address to, uint tokens) internal {
    token.mint(this, tokens);
    token.transfer(to, tokens);
    TokenMinted(to, tokens, now);
  }

  /**
    * Payable function
    */
  function() external payable {
    createTokens();
  }
  
  /**
    * Function to retrieve and transfer back external tokens
    * @param anotherToken external token received
    * @param to address destination to transfer the token to
    */
  function retrieveExternalTokens(address anotherToken, address to) public onlyOwner {
    ERC20 alienToken = ERC20(anotherToken);
    alienToken.transfer(to, alienToken.balanceOf(this));
  }

  /**
    * Function to refund funds if softcap is not reached and sale period is over 
    */
  function refund() public saleIsUnsuccessful {
    uint value = investedAmountOf[msg.sender];
    investedAmountOf[msg.sender] = 0;
    msg.sender.transfer(value);
    InvestmentReturned(msg.sender, value, now);
  }

}