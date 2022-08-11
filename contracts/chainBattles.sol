//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// 0xc0e2E50DCD8A3640C6a436305EaD8a2555118521

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct stats {
        uint256 level;
        uint256 hp;
        uint256 power;
    }

    mapping(uint256 => stats) public tokenIdtoStats;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(tokenId),
            "HP: ",
            getHp(tokenId),
            "Power: ",
            getPower(tokenId),
            "</text>",
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdtoStats[tokenId].level;
        return levels.toString();
    }

    function getHp(uint256 tokenId) public view returns (string memory) {
        uint256 hp = tokenIdtoStats[tokenId].hp;
        return hp.toString();
    }

    function getPower(uint256 tokenId) public view returns (string memory) {
        uint256 power = tokenIdtoStats[tokenId].power;
        return power.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdtoStats[newItemId].level = 0;
        tokenIdtoStats[newItemId].hp = 7 + (random() % 5);
        tokenIdtoStats[newItemId].power = (random() % 5);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(abi.encodePacked(block.difficulty, block.timestamp))
            );
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );
        uint256 currentLevel = tokenIdtoStats[tokenId].level;
        tokenIdtoStats[tokenId].level = currentLevel + 1;
        uint256 currentHP = tokenIdtoStats[tokenId].hp;
        tokenIdtoStats[tokenId].hp = currentHP + 3;
        uint256 currentPower = tokenIdtoStats[tokenId].power;
        tokenIdtoStats[tokenId].power = currentPower + 2;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
