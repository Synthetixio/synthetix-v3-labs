const fs = require("fs");

async function deploy() {
  const owner = "0x68BF577920D6607c52114CB5E13696a19c2C9eFa";

  // ---------------------------
  // Facet utils
  // ---------------------------

  function getSelectorsForContract({ contract }) {
    return contract.interface.fragments.reduce((selectors, fragment) => {
      if (fragment.type === "function") {
        selectors.push(contract.interface.getSighash(fragment));
      }

      return selectors;
    }, []);
  }

  async function deployContract({ name, libraries, args = [] }) {
    let factory;
    if (libraries) {
      factory = await ethers.getContractFactory(name, { libraries });
    } else {
      factory = await ethers.getContractFactory(name);
    }
    return await factory.deploy(...args);
  }

  async function connetToContract({ name, address }) {
    return await ethers.getContractAt(name, address);
  }

  // ---------------------------
  // Initial deploy of diamond
  // ---------------------------

  const facets = [];

  const DiamondLibrary = await deployContract({ name: "DiamondLibrary" });
  console.log(`Deployed DiamondLibrary to ${DiamondLibrary.address}`);

  let OwnerFacet = await deployContract({
    name: "OwnerFacet",
    // libraries: { DiamondLibrary: DiamondLibrary.address },
  });
  facets.push([
    OwnerFacet.address,
    getSelectorsForContract({ contract: OwnerFacet }),
  ]);
  console.log(`Deployed OwnerFacet to ${OwnerFacet.address}`);

  let UpgradeFacet = await deployContract({
    name: "UpgradeFacet",
    libraries: { DiamondLibrary: DiamondLibrary.address },
  });
  facets.push([
    UpgradeFacet.address,
    getSelectorsForContract({ contract: UpgradeFacet }),
  ]);
  console.log(`Deployed UpgradeFacet to ${UpgradeFacet.address}`);

  const Synthetix = await deployContract({
    name: "DiamondProxy",
    args: [facets],
    libraries: { DiamondLibrary: DiamondLibrary.address },
  });
  console.log(`Deployed Synthetix to ${Synthetix.address}`);

  // ---------------------------
  // Re-wrap facets
  // ---------------------------

  OwnerFacet = await connetToContract({
    name: "OwnerFacet",
    address: Synthetix.address,
  });
  UpgradeFacet = await connetToContract({
    name: "UpgradeFacet",
    address: Synthetix.address,
  });

  // ---------------------------
  // Sanity checks
  // ---------------------------

  console.log(`owner: ${await OwnerFacet.getOwner()}`);
}

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
