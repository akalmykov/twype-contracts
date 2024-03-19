// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token20 is ERC721, Ownable {
    constructor(
        string memory _name,
        string memory _symbol,
        address[] memory _mintAddresses
    ) ERC721(_name, _symbol) Ownable(msg.sender) {
        for (uint256 i = 0; i < _mintAddresses.length; i++) {
            _safeMint(_mintAddresses[i], i);
        }
    }    
}