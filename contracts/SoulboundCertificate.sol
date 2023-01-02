// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SoulboundCertificate is ERC721, Ownable{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct CERTIFICATE{
        address holder_address;
        string holder_name;
        string course_name;
        uint256 issue_date;
        uint256 expiry_date;
    }

    // mapping of tokenId and certificate details
    mapping(uint256 => CERTIFICATE) private certificateDetails;

    constructor() ERC721("Soulbound Certificate Token","SBCT"){
        // TokenId counter start from 1
        _tokenIdCounter.increment();
    }

    function createCertificate(address _holderAddress,
                               string memory _holderName,
                               string memory _courseName,
                               uint256 _expiryDate) public onlyOwner{
        require(_holderAddress != address(0),"Error: Certificate holder address should be valid!");

        uint256 tokenId = _tokenIdCounter.current();

        certificateDetails[tokenId].holder_address = _holderAddress;
        certificateDetails[tokenId].holder_name = _holderName;
        certificateDetails[tokenId].course_name = _courseName;
        certificateDetails[tokenId].issue_date = block.timestamp;
        certificateDetails[tokenId].expiry_date = _expiryDate;


        _tokenIdCounter.increment();

        _safeMint(_holderAddress,tokenId,"");
    } 

    function getCertificateDetails(uint256 tokenId, address holderAddress) external view returns(address cert_holder_address,
                                                                          string memory cert_holder_name,
                                                                          string memory cert_course_name,
                                                                          uint256 cert_issue_date,
                                                                          uint256 cert_expiry_date){
        require(_exists(tokenId) && certificateDetails[tokenId].holder_address == holderAddress,"Error: Certificate does not exists!");

        return (certificateDetails[tokenId].holder_address,
                certificateDetails[tokenId].holder_name,
                certificateDetails[tokenId].course_name,
                certificateDetails[tokenId].issue_date,
                certificateDetails[tokenId].expiry_date);                                                                     
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