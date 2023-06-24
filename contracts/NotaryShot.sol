//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/access/OwnableUpgradeable.sol";
import "@openzeppelin/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/utils/StringsUpgradeable.sol";
import '@chainlink/ChainlinkClient.sol';
import "../interfaces/INotaryShot.sol";

/**
    @title NotarizedScreenshot
    @author Gene A. Tsvigun
    @author Denise Epstein
    @notice The main contract for QuantumOracle's NotarizedScreenshot NFTs.
    @notice Allows users to mint NFTs representing verifiable screenshots of web content.
    @notice Utilizes Chainlink nodes with QuantumOracle's external adapter for data verification and retrieval.
*/
contract NotaryShot is INotaryShot, UUPSUpgradeable, ERC721EnumerableUpgradeable, OwnableUpgradeable, ChainlinkClient {
    using Chainlink for Chainlink.Request;

    struct RequestData {
        address minter;
        uint64 tweetId;
    }

    mapping(bytes32 => RequestData) public requestData;
    mapping(uint256 => string) public metadata;

    uint256 public oracleFee;
    address public oracle; //operator contract
    bytes32 public jobId;
    uint256 public latestTokenId;

    /**
        @notice Initializes the contract by setting the payment receiver and assigning DEFAULT_ADMIN_ROLE to the sender
        @param _linkToken LINK token address
        @param _oracle operator contract address
        @notice the job may be named like 'Get Mintable Screenshot Metadata CID by tweetId'
        @notice job ID initially contains dashes, like 5f26bf32-4517-4615-8e11-edb088eb3312, remove dashes first
        @param _jobid ChainLink job ID without dashes like 5f26bf32451746158e11edb088eb3312
        @param _name NFT collection name
        @param _symbol NFT collection symbol
     */
    function initialize(
        address _linkToken,
        address _oracle,
        uint256 _oracleFee,
        string memory _jobid,
        string memory _name,
        string memory _symbol
    ) public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init();
        __ERC721Enumerable_init();
        __ERC721_init(_name, _symbol);
        setChainlinkToken(_linkToken);
        jobId = stringToBytes32(_jobid);
        oracle = _oracle;
        oracleFee = _oracleFee;
    }

    /**
        @notice This is how users declare their intention to mint a verifiable screenshot of a single tweet
        @notice after they have seen a preview
        @param tweetId ID of the tweet to immortalize
        @dev saves `msg.sender` as minter alongside `tweetId` until a Chainlink node provides results
        @dev this function temporarily stays till the frontend migrates to the new interface
    */
    function submitTweetMint(uint64 tweetId) external {
        bytes32 requestId = requestContentHash(tweetId);
        emit SubmitTweetMint(msg.sender, tweetId);
        requestData[requestId].minter = msg.sender;
        requestData[requestId].tweetId = tweetId;
    }

    /**
        @notice This is how users declare their intention to mint a verifiable screenshot of a single tweet
        @notice after they have seen a preview
        @param tweetId ID of the tweet to immortalize
        @param cid NFT metadata CID being confirmed by the user
        @dev saves `msg.sender` as minter alongside `tweetId` until a Chainlink node provides results
    */
    function submitTweetMint(uint64 tweetId, string calldata cid) external {
        bytes32 requestId = confirmCid(tweetId, cid);
        emit SubmitTweetMint(msg.sender, tweetId);
        requestData[requestId].minter = msg.sender;
        requestData[requestId].tweetId = tweetId;
    }

    /**
        @notice This method is used to change the oracle fee
        @param _oracleFee new oracle fee
    */
    function setOracleFee(uint256 _oracleFee) public onlyOwner {
        oracleFee = _oracleFee;
    }

    /**
        @notice This method is used to change the operator address
        @param _oracle new operator address
    */
    function setOracle(address _oracle) public onlyOwner {
        oracle = _oracle;
    }

    /**
        @notice This method is used to change the job ID
        @param _jobId new job ID
    */
    function setJobId(string memory _jobId) public onlyOwner {
        jobId = stringToBytes32(_jobId);
    }

    function transferOwnership(address newOwner) public override(INotaryShot, OwnableUpgradeable) onlyOwner {
        super.transferOwnership(newOwner);
    }

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) public view override(ERC721Upgradeable, IERC721MetadataUpgradeable) returns (string memory) {
        _requireMinted(tokenId);
        return string(abi.encodePacked("ipfs://", metadata[tokenId]));
    }

    /**
     * @notice owner can perform upgrades
     */
    function _authorizeUpgrade(address) internal override onlyOwner {}

    /**
     * @dev Requests saved tweet screenshot content ID
     */
    function requestContentHash(uint64 tweetId) private returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillContentHash.selector
        );
        req.add('tweetId', StringsUpgradeable.toString(uint256(tweetId)));
        requestId = sendChainlinkRequestTo(oracle, req, oracleFee);
    }

    /**
     * @dev Requests saved tweet screenshot content ID confirmation
     */
    function confirmCid(uint64 tweetId, string calldata cid) private returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillContentHash.selector
        );
        req.add('tweetId', StringsUpgradeable.toString(uint256(tweetId)));
        req.add('cid', cid);
        requestId = sendChainlinkRequestTo(oracle, req, oracleFee);
    }


    /**
     * @dev Accept saved tweet content ID provided by a Chainlink node with QuantumOracle's external adapter
     */
    function fulfillContentHash(bytes32 requestId, string calldata cid) public recordChainlinkFulfillment(requestId) {
        RequestData memory request = requestData[requestId];
        _mint(request.minter, ++latestTokenId);
        metadata[latestTokenId] = cid;
        delete requestData[requestId];
        emit TweetMint(latestTokenId, request.minter, request.tweetId, cid);
    }


    /**
     * @dev Convert job ID to a bytes32 value
     */
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
