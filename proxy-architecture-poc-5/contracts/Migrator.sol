//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./modules/OwnerModule.sol";
import "./modules/UpgradeModule.sol";
import "./modules/StatusModule.sol";


contract Migrator {
    address public constant Synthetix = 0x3E661784267F128e5f706De17Fac1Fc1c9d56f30;
    address public constant newRouter = 0x8f119cd256a0FfFeed643E830ADCD9767a1d517F;

    OwnerModule public constant ownerModule = OwnerModule(Synthetix);
    UpgradeModule public constant upgradeModule = UpgradeModule(Synthetix);
    StatusModule public constant statusModule = StatusModule(Synthetix);

    address public owner;

    function migrate() public {
        _takeOwnership();
        _preliminaryChecks();
        _suspendSystem();
        _upgradeRouter();
        _initializeModules();
        _registerModules();
        _upgradeSettings();
        _resumeSystem();
        _concludingChecks();
        _restoreOwnership();
    }

    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Upgrade / initialize
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    function _upgradeRouter() internal {
        upgradeModule.upgradeTo(newRouter);
    }

    function _initializeModules() internal {
        // TODO
    }

    function _registerModules() internal {
        // TODO
    }

    function _upgradeSettings() internal {
        // TODO
    }

    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Validate / test
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    function _preliminaryChecks() internal {
        // TODO
    }

    function _concludingChecks() internal {
        // TODO

        require(ownerModule.getOwner() == owner, "Owner not restored");
    }

    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Suspend / resume
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    function _suspendSystem() internal {
        statusModule.suspendSystem();
    }

    function _resumeSystem() internal {
        statusModule.resumeSystem();
    }

    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Ownership
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    function _takeOwnership() internal {
        require(ownerModule.getNominatedOwner() == address(this), "Migrator not nominated for ownership");

        owner = ownerModule.getOwner();
        ownerModule.acceptOwnership();

        require(ownerModule.getOwner() == address(this), "Could not take ownership");
    }

    function _restoreOwnership() internal {
        require(ownerModule.getOwner() == address(this), "Migrator is not owner");

        ownerModule.nominateOwner(owner);
        owner = address(0);
    }
}
