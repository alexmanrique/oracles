// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {PythOracle} from "../src/PythOracle.sol";
import {IPyth} from "@pythnetwork/pyth-sdk-solidity/IPyth.sol";
import {PythStructs} from "@pythnetwork/pyth-sdk-solidity/PythStructs.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract PythOracleChecksTest is Test {
    PythOracle public pythOracle;

    address pythContract = 0xff1a0f4744e8582DF1aE09D5611b887B6a12925C;
    bytes32 priceIdEthUsd = 0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace;

    function setUp() public {
        pythOracle = new PythOracle(pythContract, priceIdEthUsd);
        vm.deal(address(this), 1 ether);
    }

    function testGetLatestPrice() public {
        PythStructs.Price memory priceData =
            PythStructs.Price({price: 2_000_00000000, conf: 1, expo: -8, publishTime: block.timestamp});
        vm.mockCall(
            pythContract, abi.encodeWithSelector(IPyth.getPriceUnsafe.selector, priceIdEthUsd), abi.encode(priceData)
        );
        (int64 price, uint64 conf, int32 expo) = pythOracle.getLatestPrice();
        assertTrue(price > 0, "Invalid price");
        assertTrue(conf > 0, "Invalid confidence");
        assertTrue(expo < 0, "Invalid exponent");
    }

    function testUpdatePrice() public {
        bytes[] memory updateData = new bytes[](0);
        uint256 fee = 1;
        vm.mockCall(pythContract, abi.encodeWithSelector(IPyth.getUpdateFee.selector, updateData), abi.encode(fee));
        vm.mockCall(pythContract, abi.encodeWithSelector(IPyth.updatePriceFeeds.selector, updateData), "");
        pythOracle.updatePrice{value: fee}(updateData);
        assertTrue(true, "Update price successful");
    }
}
