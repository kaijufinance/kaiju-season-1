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
import { TokenVaultUpgradeable } from "./TokenVaultUpgradeable.sol";

contract MultiTokenBucketMiniVaultsUpgradeable is Initializable, AccessControlUpgradeable, OwnableUpgradeable//, UUPSUpgradeable 
{
    enum BucketType { STORE, AAVE }

    /// @custom:storage-location erc7201:openzeppelin.storage.ERC4626
    struct MultiTokenBucketMiniVaultsUpgradeableStorage 
    {
        mapping(address => TokenVaultUpgradeable) vaults;
        address aaveAddress;
    }

    // keccak256(abi.encode(uint256(keccak256("kaijufinance.storage.MultiTokenBucketMiniVaultsUpgradeable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant MultiTokenBucketMiniVaultsUpgradeableStorageLocation = 0x2ca894d92e142fff7d00380311aa1e74c80eae52fdc58bc3f307e90a6ec91600;

    event VaultCreated(address indexed token, address vault);
    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdrawal(address indexed user, address indexed token, uint256 amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function _getMultiTokenBucketMiniVaultsUpgradeableStorage() private pure returns (MultiTokenBucketMiniVaultsUpgradeableStorage storage $) {
        assembly {
            $.slot := MultiTokenBucketMiniVaultsUpgradeableStorageLocation
        }
    }

    function __MultiTokenBucketMiniVaultsUpgradeable_init(address aaveAddress) internal onlyInitializing 
    {
        __MultiTokenBucketMiniVaultsUpgradeable_init_unchained(aaveAddress);
    }

    function __MultiTokenBucketMiniVaultsUpgradeable_init_unchained(address aaveAddress) internal onlyInitializing 
    {
        MultiTokenBucketMiniVaultsUpgradeableStorage storage $ = _getMultiTokenBucketMiniVaultsUpgradeableStorage();  
        $.aaveAddress = aaveAddress;
    }

    function createVault(address token) external 
    {
        MultiTokenBucketMiniVaultsUpgradeableStorage storage $ = _getMultiTokenBucketMiniVaultsUpgradeableStorage();

        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Must have vault manager role to burn");
        require(address($.vaults[token]) == address(0), "Vault already exists");

        TokenVaultUpgradeable newVault = new TokenVaultUpgradeable();
        newVault.initialize(IERC20(token));
        $.vaults[token] = newVault;

        emit VaultCreated(token, address(newVault));  
    }

    function deposit(address token, uint256 amount) external 
    {
        MultiTokenBucketMiniVaultsUpgradeableStorage storage $ = _getMultiTokenBucketMiniVaultsUpgradeableStorage();

        TokenVaultUpgradeable vault = $.vaults[token];
        require(address(vault) != address(0), "Vault does not exist");

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        IERC20(token).approve(address(vault), amount);
        vault.deposit(amount, msg.sender);

        emit Deposit(msg.sender, token, amount);
    }

    function withdraw(address token, address receiver, uint256 shares) external
    {
        MultiTokenBucketMiniVaultsUpgradeableStorage storage $ = _getMultiTokenBucketMiniVaultsUpgradeableStorage();

        require(address($.vaults[token]) != address(0), "Vault does not exist");

        uint256 amount = $.vaults[token].convertToAssets(shares);
        $.vaults[token].withdraw(amount, receiver, msg.sender);

        emit Withdrawal(msg.sender, token, amount);
    }

    function claimRewards(address token, address receiver) onlyOwner external
    {
        MultiTokenBucketMiniVaultsUpgradeableStorage storage $ = _getMultiTokenBucketMiniVaultsUpgradeableStorage();

        TokenVaultUpgradeable vault = $.vaults[token];

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

    //function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}