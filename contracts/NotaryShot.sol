pragma solidity ^0.8.15;

import "@openzeppelin/token/ERC721/extensions/ERC721Enumerable.sol";
import "../interfaces/INotaryShot.sol";
import '@chainlink/ChainlinkClient.sol';


contract NotaryShot is ERC721Enumerable, INotaryShot, ChainlinkClient {
    using Chainlink for Chainlink.Request;

    event RequestContentHashSent(address indexed requester, string url, uint256 sha256sum);
    event RequestContentHashFulfilled(address indexed requester, string url, uint256 sha256sum);
    event MintRequestRefused(address indexed requester, string url, uint256 expectedSha256sum, uint256 actualSha256sum);

    struct RequestData {
        address requester;
        string url;
        uint256 sha256sum;
    }

    uint256 private constant ORACLE_PAYMENT = 10 ** 15;
    address public oracle;
    bytes32 public jobId;

    mapping(bytes32 => RequestData) public requestIdToAddress;


    constructor(address _oracle, string memory _jobid) ERC721("NotarizedScreenshot", "NS"){
        setChainlinkToken(0xb0897686c545045aFc77CF20eC7A532E3120E0F1);
        oracle = _oracle;
        jobId = stringToBytes32(_jobid);
    }

    function setJobId(string memory _jobid) external {//TODO permissions
        jobId = stringToBytes32(_jobid);
    }

    function submitMint(string calldata _url, uint256 _urlContentHash) external {
        bytes32 requestId = requestContentHash(_url);
        emit RequestContentHashSent(msg.sender, _url, _urlContentHash);
        requestIdToAddress[requestId].requester = msg.sender;
        requestIdToAddress[requestId].url = _url;
        requestIdToAddress[requestId].sha256sum = _urlContentHash;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, IERC721Metadata) returns (string memory) {
        return "https://ytwfrmzfwi7oigsoinjcijvyn4kxg4x2z2zxqts5qv3zdapqtn6a.arweave.net/xOxYsyWyPuQaTkNSJCa4bxVzcvrOs3hOXYV3kYHwm3w";
    }

    function requestContentHash(string calldata _url) private returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillContentHash.selector
        );
        req.add('get', _url);
        requestId = sendChainlinkRequestTo(oracle, req, ORACLE_PAYMENT);
    }

    function fulfillContentHash(bytes32 _requestId, uint256 _sha256sum) public recordChainlinkFulfillment(_requestId) {
        RequestData memory requestData = requestIdToAddress[_requestId];
        emit RequestContentHashFulfilled(msg.sender, requestData.url, _sha256sum);
        if (_sha256sum == requestData.sha256sum) {
            _mint(requestData.requester, _sha256sum);
        } else {
            emit MintRequestRefused(msg.sender, requestData.url, requestData.sha256sum, _sha256sum);
        }
        delete requestIdToAddress[_requestId];
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
