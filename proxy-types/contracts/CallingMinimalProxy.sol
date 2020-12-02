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
|           0x00000007      36             calldatasize          cds 0 0                  Pushes the size of calldata to the stack
|           0x00000008      3d             returndatasize        0 cds 0 0                Pushes 0 to the stack
                            3d             returndatasize        0 0 cds 0 0
|           0x00000009      73bebebebebe.  push20 0xbebebebe     0xbebe 0 0 cds 0 0       Pushes registry address to the stack
|           0x0000001e      5a             gas                   gas 0xbebe 0 0 cds 0 0   Pushes available gas to the stack
|           0x0000001e      f1             call                  suc                      call(gas, registry, 0 value, calldata)
|           0x000000        602b           push1 0xxx            0x2b suc                 Pushes 0x2b to the stack
|       ,=< 0x00000029      57             jumpi                                          Jumps to 0x2b if suc == true
|       |   0x0000002a      fd             revert                                         Did not jump? xP
|       `-> 0x0000002b      5b             jumpdest                                       Jump here!
|           0x00000004      3d             returndatasize        0                        Pushes 0 to the stack
|           0x00000005      3d             returndatasize        0 0                      Pushes 0 to the stack
|           0x00000006      3d             returndatasize        0 0 0                    Pushes 0 to the stack
|           0x00000007      36             calldatasize          cds 0 0 0                Pushes the size of calldata to the stack
|           0x00000008      3d             returndatasize        0 cds 0 0 0              Pushes 0 to the stack
                                           mload                 impl 0 cds 0 0 0         Pushes implementation address to the stack
|           0x0000001f      f4             delegatecall          suc 0                    delegatecall(gas, 0xbebe, 0 value, calldata) => returns suc "success"
|           0x00000020      3d             returndatasize        rds suc 0                Pushes size of return data to stack
|           0x00000021      82             dup3                  0 rds suc 0              Pushes 0 to the stack
|           0x00000022      80             dup1                  0 0 rds suc 0            Pushes 0 to the stack
|           0x00000023      3e             returndatacopy        suc 0                    Copies rds bytes from return data to memory
|           0x00000024      90             swap1                 0 suc                    Swaps the first 2 elements in the stack
|           0x00000025      3d             returndatasize        rds 0 suc                Pushes size of return data to stack
|           0x00000026      91             swap2                 suc 0 rds                Swaps the first and 2nd elements in the stack
|           0x00000027      602b           push1 0x2b            0x2b suc 0 rds           Pushes 0x2b to the stack
|       ,=< 0x00000029      57             jumpi                 0 rds                    Jumps to 0x2b if suc == true
|       |   0x0000002a      fd             revert                                         Did not jump? xP
|       `-> 0x0000002b      5b             jumpdest              0 rds                    Jump here!
\           0x0000002c      f3             return                                         Returns with data at mem pos 0, length rds
 = 363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3
 */

contract CallingMinimalProxy {
    // WIP
    // constructor(address registry) {
    //     bytes20 registryBytes = bytes20(registry);

    //     // solhint-disable-next-line no-inline-assembly
    //     assembly {
    //         // Load free memory pointer
    //         let runtimeCode := mload(0x40)

    //         // The target runtime code is
    //         // 363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3
    //         // ^                   ^                                       ^                             ^
    //         // First chunk         Registry address                        Second chunk                  End
    //         // 0                   10                                      30                            45
    //         // 0x00                0x0a                                    0x1e                          0x2d

    //         // The plan is to write the frist chunk to memory, then the implementation address,
    //         // and finally the second chunk

    //         // Write the first chunk at pos 0
    //         mstore(runtimeCode, 0x363d3d373d3d3d363d730000000000000000000000000000000000000000000)

    //         // Write the implementation address at pos 10, or 0x2a
    //         mstore(add(runtimeCode, 0x0a), implementationBytes)

    //         // Write the second chunk  at pos 30, or 0x1e
    //         mstore(add(runtimeCode, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

    //         // Returning from a constructor means defining a contract's runtime code.
    //         // So, return the pointer, and the length of the runtime code, 45, or 0x2d
    //         return(runtimeCode, 0x2d)
    //     }
    // }
}
