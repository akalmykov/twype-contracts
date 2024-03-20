// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./Shares.sol";

struct Group {
    uint id;
    address owner;
    Rule rule;
}

struct Rule {
    IERC20 token;
    uint tokenNum;
    IERC721 nft;
    uint nftNum;
    address sharesSubject;
    uint sharesNum;
    address attesterAddress;
}

contract Core is Ownable {
    Shares shares;

    constructor(address _sharesAddress) Ownable(msg.sender) {
        shares = Shares(_sharesAddress);
    }

    event GroupCreation(
        uint groupId,
        Rule rule,
        address owner
    );

    event GroupUpdate(
        uint groupId,
        Rule rule,
        address owner
    );

    uint numGroups = 0;
    mapping (uint256 => Group) groups;

    function createGroup(Rule memory _rule) internal returns (uint) {
        Group storage group = groups[numGroups];
        group.id = numGroups;
        numGroups++;
        group.rule = _rule;

        emit GroupCreation(group.id, _rule, msg.sender);

        return numGroups - 1;
    }

    function createGroup(address _token, uint _tokenNum, address _nft, uint _nftNum, address _sharesSubject, uint _sharesNum, address _attesterAddress) external {
        createGroup(Rule(IERC20(_token), _tokenNum, IERC721(_nft), _nftNum, _sharesSubject, _sharesNum, _attesterAddress));
    }

    function updateGroup(uint groupId, Rule calldata _rule) external onlyGroupOwner(msg.sender, groupId) {
        Group storage group = groups[groupId];
        group.rule = _rule;
        emit GroupUpdate(group.id, _rule, msg.sender);
    }

    function checkRights(uint groupId, address account) external view returns (bool) {
        Rule storage rule = groups[groupId].rule;

        return (rule.token.balanceOf(account) > rule.tokenNum && rule.nft.balanceOf(account) > rule.nftNum && shares.getBalance(rule.sharesSubject, account) > rule.sharesNum);
    }

    function checkSignature(address account, uint groupId, uint8 _v, bytes32 _r, bytes32 _s) internal view returns (bool) {
        return ecrecover(keccak256(abi.encodePacked(account, groupId)), _v, _r, _s) == groups[groupId].rule.attesterAddress;
    }

    modifier onlyGroupOwner(address account, uint groupId) {
        require(
            account == groups[groupId].owner,
            "Only group owner can do this action"
        );
        _;
    }
}
