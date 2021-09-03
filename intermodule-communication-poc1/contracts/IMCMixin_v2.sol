//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract IMCMixinV2 {

    function getUpgradeModuleAddress() internal pure returns (address) {
        return 0x8E3C115787FA05Ea526175Fa1b939d3b1F546314;
    }
    function getSettingsModuleAddress() internal pure returns (address) {
        return 0xC5778be11e8c03b8635D3F7b500E8C5436EA4C70;
    }
    function getOwnerModuleAddress() internal pure returns (address) {
        return 0x267ccE7a76e6a76D98D2022cc46E047451021248;
    }
    function getAModuleAddress() internal pure returns (address) {
        return 0xE6deF028B0D79497dC2E421526CF22673c563004;
    }
    function getBModuleAddress() internal pure returns (address) {
        return 0x0000000000000000000000000000000000000000;
    }
    function getRegistryModuleAddress() internal pure returns (address) {
        return 0x89D7B5891130Ef7566015188aeabc2dDec21F7D0;
    }

}