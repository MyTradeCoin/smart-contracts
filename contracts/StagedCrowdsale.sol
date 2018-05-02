pragma solidity ^0.4.18;
import "./zeppelin/Pausable.sol";
import "./zeppelin/SafeMath.sol";

contract StagedCrowdsale is Pausable {

  using SafeMath for uint;

  //Structure of stage information 
  struct Stage {
    uint hardcap;
    uint price;
    uint invested;
    uint closed;
  }

  //start date of sale
  uint public start;

  //period in days of sale
  uint public period;

  //sale's hardcap
  uint public totalHardcap;
 
  //total invested so far in the sale in wei
  uint public totalInvested;

  //sale's softcap
  uint public softcap;

  //sale's stages
  Stage[] public stages;

  event MilestoneAdded(uint hardcap, uint price);

  modifier saleIsOn() {
    require(stages.length > 0 && now >= start && now < lastSaleDate());
    _;
  }

  modifier saleIsFinished() {
    require(totalInvested >= softcap || now > lastSaleDate());
    _;
  }
  
  modifier isUnderHardcap() {
    require(totalInvested <= totalHardcap);
    _;
  }

  modifier saleIsUnsuccessful() {
    require(totalInvested < softcap || now > lastSaleDate());
    _;
  }

  /**
    * counts current sale's stages
    */
  function stagesCount() public constant returns(uint) {
    return stages.length;
  }

  /**
    * sets softcap
    * @param newSoftcap new softcap
    */
  function setSoftcap(uint newSoftcap) public onlyOwner {
    require(newSoftcap > 0);
    softcap = newSoftcap.mul(1 ether);
  }

  /**
    * sets start date
    * @param newStart new softcap
    */
  function setStart(uint newStart) public onlyOwner {
    start = newStart;
  }

  /**
    * sets period of sale
    * @param newPeriod new period of sale
    */
  function setPeriod(uint newPeriod) public onlyOwner {
    period = newPeriod;
  }

  /**
    * adds stage to sale
    * @param hardcap stage's hardcap in ethers
    * @param price stage's price
    */
  function addStage(uint hardcap, uint price) public onlyOwner {
    require(hardcap > 0 && price > 0);
    Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
    stages.push(stage);
    totalHardcap = totalHardcap.add(stage.hardcap);
    MilestoneAdded(hardcap, price);
  }

  /**
    * removes stage from sale
    * @param number index of item to delete
    */
  function removeStage(uint8 number) public onlyOwner {
    require(number >= 0 && number < stages.length);
    Stage storage stage = stages[number];
    totalHardcap = totalHardcap.sub(stage.hardcap);    
    delete stages[number];
    for (uint i = number; i < stages.length - 1; i++) {
      stages[i] = stages[i+1];
    }
    stages.length--;
  }

  /**
    * updates stage
    * @param number index of item to update
    * @param hardcap stage's hardcap in ethers
    * @param price stage's price
    */
  function changeStage(uint8 number, uint hardcap, uint price) public onlyOwner {
    require(number >= 0 && number < stages.length);
    Stage storage stage = stages[number];
    totalHardcap = totalHardcap.sub(stage.hardcap);    
    stage.hardcap = hardcap.mul(1 ether);
    stage.price = price;
    totalHardcap = totalHardcap.add(stage.hardcap);    
  }

  /**
    * inserts stage
    * @param numberAfter index to insert
    * @param hardcap stage's hardcap in ethers
    * @param price stage's price
    */
  function insertStage(uint8 numberAfter, uint hardcap, uint price) public onlyOwner {
    require(numberAfter < stages.length);
    Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
    totalHardcap = totalHardcap.add(stage.hardcap);
    stages.length++;
    for (uint i = stages.length - 2; i > numberAfter; i--) {
      stages[i + 1] = stages[i];
    }
    stages[numberAfter + 1] = stage;
  }

  /**
    * deletes all stages
    */
  function clearStages() public onlyOwner {
    for (uint i = 0; i < stages.length; i++) {
      delete stages[i];
    }
    stages.length -= stages.length;
    totalHardcap = 0;
  }

  /**
    * calculates last sale date
    */
  function lastSaleDate() public constant returns(uint) {
    return start + period * 1 days;
  }  

  /**
    * returns index of current stage
    */
  function currentStage() public saleIsOn isUnderHardcap constant returns(uint) {
    for(uint i = 0; i < stages.length; i++) {
      if(stages[i].closed == 0) {
        return i;
      }
    }
    revert();
  }

}