// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "ERC721A/ERC721A.sol";
import "../src/AzukiBeanPair.sol";

// Run tests against fork of mainnet at block 15894587
// forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/API_KEY_HERE --fork-block-number 15894587
contract AzukiBeanTest is Test {
    AzukiBeanPair public azukiBeanPair;
    address rewkang = 0xff3879B8A363AeD92A6EABa8f61f1A96a9EC3c1e;

    ERC721A public immutable AZUKI =
        ERC721A(0xED5AF388653567Af2F388E6224dC7C4b3241C544);

    function setUp() public {
        address AZUKI_ADDRESS = 0xED5AF388653567Af2F388E6224dC7C4b3241C544;
        address BEANZ_ADDRESS = 0x306b1ea3ecdf94aB739F1910bbda052Ed4A9f949;
        azukiBeanPair = new AzukiBeanPair(AZUKI_ADDRESS, BEANZ_ADDRESS);
    }

    function testMintPair() public {
        vm.prank(rewkang);
        azukiBeanPair.mintPair(1414, 18464);
        uint azukiId = azukiBeanPair.getPairAzukiId(0);
        uint beanzId = azukiBeanPair.getPairBeanzId(0);
        assertEq(azukiId, 1414);
        assertEq(beanzId, 18464);
        address owner = azukiBeanPair.ownerOf(0);
        assertEq(owner, rewkang);
    }

    function testBurnPair() public {
        address dingaling = 0x54BE3a794282C030b15E43aE2bB182E14c409C5e;

        vm.prank(rewkang);
        azukiBeanPair.mintPair(1414, 18464);

        vm.prank(rewkang);
        AZUKI.transferFrom(rewkang, dingaling, 1414);

        vm.prank(dingaling);
        azukiBeanPair.burnPair(0);

        uint bal = azukiBeanPair.balanceOf(rewkang);
        assertEq(bal, 0);
    }
}
