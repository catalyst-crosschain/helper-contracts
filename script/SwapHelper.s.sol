// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/SwapHelper.sol";

contract DeploySwapHelper is Script {
    function run() public {
        // Define the Uniswap Router address and any other necessary parameters
        address uniswapRouter = address(0); // Replace with the actual Uniswap Router address

        // Deploy the SwapHelper contract
        SwapHelper swapHelper = new SwapHelper(uniswapRouter);

        // Optionally, log the address of the deployed contract
        console.log("SwapHelper deployed at:", address(swapHelper));
    }
}
