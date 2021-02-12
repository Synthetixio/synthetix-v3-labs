const fs = require('fs');
const { AutotaskClient } = require('defender-autotask-client');

async function main() {
  console.log(`Updating Defender autotasks...`);

	const autotasks = new AutotaskClient({
    apiKey: process.env.DEFENDER_KEY,
    apiSecret: process.env.DEFENDER_SECRET,
	});

  async function addAutoTask(file, id) {
    const code = fs.readFileSync(`./scripts/autotasks/${file}`, 'utf8');

    await autotasks.updateCodeFromSources(id, {
      'index.js': code
    });

    console.log(`  > Updated autotask ${file}`);
  }

  await addAutoTask('ticktick.js', 'b04c38c8-614b-4945-9d0d-b13d3b3e666c');
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
