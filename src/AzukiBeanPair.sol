// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ERC721A/ERC721A.sol";

contract AzukiBeanPair is ERC721A {
    event MintPair(uint azukiId, uint beanzId);

    ERC721A public immutable AZUKI;
    ERC721A public immutable BEANZ;

    struct AzukiBeanzPair {
        uint azukiId;
        uint beanzId;
    }

    mapping(uint => AzukiBeanzPair) public idToPair;

    constructor(address _azukiAddress, address _beanzAddress)
        ERC721A("AzukiBeanPair", "ABP")
    {
        AZUKI = ERC721A(_azukiAddress);
        BEANZ = ERC721A(_beanzAddress);
    }

    function mintPair(uint _azukiId, uint _beanzId) external {
        require(
            AZUKI.ownerOf(_azukiId) == msg.sender &&
                BEANZ.ownerOf(_beanzId) == msg.sender,
            "Can't mint a pair that you don't own"
        );
        uint id = _totalMinted();
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

    function getPairAzukiId(uint id) public view returns (uint) {
        return idToPair[id].azukiId;
    }

    function getPairBeanzId(uint id) public view returns (uint) {
        return idToPair[id].beanzId;
    }
}
