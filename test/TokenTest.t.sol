// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {DeployToken} from "../script/DeployToken.s.sol";
import {OpenZepToken} from "../src/OpenZepToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract TokenTest is StdCheats, Test {
    uint256 BOB_STARTING_AMOUNT = 100 ether;

    OpenZepToken public newToken;
    DeployToken public deployer;
    address public deployerAddress;
    address bob;
    address alice;

    function setUp() public {
        deployer = new DeployToken();
        newToken = deployer.run();

        bob = makeAddr("bob");
        alice = makeAddr("alice");

        deployerAddress = vm.addr(deployer.deployerKey());
        vm.prank(deployerAddress);
        newToken.transfer(bob, BOB_STARTING_AMOUNT);
    }

    function testInitialSupply() public {
        assertEq(newToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(newToken)).mint(address(this), 1);
    }

    function testAllowances() public {
        // transferFrom should throw error if
        // payer has not authrorized payee to spend on their behalf
        uint256 initialAllowance = 1000;

        // Alice approves Bob to spend tokens on her behalf
        vm.prank(bob);
        newToken.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        newToken.transferFrom(bob, alice, transferAmount);
        assertEq(newToken.balanceOf(alice), transferAmount);
        assertEq(newToken.balanceOf(bob), BOB_STARTING_AMOUNT - transferAmount);
    }
}
