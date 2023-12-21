// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/SwapHelper.sol";

contract DeploySwapHelper is Script {
    function run() public {
        address uniswapRouter = address(0);

        SwapHelper swapHelper = new SwapHelper(uniswapRouter);

        console.log("SwapHelper deployed at:", address(swapHelper));
    }
}
