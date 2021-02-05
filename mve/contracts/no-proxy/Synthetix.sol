//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./Exchanger.sol";
import "./Issuer.sol";
import "./Rates.sol";


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
        // TODO
    }

    function withdraw(uint amount) externla {
        // TODO
    }

    function issue(uint amount) external {
        // TODO
    }

    function burn(uint amount) external {
        // TODO
    }

    function exchange(
        bytes32 fromCurrency,
        uint fromAmount,
        bytes32 toCurrency
    ) external returns (uint) {
        // TODO
    }
}
