// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../EmojiGotchi.sol";

contract EmojiGotchiTest is DSTest {
    EmojiGotchi public eg;

    // assign contract
    // create address
    function setUp() public {
        eg = new EmojiGotchi();
        address addr = 0x1234567890123456789012345678901234567890;
        // mint nft to this address
        eg.safeMint(addr);
    }

    // mint
    function testMint() public {
        // verify that we minted an NFT and signed it to address
        address addr = 0x1234567890123456789012345678901234567890;
        address owner = eg.ownerOf(0);
        assertEq(addr, owner);
    }

    // URI
    function testUri() public {
        // happiness, hunger, enrichment, checked, image
        (
            uint256 happiness,
            uint256 hunger,
            uint256 enrichment,
            uint256 checked,

        ) = eg.gotchiStats(0);

        assertEq(happiness, (hunger + enrichment) / 2);
        assertEq(hunger, 100);
        assertEq(enrichment, 100);
        assertEq(checked, block.timestamp);
    }

    // emoji is based on NFT. test minting

    // passing time
    // feed
    // play
    // image change
    // check upkeep
    // perform upkeep
    function testExample() public {
        assertTrue(true);
    }
}
