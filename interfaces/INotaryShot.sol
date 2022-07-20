pragma solidity ^0.8.15;

import "@openzeppelin/token/ERC721/extensions/IERC721Metadata.sol";

interface INotaryShot is IERC721Metadata {
    function submitMint(string calldata url, uint256 urlContentHash) external;
}
