## "Router Proxy" POC #5

This experiment continues where POC #4 left of. Please see that README before reading this one.

### Differences with POC #4

1. Cheaper proxying

Instead of using OpenZeppelin transparent proxies, this experiment uses UUPS proxies are used (Universal Upgradeable Proxy Standard). See https://eips.ethereum.org/EIPS/eip-1822

Transparent proxy have a forwarding overhead of around ~3000 gas, while UUPS only add ~1600. This, combined with the router adds an overhead of ~2600 gas, which is less than a system only using transparent proxies. Of course, this could increase with a larger router, which could be later optimized with lower level code generation and/or implementing a binary search in the routing.

2. TBD
