// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import { IdentityProvider } from "./IdentityProvider.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract Project {
    using EnumerableSet for EnumerableSet.UintSet;

    EnumerableSet.UintSet private contributors;
    IdentityProvider public identityProvider;
    string public ipfs;

    constructor(string memory _ipfs, IdentityProvider _identityProvider) {
        ipfs = _ipfs;
        identityProvider = _identityProvider;
    }

    modifier onlyOwnerOfId(uint256 id) {
        require(identityProvider.ownerOf(id) == msg.sender, "You are not the owner of this identity");
        _;
    }

    /**
     * 
     * @param id Identity to enter
     */
    function enter(uint256 id) onlyOwnerOfId(id) external {
        require(!contributors.add(id), "You have already entered this project");
    }

    function exit(uint256 id) onlyOwnerOfId(id) external {
        require(contributors.add(id), "You have not entered this project");
    }

    function getContributors() external view returns(uint[] memory) {
        return contributors.values();
    }
}
