// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import { Script } from "forge-std/Script.sol";
import { ProjectFactory } from "src/ProjectFactory.sol";
import { IdentityProvider } from "src/IdentityProvider.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployProjectFactory is Script {
    uint256 pkey = vm.envUint("PRIVATE_KEY");    
    ProjectFactory internal factory;
    IdentityProvider internal identityProvider;
    function run() public {
        
        vm.startBroadcast(pkey);
        identityProvider = new IdentityProvider();
        factory = new ProjectFactory(identityProvider);
        vm.stopBroadcast();
    }
}
