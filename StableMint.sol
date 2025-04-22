// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; 

contract ETHBackedStablecoin is ERC20 {
  AggregatorV3Interface public immutable ethUsdPriceFeed;

  // Tracks ETH collateral deposited by each user
  // Use 1e8 Gwei
  mapping(address => uint256) public ethCollateral;
  uint256 public constant MIN_COLLATERAL_RATIO = 15000; // User must have at least 150% collateral

  constructor() ERC20("Frutero USD Stable", "FruitUSD") {
      ethUsdPriceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); // ETH/USD price feed
  }

    // Deposit ETH and mint USD only if collateral is above 150%
    // Mint 100 FruitUSD = 100e18
  function depositAndMint(uint256 amountToMint) external payable {
    require(amountToMint > 0, "Mint amount must be greater than zero");
    require(msg.value > 0, "Must deposit ETH");

    ethCollateral[msg.sender] += msg.value; // Update collateral balance

    uint256 ethUsdPrice = getLatestPrice();

    // Calculate total collateral in USD
    uint256 totalCollateralUsd = (ethCollateral[msg.sender] * ethUsdPrice) / 1e8;
    uint256 newMintedTotal = balanceOf(msg.sender) + amountToMint;

    // Check if collateral meets the minimum ratio
    require(
        (totalCollateralUsd * 10000) / newMintedTotal >= MIN_COLLATERAL_RATIO,
        "Insufficient collateral"
    );

    _mint(msg.sender, amountToMint);
  }

    // Burn USD tokens and withdraw ETH
  function burnAndWithdrawAll() external {
    uint256 userBalance = balanceOf(msg.sender);
    require(userBalance > 0, "Nothing to burn");

    uint256 collateral = ethCollateral[msg.sender];
    require(collateral > 0, "No collateral");

    // Reset collateral first (Checks-Effects-Interactions)
    ethCollateral[msg.sender] = 0;

    // Burn all FruitUSD
    _burn(msg.sender, userBalance);

    // Send full ETH collateral back
    payable(msg.sender).transfer(collateral);
  }

  // Chainlink Price Feed for ETH/USD
  function getLatestPrice() public view returns (uint256 ethUsdPrice) {
    (, int256 price, ,uint256 updatedAt,) = ethUsdPriceFeed.latestRoundData();

    require(price > 0, "Invalid oracle price");
    require(block.timestamp - updatedAt < 1 hours, "Stale oracle data");

    return uint256(price);
  }

  receive() external payable {}
}
