// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import { IdentityProvider } from "./IdentityProvider.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract Project {
    using EnumerableSet for EnumerableSet.UintSet;

    EnumerableSet.UintSet private contributors;
    IdentityProvider public identityProvider;
    string public ipfs;
    IERC20 public asset;
    address public host;

    constructor(string memory _ipfs, address _host, IERC20 _asset, IdentityProvider _identityProvider) {
        ipfs = _ipfs;
        identityProvider = _identityProvider;
        asset = _asset;
        host = _host;
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
        require(contributors.add(id), "You have already entered this project");
    }

    function exit(uint256 id) onlyOwnerOfId(id) external {
        require(contributors.remove(id), "You have not entered this project");
    }

    function endProject() external {
        require(msg.sender == host, "You are not the host of this project");
        uint l = contributors.length();
        uint i = 0;
        uint amount = asset.balanceOf(address(this)) / l;
        for (i; i < l;) {
            uint id = contributors.at(i);
            asset.transfer(identityProvider.ownerOf(id), amount);
            unchecked {
                ++i;
            }
        }
        // sweep remainder to host
        asset.transfer(host, asset.balanceOf(address(this)));
    }




    function getContributors() external view returns(uint[] memory) {
        return contributors.values();
    }
}
