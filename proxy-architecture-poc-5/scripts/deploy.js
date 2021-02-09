async function main() {
	const _hre = hre;

	await _hre.run('run', { script: './scripts/clear-deployments.js' });
	await _hre.run('run', { script: './scripts/deploy-proxy.js' });
	await _hre.run('run', { script: './scripts/deploy-modules.js' });
	await _hre.run('run', { script: './scripts/generate-router.js' });
	await _hre.run('run', { script: './scripts/upgrade-router.js' });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
