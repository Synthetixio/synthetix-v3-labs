//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../storage/ProxyStorage.sol";
import "@openzeppelin/contracts/utils/Address.sol";


contract UpgradeMixin is ProxyStorageNamespace {
    /* MUTATIVE FUNCTIONS */

    function _upgradeTo(address newImplementation) internal {
        require(newImplementation != address(0), "Invalid new implementation: zero address");
        require(Address.isContract(newImplementation), "Invalid new implementation: not a contract");
        _requireIsUpgradeable(newImplementation);

        _setImplementation(newImplementation);
    }

    function _requireIsUpgradeable(address newImplementation) private {
        // Doing a call allows us to throw a prettier error
        // in case that the `isUpgradeable` selector doesnt exist.
        (bool success, bytes memory data) = address(newImplementation).call(
            abi.encodeWithSelector(UpgradeMixin(0).isUpgradeable.selector)
        );

        bool isUpgradeable = abi.decode(data, (bool));

        require(success && isUpgradeable, "Invalid new implementation: not upgradeable");
    }

    /* VIEW FUNCTIONS */

    function isUpgradeable() public pure returns (bool) {
        return true;
    }

    function getImplementation() public view returns (address) {
        return _getImplementation();
    }

    function getKnownValue() public pure returns (uint) {
        return 42;
    }
}
