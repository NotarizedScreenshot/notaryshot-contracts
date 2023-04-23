//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/token/ERC721/extensions/IERC721Metadata.sol";

interface INotaryShot is IERC721Metadata {
    function submitTweetMint(uint64 tweetId) external;
}
