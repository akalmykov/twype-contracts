// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token20 is ERC20, Ownable {
    constructor(
        string memory _name,
        string memory _symbol,
        address[] memory _mintAddresses
    ) ERC20(_name, _symbol) Ownable(msg.sender) {
        for (uint256 i = 0; i < _mintAddresses.length; i++) {
            _mint(_mintAddresses[i], 1);
        }
        _mint(msg.sender, 10000);
    }    
}