// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import { ERC721 } from "lib/solmate/src/tokens/ERC721.sol";

contract IdentityProvider is ERC721 {

    constructor() ERC721("GO-FUND-THAT", "GFT") {}

    uint public totalSupply;

    function mint() external {
        require(_balanceOf[msg.sender] == 0, "You have already minted an identity");
        
        _mint(msg.sender, totalSupply);

        unchecked {
            ++totalSupply;
        }
    }

    /*/////////////////////////////////////////////
                        SOULBOUND
    /////////////////////////////////////////////*/
    
    function transferFrom(address , address , uint256 ) public override pure {        
        revert("You cannot transfer an identity");
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return "ipfs link";
    }
}
