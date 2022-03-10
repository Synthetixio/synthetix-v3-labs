import 'dotenv/config'

import createQueue from 'fastq'
import ethers from 'ethers'
import fs from 'fs'
import path from 'path'
import sortKeys from 'sort-keys'
import { fileURLToPath } from 'url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))

const SynthetixDebtShare = JSON.parse(
  fs.readFileSync(
    path.resolve(__dirname, '..', 'data', 'SynthetixDebtShare.json')
  )
)

const FILE = path.resolve(__dirname, '..', 'debts.json')

function read() {
  return JSON.parse(fs.readFileSync(FILE))
}

function write(key, value) {
  const data = read()
  data[key] = value
  fs.writeFileSync(FILE, JSON.stringify(sortKeys(data), null, 2))
}

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
    try {
      const debt = await Contract.balanceOf(address, { blockTag })

      if (debt > 0) {
        write(address, debt.toString())
      }

      const index = (++i).toString().padStart(pad)
      console.log(`${index} ${address} debt: ${ethers.utils.formatEther(debt)}`)
    } catch (err) {
      console.error(`Error processing ${address}:`)
      console.error(err)
    }
  }, 15)

  for (const address of addresses) {
    queue.push(address)
  }

  await queue.drained()

  return debts
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

  let addresses = await getAccounts(Contract, SynthetixDebtShare.deployedBlock)

  console.log(`  Collected ${addresses.length} addresses`)

  // Do not get debts for addresses already fetched
  if (fs.existsSync(FILE)) {
    const currentDebts = read()
    const currentAddresses = new Set(addresses)
    for (const address of Object.keys(currentDebts)) {
      currentAddresses.delete(address)
    }
    addresses = Array.from(currentAddresses)
  } else {
    fs.writeFileSync(FILE, '{}')
  }

  await getDebts({ Contract, blockTag, addresses })
}

main().catch((err) => {
  console.error(err)
  process.exit(1)
})
