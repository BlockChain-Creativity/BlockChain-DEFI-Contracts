/* 
## Test with Foundry
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./06UniswapV3Liquidity.sol";

contract UniswapV3LiquidityTest is Test {

    IWETH private constant weth = IWETH(WETH);
    IERC20 private constant dai = IERC20(DAI);

    address private constant DAI_WHALE = 0xe81D6f03028107A20DBc83176DA82aE8099E9C42;

    UniswapV3Liquidity private uni = new UniswapV3Liquidity();

    function setUp() public {
        vm.prank(DAI_WHALE);
        dai.transfer(address(this), 20 * 1e18);

        weth.deposit{value: 2 * 1e18}();

        dai.approve(address(uni), 20 * 1e18);
        weth.approve(address(uni), 20 * 1e18);
    }

    function testLiquidity() public {
        // track total liquidity
        uint128 liquidity;

        // Mint new position
        uint daiAmount = 10 * 1e18;
        uint wethAmount = 1e18;

        (uint tokenId, uint128 liquidityDelta, uint amount0, uint amount1) = uni.mintNewPosition(daiAmount, wethAmount);
        liquidity += liquidityDelta;

        console.log("--- Mint new position ---");
        console.log("token id", tokenId);
        console.log("liquidity", liquidity);
        console.log("amount 0", amount0);
        console.log("amount 1", amount1);

        // Collect Fees
        (uint fee0, uint fee1) = uni.collectAllFees(tokenId);

        console.log("--- Collect fees ---");
        console.log("fee 0", fee0);
        console.log("fee 1", fee1);

        // Increase liquidity
        uint daiAmountToAdd = 5 * 1e18;
        uint wethAmountToAdd = 0.5 * 1e18;

        (liquidityDelta, amount0, amount1);
    }
}


/* 
 2. Execute the following commands to run the test

FORK_URL=https://eth-mainnet.g.alchemy.com/v2/613t3mfjTevdrCwDl28CVvuk6wSIxRPi
forge test -vv --gas-report --fork-url $FORK_URL --match-path test/UniswapV3Liquidity.test.sol
*/