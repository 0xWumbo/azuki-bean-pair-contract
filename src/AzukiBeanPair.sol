// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ERC721A/ERC721A.sol";
import "openzeppelin-contracts/token/ERC1155/ERC1155.sol";

contract AzukiBeanPair is ERC721A {
    event MintPair(uint azukiId, uint beanzId);

    uint128 constant BOBU_TOKEN_ID = 40;
    ERC721A public immutable AZUKI;
    ERC721A public immutable BEANZ;
    ERC1155 public immutable BOBU;

    struct AzukiBeanzPair {
        uint128 azukiId;
        uint128 beanzId;
    }

    mapping(uint => AzukiBeanzPair) public idToPair;

    constructor(
        address _azukiAddress,
        address _beanzAddress,
        address _bobuAddress
    ) ERC721A("AzukiBeanPair", "ABP") {
        AZUKI = ERC721A(_azukiAddress);
        BEANZ = ERC721A(_beanzAddress);
        BOBU = ERC1155(_bobuAddress);
    }

    function mintPair(uint128 _azukiId, uint128 _beanzId) external {
        require(
            AZUKI.ownerOf(_azukiId) == msg.sender &&
                BEANZ.ownerOf(_beanzId) == msg.sender,
            "Can't mint a pair that you don't own"
        );
        uint id = _nextTokenId();
        idToPair[id] = AzukiBeanzPair({azukiId: _azukiId, beanzId: _beanzId});
        _mint(msg.sender, 1);
        emit MintPair(_azukiId, _beanzId);
    }

    // Burn the Azuki-Bean pair if msg.sender owns either the Azuki or the Bean
    function burnPair(uint _id) external {
        require(_exists(_id), "Doesn't exist");
        require(
            AZUKI.ownerOf(getPairAzukiId(_id)) == msg.sender ||
                BEANZ.ownerOf(getPairBeanzId(_id)) == msg.sender,
            "Can't burn a token if you don't own the Azuki/Bean"
        );
        _burn(_id);
    }

    function mintBobuPair(uint128 _beanzId) external {
        require(BOBU.balanceOf(msg.sender, 1) > 0, "You need Bobu");
        require(
            BEANZ.ownerOf(_beanzId) == msg.sender,
            "You don't own that bean"
        );
        uint id = _nextTokenId();
        idToPair[id] = AzukiBeanzPair({
            azukiId: BOBU_TOKEN_ID,
            beanzId: _beanzId
        });
        _mint(msg.sender, 1);
        emit MintPair(BOBU_TOKEN_ID, 1);
    }

    function burnBobuPair(uint128 _id) external {
        require(
            BEANZ.ownerOf(getPairBeanzId(_id)) == msg.sender,
            "You need the bean"
        );
        _burn(_id);
    }

    function getPairAzukiId(uint id) public view returns (uint) {
        return idToPair[id].azukiId;
    }

    function getPairBeanzId(uint id) public view returns (uint) {
        return idToPair[id].beanzId;
    }
}
