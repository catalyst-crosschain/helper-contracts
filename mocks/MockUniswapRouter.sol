// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./MockERC20.sol";

contract MockUniswapRouter {
    function exactInputSingle(
        ISwapRouter.ExactInputSingleParams memory params
    ) external returns (uint256 amountOut) {
        MockERC20 tokenIn = MockERC20(params.tokenIn);
        MockERC20 tokenOut = MockERC20(params.tokenOut);

        require(tokenIn.balanceOf(msg.sender) >= params.amountIn, "MockUniswapRouter: Not enough tokens");
        tokenIn.transferFrom(msg.sender, address(this), params.amountIn);

        // For simplicity, this mock assumes a 1:1 swap rate.
        amountOut = params.amountIn;
        require(amountOut >= params.amountOutMinimum, "MockUniswapRouter: Insufficient output amount");

        tokenOut.mint(params.recipient, amountOut);
    }
}
