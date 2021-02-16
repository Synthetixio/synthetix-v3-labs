async function getSelectorsForModule(moduleName) {
  const contract = await ethers.getContractAt(moduleName, '0x0000000000000000000000000000000000000001');

  return contract.interface.fragments.reduce((selectors, fragment) => {
    if (fragment.type === "function") {
      selectors.push({
        name: fragment.name,
        selector: contract.interface.getSighash(fragment)
      });
    }

    return selectors;
  }, []);
}

module.exports = {
	getSelectorsForModule,
};
