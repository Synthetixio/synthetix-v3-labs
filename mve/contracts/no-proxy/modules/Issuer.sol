//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "./BaseModule.sol";
import "../erc20/Token.sol";
import "./DecimalMath.sol";


contract Issuer is BaseModule {
    using DecimalMath for uint;

    // See DecimalMath: 10**18 = 1.0
    uint public minSynthetixToUsdCollateralRatio;

    mapping(address => uint) public stakedBalanceOf;
    mapping(address => uint) public debtBalanceOf;

    function setCollateralRatio(uint ratio) external onlyOwner {
        collateralRatio = ratio;
    }

    function stake(uint amount) external {
        require(synthetix.SNX.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");

        stakedBalanceOf[msg.sender] = stakedBalanceOf[msg.sender] + amount;

        synthetix.SNX.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint amount) externla {
        uint SNXRate = synthetix.rates.getRate(bytes32("SNX"));

        uint stakedBalance = stakedBalanceOf[msg.sender];
        uint stakedValue = stakedBalance.multiplyDecimal(SNXRate);

        uint debtBalance = debtBalanceOf[msg.sender];
        uint withdrawableValue = stakedValue - debtBalance;

        require(withdrawableValue >= amount, "Insufficient withdrawableValue");

        stakedBalanceOf[msg.sender] = stakedBalance - amount;

        synthetix.SNX.transfer(msg.sender, amount);
    }

    function issue(uint amount) external {
        uint debtBalance = debtBalanceOf[msg.sender];
        uint newDebtBalance = debtBalance + amount;

        uint SNXRate = synthetix.rates.getRate(bytes32("SNX"));
        uint stakedValue = stakedBalanceOf[msg.sender].multiplyDecimal(SNXRate);
        uint collateralRatio = stakedValue.mul(newDebtBalance);
        require(
            collateralRatio >= minSynthetixToUsdCollateralRatio,
            "Insufficient stake"
        );

        debtBalanceOf[msg.sender] = newDebtBalance;

        synthetix.USD.mint(msg.sender, amount);
    }

    function burn(uint amount) external {
        require(synthetix.USD.balanceOf(msg.sender) >= amount, "Insufficient balance");

        debtBalanceOf[msg.sender] = debtBalanceOf[msg.sender] - amount;

        synthetix.USD.burn(msg.sender, amount);
    }
}
