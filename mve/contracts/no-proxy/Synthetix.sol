//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./erc20/Token.sol";
import "./modules/Exchanger.sol";
import "./modules/Issuer.sol";
import "./modules/Rates.sol";


contract Synthetix {
    Token SNX;
    Token USD;
    Token ETH;
    Token BTC;

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

        SNX = new Token(
            "Synthetix Network Token",
            "SNX",
            100000000 ether
        );

        USD = new Token(
            "Synthetic US Dollar",
            "sUSD",
            0
        );

        ETH = new Token(
            "Synthetic Ether",
            "sETH",
            0
        );

        BTC = new Token(
            "Synthetic Bitcoin",
            "sBTC",
            0
        );

        rates.setRate(bytes32(USD.symbol), 1 ether);
        rates.setRate(bytes32(SNX.symbol), 60 ether);
        rates.setRate(bytes32(ETH.symbol), 2000 ether);
        rates.setRate(bytes32(BTC.symbol), 40000 ether);

        exchanger.addSynth(ETH);
        exchanger.addSynth(BTC);
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
