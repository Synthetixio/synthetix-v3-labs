const { expect } = require('chai');

describe('Synthetix v3', function() {
  let beacon;

  const nebulaModuleId = ethers.utils.formatBytes32String('nebula'); // 0x6e6562756c610000000000000000000000000000000000000000000000000000
  let nebulaProxy;

  const pulsarModuleId = ethers.utils.formatBytes32String('pulsar'); // 0x70756c7361720000000000000000000000000000000000000000000000000000
  let pulsarProxy;

  const cratioSettingId = ethers.utils.formatBytes32String('cratio'); // 0x63726174696f0000000000000000000000000000000000000000000000000000

  // ----------------------------------------
  // Version 1
  // ----------------------------------------

  describe('when deploying version 1', () => {
    before('deploy the beacon', async () => {
      const Beacon = await ethers.getContractFactory('Beacon');
      beacon = await Beacon.deploy();

      await beacon.deployed();
    });

    before('deploy and run the first migrator', async () => {
      const Migrator = await ethers.getContractFactory('MigrateToV1');
      const migrator = await Migrator.deploy();
      await migrator.deployed();

      let tx;

      tx = await beacon.stageMigrator(migrator.address);
      await tx.wait();

      tx = await migrator.prepareForMigration(beacon.address);
      await tx.wait();

      tx = await migrator.migrateContracts();
      await tx.wait();

      tx = await migrator.initializeProxies();
      await tx.wait();

      tx = await migrator.migrateSettings();
      await tx.wait();

      tx = await migrator.finalizeMigration();
      await tx.wait();
    });

    before('identify newly created proxies', async () => {
      let proxyAddress = await beacon.getProxy(nebulaModuleId);
      nebulaProxy = await ethers.getContractAt(
        'NebulaV1',
        proxyAddress
      );

      proxyAddress = await beacon.getProxy(pulsarModuleId);
      pulsarProxy = await ethers.getContractAt(
        'PulsarV1',
        proxyAddress
      );
    });

    it('retrieves the correct version from the beacon', async () => {
      expect(await beacon.getVersion()).to.equal('1');
    });

    it('properly forwards to the implementations', async () => {
      expect(await nebulaProxy.whoami()).to.equal('NebulaV1');
      expect(await pulsarProxy.whoami()).to.equal('PulsarV1');
    });

    it('initialized someVal in nebulaProxy', async () => {
      expect(await nebulaProxy.getSomeVal()).to.equal('42');
    });

    it('retrieves settings correctly', async () => {
      expect(await beacon.getSetting(cratioSettingId)).to.equal(600);
    });

    it('reverts when attempting to call an initializer again', async () => {
      expect(nebulaProxy.initialize(beacon.address)).to.be.reverted;
    });

    // ----------------------------------------
    // Configure version 1
    // ----------------------------------------

    describe('when upgrading the system to version 2', () => {
      before('deploy and run the migrator', async () => {
        const Migrator = await ethers.getContractFactory('MigrateToV2');
        const migrator = await Migrator.deploy();
        await migrator.deployed();

        let tx;

        tx = await beacon.stageMigrator(migrator.address);
        await tx.wait();

        tx = await migrator.prepareForMigration(beacon.address);
        await tx.wait();

        tx = await migrator.migrateSettings();
        await tx.wait();

        tx = await migrator.finalizeMigration();
        await tx.wait();
      });

      it('retrieves the correct version from the beacon', async () => {
        expect(await beacon.getVersion()).to.equal('2');
      });

      it('retrieves settings correctly', async () => {
        expect(await beacon.getSetting(cratioSettingId)).to.equal(500);
      });

      // ----------------------------------------
      // Version 2
      // ----------------------------------------

      describe('when upgrading the system to version 3', () => {
        before('deploy and run the migrator', async () => {
          const Migrator = await ethers.getContractFactory('MigrateToV3');
          const migrator = await Migrator.deploy();
          await migrator.deployed();

          let tx;

          tx = await beacon.stageMigrator(migrator.address);
          await tx.wait();

          tx = await migrator.prepareForMigration(beacon.address);
          await tx.wait();

          tx = await migrator.migrateContracts();
          await tx.wait();

          tx = await migrator.initializeProxies();
          await tx.wait();

          tx = await migrator.finalizeMigration();
          await tx.wait();
        });

        before('update to the new proxy abi', async () => {
          const proxyAddress = await beacon.getProxy(nebulaModuleId);
          nebulaProxy = await ethers.getContractAt(
            'NebulaV2',
            proxyAddress
          );
        });

        it('retrieves the correct versions from the beacon', async () => {
          expect(await beacon.getVersion()).to.equal('3');
        });

        it('initialized someVal in nebulaProxy', async () => {
          expect(await nebulaProxy.getSomeVal()).to.equal('42');
        });

        it('initialized someOtherVal in nebulaProxy', async () => {
          expect(await nebulaProxy.getSomeOtherVal()).to.equal('33');
        });

        it('properly forwards to the implementations', async () => {
          expect(await nebulaProxy.whoami()).to.equal('NebulaV2');
          expect(await pulsarProxy.whoami()).to.equal('PulsarV1');
        });

        it('enables modules to know about each other', async () => {
          expect(await nebulaProxy.whoispulsar(), 'PulsarV1');
        });

        it('enables modules to know about settings', async () => {
          expect(await nebulaProxy.getCRatio()).to.equal(500);
        });

        it('reverts when attempting to call an initializer again', async () => {
          expect(nebulaProxy.initializeV2()).to.be.reverted;
        });
      });
    });
  });
});
