//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../mixins/OwnerMixin.sol";
import "../mixins/UpgradeMixin.sol";
import "../storage/ProxyStorage.sol";
import "@openzeppelin/contracts/utils/Address.sol";


contract UpgradeModule is UpgradeMixin, OwnerMixin {
    /* MUTATIVE FUNCTIONS */

    function upgradeTo(address newImplementation) public onlyOwner {
        _upgradeTo(newImplementation);

        _validateUpgrade();
    }

    function _validateUpgrade() private {
        bool isValid = false;

        try this.canUpgradeAgain() {
          revert();
        } catch Error(string memory) {
          isValid = true;
        } catch (bytes memory) {}

        if (!isValid) {
            revert("Target upgrade is not safe");
        }
    }

    function canUpgradeAgain() public {
        ProxyStorage storage store = _proxyStorage();
        if (store.safeImplementation == address(0)) {
            store.safeImplementation = address(new UpgradeMixin());
        }

        _upgradeTo(store.safeImplementation);

        if (this.getKnownValue() == 42) {
            revert("ok");
        }

        revert();
    }

    /* VIEW FUNCTIONS */

}
