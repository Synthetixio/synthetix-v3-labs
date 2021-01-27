const fs = require("fs");

async function deploy() {
  const network = 'kovan';

  // ---------------------------
  // Retrieve data file
  // ---------------------------

  const deploymentsFilePath = `./deployments/${network}.json`;
	const deployments = JSON.parse(fs.readFileSync(deploymentsFilePath));

  function saveDeploymentsFile() {
	  fs.writeFileSync(
	    deploymentsFilePath,
	    JSON.stringify(deployments, null, 2)
	  );
  }

  // ---------------------------
  // Ethers utils
  // ---------------------------

  function getSelectorsForContract({ contract }) {
    return contract.interface.fragments.reduce((selectors, fragment) => {
      if (fragment.type === "function") {
        selectors.push(contract.interface.getSighash(fragment));
      }

      return selectors;
    }, []);
  }

  async function deployContract({ name, args = [] }) {
    const factory = await ethers.getContractFactory(name);

    return await factory.deploy(...args);
  }

  async function connetToContract({ name, address }) {
    return await ethers.getContractAt(name, address);
  }

  // ---------------------------
  // Facet utils
  // ---------------------------

  async function deployFacet({ name, facets }) {
    const contract = await deployContract({ name });

    facets.push([
      contract.address,
      getSelectorsForContract({ contract }),
    ]);

    console.log(`Deployed ${name} to ${contract.address}`);

    deployments.facets[name] = contract.address;
    saveDeploymentsFile();

    return contract;
  }

  // ---------------------------
  // Signers
  // ---------------------------

  const signers = await ethers.getSigners();

  const owner = signers[0];
  console.log(`Signer: ${owner.address}`);

  // ---------------------------
  // Initial deploy of diamond
  // ---------------------------

  if (deployments.Synthetix === '') {
    // Main library
    const DiamondLibrary = await deployContract({ name: "DiamondLibrary" });
    console.log(`Deployed DiamondLibrary to ${DiamondLibrary.address}`);
    deployments.DiamondLibrary = DiamondLibrary.address;
    saveDeploymentsFile();

    // Initial facets
    const facets = [];
    await deployFacet({ name: 'OwnerFacet', facets });
    await deployFacet({ name: 'UpgradeFacet', facets });

    // Main proxy
    const Synthetix = await deployContract({
      name: "DiamondProxy",
      args: [facets],
    });
    console.log(`Deployed Synthetix to ${Synthetix.address}`);
    deployments.Synthetix = Synthetix.address;
    saveDeploymentsFile();
  }

  // ---------------------------
  // Interact with facets
  // ---------------------------

  const Synthetix = await connetToContract({
    name: 'DiamondProxy',
    address: deployments.Synthetix
  });
  // console.log(await ethers.provider.getCode(Synthetix.address));

  const OwnerFacet = await connetToContract({
    name: "OwnerFacet",
    address: Synthetix.address,
  });
  // console.log(await ethers.provider.getCode(OwnerFacet.address));

  console.log(`Synthetix owner: ${await OwnerFacet.getOwner()}`);
}

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
