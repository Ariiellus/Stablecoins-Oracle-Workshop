// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; 

contract ETHBackedStablecoin is ERC20 {
    AggregatorV3Interface public immutable ethUsdPriceFeed;

    // Tracks ETH collateral deposited by each user.
    mapping(address => uint256) public ethCollateral;
    uint256 public constant MIN_COLLATERAL_RATIO_BPS = 15000;

    constructor() ERC20("USD Stable", "FruitUSD") {
        ethUsdPriceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function depositAndMint(uint256 amountToMint) external payable {
        require(amountToMint > 0, "Mint amount must be greater than zero");
        require(msg.value > 0, "Must deposit ETH");

        ethCollateral[msg.sender] += msg.value;

        uint256 ethUsdPrice = getLatestPrice();

        // Calculate new total minted balance and ensure overcollateralization
        uint256 totalCollateralUsd = (ethCollateral[msg.sender] * ethUsdPrice) / 1e8;
        uint256 newMintedTotal = balanceOf(msg.sender) + amountToMint;

        require(
            (totalCollateralUsd * 10000) / newMintedTotal >= MIN_COLLATERAL_RATIO_BPS,
            "Insufficient collateral"
        );

        _mint(msg.sender, amountToMint);
    }

    // Burn USD tokens and withdraw ETH
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
