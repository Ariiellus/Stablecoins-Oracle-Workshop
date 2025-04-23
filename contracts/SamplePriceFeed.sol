// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED
 * VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

contract DataConsumerV3 {
    AggregatorV3Interface internal btcUsdFeed;
    AggregatorV3Interface internal ethUsdFeed; 

    /**
     * Network: Sepolia
     * Aggregator:
     * BTC/USD: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     * ETH/USD: 0x694AA1769357215DE4FAC081bf1f309aDC325306
     */

    constructor() {
        btcUsdFeed = AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43);
        ethUsdFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    // Returns the latest prices.
    function getBTCLatestPrice() public view returns (int) {
        (
        , 
        int256 answer,
        ,
        ,
        ) = btcUsdFeed.latestRoundData();
        return answer;
    }

    function getETHLatestPrice() public view returns (int) {
        (, int256 answer, , , ) = ethUsdFeed.latestRoundData();
        return answer;
    }
}
