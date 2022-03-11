import fs from 'fs'
import path from 'path'
import { parseBalanceMap } from './uni/parse-balance-tree'

const FILE = path.resolve(__dirname, '..', 'debts.json')
const ARTIFACT_FILE = path.resolve(__dirname, '..', 'proofs.json')

function read() {
  return JSON.parse(fs.readFileSync(FILE, 'utf8'))
}

function write(data: any) {
  fs.writeFileSync(ARTIFACT_FILE, JSON.stringify(data, null, 2))
}


async function main() {

  const debts = read()

  const exportedArtifact = parseBalanceMap(debts)

  write(exportedArtifact)
}

main().catch((err) => {
  console.error(err)
  process.exit(1)
})