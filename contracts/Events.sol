// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./ATP.sol";

contract Events {
    AggregatorV3Interface public priceOracle;
    uint256 public targetPegValue;
    address public atpContract;

    // Event to log a buyback operation
     event BuybackTriggered(uint256 currentPrice);
     event PriceCheck(uint256 currentPrice, uint256 targetPrice);

   constructor(address _priceOracleAddress, address _atpContract) {
    priceOracle = AggregatorV3Interface(_priceOracleAddress);
    targetPegValue = 1;
   atpContract = address(_atpContract);
}

    // Function to initiate a buyback when the price falls below the target peg value
    function initiateBuyback() external {
        // Check if the current price is below the target peg value
        (, int256 price, , , ) = priceOracle.latestRoundData();
        uint256 currentPrice = uint256(price);

        emit PriceCheck(currentPrice, targetPegValue);

        // Compare the current price to the target peg value
        if (currentPrice < targetPegValue) {
            // If the price is below the target, trigger a buyback in the ATP contract
            ATP(atpContract).initiateBuyback();
            emit BuybackTriggered(currentPrice);
        }
    }
}