//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/proxy/UpgradeableProxy.sol";


contract Synthetix is UpgradeableProxy {
    constructor(address firstImplementation)
        UpgradeableProxy(
            firstImplementation,
            bytes("")
        )
    {}
}


// import "./storage/ProxyStorage.sol";


// contract Synthetix is ProxyStorageNamespace {
//     constructor(address firstImplementation) {
//         _setImplementation(firstImplementation);
//     }

//     fallback() external {
//         address implementation = _getImplementation();

//         assembly {
//             calldatacopy(0, 0, calldatasize())

//             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
//             returndatacopy(0, 0, returndatasize())

//             switch result
//             case 0 {
//                 revert(0, returndatasize())
//             }
//             default {
//                 return(0, returndatasize())
//             }
//         }
//     }
// }
