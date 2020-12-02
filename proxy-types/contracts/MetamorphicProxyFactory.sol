pragma solidity >= 0.6.0 < 0.8.0;

contract MetamorphicProxyFactory {
    event ProxyCreated(address indexed proxy);

    function createProxy(address implementation, uint256 salt) public {
        address proxy;

        bytes20 implementationBytes = bytes20(implementation);

        assembly {
            // Load free memory pointer
            let code := mload(0x40)

            // Note: this bytecode is similar to the one in MinimalProxy, except that a constructor chunk is prepended.

            // The target creation code is
            // 3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3
            // ^                   ^                   ^                                       ^                             ^
            // Constructor code    First chunk         Implementation address                  Second chunk                  End
            //                     0                   10                                      30                            45
            //                     0x00                0x0a                                    0x1e                          0x2d

            // The plan is to write the frist chunk to memory, then the implementation address,
            // and finally the second chunk

            // Write the first chunk at pos 0
            mstore(code, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)

            // Write the implementation address at pos 10, or 0x2a
            mstore(add(code, 0x14), implementationBytes)

            // Write the second chunk  at pos 30, or 0x1e
            mstore(add(code, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

            // Instantiate contract using create2
            // The target address is ultimately determined by: keccak256(0xff ++ deployingAddr ++ salt ++ keccak256(bytecode))
            // If there is code at the target address, the tx should revert. Otherwise, a new contract is instantiated.
            // If a contract exists at the address, it should call selfdestruct before the upgrade.
            /*
            create2(
                value,
                memoryPos,
                memoryLen,
                salt
            )
            */
           proxy := create2(0, code, 0x37, salt)

           // Check that the resulting runtime code (after constructor is executed)
           // is not zero
           if iszero(extcodesize(proxy)) {
               revert(0, 0)
           }
        }

        emit ProxyCreated(proxy);
    }
}
