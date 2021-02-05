//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./BaseModule.sol";
import "./Token.sol";
import "./Rates.sol";
import "./DecimalMath.sol";


contract Issuer is BaseModule {
    using DecimalMath for uint;

    // See DecimalMath: 10**18 = 1.0
    uint public minSynthetixToUsdCollateralRatio;

    Token public synthetixToken;
    Token public usdToken;

    mapping(address => uint) public stakedBalanceOf;
    mapping(address => uint) public debtBalanceOf;

    function setSynthetixToken(Token newSynthetixToken) external onlyOwner {
        synthetixToken = newSynthetixToken;
    }

    function setUsdToken(Token newUsdToken) external onlyOwner {
        usdToken = newUsdToken;
    }

    function setCollateralRatio(uint ratio) external onlyOwner {
        collateralRatio = ratio;
    }

    function stake(uint amount) external {
        require(synthetixToken.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");

        stakedBalanceOf[msg.sender] = stakedBalanceOf[msg.sender] + amount;

        synthetixToken.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint amount) externla {
        uint stakedBalance = stakedBalanceOf[msg.sender];

        require(stakedBalanceOf >= amount, "Insufficient staked balance");

        stakedBalanceOf[msg.sender] = stakedBalance - amount;

        synthetixToken.transfer(msg.sender, amount);
    }

    function issue(uint amount) external {
        uint debtBalance = debtBalanceOf[msg.sender];
        uint newDebtBalance = debtBalance + amount;

        uint snxRate = synthetix.rates.getRate(bytes32("SNX"));
        uint stakedValue = stakedBalanceOf[msg.sender].multiplyDecimal(snxRate);
        uint collateralRatio = stakedValue.mul(newDebtBalance);
        require(
            collateralRatio >= minSynthetixToUsdCollateralRatio,
            "Insufficient stake"
        );

        debtBalanceOf[msg.sender] = newDebtBalance;

        usdToken.mint(msg.sender, amount);
    }

    function burn(uint amount) external {
        require(usdToken.balanceOf(msg.sender) >= amount, "Insufficient balance");

        debtBalanceOf[msg.sender] = debtBalanceOf[msg.sender] - amount;

        usdToken.burn(msg.sender, amount);
    }
}
