// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.18;

import { ERC721 } from "lib/solmate/src/tokens/ERC721.sol";

contract IdentityProvider is ERC721 {

    constructor() ERC721("Helping Hand", "HH") {}

    mapping(address project => mapping(uint id => bytes32[])) public photos;

    uint public totalSupply;

    function mint() external {
        require(_balanceOf[msg.sender] == 0, "You have already minted an identity");
        
        _mint(msg.sender, totalSupply);

        unchecked {
            ++totalSupply;
        }
    }

    function addPhotos(address project, uint id, bytes32[] calldata  _photos) external {
        require(ownerOf(id) == msg.sender, "You are not the owner of this identity");
        uint length = _photos.length;
        uint i;
        for (i = 0; i < length;) {
            photos[project][id].push(_photos[i]);
            unchecked {
                ++i;
            }
        }
    }

    function removePhotos(address project, uint id, uint[] calldata indices) external {
        require(ownerOf(id) == msg.sender, "You are not the owner of this identity");
        uint length = indices.length;
        uint i;
        for (i = 0; i < length;) {
            uint index = indices[i];
            require(index < length, "Index out of bounds");
            delete photos[project][id][index];
            unchecked {
                ++i;
            }
        }
    }

    function getPhotos(address project, uint id) external view returns(bytes32[] memory) {
        return photos[project][id];
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
