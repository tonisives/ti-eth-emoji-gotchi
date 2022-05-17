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

    function testMyGotchi() public {
        // happiness, hunger, enrichment, checked, image
        (
            uint256 happiness,
            uint256 hunger,
            uint256 enrichment,
            uint256 checked,

        ) = eg.myGotchi();

        assertEq(happiness, (hunger + enrichment) / 2);
        assertEq(hunger, 100);
        assertEq(enrichment, 100);
        assertEq(checked, block.timestamp);
    }

    // passing time

    function testPassTime() public {
        // pass time for an nft. They are different because it is related to when
        // the NFT was minted
        eg.passTime(0);

        (uint256 happiness, uint256 hunger, uint256 enrichment, , ) = eg
            .gotchiStats(0);

        // when time passes, we want to decrease hunger and enrichment
        assertEq(hunger, 90);
        assertEq(enrichment, 90);
        assertEq(happiness, (90 + 90) / 2);
    }

    // feed

    function testFeed() public {
        eg.passTime(0);
        // test that feeding increases hunger, enrichment, happiness back to 100
        eg.feed();

        (uint256 happiness, uint256 hunger, , , ) = eg.myGotchi();

        // when time passes, we want to decrease hunger and enrichment
        assertEq(hunger, 100);
        assertEq(happiness, 95);
    }

    // play

    function testPlay() public {
        eg.passTime(0);
        // test that feeding increases hunger, enrichment, happiness back to 100
        eg.play();

        (uint256 happiness, uint256 hunger, uint256 enrichment, , ) = eg
            .myGotchi();

        // when time passes, we want to decrease hunger and enrichment
        assertEq(hunger, 90);
        assertEq(enrichment, 100);
        assertEq(happiness, 95);
    }

    // image change
    // check upkeep
    // perform upkeep
    function testExample() public {
        assertTrue(true);
    }
}
