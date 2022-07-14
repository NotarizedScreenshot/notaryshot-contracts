pragma solidity ^0.8.15;

import "@openzeppelin/token/ERC721/ERC721.sol";
import "../interfaces/INotaryShot.sol";

contract NotaryShot is ERC721, INotaryShot {
    constructor() ERC721("NotarizedScreenshot", "NS"){}
    function mint(string calldata url, uint256 urlContentHash, uint256 tokenId) external {
        _mint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, IERC721Metadata) returns (string memory) {
        return "https://ytwfrmzfwi7oigsoinjcijvyn4kxg4x2z2zxqts5qv3zdapqtn6a.arweave.net/xOxYsyWyPuQaTkNSJCa4bxVzcvrOs3hOXYV3kYHwm3w";
    }

    function _checkUrl(string calldata url, uint256 urlContentHash) private returns (bool) {
        //TODO call the oracle here to check the url
        return true;
    }
}
