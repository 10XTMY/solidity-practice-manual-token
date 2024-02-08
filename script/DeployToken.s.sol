// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {OpenZepToken} from "../src/OpenZepToken.sol";
import {console} from "forge-std/console.sol";

// do not need a helperconfig because the token is going to be
// exactly the same no matter what chain we are on
// there are no special contracts that we need to interact with

contract DeployToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether; // 1 million tokens with 18 decimal places
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external returns (OpenZepToken) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }
        vm.startBroadcast(deployerKey);
        OpenZepToken newToken = new OpenZepToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return newToken;
    }
}
