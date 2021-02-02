//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./ExchangerModule.sol";
import "../storage/IssuanceStorage.sol";
import "../mixins/OwnerMixin.sol";


contract IssuerModule is IssuanceStorageAccessor, OwnerMixin {
    function getVersionViaExchanger() public view returns (string memory) {
        return ExchangerModule(address(this)).getSystemVersion();
    }

    function setOracleType(string memory newOracleType) public onlyOwner {
        issuanceStorage().oracleType = newOracleType;
    }

    function getOracleType() public view returns (string memory) {
        return issuanceStorage().oracleType;
    }
}
