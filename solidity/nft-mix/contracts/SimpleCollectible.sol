// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SimpleCollectible is ERC721 {
    uint256 public tokenCounter;
    constructor () public ERC721 ("Doggie", "DOG") {
        tokenCounter = 0;
    }

    function createCollectible(string memory tokenURI) public returns (uint256) {
        uint256 newItemId = tokenCounter;
        //creates new nft
        _safeMint(msg.sender, newItemId);
        //sender = owner

        // 
        _setTokenURI(newItemId, tokenURI);
        // add counter
        tokenCounter = tokenCounter + 1;
    }
}