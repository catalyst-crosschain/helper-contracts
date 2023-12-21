// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "../src/SwapHelper.sol";
import "./mocks/MockERC20.sol";
import "./mocks/MockUniswapRouter.sol";

contract SwapHelperTest is DSTest {
    SwapHelper swapHelper;
    MockERC20 tokenA;
    MockERC20 tokenB;
    MockUniswapRouter uniswapRouter;

    function setUp() public {
        tokenA = new MockERC20("Token A", "TKNA", 18);
        tokenB = new MockERC20("Token B", "TKNB", 18);
        uniswapRouter = new MockUniswapRouter();

        swapHelper = new SwapHelper(address(uniswapRouter));

        tokenA.mint(address(this), 1e18);
        tokenB.mint(address(this), 1e18);
    }

    function testSwap() public {
        uint256 amountIn = 1e18;
        uint256 amountOutMin = 1e18;

        tokenA.approve(address(swapHelper), amountIn);

        swapHelper.swap(address(tokenA), address(tokenB), amountIn, amountOutMin);
    }

}
