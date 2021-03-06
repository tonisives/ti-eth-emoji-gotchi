// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

contract EmojiGotchi is ERC721, ERC721URIStorage, Ownable {
    string SVGBase =
        "data:image/svg+xml;base64,PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHdpZHRoPScxMDAlJyBoZWlnaHQ9JzEwMCUnIHZpZXdCb3g9JzAgMCA4MDAgODAwJz48cmVjdCBmaWxsPScjZmZmZmZmJyB3aWR0aD0nODAwJyBoZWlnaHQ9JzgwMCcvPjxkZWZzPjxyYWRpYWxHcmFkaWVudCBpZD0nYScgY3g9JzQwMCcgY3k9JzQwMCcgcj0nNTAuMSUnIGdyYWRpZW50VW5pdHM9J3VzZXJTcGFjZU9uVXNlJz48c3RvcCAgb2Zmc2V0PScwJyBzdG9wLWNvbG9yPScjZmZmZmZmJy8+PHN0b3AgIG9mZnNldD0nMScgc3RvcC1jb2xvcj0nIzBFRicvPjwvcmFkaWFsR3JhZGllbnQ+PHJhZGlhbEdyYWRpZW50IGlkPSdiJyBjeD0nNDAwJyBjeT0nNDAwJyByPSc1MC40JScgZ3JhZGllbnRVbml0cz0ndXNlclNwYWNlT25Vc2UnPjxzdG9wICBvZmZzZXQ9JzAnIHN0b3AtY29sb3I9JyNmZmZmZmYnLz48c3RvcCAgb2Zmc2V0PScxJyBzdG9wLWNvbG9yPScjMEZGJy8+PC9yYWRpYWxHcmFkaWVudD48L2RlZnM+PHJlY3QgZmlsbD0ndXJsKCNhKScgd2lkdGg9JzgwMCcgaGVpZ2h0PSc4MDAnLz48ZyBmaWxsLW9wYWNpdHk9JzAuNSc+PHBhdGggZmlsbD0ndXJsKCNiKScgZD0nTTk5OC43IDQzOS4yYzEuNy0yNi41IDEuNy01Mi43IDAuMS03OC41TDQwMSAzOTkuOWMwIDAgMC0wLjEgMC0wLjFsNTg3LjYtMTE2LjljLTUuMS0yNS45LTExLjktNTEuMi0yMC4zLTc1LjhMNDAwLjkgMzk5LjdjMCAwIDAtMC4xIDAtMC4xbDUzNy4zLTI2NWMtMTEuNi0yMy41LTI0LjgtNDYuMi0zOS4zLTY3LjlMNDAwLjggMzk5LjVjMCAwIDAtMC4xLTAuMS0wLjFsNDUwLjQtMzk1Yy0xNy4zLTE5LjctMzUuOC0zOC4yLTU1LjUtNTUuNWwtMzk1IDQ1MC40YzAgMC0wLjEgMC0wLjEtMC4xTDczMy40LTk5Yy0yMS43LTE0LjUtNDQuNC0yNy42LTY4LTM5LjNsLTI2NSA1MzcuNGMwIDAtMC4xIDAtMC4xIDBsMTkyLjYtNTY3LjRjLTI0LjYtOC4zLTQ5LjktMTUuMS03NS44LTIwLjJMNDAwLjIgMzk5YzAgMC0wLjEgMC0wLjEgMGwzOS4yLTU5Ny43Yy0yNi41LTEuNy01Mi43LTEuNy03OC41LTAuMUwzOTkuOSAzOTljMCAwLTAuMSAwLTAuMSAwTDI4Mi45LTE4OC42Yy0yNS45IDUuMS01MS4yIDExLjktNzUuOCAyMC4zbDE5Mi42IDU2Ny40YzAgMC0wLjEgMC0wLjEgMGwtMjY1LTUzNy4zYy0yMy41IDExLjYtNDYuMiAyNC44LTY3LjkgMzkuM2wzMzIuOCA0OTguMWMwIDAtMC4xIDAtMC4xIDAuMUw0LjQtNTEuMUMtMTUuMy0zMy45LTMzLjgtMTUuMy01MS4xIDQuNGw0NTAuNCAzOTVjMCAwIDAgMC4xLTAuMSAwLjFMLTk5IDY2LjZjLTE0LjUgMjEuNy0yNy42IDQ0LjQtMzkuMyA2OGw1MzcuNCAyNjVjMCAwIDAgMC4xIDAgMC4xbC01NjcuNC0xOTIuNmMtOC4zIDI0LjYtMTUuMSA0OS45LTIwLjIgNzUuOEwzOTkgMzk5LjhjMCAwIDAgMC4xIDAgMC4xbC01OTcuNy0zOS4yYy0xLjcgMjYuNS0xLjcgNTIuNy0wLjEgNzguNUwzOTkgNDAwLjFjMCAwIDAgMC4xIDAgMC4xbC01ODcuNiAxMTYuOWM1LjEgMjUuOSAxMS45IDUxLjIgMjAuMyA3NS44bDU2Ny40LTE5Mi42YzAgMCAwIDAuMSAwIDAuMWwtNTM3LjMgMjY1YzExLjYgMjMuNSAyNC44IDQ2LjIgMzkuMyA2Ny45bDQ5OC4xLTMzMi44YzAgMCAwIDAuMSAwLjEgMC4xbC00NTAuNCAzOTVjMTcuMyAxOS43IDM1LjggMzguMiA1NS41IDU1LjVsMzk1LTQ1MC40YzAgMCAwLjEgMCAwLjEgMC4xTDY2LjYgODk5YzIxLjcgMTQuNSA0NC40IDI3LjYgNjggMzkuM2wyNjUtNTM3LjRjMCAwIDAuMSAwIDAuMSAwTDIwNy4xIDk2OC4zYzI0LjYgOC4zIDQ5LjkgMTUuMSA3NS44IDIwLjJMMzk5LjggNDAxYzAgMCAwLjEgMCAwLjEgMGwtMzkuMiA1OTcuN2MyNi41IDEuNyA1Mi43IDEuNyA3OC41IDAuMUw0MDAuMSA0MDFjMCAwIDAuMSAwIDAuMSAwbDExNi45IDU4Ny42YzI1LjktNS4xIDUxLjItMTEuOSA3NS44LTIwLjNMNDAwLjMgNDAwLjljMCAwIDAuMSAwIDAuMSAwbDI2NSA1MzcuM2MyMy41LTExLjYgNDYuMi0yNC44IDY3LjktMzkuM0w0MDAuNSA0MDAuOGMwIDAgMC4xIDAgMC4xLTAuMWwzOTUgNDUwLjRjMTkuNy0xNy4zIDM4LjItMzUuOCA1NS41LTU1LjVsLTQ1MC40LTM5NWMwIDAgMC0wLjEgMC4xLTAuMUw4OTkgNzMzLjRjMTQuNS0yMS43IDI3LjYtNDQuNCAzOS4zLTY4bC01MzcuNC0yNjVjMCAwIDAtMC4xIDAtMC4xbDU2Ny40IDE5Mi42YzguMy0yNC42IDE1LjEtNDkuOSAyMC4yLTc1LjhMNDAxIDQwMC4yYzAgMCAwLTAuMSAwLTAuMUw5OTguNyA0MzkuMnonLz48L2c+PHRleHQgeD0nNTAlJyB5PSc1MCUnIGNsYXNzPSdiYXNlJyBkb21pbmFudC1iYXNlbGluZT0nbWlkZGxlJyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBmb250LXNpemU9JzhlbSc+8J+";

    string[] emojiSuffixes = [
        "kqTwvdGV4dD48L3N2Zz4=",
        "YgTwvdGV4dD48L3N2Zz4=",
        "YkDwvdGV4dD48L3N2Zz4=",
        "YoTwvdGV4dD48L3N2Zz4=",
        "SgDwvdGV4dD48L3N2Zz4="
    ];

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct GotchiAttributes {
        uint256 gotchiIndex;
        uint256 happiness;
        uint256 hunger;
        uint256 enrichment;
        uint256 lastChecked;
        string imageUri;
    }

    event EmojiUpdated(
        uint256 happiness,
        uint256 hunger,
        uint256 enrichment,
        uint256 lastChecked,
        string imageUri,
        uint256 gotchiIndex
    );

    // owner addresses to gotchi token id
    mapping(address => uint256) public gotchiHolders;
    // gotchi token id to attributes
    mapping(uint256 => GotchiAttributes) public gotchiHolderAttributes;

    constructor() ERC721("EmojiGotchi", "EMG") {
        safeMint(msg.sender);
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        string memory finalSVG = string(
            abi.encodePacked(SVGBase, emojiSuffixes[0])
        );

        // create attributes for token id
        gotchiHolderAttributes[tokenId] = GotchiAttributes({
            gotchiIndex: tokenId,
            happiness: 100,
            hunger: 100,
            enrichment: 100,
            lastChecked: block.timestamp,
            imageUri: finalSVG
        });

        gotchiHolders[to] = tokenId;

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI(tokenId));
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        GotchiAttributes memory gotchiAttributes = gotchiHolderAttributes[
            tokenId
        ];
        string memory strHappiness = Strings.toString(
            gotchiAttributes.happiness
        );
        string memory strHunger = Strings.toString(gotchiAttributes.hunger);
        string memory strEnrichment = Strings.toString(
            gotchiAttributes.enrichment
        );

        string memory json = string(
            abi.encodePacked(
                "{",
                '"name": "Emoji friend",',
                '"description": "Keep your friend happy!","image": "',
                gotchiAttributes.imageUri,
                '",',
                '"traits": [',
                '{"trait_type":"hunger","value":',
                strHunger,
                "},",
                '{"trait_type":"happiness","value":',
                strHappiness,
                "},",
                '{"trait_type":"enrichment","value":',
                strEnrichment,
                "}",
                "]}"
            )
        );

        return json;
    }

    function gotchiStats(uint256 gotchiTokenId)
        public
        view
        returns (
            uint256 happiness,
            uint256 hunger,
            uint256 enrichment,
            uint256 checked,
            string memory image
        )
    {
        return (
            gotchiHolderAttributes[gotchiTokenId].happiness,
            gotchiHolderAttributes[gotchiTokenId].hunger,
            gotchiHolderAttributes[gotchiTokenId].enrichment,
            gotchiHolderAttributes[gotchiTokenId].lastChecked,
            gotchiHolderAttributes[gotchiTokenId].imageUri
        );
    }

    function myGotchi()
        public
        view
        returns (
            uint256 happiness,
            uint256 hunger,
            uint256 enrichment,
            uint256 checked,
            string memory image
        )
    {
        return gotchiStats(gotchiHolders[msg.sender]);
    }

    function passTime(uint256 tokenId) public {
        if (gotchiHolderAttributes[tokenId].hunger >= 10) {
            gotchiHolderAttributes[tokenId].hunger -= 10;
        }

        if (gotchiHolderAttributes[tokenId].enrichment >= 10) {
            gotchiHolderAttributes[tokenId].enrichment -= 10;
        }

        gotchiHolderAttributes[tokenId].happiness =
            (gotchiHolderAttributes[tokenId].hunger +
                gotchiHolderAttributes[tokenId].enrichment) /
            2;

        updateURI(tokenId);
        emitUpdate(tokenId);
    }

    function updateURI(uint256 tokenId) private {
        // set the emoji according to attributes
        string memory emojiSuffix = emojiSuffixes[0];
        if (gotchiHolderAttributes[tokenId].happiness == 100) {
            emojiSuffix = emojiSuffixes[0];
        } else if (gotchiHolderAttributes[tokenId].happiness > 66) {
            emojiSuffix = emojiSuffixes[1];
        } else if (gotchiHolderAttributes[tokenId].happiness > 33) {
            emojiSuffix = emojiSuffixes[2];
        } else if (gotchiHolderAttributes[tokenId].happiness > 0) {
            emojiSuffix = emojiSuffixes[3];
        } else {
            emojiSuffix = emojiSuffixes[4];
        }

        string memory fullEmojiUri = string(
            abi.encodePacked(SVGBase, emojiSuffix)
        );
        gotchiHolderAttributes[tokenId].imageUri = fullEmojiUri;
        // set the full json uri
        _setTokenURI(tokenId, tokenURI(tokenId));
    }

    function feed() public {
        uint256 tokenId = gotchiHolders[msg.sender];
        // increase hunger by 10
        gotchiHolderAttributes[tokenId].hunger = 100;

        gotchiHolderAttributes[tokenId].happiness =
            (gotchiHolderAttributes[tokenId].hunger +
                gotchiHolderAttributes[tokenId].enrichment) /
            2;

        // update the emoji, maybe it changed
        updateURI(tokenId);
        emitUpdate(tokenId);
    }

    function play() public {
        uint256 tokenId = gotchiHolders[msg.sender];
        // increase hunger by 10
        gotchiHolderAttributes[tokenId].enrichment = 100;

        gotchiHolderAttributes[tokenId].happiness =
            (gotchiHolderAttributes[tokenId].hunger +
                gotchiHolderAttributes[tokenId].enrichment) /
            2;

        // update the emoji, maybe it changed
        updateURI(tokenId);
        emitUpdate(tokenId);
    }

    // KeeperCompatibleInterface

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        // every 60s do upkeep
        // if had multiple gotchis, would need to iterate over all of them
        uint256 lastTimeStamp = gotchiHolderAttributes[0].lastChecked;
        upkeepNeeded =
            ((block.timestamp - lastTimeStamp) > 60) &&
            gotchiHolderAttributes[0].happiness > 0;
    }

    function performUpkeep(
        bytes calldata /* performData */
    ) external {
        // there is a gas fee for upkeep. Just in case run the checkUpKeep test again
        uint256 lastTimeStamp = gotchiHolderAttributes[0].lastChecked;
        bool upkeepNeeded = ((block.timestamp - lastTimeStamp) > 60) &&
            gotchiHolderAttributes[0].happiness > 0;

        if (upkeepNeeded) {
            // TODO: should loop all NFT-s and passTime() on them
            gotchiHolderAttributes[0].lastChecked = block.timestamp;
            passTime(0);
        }
    }

    function emitUpdate(uint256 tokenId) internal {
        emit EmojiUpdated(
            gotchiHolderAttributes[tokenId].happiness,
            gotchiHolderAttributes[tokenId].hunger,
            gotchiHolderAttributes[tokenId].enrichment,
            gotchiHolderAttributes[tokenId].lastChecked,
            gotchiHolderAttributes[tokenId].imageUri,
            tokenId
        );
    }
}
