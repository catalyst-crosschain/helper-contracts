// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MockUniswapV3Pool {
    struct Position {
        uint256 amount0;
        uint256 amount1;
    }

    mapping(bytes32 => Position) public positions;

    function positions(bytes32 key) external view returns (uint256 amount0, uint256 amount1) {
        Position memory position = positions[key];
        return (position.amount0, position.amount1);
    }

    function mock_setPosition(bytes32 key, uint256 _amount0, uint256 _amount1) external {
        positions[key] = Position({amount0: _amount0, amount1: _amount1});
    }
    
}
