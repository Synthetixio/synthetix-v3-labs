// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Proxy.sol";
import "./BeaconResolver.sol";


contract Beacon {
    uint256 private _contractsVersion;
    uint256 private _settingsVersion;

    // setting id => setting value
    mapping(bytes32 => uint) private _settings;

    // module id => module proxy address
    mapping(bytes32 => address) private _proxies;

    // module proxy address => proxy implementation address
    mapping(address => address) private _implementations;

    event ProxyCreated(bytes32 moduleId, address proxy);

    function upgrade(bytes32[] memory moduleIds, address[] memory newImplementations) public {
        uint len = moduleIds.length;
        for (uint i; i < len; i++) {
            bytes32 moduleId = moduleIds[i];
            address implementation = newImplementations[i];

            address proxy = _proxies[moduleId];
            if (proxy == address(0)) {
                proxy = _createProxy(moduleId);
            } else {
                // TODO: Upgrade implementation for existing proxy.
            }

            _implementations[proxy] = implementation;
        }

        _contractsVersion++;
    }

    function configure(bytes32[] memory settingIds, uint[] memory values) public {
        uint len = settingIds.length;
        for (uint i; i < len; i++) {
            bytes32 settingId = settingIds[i];
            uint value = values[i];

            _settings[settingId] = value;
        }

        _settingsVersion++;
    }

    function _createProxy(bytes32 moduleId) private returns (address) {
        address proxyAddress = address(new Proxy());
        _proxies[moduleId] = proxyAddress;

        emit ProxyCreated(moduleId, proxyAddress);

        return proxyAddress;
    }

    function suspend() public {
        // TODO
    }

    function resume() public {
        // TODO
    }

    function getProxy(bytes32 moduleId) public view returns (address) {
        return _proxies[moduleId];
    }

    function getImplementation(address proxy) public view returns (address) {
        return _implementations[proxy];
    }

    function getImplementationForSender() public view returns (address) {
        return _implementations[msg.sender];
    }

    function getContractsVersion() public view returns (uint) {
        return _contractsVersion;
    }

    function getSettingsVersion() public view returns (uint) {
        return _settingsVersion;
    }

    function getSetting(bytes32 settingId) public view returns (uint) {
        return _settings[settingId];
    }
}
