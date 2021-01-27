const fs = require("fs");

async function deploy() {
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

  async function deployContract({ name, args = [] }) {
    const factory = await ethers.getContractFactory(name);

    return await factory.deploy(...args);
  }

  async function connetToContract({ name, address }) {
    return await ethers.getContractAt(name, address);
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

  const facets = [];

  const DiamondLibrary = await deployContract({ name: "DiamondLibrary" });
  console.log(`Deployed DiamondLibrary to ${DiamondLibrary.address}`);

  let OwnerFacet = await deployContract({ name: "OwnerFacet" });
  facets.push([
    OwnerFacet.address,
    getSelectorsForContract({ contract: OwnerFacet }),
  ]);
  console.log(`Deployed OwnerFacet to ${OwnerFacet.address}`);

  let UpgradeFacet = await deployContract({ name: "UpgradeFacet" });
  facets.push([
    UpgradeFacet.address,
    getSelectorsForContract({ contract: UpgradeFacet }),
  ]);
  console.log(`Deployed UpgradeFacet to ${UpgradeFacet.address}`);

  const Synthetix = await deployContract({
    name: "DiamondProxy",
    args: [facets],
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

  console.log(`Synthetix owner: ${await OwnerFacet.getOwner()}`);
}

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
