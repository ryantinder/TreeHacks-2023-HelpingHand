// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { ProjectFactory } from "src/ProjectFactory.sol";
import { Project } from "src/Project.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract FactoryTest is PRBTest, StdCheats {
    address me = 0xb9413c6FDA8Eac23E8F2cB2cc62D90881aBdD77d;
    /// @dev An optional function invoked before each test case is run
    ProjectFactory factory;
    Proj

    string RPC_URL = vm.envString("OPTIMISM");
    function setUp() public {
        // solhint-disable-previous-line no-empty-blocks
        vm.createSelectFork(RPC_URL);

        factory = new ProjectFactory();

    }
}
