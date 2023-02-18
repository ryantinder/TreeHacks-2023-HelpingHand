// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import { Project } from "./Project.sol";
import { IdentityProvider} from "./IdentityProvider.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract ProjectFactory {

    event ProjectCreated(address projectAddress);

    IdentityProvider public identityProvider;

    constructor() {
        identityProvider = new IdentityProvider();
    }

    function createProject(string memory ipfs, IERC20 asset) external returns (address project) {
        require(msg.sender.code.length == 0, "!EOA");
        project = address(new Project(ipfs, msg.sender, asset, identityProvider));
        emit ProjectCreated(project);
    }
}
