// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {
    AggregatorV3Interface
} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract SecureChainlinkOracle {
    AggregatorV3Interface public immutable PRIMARY_PRICE_FEED;
    AggregatorV3Interface public immutable SECONDARY_PRICE_FEED;
    uint256 public immutable STALE_FEED_THRESHOLD;

    constructor(address _primaryFeed, address _secondaryFeed, uint256 _staleThreshold) {
        require(_primaryFeed != address(0), "Primary feed address required");
        require(_secondaryFeed != address(0), "Secondary feed address required");
        require(_staleThreshold > 0, "Stale threshold must be positive");

        PRIMARY_PRICE_FEED = AggregatorV3Interface(_primaryFeed);
        SECONDARY_PRICE_FEED = AggregatorV3Interface(_secondaryFeed);
        STALE_FEED_THRESHOLD = _staleThreshold;
    }

    function getLatestPrice() external view returns (int256 price, uint8 decimals) {
        try PRIMARY_PRICE_FEED.latestRoundData() {
            (, int256 answer,, uint256 updatedAt,) = PRIMARY_PRICE_FEED.latestRoundData();
            require(answer > 0, "Primary feed: price <= 0");
            require(updatedAt > 0, "Primary feed: invalid timestamp");
            require(block.timestamp - updatedAt <= STALE_FEED_THRESHOLD, "Primary feed: stale");

            price = answer;
            decimals = PRIMARY_PRICE_FEED.decimals();
        } catch {
            try SECONDARY_PRICE_FEED.latestRoundData() {
                (, int256 answer,, uint256 updatedAt,) = SECONDARY_PRICE_FEED.latestRoundData();

                require(answer > 0, "Secondary feed: price <= 0");
                require(updatedAt > 0, "Secondary feed: invalid timestamp");
                require(block.timestamp - updatedAt <= STALE_FEED_THRESHOLD, "Secondary feed: stale");

                price = answer;
                decimals = SECONDARY_PRICE_FEED.decimals();
            } catch {
                revert("Both price feeds failed");
            }
        }
    }

    function getDecimals() external view returns (uint8) {
        return PRIMARY_PRICE_FEED.decimals();
    }

    function getPriceFeedAddress() external view returns (address) {
        return address(PRIMARY_PRICE_FEED);
    }
}
