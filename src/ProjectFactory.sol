// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import { Project } from "./Project.sol";
import { IdentityProvider} from "./IdentityProvider.sol";

contract ProjectFactory {

    event ProjectCreated(address projectAddress);

    IdentityProvider public identityProvider;

    constructor() {
        identityProvider = new IdentityProvider();
    }

    function createProject(string memory ipfs) external returns (address) {
        address newProject = address(new Project(ipfs, identityProvider));
        emit ProjectCreated(newProject);
    }
}
