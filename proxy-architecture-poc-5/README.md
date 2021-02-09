## "Router Proxy" POC #5

This experiment continues where POC #4 left of. Please see that README before reading this one.

### Differences with POC #4

1. Cheaper proxying

Instead of using OpenZeppelin transparent proxies, UUPS proxies are used (Universal Upgradeable Proxy Standard). See https://eips.ethereum.org/EIPS/eip-1822

Transparent proxies have a forwarding overhead of around ~3000 gas, while UUPS only add nearly half as much, ~1600 gas. This, combined with the router adds an overhead of ~2600 gas, is less than a system only using transparent proxies.

Of course, this could increase with a larger router, which could be later optimized with lower level code generation and/or implementing a binary search in the routing.

Universal proxies achieve this optimization by placing the upgradeability management code in the implementation, instead of the proxy. Thus, it avoids checking if the caller is the admin on every single interaction with the system. The downside is that an incorrect implementation could brick the proxy. Fran and I believe, however, that this problem could be mitigated by checks on the upgrade logic and good tooling.

2. TBD
