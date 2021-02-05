//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./BaseModule.sol";
import "../erc20/Token.sol";
import "../libraries/DecimalMath.sol";


contract Exchanger is BaseModule {
    using DecimalMath for uint;

    mapping(bytes32 => Token) synthForCurrency;

    function addSynth(bytes32 currencyKey, Token synth) external onlyOwner {
        synthForCurrency[currencyKey] = synth;
    }

    function removeSynth(bytes32 currencyKey) external onlyOwner {
        synthForCurrency[currencyKey] = Token(0);
    }

    function exchange(
        bytes32 fromCurrency,
        uint fromAmount,
        bytes32 toCurrency
    ) external returns (uint) {
        Token fromToken = synthForCurrency[fromCurrency];
        require(fromToken != Token(0), "Invalid fromCurrency");

        Token toToken = synthForCurrency[toCurrency];
        require(toToken != Token(0), "Invalid toCurrency");

        require(fromToken.balanceOf(msg.sender) >= amount, "Insufficient fromToken balance")

        uint fromRate = synthetix.rates.getRate(fromCurrency);
        uint toRate = synthetix.rates.getRate(toCurrency);

        uint fromValue = fromAmount.multiplyDecimal(fromRate);
        uint toAmount = fromValue.div(toRate);

        fromToken.burn(msg.sender, fromAmount);
        toToken.mint(msg.sender, toAmount);
    }
}
