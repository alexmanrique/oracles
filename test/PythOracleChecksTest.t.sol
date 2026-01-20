// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {PythOracleChecks} from "../src/PythOracleChecks.sol";
import {IPyth} from "../lib/pyth-sdk-solidity/IPyth.sol";
import {PythStructs} from "../lib/pyth-sdk-solidity/PythStructs.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract PythOracleChecksTest is Test {
    PythOracleChecks public pythOracle;

    address pythContract = 0xff1a0f4744e8582DF1aE09D5611b887B6a12925C;
    bytes32 priceIdEthUsd = 0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace;

    function setUp() public {
        pythOracle = new PythOracleChecks(pythContract, priceIdEthUsd);
        vm.deal(address(this), 1 ether);
    }

    function testGetLatestPrice() public {
        bytes[] memory updateData = new bytes[](0);
        uint256 fee = 1;
        PythStructs.Price memory priceData =
            PythStructs.Price({price: 2_000_00000000, conf: 1, expo: -8, publishTime: block.timestamp});
        vm.mockCall(pythContract, abi.encodeWithSelector(IPyth.getUpdateFee.selector, updateData), abi.encode(fee));
        vm.mockCall(pythContract, abi.encodeWithSelector(IPyth.updatePriceFeeds.selector, updateData), "");
        vm.mockCall(
            pythContract,
            abi.encodeWithSelector(IPyth.getPriceNoOlderThan.selector, priceIdEthUsd, pythOracle.MAX_AGE_SECONDS()),
            abi.encode(priceData)
        );
        (int64 price, uint64 conf, int32 expo) = pythOracle.getLatestPrice{value: fee}(updateData);
        assertTrue(price > 0, "Invalid price");
        assertTrue(conf > 0, "Invalid confidence");
        assertTrue(expo >= pythOracle.MIN_ACCEPTABLE_EXPO(), "Invalid exponent");
    }

    function testUpdatePrice() public {
        bytes[] memory updateData = new bytes[](0);
        uint256 fee = 1;
        vm.mockCall(pythContract, abi.encodeWithSelector(IPyth.getUpdateFee.selector, updateData), abi.encode(fee));
        vm.mockCall(pythContract, abi.encodeWithSelector(IPyth.updatePriceFeeds.selector, updateData), "");
        pythOracle.updatePrice{value: fee}(updateData);
        assertTrue(true, "Update price successful");
    }

    function testUpdatePriceInsufficientFee() public {
        bytes[] memory updateData = new bytes[](0);
        uint256 fee = 0;
        vm.mockCall(
            pythContract, abi.encodeWithSelector(IPyth.getUpdateFee.selector, updateData), abi.encode(uint256(1))
        );
        vm.expectRevert("Insufficient fee sent");
        pythOracle.updatePrice{value: fee}(updateData);
    }
}
