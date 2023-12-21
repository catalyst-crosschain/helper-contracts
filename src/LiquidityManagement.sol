// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/libraries/TickMath.sol";
import "@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";

contract LiquidityManagement {
    INonfungiblePositionManager public immutable positionManager;

    struct PositionDetails {
        uint256 tokenId;
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint128 liquidity;
        uint256 amount0;
        uint256 amount1;
    }

    constructor(address _positionManager) {
        positionManager = INonfungiblePositionManager(_positionManager);
    }

    constructor(address _positionManager) {
        positionManager = INonfungiblePositionManager(_positionManager);
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountA,
        uint256 amountB,
        uint24 fee,
        uint160 sqrtPriceX96
    ) external returns (uint256 tokenId) {
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);

        IERC20(tokenA).approve(address(positionManager), amountA);
        IERC20(tokenB).approve(address(positionManager), amountB);

        INonfungiblePositionManager.MintParams
            memory params = INonfungiblePositionManager.MintParams({
                token0: tokenA,
                token1: tokenB,
                fee: fee,
                tickLower: calculateTickLower(sqrtPriceX96),
                tickUpper: calculateTickUpper(sqrtPriceX96),
                amount0Desired: amountA,
                amount1Desired: amountB,
                amount0Min: 0,
                amount1Min: 0,
                recipient: address(this),
                deadline: block.timestamp
            });

        (tokenId, , , ) = positionManager.mint(params);
    }

    function removeLiquidity(uint256 tokenId) external {
        require(
            positionManager.ownerOf(tokenId) == msg.sender,
            "Not the owner of the liquidity position"
        );

        positionManager.safeTransferFrom(address(this), msg.sender, tokenId);

        INonfungiblePositionManager.DecreaseLiquidityParams
            memory params = INonfungiblePositionManager
                .DecreaseLiquidityParams({
                    tokenId: tokenId,
                    liquidity: amountLiquidityToDecrease,
                    amount0Min: 0,
                    amount1Min: 0,
                    deadline: block.timestamp
                });

        positionManager.decreaseLiquidity(params);

        INonfungiblePositionManager.CollectParams
            memory collectParams = INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: msg.sender,
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            });

        positionManager.collect(collectParams);

        emit LiquidityRemoved(tokenId, msg.sender);
    }

    function calculateTickLower(
        uint160 sqrtPriceX96,
        int24 tickSpacing
    ) internal pure returns (int24) {
        require(tickSpacing > 0, "Invalid tick spacing");

        int24 tick = TickMath.getTickAtSqrtRatio(sqrtPriceX96);

        int24 tickLower = (tick / tickSpacing) * tickSpacing;

        return tickLower;
    }

    function calculateTickUpper(
        uint160 sqrtPriceX96,
        int24 tickSpacing
    ) internal pure returns (int24) {
        require(tickSpacing > 0, "Invalid tick spacing");

        int24 tick = TickMath.getTickAtSqrtRatio(sqrtPriceX96);

        int24 tickUpper = ((tick + tickSpacing - 1) / tickSpacing) *
            tickSpacing;

        return tickUpper;
    }

    function getPositionDetails(uint256 tokenId) external view returns (PositionDetails memory) {
        (
            ,
            ,
            address token0,
            address token1,
            uint24 fee,
            int24 tickLower,
            int24 tickUpper,
            uint128 liquidity,
            ,
            ,
            ,
        ) = positionManager.positions(tokenId);

        IUniswapV3Pool pool = IUniswapV3Pool(
            positionManager.poolForPair(token0, token1, fee)
        );
        (uint256 amount0, uint256 amount1) = pool.positions(getPositionKey(token0, token1, fee, tickLower, tickUpper));

        return PositionDetails({
            tokenId: tokenId,
            token0: token0,
            token1: token1,
            fee: fee,
            tickLower: tickLower,
            tickUpper: tickUpper,
            liquidity: liquidity,
            amount0: amount0,
            amount1: amount1
        });
    }

    function getPositionKey(
        address token0,
        address token1,
        uint24 fee,
        int24 tickLower,
        int24 tickUpper
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(token0, token1, fee, tickLower, tickUpper));
    }
}
