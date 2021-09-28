// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./interfaces/IDebtShares.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DebtShares is IDebtShares, ERC20("syntheticUSD", "sUSD") {

    uint256 public totalDebt;
    
    mapping (address => uint256) debtsUSD;
    
    function burn(uint256 amount) external override {

        uint256 totalDebtShares = totalSupply();

        _burn(msg.sender, amount);    
    }

    function debtBalance(address account) external view override returns (uint256) {
        return debtsUSD[account];
    }

    function stake(uint256 amount) external override {
        _stake(amount);
    }

    function stakeAndIssue(uint256 stakeAmount, uint256 issueAmount) external override {
        _stake(stakeAmount);
        _issue(issueAmount);
    }

    function issue(uint256 amount) external override {
        _issue(amount);
    }

    function maxIssuableSynths(address account) public view returns (uint256) {
        return type(uint).max;
    }

    function _stake(uint256 amount) internal {
        // get th user's balance
        uint256 balance = balanceOf(msg.sender);
        // check if the balance is sufficient
        require(amount <= balance, "Amount exceeds balance");
         
    }

    function _issue(uint256 amount) internal {
        // first get the maximum amount of synths that the user can issue
        uint256 issuable = maxIssuableSynths(msg.sender);
        // check if the requested amount is larger than the max
        require(amount <= issuable, "Amount too large");
        // mint the sUSD amount
        _mint(msg.sender, amount);
        // "issue" the same amount of sUSD debt
        debtsUSD[msg.sender] += amount;
    }

}
