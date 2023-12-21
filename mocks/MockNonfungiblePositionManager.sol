// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockNonfungiblePositionManager is ERC721 {
    uint256 private _nextTokenId = 1;
    mapping(uint256 => address) public tokenOwners;

    constructor() ERC721("MockUniswapV3Position", "MOCKPOS") {}

    function mint(address to) external returns (uint256 tokenId) {
        tokenId = _nextTokenId++;
        _mint(to, tokenId);
        tokenOwners[tokenId] = to;
    }

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "MockNPM: Not token owner");
        _burn(tokenId);
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        return tokenOwners[tokenId];
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override {
        require(ownerOf(tokenId) == from, "MockNPM: Not token owner");
        _transfer(from, to, tokenId);
        tokenOwners[tokenId] = to;
    }

    function positions(uint256) external pure returns (uint256, uint256, address, address, uint24, int24, int24, uint128, uint256, uint256, uint256, uint256) {
        return (0, 0, address(0), address(0), 0, 0, 0, 0, 0, 0, 0, 0);
    }

    function poolForPair(address, address, uint24) external pure returns (address) {
        return address(0);
    }
}
