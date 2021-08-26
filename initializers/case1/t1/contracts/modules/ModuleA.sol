//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

// imports 
import "../storage/ModuleAStorage.sol";


contract ModuleA is ModuleAStorageNamespace {
    /* MUTATIVE FUNCTIONS */
    // update some functions

    //...
    /* DEFAULT INITIALIZER FUNCTIONS */
    function defaultInitializer() {
        _moduleAStorage().daiAddress = '0x6b175474e89094c44da98b954eedeac495271d0f';
        _moduleAStorage().someValue = 42;
    }
}
