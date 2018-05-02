pragma solidity ^0.4.18;

import "./zeppelin/StandardToken.sol";
import "./MintableToken.sol";

contract MYTCToken is MintableToken {	
    
  //Token name
  string public constant name = "MYTC";
   
  //Token symbol
  string public constant symbol = "MYTC";
    
  //Token's number of decimals
  uint32 public constant decimals = 18;

  //Dictionary with locked accounts
  mapping (address => uint) public locked;

  /**
    * transfer for unlocked accounts
    */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(locked[msg.sender] < now);
    return super.transfer(_to, _value);
  }

  /**
    * transfer from for unlocked accounts
    */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(locked[_from] < now);
    return super.transferFrom(_from, _to, _value);
  }
  
  /**
    * locks an account for given a number of days
    * @param addr account address to be locked
    * @param periodInDays days to be locked
    */
  function lock(address addr, uint periodInDays) public {
    require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
    locked[addr] = now + periodInDays * 1 days;
  }

}