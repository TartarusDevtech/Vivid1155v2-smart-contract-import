// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./StructDeclaration.sol";
interface IRoleNFT is IERC721 {
    function getIdentity(address _address) external view returns (Identity memory);
    function isAdmin(address account) external view  returns (bool);
}
