//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./modules/Exchanger.sol";
import "./modules/Issuer.sol";
import "./modules/Rates.sol";


contract Synthetix {
    Exchanger public exchanger;
    Issuer public issuer;
    Rates public rates;

    constructor(
        Exchanger newExchanger,
        Issuer newIssuer,
        Rates newRates,
    ) {
        exchanger = newExchanger;
        issuer = newIssuer;
        rates = newRates;
    }

    function stake(uint amount) external {
        issuer.stake(amount);
    }

    function withdraw(uint amount) externla {
        issuer.withdraw(amount);
    }

    function issue(uint amount) external {
        issuer.issue(amount);
    }

    function burn(uint amount) external {
        issuer.burn(amount);
    }

    function exchange(
        bytes32 fromCurrency,
        uint fromAmount,
        bytes32 toCurrency
    ) external returns (uint) {
        exchanger.exchange(fromCurrency, fromAmount, toCurrency);
    }
}
