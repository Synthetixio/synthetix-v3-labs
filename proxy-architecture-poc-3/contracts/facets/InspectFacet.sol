// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "../DiamondLibrary.sol";

contract InspectFacet {
    function implementationForSelector(bytes4 selector) external view returns (address) {
        return DiamondLibrary.proxyStorage().implementationForSelector[selector];
    }
}
