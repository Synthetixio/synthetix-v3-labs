// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./interfaces/IDebtShares.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DebtPool is ERC20 {

    IDebtShares debtShares;

    uint256 public totalDebtShares;
    uint256 public sUSDBalance;
    uint256 public synthPrice; // needs to be an oracle feed

    constructor(IDebtShares debtSharesContract, string memory poolName, string memory poolSymbol) ERC20(poolName, poolSymbol) {
        debtShares = debtSharesContract;
    }

    function optIn(uint256 amount) external {
        uint256 debtsUSD = debtShares.debtBalance(msg.sender);
        require(debtsUSD >= amount, "not enough debt shares");
    }

    function totalDebt() public view returns (uint256) {
        return sUSDBalance + totalSupply() * synthPrice;
    }
     
    function _calculateSharesAmount(uint256 amount) internal view returns (uint) {
        // if there is zero debt then return the amount requested
        if (totalDebtShares == 0) {
            return amount;
        }
        // according to SIP-XXX the debt shares calulation is based on this formula: totalShares * (sUSDAmount / totalDebt)
        uint256 shares = totalDebtShares * amount / totalDebt();
        return shares;
    }
}
