// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin-5.0.1/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin-5.0.1/contracts/token/ERC20/ERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title ETHBackedStablecoin
 * @notice A simplified ETH-collateralized stablecoin pegged to USD using Chainlink ETH/USD price feed.
 * @dev Demonstrates oracle integration and overcollateralized minting logic.
 */
contract ETHBackedStablecoin is ERC20 {
    AggregatorV3Interface public immutable ethUsdPriceFeed;

    /// @notice Tracks ETH collateral deposited by each user.
    mapping(address => uint256) public ethCollateral;

    /// @notice Minimum collateralization ratio in basis points (e.g., 15000 = 150%).
    uint256 public constant MIN_COLLATERAL_RATIO_BPS = 15000;

    constructor(address _priceFeed) ERC20("USD Stable", "USDS") {
        require(_priceFeed != address(0), "Invalid price feed address");
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeed);
    }

    /**
     * @notice Allows users to deposit ETH and mint stablecoins against it.
     * @param amountToMint The amount of USDS the user wants to mint.
     */
    function depositAndMint(uint256 amountToMint) external payable {
        require(amountToMint > 0, "Mint amount must be greater than zero");
        require(msg.value > 0, "Must deposit ETH");

        ethCollateral[msg.sender] += msg.value;

        uint256 ethUsdPrice = getLatestPrice();
        uint256 collateralValueUsd = (msg.value * ethUsdPrice) / 1e8;

        // Calculate new total minted balance and ensure overcollateralization
        uint256 totalCollateralUsd = (ethCollateral[msg.sender] * ethUsdPrice) / 1e8;
        uint256 newMintedTotal = balanceOf(msg.sender) + amountToMint;

        require(
            (totalCollateralUsd * 10000) / newMintedTotal >= MIN_COLLATERAL_RATIO_BPS,
            "Insufficient collateral"
        );

        _mint(msg.sender, amountToMint);
    }

    /**
     * @notice Allows users to burn USDS and withdraw corresponding ETH.
     * @param amountToBurn The amount of USDS to burn for redeeming ETH.
     */
    function burnAndWithdraw(uint256 amountToBurn) external {
        require(amountToBurn > 0, "Burn amount must be greater than zero");
        require(balanceOf(msg.sender) >= amountToBurn, "Insufficient balance");

        uint256 ethUsdPrice = getLatestPrice();

        // Calculate value of burned tokens in USD
        uint256 usdValue = amountToBurn;

        // Convert USD value back to ETH (assuming price is in 8 decimals)
        uint256 ethToReturn = (usdValue * 1e8) / ethUsdPrice;

        require(ethCollateral[msg.sender] >= ethToReturn, "Insufficient collateral");

        ethCollateral[msg.sender] -= ethToReturn;

        _burn(msg.sender, amountToBurn);
        payable(msg.sender).transfer(ethToReturn);
    }

    /**
     * @notice Reads the latest ETH/USD price from the Chainlink oracle.
     * @dev Reverts if the price is stale or invalid.
     * @return ethUsdPrice The latest ETH price in USD with 8 decimals.
     */
    function getLatestPrice() public view returns (uint256 ethUsdPrice) {
        (
            , 
            int256 price,
            ,
            uint256 updatedAt,
            
        ) = ethUsdPriceFeed.latestRoundData();

        require(price > 0, "Invalid oracle price");
        require(block.timestamp - updatedAt < 1 hours, "Stale oracle data");

        return uint256(price);
    }

    receive() external payable {}
}
