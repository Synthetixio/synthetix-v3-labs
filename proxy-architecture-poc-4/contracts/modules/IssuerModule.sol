//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./ExchangerModule.sol";
import "../storage/IssuanceStorage.sol";
import "../mixins/OwnerMixin.sol";


library IssuerModule {
    function getVersionViaExchanger() public view returns (string memory) {
        return ExchangerModule.getSystemVersion();
    }

    function setOracleType(string memory newOracleType) public {
        OwnerMixin.requireOwner();

        IssuanceStorage.store().oracleType = newOracleType;
    }

    function getOracleType() public view returns (string memory) {
        return IssuanceStorage.store().oracleType;
    }
}
