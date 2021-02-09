const fs = require('fs');

function getDeploymentsFile({ network }) {
  const deploymentsFilePath = `./deployments/${network}.json`;

	return JSON.parse(fs.readFileSync(deploymentsFilePath));
}

function saveDeploymentsFile({ deployments, network }) {
  const deploymentsFilePath = `./deployments/${network}.json`;

	fs.writeFileSync(
	  deploymentsFilePath,
	  JSON.stringify(deployments, null, 2)
	);
}

module.exports = {
	getDeploymentsFile,
	saveDeploymentsFile,
};
