
// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

contract Upgradeable {
    // bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1))
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    // bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
    bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    modifier ifAdmin() {
        if (msg.sender == getAdmin()) {
            _;
        } else {
            _fallback();
        }
    }

    constructor() {
        address firstAdmin = msg.sender;

        bytes32 slot = _ADMIN_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            sstore(slot, firstAdmin)
        }
    }

    function setImplementation(address newImplementation) public ifAdmin {
        bytes32 slot = _IMPLEMENTATION_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            sstore(slot, newImplementation)
        }
    }

    function getImplementation() public view returns (address implementation) {
        bytes32 slot = _IMPLEMENTATION_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            implementation := sload(slot)
        }
    }

    function setAdmin(address newAdmin) public ifAdmin {
        bytes32 slot = _ADMIN_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            sstore(slot, newAdmin)
        }
    }

    function getAdmin() public view returns (address admin) {
        bytes32 slot = _ADMIN_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            admin := sload(slot)
        }
    }

    function _fallback() public virtual {}

    function destroy() public {
        selfdestruct(msg.sender);
    }
}
