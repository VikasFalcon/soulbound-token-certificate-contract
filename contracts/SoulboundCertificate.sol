// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SoulboundCertificate is ERC721, Ownable{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Soulbound Certificate Token","SBCT"){
        // TokenId counter start from 1
        _tokenIdCounter.increment();
    }

    function safeMint(address to) public onlyOwner{
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        _safeMint(to,tokenId,"");
    } 

    function burn(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId),"Error: Only token owner can burn token!");
        _burn(tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721){
        super._burn(tokenId);
    }

    // Override this method to restrict user to transfer token
    function _beforeTokenTransfer(address from, address to, uint256, uint256 batchSize) internal override pure{
        require(from == address(0) || to == address(0),"Error: This is soulbound token and can not be transfer.");
    }
}