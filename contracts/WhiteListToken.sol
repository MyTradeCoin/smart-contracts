pragma solidity ^0.4.18;

import './CommonSale.sol';

contract WhiteListToken is CommonSale {

  mapping(address => bool)  public whiteList;

  modifier onlyIfWhitelisted() {
    require(whiteList[msg.sender]);
    _;
  }

  function addToWhiteList(address _address) public onlyDirectMintAgentOrOwner {
    whiteList[_address] = true;
  }

  function addAddressesToWhitelist(address[] _addresses) public onlyDirectMintAgentOrOwner {
    for (uint256 i = 0; i < _addresses.length; i++) {
      addToWhiteList(_addresses[i]);
    }
  }

  function deleteFromWhiteList(address _address) public onlyDirectMintAgentOrOwner {
    whiteList[_address] = false;
  }

  function deleteAddressesFromWhitelist(address[] _addresses) public onlyDirectMintAgentOrOwner {
    for (uint256 i = 0; i < _addresses.length; i++) {
      deleteFromWhiteList(_addresses[i]);
    }
  }

}