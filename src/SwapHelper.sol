// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract SwapHelper is ReentrancyGuard {
    using SafeERC20 for IERC20;

    ISwapRouter public immutable uniswapRouter;

    event SwapExecuted(address indexed user, address indexed tokenIn, address indexed tokenOut, uint256 amountIn, uint256 amountOut);

    constructor(address _uniswapRouter) {
        require(_uniswapRouter != address(0), "SwapHelper: Invalid Router Address");
        uniswapRouter = ISwapRouter(_uniswapRouter);
    }

    function swap(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOutMin) external nonReentrant {
        IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenIn).safeApprove(address(uniswapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            fee: 3000,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: amountOutMin,
            sqrtPriceLimitX96: 0
        });

        uint256 amountOut = uniswapRouter.exactInputSingle(params);
        require(amountOut > 0, "SwapHelper: Zero output amount");

        emit SwapExecuted(msg.sender, tokenIn, tokenOut, amountIn, amountOut);
    }
}
