// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DebtShares is ERC20("DebtShares", "dbt") {


    function issue(uint256 _amount) public {
        
        uint256 totalDebtShares = totalSupply();
        
        _mint(msg.sender, _amount);
         
    }

    
    function burn(uint256 _amount) public {

        uint256 totalDebtShares = totalSupply();

        _burn(msg.sender, _amount);
        
    }
}
