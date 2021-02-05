//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "../Synthetix.sol";


contract BaseModule {
    Synthetix public synthetix;

    constructor(Synthetix newSynthetix) {
        synthetix = newSynthetix;
    }
}
