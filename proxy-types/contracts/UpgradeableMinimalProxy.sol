// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.8.0;

/*
|           Position        Opcode         Instruction           Stack                    Description
|           0x00000000      36             calldatasize          cds                      Pushes the size of calldata to the stack
|           0x00000001      3d             returndatasize        0 cds                    Pushes 0 to the stack
|           0x00000002      3d             returndatasize        0 0 cds                  Pushes 0 to the stack
|           0x00000003      37             calldatacopy                                   Copies calldata to memory position 0
|           0x00000004      3d             returndatasize        0                        Pushes 0 to the stack
|           0x00000005      3d             returndatasize        0 0                      Pushes 0 to the stack
|           0x00000006      3d             returndatasize        0 0 0                    Pushes 0 to the stack
|           0x00000007      36             calldatasize          cds 0 0 0                Pushes the size of calldata to the stack
|           0x00000008      3d             returndatasize        0 cds 0 0 0              Pushes 0 to the stack
|           0x00000009      7f360894a13b.  push32 0x360894a13b.  slot 0 cds 0 0 0         Pushes the implementation slot to the stack
|           0x0000002a      54             sload                 0xbebe 0 cds 0 0 0 .     Reads the implementation from storage
|           0x0000002b      5a             gas                   gas 0xbebe 0 cds 0 0 0.  Pushes available gas to the stack
|           0x0000002c      f4             delegatecall          suc 0                    delegatecall(gas, 0xbebe, 0 value, calldata) => returns suc "success"
|           0x0000002d      3d             returndatasize        rds suc 0                Pushes size of return data to stack
|           0x0000002e      82             dup3                  0 rds suc 0              Pushes 0 to the stack
|           0x0000002f      80             dup1                  0 0 rds suc 0            Pushes 0 to the stack
|           0x00000030      3e             returndatacopy        suc 0                    Copies rds bytes from return data to memory
|           0x00000031      90             swap1                 0 suc                    Swaps the first 2 elements in the stack
|           0x00000032      3d             returndatasize        rds 0 suc                Pushes size of return data to stack
|           0x00000033      91             swap2                 suc 0 rds                Swaps the first and 2nd elements in the stack
|           0x00000034      6038           push1 0x38            0x38 suc 0 rds           Pushes 0x38 to the stack
|       ,=< 0x00000036      57             jumpi                 0 rds                    Jumps to 0x38 if suc == true
|       |   0x00000037      fd             revert                                         Did not jump? xP
|       `-> 0x00000038      5b             jumpdest              0 rds                    Jump here!
\           0x00000039      f3             return                                         Returns with data at mem pos 0, length rds
 = 363d3d373d3d3d363d7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc545af43d82803e903d91603857fd5bf3
 */

contract UpgradeableMinimalProxy {
    constructor(address implementation) {
        // Write admin to storage
        address firstAdmin = msg.sender;
        bytes32 admin_slot = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
        assembly {
            sstore(admin_slot, firstAdmin)
        }

        // Write the first implementation to storage
        bytes32 impl_slot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        assembly {
            sstore(impl_slot, implementation)
        }

        // Build and return runtime code
        assembly {

            // The target runtime code is
            // 363d3d373d3d3d363d7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc545af43d82803e903d91603857fd5bf3
            // But it is too large to fit in a single word. Thus, it's split in two:
            // 0x363d3d373d3d3d363d7F360894a13ba1a3210667c828492db98dca3e2076cc37
            // 0x35a920a3ca505d382bbc545af43d82803e903d91603857fd5bf3000000000000

            // Load free memory pointer
            let runtimeCode := mload(0x40)

            // Write the first half of the code
            mstore(runtimeCode, 0x363d3d373d3d3d363d7f360894a13ba1a3210667c828492db98dca3e2076cc37)

            // Write the second half of the code
            mstore(add(runtimeCode, 0x20), 0x35a920a3ca505d382bbc545af43d82803e903d91603857fd5bf3000000000000)

            // Returning from a constructor means defining a contract's runtime code.
            // So, return the pointer, and the length of the runtime code, 58, or 0x3a
            return(runtimeCode, 0x3a)
        }
    }

    // These functions won't make it to runtime code,
    // They're only here for the ABI to exist.
    function setImplementation(address newImplementation) public {}
    function getImplementation() public view returns (address) {}
    function setAdmin(address newAdmin) public {}
    function getAdmin() public view returns (address) {}
    function destroy() public {}
}
