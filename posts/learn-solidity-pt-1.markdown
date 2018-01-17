---
title: Learn Solidity (pt.1)
date: 2018-01-16
disqus: True
---

## Motivation
I have been so interested in blockchain technology recently. However, Dapps development is a very new growing field and it's not too easy to find good in-depth resources in it so I hope this post can be useful for people like me who just get started in dapps.


## What's decentralized apps?
As a developer, we used to build centralized application which means typical server-client model. The server might be distributed across different node but they are essentially from the same central power. As for decentralized applications, instead of having one central power, all nodes are cooperating and the consensus is usually made by proof of work or proof of stake. Data are persisted in blockchain which is usually public.

## FreeSwap - A toy dapps project for swapping items
I am building a toy project for people to swapping items. The main purpose is to learn dapps development rather than building a production-ready application.

### Project Setup
```bash
git clone git@github.com:SWTPAIN/freeswap-dapps.git
git checkout v0.0.1
npm i
truffle compile; truffle migrate;truffle develop
# another window
npm start #make sure MetaMask is install for your browser
```

Note that I used [Truffle](https://github.com/trufflesuite/truffle) to create a react-webpack boilderplate. There are lots of good tutorial about developing dapps in Truffle website. Please check them out.

## Tips & Gotchas
I will not go through the process because it's relatively straight-forward and simple application now. Instead, I would like to share some gotchas and hope that could save you some times in your first dapps development.

### Return Tuple instead of struct
It's not possible to return struct from public function. You need to change the function to return tuple which containing the fields that you are interested.

```solidity
function getItem(uint itemId)
  public
  view
  returns (
  uint _itemId, string name, string description, ItemState state
) {
  .....
}
```

### Debugging Contracts

First, we need to open a second console with logging `truffle develop --log` so we can easily see transaction ids when a transaction failure happen.

Let's say we try to call a function in a contract but it reverts transaction and throw error. We get the transaction id from log and use `debug transtionIdxxxxxxx` in `truffle console`. And then you will enter into an interactive mode where you can step into/over/out to the statement evaluated in EVM.

### Reinstall MetaMask everytime restart testrpc/truffle console
It's a bug casued by nonce calucation. [Bug here](https://github.com/MetaMask/metamask-extension/issues/1999)


## Suggested Materials
- [Crypto Zombies](https://cryptozombies.io/) an interactive fun game to learn solidity
- [Crypto Kitties](https://github.com/axiomzen/cryptokitties-bounty) there are relatively complicated contracts which you can learn about inheritence, data structure, modifier and code testing.

