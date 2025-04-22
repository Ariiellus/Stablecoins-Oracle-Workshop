// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "StableMint.sol";

contract DeployETHBackedStablecoin is Script {
    function run() external {
        // Carga tu private key desde .env
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Despliega el contrato
        ETHBackedStablecoin token = new ETHBackedStablecoin();

        vm.stopBroadcast();

        console2.log("Deployed ETHBackedStablecoin at:", address(token));
    }
}
