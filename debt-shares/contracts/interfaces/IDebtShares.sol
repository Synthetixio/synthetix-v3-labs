// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface IDebtShares {

    function debtBalance(address account) external returns (uint256);

    function stake(uint256 amount) external;

    function stakeAndIssue(uint256 stakeAmount, uint256 issueAmount) external;

    function issue(uint256 amount) external;
    
    function burn(uint256 amount) external;

}
