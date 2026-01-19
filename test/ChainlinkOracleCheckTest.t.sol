// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {SecureChainlinkOracle} from "../src/ChainLinlOracleChecks.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract ChainlinkOracleCheckTest is Test {
    SecureChainlinkOracle public chainlinkOracleChecks;

    address primaryPriceFeed = 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612;
    address secondaryPriceFeed = 0xe4D040128CFdF03eC221832251caC9b6f0515E3f;
    uint256 staleFeedThreshold = 1 hours;

    function setUp() public {
        chainlinkOracleChecks = new SecureChainlinkOracle(primaryPriceFeed, secondaryPriceFeed, staleFeedThreshold);
    }

    function testGetLatestPrice() public view {
        (int256 latestPrice, uint8 decimals) = chainlinkOracleChecks.getLatestPrice();
        assertTrue(latestPrice > 0, "Invalid price");
        assertTrue(decimals > 0, "Invalid decimals");
    }

    function testGetLatestPriceInvalidPrimary() public {
        SecureChainlinkOracle chainlinkOracleChecksInvalidPrimary =
            new SecureChainlinkOracle(vm.addr(1), secondaryPriceFeed, staleFeedThreshold);

        (int256 latestPrice, uint8 decimals) = chainlinkOracleChecksInvalidPrimary.getLatestPrice();
        assertTrue(latestPrice >= 0, "Invalid price");
        assertTrue(decimals > 0, "Invalid decimals");
    }

    function testGetLatestPriceStale() public {
        SecureChainlinkOracle chainlinkOracleChecksStale =
            new SecureChainlinkOracle(primaryPriceFeed, secondaryPriceFeed, 1);
        vm.expectRevert();
        chainlinkOracleChecksStale.getLatestPrice();
    }

    function testBothFeedsFailed() public {
        SecureChainlinkOracle chainlinkOracleChecksBothInvalid =
            new SecureChainlinkOracle(vm.addr(1), vm.addr(2), staleFeedThreshold);
        vm.expectRevert("Both price feeds failed");
        chainlinkOracleChecksBothInvalid.getLatestPrice();
    }

    function testGetDecimals() public view {
        uint8 decimals = chainlinkOracleChecks.getDecimals();
        assertTrue(decimals > 0, "Invalid decimals");
    }
}
