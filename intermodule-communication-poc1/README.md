# Tests on inter module communications

## Concepts
The idea of the Inter Module Communication is to allow communication between modules in a cheap (not consuming much gas) way.

This concept adds a mixing (three in fact) where the addresses are pre-filled and hardcoded. 

The modules requiring communication to other modules can inherit this mixin as shown in AModule.sol and access the addresses to cast another module.

IMCMixin_v1 and IMCMixin_v2 are simmilar in cost but require the addresses of the modules to be known before compiling the modules.

IMCMixin_v3 is costlier since uses storage for holding the values but the addresses can be set after the modules are deployed.

The gas used in a single assign is *~11* using a constant (v1 mode), and *~46* for a pure function call (v2 mode) while using the storage takes *~2268* gas.

## Process
In order to use constants or pure functions calls we require to know the address of the contracts (modules) that are going to be deployed beforehand to set the addresses. So, the steps involved are:

1- Make a dummy mixing with fake address (can be all 0x0). Needed to pass the linter.

2- Code the contracts using the mixing.

3- At deployer scan for the contracts that need to be deployed, their order and pre-calculate the address of the contracts that are going to be deployed. See notes below.

4- Set the right addresses in the IMC mixing.

5- Compile the contracts. 

6- Deploy the contracts in the order defined at step 3.

7- Confirm the addresses are the right ones (pre-calculated at step 3).

8- Continue with the deployment process (build and deploy the router, etc.)

## Notes
This snippet can be used to pre-calculate the address of the contracts to be deployed
```
	async evaluateNextDeployedContractAddress() {
		const nonce = await this.provider.getTransactionCount(this.account);
		const rlpEncoded = ethers.utils.RLP.encode([this.account, ethers.utils.hexlify(nonce)]);
		const hashed = ethers.utils.keccak256(rlpEncoded);

		return `0x${hashed.slice(12).substring(14)}`;
	}
```

