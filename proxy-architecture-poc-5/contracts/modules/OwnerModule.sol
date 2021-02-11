//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../mixins/OwnerMixin.sol";


contract OwnerModule is OwnerMixin {
    /* MUTATIVE FUNCTIONS */

    function setOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");

        _ownerStorage().owner = newOwner;
    }

    /* VIEW FUNCTIONS */

    function getOwner() public view returns (address) {
        return _ownerStorage().owner;
    }
}
