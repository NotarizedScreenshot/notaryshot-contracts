//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";

interface INotaryShot is IERC721MetadataUpgradeable {
    event SubmitTweetMint(address indexed minter, uint64 tweetId);
    event TweetMint(uint256 id, address indexed minter, uint64 tweetId, string _metadataCid);

    function submitTweetMint(uint64 tweetId) external;
    function setOracleFee(uint256 _oracleFee) external;
    function setOracle(address _oracle) external;
    function setJobId(string memory _jobId) external;
    function transferOwnership(address newOwner) external;
}
