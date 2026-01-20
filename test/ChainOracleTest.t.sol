// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {ChainlinkOracle} from "../src/ChainlinkOracle.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract ChainOracleTest is Test {
    ChainlinkOracle public chainlinkOracle;

    address primaryPriceFeed = 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612;

    function setUp() public {
        chainlinkOracle = new ChainlinkOracle(primaryPriceFeed);
    }

    function testGetLatestPrice() public view {
        int256 latestPrice = chainlinkOracle.getLatestPrice();
        assertTrue(latestPrice > 0, "Invalid price");
    }

    function testGetRoundData() public view {
        (uint80 roundId, int256 price, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            chainlinkOracle.getRoundData();
        assertTrue(roundId > 0, "Invalid round id");
        assertTrue(price > 0, "Invalid price");
        assertTrue(startedAt > 0, "Invalid started at");
        assertTrue(updatedAt > 0, "Invalid updated at");
        assertTrue(answeredInRound > 0, "Invalid answered in round");
    }
}
