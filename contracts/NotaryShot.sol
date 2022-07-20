pragma solidity ^0.8.15;

import "@openzeppelin/token/ERC721/ERC721.sol";
import "../interfaces/INotaryShot.sol";
import '@chainlink/ChainlinkClient.sol';


contract NotaryShot is ERC721, INotaryShot, ChainlinkClient {
    using Chainlink for Chainlink.Request;

    event RequestContentHashFulfilled(string url, uint256 sha256sum);

    uint256 private constant ORACLE_PAYMENT = 10 ** 15;
    address public oracle;
    bytes32 public jobId;
    //    mapping(bytes32 => address) //TODO keep user address and submitted hash
    address minter;               //TODO
    string url;                   //TODO
    uint256 urlContentHash;       //TODO

    constructor(address _oracle, string memory _jobid) ERC721("NotarizedScreenshot", "NS"){
        setChainlinkToken(0xb0897686c545045aFc77CF20eC7A532E3120E0F1);
        oracle = _oracle;
        jobId = stringToBytes32(_jobid);
    }

    function setJobId(string memory _jobid) external { //TODO permissions
        jobId = stringToBytes32(_jobid);
    }

    function submitMint(string calldata _url, uint256 _urlContentHash) external {
        minter = msg.sender;
        url = _url;
        urlContentHash = _urlContentHash;
        requestContentHash(_url);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, IERC721Metadata) returns (string memory) {
        return "https://ytwfrmzfwi7oigsoinjcijvyn4kxg4x2z2zxqts5qv3zdapqtn6a.arweave.net/xOxYsyWyPuQaTkNSJCa4bxVzcvrOs3hOXYV3kYHwm3w";
    }

    function requestContentHash(string calldata _url) private {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillContentHash.selector
        );
        req.add('get', _url);
        sendChainlinkRequestTo(oracle, req, ORACLE_PAYMENT);
    }

    function fulfillContentHash(bytes32 _requestId, uint256 _sha256sum) public recordChainlinkFulfillment(_requestId) {
        emit RequestContentHashFulfilled(url, _sha256sum);
        if (_sha256sum == urlContentHash) {
            _mint(minter, urlContentHash);
        }
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
