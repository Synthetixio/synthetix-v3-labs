//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./BaseModule.sol";


contract Rates is BaseModule {
    mapping(bytes32 => uint) public rateForCurrency;

    function setRate(bytes32 currencyKey, uint rate) external onlyOwner {
        rateForCurrency[currencyKey] = rate;
    }

    function getRate(bytes32 currencyKey) public view returns (uint) {
        return rateForCurrency[currencyKey];
    }
}
