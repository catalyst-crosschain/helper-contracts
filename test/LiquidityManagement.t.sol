// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "../src/LiquidityManagement.sol";
import "./mocks/MockERC20.sol";
import "./mocks/MockUniswapV3Pool.sol";
import "./mocks/MockNonfungiblePositionManager.sol";

contract LiquidityManagementTest is DSTest {
    MockERC20 tokenA;
    MockERC20 tokenB;
    MockNonfungiblePositionManager positionManager;
    LiquidityManagement liquidityManagement;

    function setUp() public {
        tokenA = new MockERC20("Token A", "TKNA", 18);
        tokenB = new MockERC20("Token B", "TKNB", 18);

        positionManager = new MockNonfungiblePositionManager();

        liquidityManagement = new LiquidityManagement(address(positionManager));

        tokenA.mint(address(this), 1e18);
        tokenB.mint(address(this), 1e18);
    }

    function testAddLiquidity() public {
        uint256 amountA = 1e18;
        uint256 amountB = 1e18;
        uint24 fee = 3000;
        uint160 sqrtPriceX96 = 79228162514264337593543950336;

        uint256 tokenId = liquidityManagement.addLiquidity(
            address(tokenA),
            address(tokenB),
            amountA,
            amountB,
            fee,
            sqrtPriceX96
        );

    }

    function testRemoveLiquidity() public {
        uint256 tokenId;

        liquidityManagement.removeLiquidity(tokenId);
    }

}
