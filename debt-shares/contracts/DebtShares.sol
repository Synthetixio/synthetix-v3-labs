// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./interfaces/IDebtShares.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DebtShares is IDebtShares, ERC20("DebtShares", "dbt") {

    uint256 public totalDebt;
    

    function burn(uint256 amount) external override {

        uint256 totalDebtShares = totalSupply();

        _burn(msg.sender, amount);    
    }

    function stake(uint256 amount) external override {}

    function stakeAndIssue(uint256 stakeAmount, uint256 issueAmount) external override {}

    function issue(uint256 amount) external override {
        _issue(amount);
    }

    function maxIssuableSynths(address account) public view returns (uint256) {
        return type(uint).max;
    }
    // according to SIP-XXX the debt shares calulation is based on this formula: totalShares * (sUSDAmount / totalDebt)
    function _calculateSharesAmount(uint256 amount) internal view returns (uint) {

        return totalSupply() * totalDebt / amount;
    }

    function _issue(uint256 amount) internal {
        // first get the maximum amount of synths that the user can issue
        uint256 issuable = maxIssuableSynths(msg.sender);
        // check if the requested amount is larger than the max
        require(amount <= issuable, "Amount too large");

        uint256 totalDebtShares = totalSupply();
        
        _mint(msg.sender, amount);
         
    }

}
