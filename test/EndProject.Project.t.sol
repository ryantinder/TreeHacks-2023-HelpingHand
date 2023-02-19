// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { ProjectFactory } from "src/ProjectFactory.sol";
import { Project } from "src/Project.sol";
import { IdentityProvider } from "src/IdentityProvider.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract EndProjectTests is PRBTest, StdCheats {
    address me = 0xb9413c6FDA8Eac23E8F2cB2cc62D90881aBdD77d;
    ProjectFactory factory;
    Project project;
    IdentityProvider identityProvider;
    IERC20 USDC = IERC20(0x7F5c764cBc14f9669B88837ca1490cCa17c31607);
    address alice = address(14);
    address bob = address(15);
    address admin = address(16);
    string RPC_URL = vm.envString("OPTIMISM");
    constructor() {
        // solhint-disable-previous-line no-empty-blocks
        vm.createSelectFork(RPC_URL);

        factory = new ProjectFactory();
        identityProvider = factory.identityProvider();
        hoax(alice, alice);
        identityProvider.mint();
        hoax(bob, bob);
        identityProvider.mint();
        hoax(admin, admin);
        project = Project(factory.createProject("ipfs", USDC));

    }

    function testOneWayDisperse() public {
        hoax(alice, alice);
        project.enter(0);
        deal(address(project.asset()), address(project), 10e6);

        hoax(admin, admin);
        project.endProject();

        assertEq(USDC.balanceOf(alice), 10e6);
    }

    function testTwoWayDisperse() public {
        hoax(alice, alice);
        project.enter(0);
        hoax(bob, bob);
        project.enter(1);
        
        deal(address(project.asset()), address(project), 10e6);

        hoax(admin, admin);
        project.endProject();

        assertEq(USDC.balanceOf(alice), 5e6);
        assertEq(USDC.balanceOf(bob), 5e6);
    }
}
