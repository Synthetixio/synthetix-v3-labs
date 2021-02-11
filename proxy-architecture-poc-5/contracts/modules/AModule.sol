//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./BModule.sol";


contract AModule {
    /* MUTATIVE FUNCTIONS */

    function setValueViaBModule_cast(uint newValue) public {
        BModule(address(this)).setValue(newValue);
    }

    /* VIEW FUNCTIONS */

}
