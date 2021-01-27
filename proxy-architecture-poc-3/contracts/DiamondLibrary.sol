// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;


library DiamondLibrary {
    // ~~~~~~~~~~~~~~~~~
    // Proxy storage
    // ~~~~~~~~~~~~~~~~~

    bytes32 constant PROXY_STORAGE_POSITION = keccak256("io.synthetix.proxy");

    struct ProxyStorage {
        mapping(bytes4 => address) implementationForSelector;
        address owner;
    }

    function proxyStorage() internal pure returns (ProxyStorage storage store) {
        bytes32 position = PROXY_STORAGE_POSITION;

        assembly {
            store.slot := position
        }
    }

    // ~~~~~~~~~~~~~~~~~
    // Ownership
    // ~~~~~~~~~~~~~~~~~

    function getOwner() internal view returns (address) {
        return proxyStorage().owner;
    }

    function setOwner(address newOwner) internal {
        proxyStorage().owner = newOwner;
    }

    function requireOwner() internal view {
        require(msg.sender == getOwner(), "Only the owner can call this");
    }

    // ~~~~~~~~~~~~~~~~~
    // Edit facets
    // ~~~~~~~~~~~~~~~~~

    struct FacetData {
        address implementation;
        bytes4[] selectors;
    }

    function registerFacets(FacetData[] memory facets) internal {
        ProxyStorage storage store = proxyStorage();

        // Sweep facets
        for(uint f = 0; f < facets.length; f++) {
            FacetData memory facet = facets[f];

            // Sweep facet selectors
            for(uint s = 0; s < facet.selectors.length; s++) {
                bytes4 selector = facet.selectors[s];

                store.implementationForSelector[selector] = facet.implementation;
            }
        }
    }
}
