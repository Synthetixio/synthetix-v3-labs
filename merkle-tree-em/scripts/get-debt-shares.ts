require('dotenv/config')

const fs = require('fs')
const ethers = require('ethers')
const levelup = require('levelup')
const memdown = require('memdown')
const createQueue = require('fastq')
const { SecureTrie } = require('merkle-patricia-tree')

const SynthetixDebtShare = require('../data/SynthetixDebtShare.json')

async function getAccounts(Contract, deployedBlock) {
  const events = await Contract.queryFilter(
    Contract.filters.Transfer(null, null, null),
    deployedBlock
  )

  // Use a Set to have implicitily unique values
  const addresses = new Set()
  for (const event of events) {
    addresses.add(event.args.to)
    addresses.add(event.args.from)
  }

  addresses.delete('0x0000000000000000000000000000000000000000')

  return Array.from(addresses)
}

async function getDebts({ Contract, blockTag, addresses }) {
  const debts = {}

  let i = 0
  const pad = addresses.length.toString().length

  const queue = createQueue.promise(async function (address) {
    const debt = await Contract.balanceOf(address, { blockTag })
    const index = (++i).toString().padStart(pad)
    console.log(`${index} ${address} debt: ${ethers.utils.formatEther(debt)}`)
    debts[address] = debt.toString()
  }, 15)

  for (const address of addresses) {
    queue.push(address)
  }

  await queue.drained()

  return debts
}

async function buildMerkleTree() {
  const db = levelup(memdown())
  const trie = new SecureTrie(db)

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

async function main() {
  const provider = new ethers.providers.JsonRpcProvider(
    process.env.PROVIDER_URL
  )

  const latestBLock = await provider.getBlockNumber()
  // TODO: Blocktag should be a parameter
  const blockTag = latestBLock - 10

  console.log(`  Provider URL: ${process.env.PROVIDER_URL}`)
  console.log(`  Latest block: ${latestBLock}`)
  console.log(`  Block Tag   : ${blockTag}`)

  const Contract = new ethers.Contract(
    SynthetixDebtShare.address,
    SynthetixDebtShare.abi,
    provider
  )

  const addresses = (
    await getAccounts(Contract, SynthetixDebtShare.deployedBlock)
  ).slice(0, 100)

  console.log(`  Collected ${addresses.length} addresses`)

  const debts = await getDebts({ Contract, blockTag, addresses })
}

main().catch((err) => {
  console.error(err)
  process.exit(1)
})
