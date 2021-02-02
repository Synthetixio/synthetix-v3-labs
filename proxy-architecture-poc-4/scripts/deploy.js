async function deploy() {
	const _hre = hre;

	await _hre.run('run', { script: './scripts/clear-deployment.js' });
	await _hre.run('run', { script: './scripts/deploy-modules.js' });
	await _hre.run('run', { script: './scripts/generate-proxy.js' });
	await _hre.run('run', { script: './scripts/deploy-proxy.js' });
}

deploy()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
