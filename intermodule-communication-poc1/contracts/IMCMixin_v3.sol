//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract IMCMixinV3 {
    address constant internal _UpgradeModule = 0x8E3C115787FA05Ea526175Fa1b939d3b1F546314;
    address constant internal _SettingsModule = 0xC5778be11e8c03b8635D3F7b500E8C5436EA4C70;
    address constant internal _OwnerModule = 0x267ccE7a76e6a76D98D2022cc46E047451021248;
    address constant internal _AModule = 0xE6deF028B0D79497dC2E421526CF22673c563004;
    address constant internal _BModule = 0x0000000000000000000000000000000000000000;
    address constant internal _RegistryModule = 0x89D7B5891130Ef7566015188aeabc2dDec21F7D0;

    mapping(bytes32 => address) addresses;
    bool initialized;

    function _initializer() internal {
        if (!initialized) {
            addresses["UpgradeModule"] = _UpgradeModule;
            addresses["SettingsModule"] = _SettingsModule;
            addresses["OwnerModule"] = _OwnerModule;
            addresses["AModule"] = _AModule;
            addresses["BModule"] = _BModule;
            addresses["RegistryModule"] = _RegistryModule;
            initialized = true;
        }
    }

    /* VIEW FUNCTIONS */

    function getModuleAddress(bytes32 moduleId) internal view returns (address) {
        return addresses[moduleId];
    }

}