// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./ATP.sol";

contract ATPMonitoring {
    AggregatorV3Interface public priceOracle; // Chainlink price oracle contract
    address public atpContract = 0x652c9ACcC53e765e1d96e2455E618dAaB79bA595 ; // Address of the ATP contract
    uint256 public targetPegValue = 1; // Target peg value (e.g., 1)

    event PriceCheck(uint256 currentPrice, uint256 targetPrice);
    event BuybackTriggered(uint256 currentPrice);

    constructor(address _priceOracleAddress, address _atpContractAddress) {
    priceOracle = AggregatorV3Interface(_priceOracleAddress);
    atpContract = _atpContractAddress; // Assign the ATP contract address directly
    targetPegValue = 1; // Set the initial target peg value (e.g., 1 ATP = 1 reference asset)
}
 // Function to periodically check the price and trigger buyback if necessary
    function checkPriceAndTriggerBuyback() external {
        // Get the latest price from the oracle
        (, int256 price, , , ) = priceOracle.latestRoundData();

        // Convert the Chainlink price to uint256
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
