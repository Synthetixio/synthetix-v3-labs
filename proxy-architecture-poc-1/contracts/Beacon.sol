// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

import "./Proxy.sol";


contract Beacon {
    // ---------------------------------
    // State
    // ---------------------------------

    uint256 private _contractsVersion;
    uint256 private _settingsVersion;

    // setting id => setting value
    mapping(bytes32 => uint) private _settings;

    // module id => module proxy address
    mapping(bytes32 => address) private _proxies;

    // module proxy address => proxy implementation address
    mapping(address => address) private _implementations;

    address private _admin;
    address private _stagedAdmin;
    address private _stagedMigrator;

    // ---------------------------------
    // Events
    // ---------------------------------

    event ProxyCreated(bytes32 moduleId, address proxy);

    // ---------------------------------
    // Modifiers
    // ---------------------------------

    modifier onlyAdmin() {
        require(msg.sender == _admin, "Only the admin can call this");
        _;
    }

    modifier onlyMigrator() {
        require(msg.sender == _stagedMigrator, "Only the admin can call this");
        _;
    }

    // ---------------------------------
    // Mutative functions
    // ---------------------------------

    constructor() {
        _admin = msg.sender;
    }

    function stageMigrator(address migrator) public onlyAdmin {
        _stagedMigrator = migrator;
    }

    function stageAdmin(address newAdmin) public onlyAdmin {
        _stagedAdmin = newAdmin;
    }

    function acceptAdmin() public {
        require(msg.sender == _stagedAdmin, "Sender is not staged");
        _admin = _stagedAdmin;
    }

    function releaseMigrator() public onlyMigrator {
        _stagedMigrator = address(0);
    }

    function upgrade(bytes32[] memory moduleIds, address[] memory newImplementations) public onlyMigrator {
        uint len = moduleIds.length;
        for (uint i; i < len; i++) {
            bytes32 moduleId = moduleIds[i];
            address implementation = newImplementations[i];

            address proxy = _proxies[moduleId];
            if (proxy == address(0)) {
                proxy = _createProxy(moduleId);
            }

            // TODO: delete proxy if newImplementation = 0x0?

            _implementations[proxy] = implementation;
        }

        _contractsVersion++;
    }

    function configure(bytes32[] memory settingIds, uint[] memory values) public onlyMigrator {
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

    function suspend() public onlyMigrator {
        // TODO
    }

    function resume() public onlyMigrator {
        // TODO
    }

    // ---------------------------------
    // View functions
    // ---------------------------------

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
