//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./ExchangerModule.sol";


contract IssuerModule {
    function getValueViaExchanger() public view returns (string memory) {
        return ExchangerModule(address(this)).getValue();
    }
}
