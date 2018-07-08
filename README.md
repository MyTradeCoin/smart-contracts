# MYTC smart contract sale

## MYTC

MYTC Network is designed to unite small medium enterprises globally to enjoy the ability to conduct reciprocal trade/barter with each other

# Installation
* Clone our repository 
* Run npm install
* Truffle compile

To run our unit tests:

* Run Ganache (or any other RPC client)
* Run truffle test

Important: Make sure you have the latest updates for node and truffle to run the async tests
Versions used:
Node version 8.11.2
Truffle version 4.1.12
npm version 5.6.0

# Contract Information

* Name: MYTC
* Symbol: MYTC
* Standard: ERC20
* Decimals: 18

## Investor instructions

1. Get an ERC20 compatible wallet. DO NOT use your exchange wallet.
2. Register for our sale in our website: http://mytradetoken.io
3. Accept our terms of sale agreement and whitepaper terms
4. Send your investment in ETH to the contract address provided after your identity has been checked
5. We recommend you use GAS 280000, Wei 50

### WARNING

* Transfering money from your exchange wallet will result in irreversible loss of funds.
* Minimum investment is 0.1 ETH
* Do NOT share your private keys. We will never ask for your personal keys
* Our contracts only accept ETH
* You must not be a resident of a prohibited jurisdiction

# Integration Testing
Integration testing has been done using Ropsten Network

## Contracts
Token: https://ropsten.etherscan.io/token/0x5De65F0BDE35B49e877d6dDD39b2dBFc3d252ec8
TGE: https://ropsten.etherscan.io/address/0x2A6Ec010371FFE0dD1cda0399C16Ea67e37fA2f0
PreTGE: https://ropsten.etherscan.io/address/0x51d585756EC397221dA5Fe822E9b294DD8173eB9

## Wallets
Master:
0x9767e590113FE8Db09d75b483D85529971D5f4EE

Slave:
0x63EaF07A017742c47D90d08B00552d4D03541F3F

Bounty and Advisors:
0xb283C324333fB8473f20856EfD40Fe1129aF3B70

Team:
0x2150C0a297f5a7456FdD618586Db51F6Da75f833

Reserved:
0xa8975045141D1E4cEBbA8DF4061b7d738F01DF5e

## PreTge

### The following variables were set for testing purposes:

Hardcap: 5 ETH
Softcap: 3 ETH
Rate: 1 ETH = 3000 MYTC
Duration: 3 days
Minimun Investment: 0.1 ETH


#### Purchase coins after the sale begins:
Expected result: It should succeed and return expected coins
Actual result: Transaction completed. Received 3000 MYTC for 1 ETH. Funds received
https://ropsten.etherscan.io/tx/0xbd46eca9956cd42b92d8fa1eb5908b5174aa543e0829aa1a3ef091e77b6213d2

#### Purchase coins with less than minimun amount(< 0.1 ETH):
Expected result: It should fail
Actual result: Transaction failed sending 0.05 as investement
https://ropsten.etherscan.io/tx/0xbe3d369369c92a994c1a80f1213df94e0cc81632007fa2a1993800d52977db1f

#### Close sale before softcap is reached:
Expected result: It should fail
Actual result: Transaction Failed. Softcap must be reached to consider a sale successful
https://ropsten.etherscan.io/tx/0xce569a3dea490360e7b078b6976dd068be6adb6ee358a27d4483c74c3534e842

#### Close sale before hardcap but after softcap is reached:
Expected result: It should succeed and set TGE as next sale
Actual result: Transaction completed. Sale agent updated
https://ropsten.etherscan.io/tx/0x097727bce071442de8f520b87962b5ff2d29fb744ae1d57c8897e33266ea6311

## Tge

The following variables were set for testing purposes:
Hardcap: 7 ETH
Softcap: 3 ETH

Rates: 
Milestone A: Hardcap: 2 ETH = 2000 MYTC per ETH
Milestone B: Hardcap: 5 ETH = 1000 MYTC per ETH

Duration: 3 days
Minimun Investment: 0.1 ETH
Team's wallet lock period: 15 days

#### Purchase coins after the sale begins during Milestone A:
Expected result: It should succeed and return expected coins
Actual result: Transaction completed. Received 2000 MYTC for 1 ETH. Funds received
https://ropsten.etherscan.io/tx/0xd1338498961bc14f58cf365f31fa03142f59a828ca14e683948611dcb79c086e

#### Purchase coins after the sale begins during Milestone B:
Expected result: It should succeed and return expected coins
Actual result: Transaction completed. Received 1000 MYTC for 1 ETH. Funds received
https://ropsten.etherscan.io/tx/0xa93abf0cc0b08f27abf28d4a2c27a3632cdf431009616a2d31ee3a9395aa3021

#### Purchase coins with less than minimun amount(< 0.1 ETH):
Expected result: It should fail
Actual result: Transaction failed sending 0.05 as investement
https://ropsten.etherscan.io/tx/0xe0d0392f4cb8fe185d678befa045f51b4907d988d4edbf9d470523e48d393ae4

#### Pause sale:
Expected result: It should pause the sale
Actual result: Transaction completed. Sale has been paused
https://ropsten.etherscan.io/tx/0x45f068984aeb5a433763cb64c0d157289d4e88759506a1310b625d174183e53a

#### Invest while sale is paused:
Expected result: It should fail
Actual result: Transaction failed. Can't invest while paused
https://ropsten.etherscan.io/tx/0x85b79a91427e65528996bc27df6105d3a169796cf93bfb4b988ff319d83f8eaf

#### Resume sale:
Expected result: It should unpause the sale
Actual result: Transaction completed. Sale has been restored
https://ropsten.etherscan.io/tx/0x0b5e068b2bacbb3a5ac5db1db26d09c2f2d471c7f5647318e8b115d781747a89

#### Purchase coins after resued sale during Milestone B:
Expected result: It should succeed and return expected coins
Actual result: Transaction completed. Received 1000 MYTC for 1 ETH. Funds received
https://ropsten.etherscan.io/tx/0x0fda05814f24079cfa7c32577f1ce11514ada537a3d0721378a09cb89b3a0c0d

#### Invest after hardcap has been reached:
Expected result: It should fail
Actual result: Transaction failed. Can't mint more tokens than specified hardcap
https://ropsten.etherscan.io/tx/0xd23f264ed5999dfa16760eb466abdd1855b70bc7a2151f7db55558ff497533c0

#### Finish sale after hardcap has been reached:
Expected result: It should succeed and finish minting
Actual result: Transaction completed. Sale closed, miniting has been finished and funds transfered to team, bounty and reserved wallet
https://ropsten.etherscan.io/tx/0x9be73ba2373bf248aecbd2780cb39f9be4cf5bbcc1a6c3d0def874746db13ffc

##### Tokens Generated

Total coins minted in PreTGE: 3.1 ETH = 9300 MYTC
Total coins minted in TGE: 7 ETH = 9000 MYTC
Total for sales: 18300 MYTC

##### Token distribution

MYTC Balances:
https://ropsten.etherscan.io/token/0x5de65f0bde35b49e877d6ddd39b2dbfc3d252ec8#balances

Bounty (5%): 
0xb283C324333fB8473f20856EfD40Fe1129aF3B70

Team (18%):
0x2150C0a297f5a7456FdD618586Db51F6Da75f833

Reserved (25%):
0xa8975045141D1E4cEBbA8DF4061b7d738F01DF5e

#### Transfer tokens from team's wallet after sale is finished:
Expected result: It should fail
Actual result: Transaction failed. Wallet is locked and can't transfer tokens until the lock period is met
https://ropsten.etherscan.io/tx/0xb18b1b5c4db013f5e0961cc09dc4a6770fe4a4ba987b5a49834b7f4d8f8a2622

 
# Contact

Please visit our website, http://mytradetoken.io/ for more information on the project
© 2018 MYTC Pty Ltd. All Rights Reserved.
