// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { IAAVE } from "./interfaces/IAAVE.sol";
import { TokenVault } from "./TokenVault.sol";

abstract contract MultiTokenVaultsUpgradable is Initializable, AccessControlUpgradeable, ReentrancyGuardUpgradeable, OwnableUpgradeable, UUPSUpgradeable 
{
    /// @custom:storage-location erc7201:openzeppelin.storage.ERC4626
    struct UpgradableMultiTokenVaultsUpgradeableStorage 
    {
        mapping(address => TokenVault) vaults;
        address aaveAddress;
    }

    // keccak256(abi.encode(uint256(keccak256("kaijufinance.storage.UpgradableMultiTokenVaultsUpgradeable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant UpgradableMultiTokenVaultsUpgradeableStorageLocation = 0x2ca894d92e142fff7d00380311aa1e74c80eae52fdc58bc3f307e90a6ec91600;

    event VaultCreated(address indexed token, address vault);
    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdrawal(address indexed user, address indexed token, uint256 amount);

    function _getUpgradableMultiTokenVaultsUpgradeableStorage() private pure returns (UpgradableMultiTokenVaultsUpgradeableStorage storage $) {
        assembly {
            $.slot := UpgradableMultiTokenVaultsUpgradeableStorageLocation
        }
    }

    function __UpgradableMultiTokenVaults_init() internal onlyInitializing 
    {
        __UpgradableMultiTokenVaults_init_unchained();
    }

    function __UpgradableMultiTokenVaults_init_unchained() internal onlyInitializing 
    { 
    }

    /*function createVault(address token) onlyOwner external 
    {
        UpgradableMultiTokenVaultsUpgradeableStorage storage $ = _getUpgradableMultiTokenVaultsUpgradeableStorage();

        //require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Must have vault manager role to create vault");
        require(address($.vaults[token]) == address(0), "Vault already exists");

        TokenVault newVault = new TokenVault();
        newVault.initialize(IERC20(token), $.aaveAddress);
        $.vaults[token] = newVault;

        emit VaultCreated(token, address(newVault));  
    }*/

    function createVault(address token, address vault) onlyOwner external 
    {
        UpgradableMultiTokenVaultsUpgradeableStorage storage $ = _getUpgradableMultiTokenVaultsUpgradeableStorage();

        //require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Must have vault manager role to create vault");
        require(address($.vaults[token]) == address(0), "Vault already exists");

        $.vaults[token] = TokenVault(vault);

        emit VaultCreated(token, address(vault));  
    }

    function deposit(address token, uint256 amount) external nonReentrant 
    {
        UpgradableMultiTokenVaultsUpgradeableStorage storage $ = _getUpgradableMultiTokenVaultsUpgradeableStorage();

        TokenVault vault = $.vaults[token];
        require(address(vault) != address(0), "Vault does not exist");
        
        IERC20(token).transferFrom(_msgSender(), address(this), amount);
        IERC20(token).approve(address(vault), amount);
        vault.deposit(amount, _msgSender());

        emit Deposit(_msgSender(), token, amount);
    }

    function withdraw(address token, address receiver, uint256 shares) external nonReentrant
    {
        UpgradableMultiTokenVaultsUpgradeableStorage storage $ = _getUpgradableMultiTokenVaultsUpgradeableStorage();

        require(address($.vaults[token]) != address(0), "Vault does not exist");

        uint256 amount = $.vaults[token].convertToAssets(shares);
        $.vaults[token].withdraw(amount, receiver, _msgSender());

        emit Withdrawal(_msgSender(), token, amount);
    }

    function claimRewards(address token, address receiver) onlyOwner external
    {
        UpgradableMultiTokenVaultsUpgradeableStorage storage $ = _getUpgradableMultiTokenVaultsUpgradeableStorage();

        TokenVault vault = $.vaults[token];

        vault.claimYield();
        vault.withdrawYield(receiver);
    }

    function addRole(bytes32 role, address account) public onlyOwner {
        require(role != DEFAULT_ADMIN_ROLE, "Cannot add DEFAULT_ADMIN_ROLE");
        grantRole(role, account);
    }

    function removeRole(bytes32 role, address account) public onlyOwner {
        require(role != DEFAULT_ADMIN_ROLE, "Cannot remove DEFAULT_ADMIN_ROLE");
        revokeRole(role, account);
    }
 
    function _authorizeUpgrade(address newImplementation) internal virtual override onlyOwner {}

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
