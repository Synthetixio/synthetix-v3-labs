//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./ExchangerModule.sol";
import "../storage/IssuanceStorage.sol";


contract IssuerModule is IssuanceStorageAccessor {
    function getVersionViaExchanger() public view returns (string memory) {
        return ExchangerModule(address(this)).getSystemVersion();
    }

    function setOracleType(string memory newOracleType) public {
        issuanceStorage().oracleType = newOracleType;
    }

    function getOracleType() public view returns (string memory) {
        return issuanceStorage().oracleType;
    }
}
