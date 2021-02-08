//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;


abstract contract IssuanceStorageAccessor {
    bytes32 constant STORAGE_POSITION = keccak256("io.synthetix.issuance");

    struct IssuanceStorage {
        // Issued synth balances for individual fee entitlements and exit price calculations
        mapping(address => IssuanceData) issuanceData;

        // The total count of people that have outstanding issued synths in any flavour
        uint public totalIssuerCount;

        // Global debt pool tracking
        uint[] public debtLedger;

        mapping(address => uint) lastIssueEvent;
    }

    // A struct for handing values associated with an individual user's debt position
    struct IssuanceData {
        // Percentage of the total debt owned at the time
        // of issuance. This number is modified by the global debt
        // delta array. You can figure out a user's exit price and
        // collateralisation ratio using a combination of their initial
        // debt and the slice of global debt delta which applies to them.
        uint initialDebtOwnership;
        // This lets us know when (in relative terms) the user entered
        // the debt pool so we can calculate their exit price and
        // collateralistion ratio
        uint debtEntryIndex;
    }

    function getIssuanceStorage() internal pure returns (IssuanceStorage storage store) {
        bytes32 position = STORAGE_POSITION;

        assembly {
            store.slot := position
        }
    }

    function issuanceStorage_lastDebtLedgerEntry() external view returns (uint) {
        return debtLedger[debtLedger.length - 1];
    }
}
