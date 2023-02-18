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
contract EnterExitTests is PRBTest, StdCheats {
    address me = 0xb9413c6FDA8Eac23E8F2cB2cc62D90881aBdD77d;
    ProjectFactory factory;
    Project project;
    IdentityProvider identityProvider;
    address alice = address(14);
    address bob = address(15);
    string RPC_URL = vm.envString("OPTIMISM");
    IERC20 USDC = IERC20(0x7F5c764cBc14f9669B88837ca1490cCa17c31607);

    constructor() public {
        // solhint-disable-previous-line no-empty-blocks
        vm.createSelectFork(RPC_URL);

        factory = new ProjectFactory();
        identityProvider = factory.identityProvider();
        hoax(alice, alice);
        identityProvider.mint();
        hoax(bob, bob);
        identityProvider.mint();
        project = Project(factory.createProject("ipfs", USDC));

    }

    function testRead() public {
        assertEq(project.ipfs(), "ipfs");
    }

    function testEnter() public  {
        // positive case
        hoax(alice, alice);
        project.enter(0);
        uint[] memory contributors = project.getContributors();
        assertEq(contributors[0], 0);
    }
    function testEnterNotOwner() public {
        // negative case - not owner
        startHoax(bob, bob);
        vm.expectRevert("You are not the owner of this identity");
        project.enter(0);
        vm.stopPrank();
    }
    function testEnteredAlready() public {
        // negative case - already entered
        testEnter();
        hoax(alice, alice);
        vm.expectRevert("You have already entered this project");
        project.enter(0);
    }

    function testEnterExit() public {
        // positive case
        testEnter();
        hoax(alice, alice);
        project.exit(0);
        uint[] memory contributors = project.getContributors();
        assertEq(contributors.length, 0);
    }

    function testExitNotOwner() public {
        // negative case - not owner
        testEnter();
        startHoax(bob, bob);
        vm.expectRevert("You are not the owner of this identity");
        project.exit(0);
        vm.stopPrank();
    }

    function testExitNotEntered() public {
        // negative case - not entered
        startHoax(bob, bob);
        vm.expectRevert("You have not entered this project");
        project.exit(1);
        vm.stopPrank();
    }

    function testEnterEnter() public {
        // positive case
        hoax(bob, bob);
        project.enter(1);
        hoax(alice, alice);
        project.enter(0);
        uint[] memory contributors = project.getContributors();
        assertEq(contributors[0], 1);
        assertEq(contributors[1], 0);
    }
}
