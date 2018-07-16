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
* Token: https://ropsten.etherscan.io/token/0x12867277532e64c22bcc4c8fceb1c1719443d0f2
* TGE: https://ropsten.etherscan.io/address/0x331A2B8DFeC57D9B805FAF2f6c37A21dFc00A69f
* PreTGE: https://ropsten.etherscan.io/address/0x95fa54f46C2A8b740f4D1e59D6233467B5317291

## Wallets
Master:
0xF5F8CeF2CACA5A2B45e582951a3A5D7CE50D87D9

Slave:
0x999f4E4a7025bAa06fbaE50cB648751305BB8DB8

Bounty and Advisors:
0xeB2544d37BBA671f767b75e294DE28490ead5E19

Team:
0x4Bc43B0017702B11a4E6F7Dd545723E528254169

Reserved:
0x880559F5cFf478b5F4bb74E4371aE73e75ecc0D7

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
https://ropsten.etherscan.io/tx/0xac2e9c754c65e7c14fb8189c30e14a7a618efee1f75f37259f19f5c50099f29e

#### Purchase coins with less than minimun amount(< 0.1 ETH):
Expected result: It should fail
Actual result: Transaction failed sending 0.05 as investement
https://ropsten.etherscan.io/tx/0x12c14651f0adabdc84d1d6f9a603b4113871b0aa9616e22983482ef54c208bd4

#### Close sale before softcap is reached:
Expected result: It should fail
Actual result: Transaction Failed. Softcap must be reached to consider a sale successful
https://ropsten.etherscan.io/tx/0x12c14651f0adabdc84d1d6f9a603b4113871b0aa9616e22983482ef54c208bd4

#### Close sale before hardcap but after softcap is reached:
Expected result: It should succeed and set TGE as next sale
Actual result: Transaction completed. Sale agent updated
https://ropsten.etherscan.io/tx/0x39a4f12869ef4546f75337e87263dd73a1c11c3c70c7b9abe48f3ceb39be18e6

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

#### Purchase coins before the sale begins:
Expected result: It should fail
Actual result: Transaction rejected
https://ropsten.etherscan.io/tx/0x46fd2ae67c0c1a939728ac6670127abb4dc6dae69e5bdc413ab857809e68a45b

#### Purchase coins from an address NOT in the whitelist:
Expected result: It should fail
Actual result: Transaction rejected
https://ropsten.etherscan.io/tx/0x2af2d38bd0bddee6f97aff6f465fe26fedd92988d97fff82f78e784450d2841d

#### Add address to whitelist after KYC process:
Expected result: It should succeed and register address
Actual result: Transaction completed. Address added
https://ropsten.etherscan.io/tx/0xbff4e9a24ae1a4b8e3c219a9be9721954a8d4fb087c68f8a3959627e4fa08d8e

#### Purchase coins after the sale begins during Milestone A, after KYC process:
Expected result: It should succeed and return expected coins
Actual result: Transaction completed. Received 2000 MYTC for each 1 ETH. Funds received
https://ropsten.etherscan.io/tx/0x656a50f91c73b414e2430ddb80b7fad7bf5e23486edb308927bd2d14b6370ceb

#### Purchase coins after the sale begins during Milestone B:
Expected result: It should succeed and return expected coins
Actual result: Transaction completed. Received 1000 MYTC for each 1 ETH. Funds received
https://ropsten.etherscan.io/tx/0x8f3d792b264ae8c9a45f8f8ab1917af9dc03a40b437b2a889d01814480b8a7db

#### Purchase coins with less than minimun amount(< 0.1 ETH):
Expected result: It should fail
Actual result: Transaction failed sending 0.05 as investement
https://ropsten.etherscan.io/tx/0x5a7a9088ac617c318f69eb1283f5b5401b97e1d287d1ec9e9885c356446d3f9e

#### Pause sale:
Expected result: It should pause the sale
Actual result: Transaction completed. Sale has been paused
https://ropsten.etherscan.io/tx/0x7325d675a7d0cd8fe9df57dbe30013308d929624fdb1f7063dd868472371cae7

#### Invest while sale is paused:
Expected result: It should fail
Actual result: Transaction failed. Can't invest while paused
https://ropsten.etherscan.io/tx/0x7abd7c7b46b2d182f196b05c1663e4087b727876657f1c26d8f25e763cde5ef3

#### Resume sale:
Expected result: It should unpause the sale
Actual result: Transaction completed. Sale has been restored
https://ropsten.etherscan.io/tx/0x54d9bfd2ec63b81a9c80870bf54a3bd820f0af859e725165f8208cf6f425f4dc

#### Purchase coins after resued sale during Milestone B:
Expected result: It should succeed and return expected coins
Actual result: Transaction completed. Received 1000 MYTC for each 1 ETH. Funds received
https://ropsten.etherscan.io/tx/0x18534d5781a6758bcf58630da909a3f7f3835579ce682a69dbcbea918dab27dc

#### Invest after hardcap has been reached:
Expected result: It should fail
Actual result: Transaction failed. Can't mint more tokens than specified hardcap
https://ropsten.etherscan.io/tx/0x100f13bdeeeca0e4ef813e90c1374022bf95818a516d4c323661cf1fe4573e60

#### Finish sale after hardcap has been reached:
Expected result: It should succeed and finish minting
Actual result: Transaction completed. Sale closed, miniting has been finished and funds transfered to team, bounty and reserved wallet
https://ropsten.etherscan.io/tx/0x8a999c8f6ecc50dd2227a132548ab526434fef783d53375acb4bbd84f6f661ee


##### Token distribution

MYTC Balances:
https://ropsten.etherscan.io/token/0x12867277532e64c22bcc4c8fceb1c1719443d0f2#balances

Bounty (3%): 
0xeb2544d37bba671f767b75e294de28490ead5e19

Team (18%):
0x4bc43b0017702b11a4e6f7dd545723e528254169

Reserved (58%):
0x880559f5cff478b5f4bb74e4371ae73e75ecc0d7

#### Transfer tokens from team's wallet after sale is finished:
Expected result: It should fail
Actual result: Transaction failed. Wallet is locked and can't transfer tokens until the lock period is met
https://ropsten.etherscan.io/tx/0x167ee0183e5fd8f95ab4dda3c35f2d095d34732a9627e16a97813258d3f36cbb

 
# Contact

Please visit our website, http://mytradetoken.io for more information on the project
© 2018 MYTC Pty Ltd. All Rights Reserved.
