//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../modules/DebtCacheModule.sol"
import "../modules/ExchangeRatesModule.sol"
import "../modules/CollateralManagerModule.sol"

import "../storage/SynthStorage.sol";
import "../storage/EscrowStorage.sol";
import "../storage/IssuanceStorage.sol";
import "../storage/SettingsStorage.sol";

import "../mixins/Owned.sol";

import "../libraries/SafeDecimalMath";

import "openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol";


contract IssuerModule is
        Owned,
        SynthStorageAccessor,
        IssuanceStorageAccessor,
        EscrowStorageAccessor,
        SettingsStorageAccessor
    {
    using SafeMath for uint;
    using SafeDecimalMath for uint;

    bytes32 internal constant sUSD = "sUSD";
    bytes32 internal constant sETH = "sETH";
    bytes32 internal constant SNX = "SNX";

    constructor(address _owner, address _resolver) public {}

    /* ========== VIEWS ========== */

    function _availableCurrencyKeysWithOptionalSNX(bool withSNX) internal view returns (bytes32[] memory) {
        SynthStorage storage synthStorage = getSynthStorage();

        bytes32[] memory currencyKeys = new bytes32[](synthStorage.availableSynths.length + (withSNX ? 1 : 0));

        for (uint i = 0; i < synthStorage.availableSynths.length; i++) {
            currencyKeys[i] = synthStorage.synthsByAddress[address(synthStorage.availableSynths[i])];
        }

        if (withSNX) {
            currencyKeys[synthStorage.availableSynths.length] = SNX;
        }

        return currencyKeys;
    }

    function _totalIssuedSynths(bytes32 currencyKey, bool excludeCollateral)
        internal
        view
        returns (uint totalIssued, bool anyRateIsInvalid)
    {
        (uint debt, , bool cacheIsInvalid, bool cacheIsStale) = DebtCacheModule(address(this)).cacheInfo();
        anyRateIsInvalid = cacheIsInvalid || cacheIsStale;

        IExchangeRates exRates = ExchangeRatesModule(address(this));

        // Add total issued synths from non snx collateral back into the total if not excluded
        if (!excludeCollateral) {
            // Get the sUSD equivalent amount of all the MC issued synths.
            (uint nonSnxDebt, bool invalid) = CollateralManagerModule(address(this)).totalLong();
            debt = debt.add(nonSnxDebt);
            anyRateIsInvalid = anyRateIsInvalid || invalid;

            // Now add the ether collateral stuff as we are still supporting it.
            debt = debt.add(EtherCollateralsUSDModule(address(this)).totalIssuedSynths());

            // Add ether collateral sETH
            (uint ethRate, bool ethRateInvalid) = exRates.rateAndInvalid(sETH);
            uint ethIssuedDebt = EtherCollateralModule(address(this)).totalIssuedSynths().multiplyDecimalRound(ethRate);
            debt = debt.add(ethIssuedDebt);
            anyRateIsInvalid = anyRateIsInvalid || ethRateInvalid;
        }

        if (currencyKey == sUSD) {
            return (debt, anyRateIsInvalid);
        }

        (uint currencyRate, bool currencyRateInvalid) = exRates.rateAndInvalid(currencyKey);
        return (debt.divideDecimalRound(currencyRate), anyRateIsInvalid || currencyRateInvalid);
    }

    function _debtBalanceOfAndTotalDebt(address _issuer, bytes32 currencyKey)
        internal
        view
        returns (
            uint debtBalance,
            uint totalSystemValue,
            bool anyRateIsInvalid
        )
    {
        IssuanceStorage storage issuanceStorage = issuanceStorage();

        // What was their initial debt ownership?
        (uint initialDebtOwnership, uint debtEntryIndex) = issuanceStorage.issuanceData(_issuer);

        // What's the total value of the system excluding ETH backed synths in their requested currency?
        (totalSystemValue, anyRateIsInvalid) = _totalIssuedSynths(currencyKey, true);

        // If it's zero, they haven't issued, and they have no debt.
        // Note: it's more gas intensive to put this check here rather than before _totalIssuedSynths
        // if they have 0 SNX, but it's a necessary trade-off
        if (initialDebtOwnership == 0) return (0, totalSystemValue, anyRateIsInvalid);

        // Figure out the global debt percentage delta from when they entered the system.
        // This is a high precision integer of 27 (1e27) decimals.
        uint currentDebtOwnership = issuanceStorage_lastDebtLedgerEntry()
            .divideDecimalRoundPrecise(state.debtLedger(debtEntryIndex))
            .multiplyDecimalRoundPrecise(initialDebtOwnership);

        // Their debt balance is their portion of the total system value.
        uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal().multiplyDecimalRoundPrecise(
            currentDebtOwnership
        );

        // Convert back into 18 decimals (1e18)
        debtBalance = highPrecisionBalance.preciseDecimalToDecimal();
    }

    function _canBurnSynths(address account) internal view returns (bool) {
        return now >= issuanceStorage().lastIssueEvent[account].add(getMinimumStakeTime());
    }

    function _remainingIssuableSynths(address _issuer)
        internal
        view
        returns (
            uint maxIssuable,
            uint alreadyIssued,
            uint totalSystemDebt,
            bool anyRateIsInvalid
        )
    {
        (alreadyIssued, totalSystemDebt, anyRateIsInvalid) = _debtBalanceOfAndTotalDebt(_issuer, sUSD);
        (uint issuable, bool isInvalid) = _maxIssuableSynths(_issuer);
        maxIssuable = issuable;
        anyRateIsInvalid = anyRateIsInvalid || isInvalid;

        if (alreadyIssued >= maxIssuable) {
            maxIssuable = 0;
        } else {
            maxIssuable = maxIssuable.sub(alreadyIssued);
        }
    }

    function _snxToUSD(uint amount, uint snxRate) internal pure returns (uint) {
        return amount.multiplyDecimalRound(snxRate);
    }

    function _usdToSnx(uint amount, uint snxRate) internal pure returns (uint) {
        return amount.divideDecimalRound(snxRate);
    }

    function _maxIssuableSynths(address _issuer) internal view returns (uint, bool) {
        // What is the value of their SNX balance in sUSD
        (uint snxRate, bool isInvalid) = ExchangeRatesModule(address(this)).rateAndInvalid(SNX);
        uint destinationValue = _snxToUSD(_collateral(_issuer), snxRate);

        // They're allowed to issue up to issuanceRatio of that value
        return (destinationValue.multiplyDecimal(getIssuanceRatio()), isInvalid);
    }

    function _collateralisationRatio(address _issuer) internal view returns (uint, bool) {
        uint totalOwnedSynthetix = _collateral(_issuer);

        (uint debtBalance, , bool anyRateIsInvalid) = _debtBalanceOfAndTotalDebt(_issuer, SNX);

        // it's more gas intensive to put this check here if they have 0 SNX, but it complies with the interface
        if (totalOwnedSynthetix == 0) return (0, anyRateIsInvalid);

        return (debtBalance.divideDecimalRound(totalOwnedSynthetix), anyRateIsInvalid);
    }

    function _collateral(address account) internal view returns (uint) {
        uint balance = getGlobalStorage().snx.balanceOf(account);
        balance = balance.add(getEscrowStorage().balanceOf[account]);

        return balance;
    }

    function minimumStakeTime() external view returns (uint) {
        return settingsStorage().minimumStakeTime;
    }

    function canBurnSynths(address account) external view returns (bool) {
        return _canBurnSynths(account);
    }

    function availableCurrencyKeys() external view returns (bytes32[] memory) {
        return _availableCurrencyKeysWithOptionalSNX(false);
    }

    function availableSynthCount() external view returns (uint) {
        return synthStorage().availableSynths.length;
    }

    function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid) {
        (, anyRateInvalid) = ExchangeRatesModule(address(this)).ratesAndInvalidForCurrencies(_availableCurrencyKeysWithOptionalSNX(true));
    }

    function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint totalIssued) {
        (totalIssued, ) = _totalIssuedSynths(currencyKey, excludeEtherCollateral);
    }

    function lastIssueEvent(address account) external view returns (uint) {
        return issuanceStorage().lastIssueEvent[account];
    }

    function collateralisationRatio(address _issuer) external view returns (uint cratio) {
        (cratio, ) = _collateralisationRatio(_issuer);
    }

    function collateralisationRatioAndAnyRatesInvalid(address _issuer)
        external
        view
        returns (uint cratio, bool anyRateIsInvalid)
    {
        return _collateralisationRatio(_issuer);
    }

    function collateral(address account) external view returns (uint) {
        return _collateral(account);
    }

    function debtBalanceOf(address _issuer, bytes32 currencyKey) external view returns (uint debtBalance) {
        // What was their initial debt ownership?
        (uint initialDebtOwnership, ) = issuanceStorage().issuanceData(_issuer);

        // If it's zero, they haven't issued, and they have no debt.
        if (initialDebtOwnership == 0) return 0;

        (debtBalance, , ) = _debtBalanceOfAndTotalDebt(_issuer, currencyKey);
    }

    // ETC...
}
