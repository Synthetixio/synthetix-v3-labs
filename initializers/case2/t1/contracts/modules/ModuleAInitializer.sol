//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

// imports 
import "../storage/ModuleAStorage.sol";


contract ModuleAInitializer is ModuleAStorageNamespace {
    function mainnetInitializer() {
        _moduleAStorage().daiAddress = '0x6b175474e89094c44da98b954eedeac495271d0f';
        _moduleAStorage().someValue = 42;
    }
    function kovanInitializer() {
        _moduleAStorage().daiAddress = '0x04d8a950066454035b04fe5e8f851f7045f0e6b3';
        _moduleAStorage().someValue = 42;
    }
    function localInitializer() {
        _moduleAStorage().daiAddress = '0x0000000000000000000000000000000000000011'; 
        // Address on local deployment?? will change on each test
        _moduleAStorage().someValue = 24; // local uses another value
    }
    
}
