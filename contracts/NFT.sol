// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "./StructDeclaration.sol";

contract RoleNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, AccessControlEnumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => Identity) public idOfIdentity;
    mapping(address => uint256) public tokenIdOf;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _tokenIds.increment();
        _setupRole(
            DEFAULT_ADMIN_ROLE,
            0xc7f2fBc85f84AD8dc8D11b06167C98763C02D5CA
        );
    }
        function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function isAdmin(address account) external view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, account);
    }

    modifier onlyAdmin() {
        require(this.isAdmin(msg.sender), "Restricted to members.");
        _;
    }

    function addAdmin(address account) public virtual onlyAdmin {
        grantRole(DEFAULT_ADMIN_ROLE, account);
    }

    function renounceAdminRole() public virtual {
        renounceRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(
        address to,
        string memory _tokenURI,
        string memory _department,
        string memory _role
    ) public onlyAdmin {
        uint256 existTokenID = tokenIdOf[to];
        if (existTokenID > 0) {
            _setTokenURI(existTokenID, _tokenURI);
            idOfIdentity[existTokenID] = Identity(_department, _role);
            return;
        }
        _safeMint(to, _tokenIds.current());
        _setTokenURI(_tokenIds.current(), _tokenURI);
        idOfIdentity[_tokenIds.current()] = Identity(_department, _role);
        tokenIdOf[to] = _tokenIds.current();
        _tokenIds.increment();
    }

    function updateIdentity(
        address _address,
        string memory _department,
        string memory _role
    ) public onlyAdmin {
        uint256 _tokenId = tokenIdOf[_address];
        require(_tokenId != 0, "Token id is not exist");
        idOfIdentity[_tokenId] = Identity(_department, _role);
    }

    function getIdentity(
        address _address
    ) external view returns (Identity memory) {
        uint256 _tokenId = tokenIdOf[_address];
        require(_tokenId != 0, "No token for the address");
        return idOfIdentity[_tokenId];
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function burnToken(uint256 tokenId) external onlyAdmin {
        address owner = ownerOf(tokenId);
        delete tokenIdOf[owner];
        delete idOfIdentity[tokenId];
        _burn(tokenId);
    }

    function updateTokenURI(
        uint256 tokenId,
        string memory uri
    ) public onlyAdmin {
        _setTokenURI(tokenId, uri);
    }

    function getTotalTokenCount() external view returns (uint256) {
        return _tokenIds.current() - 1;
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        require(from == address(0), "You can't transfer this NFT.");

        super._transfer(from, to, tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable, AccessControlEnumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
