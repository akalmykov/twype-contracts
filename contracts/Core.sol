// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./Shares.sol";

struct Group {
    uint id;
    Rule rule; // mapping of users?
}

struct Rule {
    uint erc20;
    uint erc721;
    uint shares;
}

contract Core is Ownable {
    IERC20 public token; // how many tokens should we support?
    IERC721 public nft;
    Shares public shares;
    

    constructor(address _shares, address _ERC20, address _ERC721) Ownable(msg.sender) {
        shares = Shares(_shares);
        token = IERC20(_ERC20);
        nft = IERC721(_ERC721);
    }

    event GroupCreation(

    );

    uint numGroups = 0;
    mapping (uint256 => Group) groups;

    function createGroup(uint256 erc20Balance, uint erc721Balance, uint sharesBalance) external {
        Group storage group = groups[numGroups];
        group.id = numGroups;
        numGroups++;
        group.rule = Rule(erc20Balance, erc721Balance, sharesBalance);
        emit GroupCreation();
    }

    function checkRights(uint groupId, address account) external view returns (bool) {
        Rule storage rule = groups[groupId].rule;
        return (token.balanceOf(account) > rule.erc20 && nft.balanceOf(account) > rule.erc721 
        && shares.getBalance(address(0), account) > rule.shares);
    }
    

}