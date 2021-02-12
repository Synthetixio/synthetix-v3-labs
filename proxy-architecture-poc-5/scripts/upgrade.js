async function main() {
	const _hre = hre;

	await _hre.run('run', { script: './scripts/upgrade-safety-module.js' });
	await _hre.run('run', { script: './scripts/deploy-modules.js' });
	await _hre.run('run', { script: './scripts/generate-router.js' });
	await _hre.run('run', { script: './scripts/upgrade-router.js' });
	await _hre.run('run', { script: './scripts/register-modules.js' });
	if (_hre.network.name == 'kovan') {
		await _hre.run('run', { script: './scripts/update-defender-contracts.js' });
	}
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
