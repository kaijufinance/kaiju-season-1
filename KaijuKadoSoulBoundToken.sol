// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import { IKaijuKadoSoulBoundToken } from "./interfaces/IKaijuKadoSoulBoundToken.sol";

contract KaijuKadoSoulBoundToken is 
    IKaijuKadoSoulBoundToken, 
    Initializable, 
    ERC721Upgradeable, 
    ERC721URIStorageUpgradeable,
    AccessControlUpgradeable,
    UUPSUpgradeable 
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter private _tokenIdCounter;
    string private _baseTokenURI;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() 
    {
        _disableInitializers();
    }

    function initialize() public initializer 
    {
        __ERC721_init("KaijuKadoSoulBoundToken", "KKSBT");
        __ERC721URIStorage_init();
        __UUPSUpgradeable_init();
        __AccessControl_init();

        _baseTokenURI = "https://ipfs.io/ipfs/";

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(URI_SETTER_ROLE, msg.sender);
    }

    function setBaseURI(string memory baseURI) 
        external 
        onlyRole(URI_SETTER_ROLE)
    {
        _baseTokenURI = baseURI;
    }

    function mint(address to) 
        public 
        onlyRole(MINTER_ROLE)
    {
        require(balanceOf(to) == 0, 'User already owns a soulbound token');
         
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, 'QmbRvCwZKuJTVAXpHm4gsSBjCouzk9CPx4NSmn5X7qMuwy');
    }

    function tokenURI(uint256 tokenId) 
        public 
        view 
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable) 
        returns (string memory) 
    {
        return ERC721URIStorageUpgradeable.tokenURI(tokenId);
    }

    function _baseURI() 
        internal 
        view 
        override 
        returns (string memory) 
    {
        return _baseTokenURI;
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override
        returns (address)
    {
        address from = _ownerOf(tokenId);
        require(from == address(0) || to == address(0), "This a Soulbound token. It cannot be transferred. It can only be burned by the token owner.");
        return super._update(to, tokenId, auth);
    }

    function _authorizeUpgrade(address newImplementation) 
        internal 
        override 
        onlyRole(DEFAULT_ADMIN_ROLE) 
    {}

    function supportsInterface(bytes4 interfaceId) 
        public 
        view 
        override(
            ERC721Upgradeable, 
            ERC721URIStorageUpgradeable,
            AccessControlUpgradeable
        ) 
        returns (bool) 
    {
        return ERC721Upgradeable.supportsInterface(interfaceId) ||
               ERC721URIStorageUpgradeable.supportsInterface(interfaceId) ||
               AccessControlUpgradeable.supportsInterface(interfaceId);
    }
}
