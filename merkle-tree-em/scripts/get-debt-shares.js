#!/usr/bin/env node
'use strict'

require('dotenv').config()

const fs = require('fs')
const ethers = require('ethers')

// DebtShares address in L1
const SYNTHETHIX_DEBT_SHARE_ADDRESS =
  '0x89FCb32F29e509cc42d0C8b6f058C993013A843F'
// DebtShares ABI
const SYNTHETHX_DEBT_SHARE_ABI = [
  {
    inputs: [
      { internalType: 'address', name: '_owner', type: 'address' },
      { internalType: 'address', name: '_resolver', type: 'address' },
    ],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'constructor',
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: 'address',
        name: 'account',
        type: 'address',
      },
      {
        indexed: false,
        internalType: 'uint256',
        name: 'amount',
        type: 'uint256',
      },
    ],
    name: 'Burn',
    type: 'event',
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: 'bytes32',
        name: 'name',
        type: 'bytes32',
      },
      {
        indexed: false,
        internalType: 'address',
        name: 'destination',
        type: 'address',
      },
    ],
    name: 'CacheUpdated',
    type: 'event',
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: 'address',
        name: 'authorizedBroker',
        type: 'address',
      },
      {
        indexed: false,
        internalType: 'bool',
        name: 'authorized',
        type: 'bool',
      },
    ],
    name: 'ChangeAuthorizedBroker',
    type: 'event',
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: 'address',
        name: 'authorizedToSnapshot',
        type: 'address',
      },
      {
        indexed: false,
        internalType: 'bool',
        name: 'authorized',
        type: 'bool',
      },
    ],
    name: 'ChangeAuthorizedToSnapshot',
    type: 'event',
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: 'address',
        name: 'account',
        type: 'address',
      },
      {
        indexed: false,
        internalType: 'uint256',
        name: 'amount',
        type: 'uint256',
      },
    ],
    name: 'Mint',
    type: 'event',
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: 'address',
        name: 'oldOwner',
        type: 'address',
      },
      {
        indexed: false,
        internalType: 'address',
        name: 'newOwner',
        type: 'address',
      },
    ],
    name: 'OwnerChanged',
    type: 'event',
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: 'address',
        name: 'newOwner',
        type: 'address',
      },
    ],
    name: 'OwnerNominated',
    type: 'event',
  },
  {
    anonymous: false,
    inputs: [
      { indexed: true, internalType: 'address', name: 'from', type: 'address' },
      { indexed: true, internalType: 'address', name: 'to', type: 'address' },
      {
        indexed: false,
        internalType: 'uint256',
        name: 'value',
        type: 'uint256',
      },
    ],
    name: 'Transfer',
    type: 'event',
  },
  {
    constant: true,
    inputs: [],
    name: 'CONTRACT_NAME',
    outputs: [{ internalType: 'bytes32', name: '', type: 'bytes32' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: false,
    inputs: [],
    name: 'acceptOwnership',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: false,
    inputs: [{ internalType: 'address', name: 'target', type: 'address' }],
    name: 'addAuthorizedBroker',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: false,
    inputs: [{ internalType: 'address', name: 'target', type: 'address' }],
    name: 'addAuthorizedToSnapshot',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: true,
    inputs: [
      { internalType: 'address', name: '', type: 'address' },
      { internalType: 'address', name: 'spender', type: 'address' },
    ],
    name: 'allowance',
    outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [
      { internalType: 'address', name: '', type: 'address' },
      { internalType: 'uint256', name: '', type: 'uint256' },
    ],
    name: 'approve',
    outputs: [{ internalType: 'bool', name: '', type: 'bool' }],
    payable: false,
    stateMutability: 'pure',
    type: 'function',
  },
  {
    constant: true,
    inputs: [{ internalType: 'address', name: '', type: 'address' }],
    name: 'authorizedBrokers',
    outputs: [{ internalType: 'bool', name: '', type: 'bool' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [{ internalType: 'address', name: '', type: 'address' }],
    name: 'authorizedToSnapshot',
    outputs: [{ internalType: 'bool', name: '', type: 'bool' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [{ internalType: 'address', name: 'account', type: 'address' }],
    name: 'balanceOf',
    outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [
      { internalType: 'address', name: 'account', type: 'address' },
      { internalType: 'uint256', name: 'periodId', type: 'uint256' },
    ],
    name: 'balanceOfOnPeriod',
    outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [
      { internalType: 'address', name: '', type: 'address' },
      { internalType: 'uint256', name: '', type: 'uint256' },
    ],
    name: 'balances',
    outputs: [
      { internalType: 'uint128', name: 'amount', type: 'uint128' },
      { internalType: 'uint128', name: 'periodId', type: 'uint128' },
    ],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: false,
    inputs: [
      { internalType: 'address', name: 'account', type: 'address' },
      { internalType: 'uint256', name: 'amount', type: 'uint256' },
    ],
    name: 'burnShare',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'currentPeriodId',
    outputs: [{ internalType: 'uint128', name: '', type: 'uint128' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'decimals',
    outputs: [{ internalType: 'uint8', name: '', type: 'uint8' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: false,
    inputs: [],
    name: 'finishSetup',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: false,
    inputs: [
      { internalType: 'address[]', name: 'accounts', type: 'address[]' },
      { internalType: 'uint256[]', name: 'amounts', type: 'uint256[]' },
    ],
    name: 'importAddresses',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'isInitialized',
    outputs: [{ internalType: 'bool', name: '', type: 'bool' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'isResolverCached',
    outputs: [{ internalType: 'bool', name: '', type: 'bool' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: false,
    inputs: [
      { internalType: 'address', name: 'account', type: 'address' },
      { internalType: 'uint256', name: 'amount', type: 'uint256' },
    ],
    name: 'mintShare',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'name',
    outputs: [{ internalType: 'string', name: '', type: 'string' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: false,
    inputs: [{ internalType: 'address', name: '_owner', type: 'address' }],
    name: 'nominateNewOwner',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'nominatedOwner',
    outputs: [{ internalType: 'address', name: '', type: 'address' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'owner',
    outputs: [{ internalType: 'address', name: '', type: 'address' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: false,
    inputs: [],
    name: 'rebuildCache',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: false,
    inputs: [{ internalType: 'address', name: 'target', type: 'address' }],
    name: 'removeAuthorizedBroker',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: false,
    inputs: [{ internalType: 'address', name: 'target', type: 'address' }],
    name: 'removeAuthorizedToSnapshot',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'resolver',
    outputs: [
      { internalType: 'contract AddressResolver', name: '', type: 'address' },
    ],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'resolverAddressesRequired',
    outputs: [
      { internalType: 'bytes32[]', name: 'addresses', type: 'bytes32[]' },
    ],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [{ internalType: 'address', name: 'account', type: 'address' }],
    name: 'sharePercent',
    outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [
      { internalType: 'address', name: 'account', type: 'address' },
      { internalType: 'uint256', name: 'periodId', type: 'uint256' },
    ],
    name: 'sharePercentOnPeriod',
    outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'symbol',
    outputs: [{ internalType: 'string', name: '', type: 'string' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: false,
    inputs: [{ internalType: 'uint128', name: 'id', type: 'uint128' }],
    name: 'takeSnapshot',
    outputs: [],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    constant: true,
    inputs: [],
    name: 'totalSupply',
    outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
    name: 'totalSupplyOnPeriod',
    outputs: [{ internalType: 'uint256', name: '', type: 'uint256' }],
    payable: false,
    stateMutability: 'view',
    type: 'function',
  },
  {
    constant: true,
    inputs: [
      { internalType: 'address', name: '', type: 'address' },
      { internalType: 'uint256', name: '', type: 'uint256' },
    ],
    name: 'transfer',
    outputs: [{ internalType: 'bool', name: '', type: 'bool' }],
    payable: false,
    stateMutability: 'pure',
    type: 'function',
  },
  {
    constant: false,
    inputs: [
      { internalType: 'address', name: 'from', type: 'address' },
      { internalType: 'address', name: 'to', type: 'address' },
      { internalType: 'uint256', name: 'amount', type: 'uint256' },
    ],
    name: 'transferFrom',
    outputs: [{ internalType: 'bool', name: '', type: 'bool' }],
    payable: false,
    stateMutability: 'nonpayable',
    type: 'function',
  },
]
// DebtShares contract deployed block
const deployedBlock = 14169250

const config = {}

async function setupData(config) {
  config.providerUrl = process.env.PROVIDER_URL
  config.provider = new ethers.providers.JsonRpcProvider(config.providerUrl)

  config.latestBLock = await provider.getBlockNumber()
  // TODO: Blocktag should be a parameter
  config.blockTag = config.latestBLock - 10

  console.log(`  Provider URL: ${config.providerUrl}`)
  console.log(`  Latest block: ${config.latestBLock}`)
  console.log(`  Block Tag   : ${config.blockTag}`)

  config.DebtShareContract = new ethers.Contract(
    SYNTHETHIX_DEBT_SHARE_ADDRESS,
    SYNTHETHX_DEBT_SHARE_ABI,
    config.provider,
  )
  return config
}

async function getAccounts(config) {
  const filterAllTransfers = config.DebtShareContract.filters.Transfer(
    null,
    null,
    null,
  )
  const events = await DebtShareContract.queryFilter(
    filterAllTransfers,
    deployedBlock,
    // 14179250,
  )

  config.collectedAddresses = {}
  for (const event of events) {
    // Collect the addresses
    if (event.args) {
      let address = event.args.to

      if (!config.collectedAddresses[address]) {
        config.collectedAddresses[address] = { collected: true }
      }

      address = event.args.from

      if (!config.collectedAddresses[address]) {
        config.collectedAddresses[address] = { collected: true }
      }
    }
  }

  config.uniqueAddresses = Object.keys(config.collectedAddresses)
  console.log(`  Collected ${config.uniqueAddresses.length} addresses`)

  // TODO Sync to addresses.json file (or defined name)
  return config
}

async function populateAccountsWithDebtShare(config) {
  const overrides = {}
  overrides.blockTag = config.blockTag

  for (const address of config.uniqueAddresses) {
    // Collect DebtShare if not collected before
    if (!config.collectedAddresses[address].debt) {
      const debt = await config.DebtShareContract.balanceOf(address, overrides)
      console.log(`      ${address} debt: ${ethers.utils.formatEther(debt)}`)

      config.collectedAddresses[address].debt = debt.toString()
      // TODO Sync to addresses.json file (or defined name)
    }
  }

  let data = JSON.stringify(config.collectedAddresses)
  fs.writeFileSync('addresses.json', data)

  return config
}

async function buildMerkleTree(config) {
  // TODO Build a merkle tree with the pack(account, debtShare)

  return config
}

async function buildMerkleTree(config) {
  // TODO Build a merkle tree with the pack(account, debtShare)

  return config
}

async function buildFEJson(config) {
  // TODO Build the artifact to be used by the FE
  // Format is
  // const json = {  "merkleRoot":"0xc8500f8e2fcf3c9a32880e1b973fb28acc88be35787a8abcf9981b2b65dbdeb5",
  //       "claims":{
  //       "0xAddress_1": {"index":0,"amount":"_Address_1_debt_share","proof":[]},
  //       "0xAddress_2": {"index":0,"amount":"_Address_2_debt_share","proof":[]},
  //       "0xAddress_3": {"index":0,"amount":"_Address_3_debt_share","proof":[]},
  //       "0xAddress_4": {"index":0,"amount":"_Address_4_debt_share","proof":[]},
  //     }}
  // This allows the FE to just find the address in the claims object and get the amount (debt shares) and precompiled proof

  return config
}

setupData(config)
  .then((v) => getAccounts(v))
  .then((v) => populateAccountsWithDebtShare(v))
  .then((v) => buildMerkleTree(v))
  .then((v) => buildFEJson(v))
  .catch((e) => console.log(e))
