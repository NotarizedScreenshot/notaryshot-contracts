//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/token/ERC721/extensions/ERC721Enumerable.sol";
import "../interfaces/INotaryShot.sol";
import '@chainlink/ChainlinkClient.sol';


contract NotaryShot is ERC721Enumerable, INotaryShot, ChainlinkClient {
    using Chainlink for Chainlink.Request;

    event SubmitTweetMint(address indexed minter, uint64 tweetId);
    event TweetMint(uint256 id, address indexed minter, uint64 tweetId, string _metadataCid);

    struct RequestData {
        address minter;
        uint64 tweetId;
    }

    uint256 private constant ORACLE_PAYMENT = 10 ** 15;
    address public oracle;
    bytes32 public jobId;
    uint256 public latestTokenId;

    mapping(bytes32 => RequestData) public requestData;
    mapping(uint256 => string) public metadata;

    constructor(
        address _linkToken,
        address _oracle,
        string memory _jobid,
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol){
        setChainlinkToken(_linkToken);
        oracle = _oracle;
        jobId = stringToBytes32(_jobid);
    }

    function setJobId(string memory _jobid) external {//TODO permissions or remove
        jobId = stringToBytes32(_jobid);
    }

    function submitTweetMint(uint64 tweetId) external {
        bytes32 requestId = requestContentHash(tweetId);
        emit SubmitTweetMint(msg.sender, tweetId);
        requestData[requestId].minter = msg.sender;
        requestData[requestId].tweetId = tweetId;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, IERC721Metadata) returns (string memory) {
        _requireMinted(tokenId);
        return string(abi.encodePacked("ipfs://", metadata[tokenId]));
    }

    function requestContentHash(uint64 tweetId) private returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillContentHash.selector
        );
        req.addUint('tweetId', uint256(tweetId));
        requestId = sendChainlinkRequestTo(oracle, req, ORACLE_PAYMENT);
    }

    function fulfillContentHash(bytes32 _requestId, string calldata _metadataCid) public recordChainlinkFulfillment(_requestId) {
        RequestData memory request = requestData[_requestId];

        _mint(request.minter, ++latestTokenId);
        metadata[latestTokenId] = _metadataCid;
        delete requestData[_requestId];
        emit TweetMint(latestTokenId, request.minter, request.tweetId, _metadataCid);
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
        // solhint-disable-line no-inline-assembly
            result := mload(add(source, 32))
        }
    }
}
