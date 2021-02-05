
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/math/SafeMath.sol";


library DecimalMath {
    using SafeMath for uint;

    uint public constant UNIT = 10**18;

    function multiplyDecimal(uint a, uint b) internal pure returns (uint) {
        return a.mul(b) / UNIT;
    }

    function divideDecimal(uint a, uint b) internal pure returns (uint) {
        return a.mul(UNIT).div(b);
    }
}
