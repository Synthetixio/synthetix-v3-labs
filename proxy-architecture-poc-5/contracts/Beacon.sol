//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

contract Beacon {
    address constant Router = 0x987e855776C03A4682639eEb14e65b3089EE6310;

    function getImplementation() public pure returns (address) {
        return Router;
    }
}
