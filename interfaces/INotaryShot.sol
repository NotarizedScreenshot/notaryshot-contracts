//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/token/ERC721/extensions/IERC721Metadata.sol";

interface INotaryShot is IERC721Metadata {
    event SubmitTweetMint(address indexed minter, uint64 tweetId);
    event TweetMint(uint256 id, address indexed minter, uint64 tweetId, string _metadataCid);

    function submitTweetMint(uint64 tweetId) external;
}
