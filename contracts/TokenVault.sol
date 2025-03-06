// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC4626Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import { IPool } from "@aave/core-v3/contracts/interfaces/IPool.sol";
import { DataTypes } from "@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";
import { IKaijuKadoSoulBoundToken } from "./interfaces/IKaijuKadoSoulBoundToken.sol";

contract TokenVault is Initializable, OwnableUpgradeable, ERC4626Upgradeable, ReentrancyGuardUpgradeable, UUPSUpgradeable
{
    using Math for uint256;

    address private _aavePoolAddress;
    address private _kaijuSoulboundTokenAddress;
    uint256 private _giftThreshold;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        IERC20 asset, 
        string memory name, 
        string memory symbol, 
        address aavePoolAddress,
        address kaijuSoulboundTokenAddress,
        uint256 giftThreshold
    ) public initializer 
    {
        __ERC4626_init(asset);
        __ERC20_init(name, symbol);
        __ReentrancyGuard_init();
        __Ownable_init(_msgSender());
        __UUPSUpgradeable_init();

        _aavePoolAddress = aavePoolAddress;
        _kaijuSoulboundTokenAddress = kaijuSoulboundTokenAddress;
        _giftThreshold = giftThreshold;
    }

    event AAVESupplied(address indexed user, address indexed token, uint256 amount, address tokenVaultAddress);
    event AAVEWithdrawn(address indexed user, address indexed token, uint256 amount, address tokenVaultAddress);

    function deposit(uint256 assets, address receiver) public nonReentrant override returns (uint256) 
    {
        uint256 maxAssets = maxDeposit(receiver);
        if (assets > maxAssets) 
        {
            revert ERC4626ExceededMaxDeposit(receiver, assets, maxAssets);
        }

        uint256 shares = previewDeposit(assets);
        _deposit(
            _msgSender(), 
            receiver, 
            assets, 
            shares
        );

        _supplyToPool(assets);

        _giftSoulBoundToken(assets, receiver);   

        return shares;
    }

    function withdraw(uint256 assets, address receiver, address owner) public nonReentrant override returns (uint256) 
    {
        uint256 maxAssets = maxWithdraw(owner);
        if (assets > maxAssets) {
            revert ERC4626ExceededMaxWithdraw(owner, assets, maxAssets);
        }

        _withdrawFromPool(assets);

        uint256 shares = previewWithdraw(assets);
        _withdraw(
            _msgSender(), 
            receiver, 
            owner, 
            assets, 
            shares
        );

        return shares;
    }

    function withdrawTokenYield(address receiver, uint256 amount) public onlyOwner 
    {
        DataTypes.ReserveData memory reserveData = IPool(_aavePoolAddress).getReserveData(asset());

        uint256 vaultATokenBalance = IERC20(reserveData.aTokenAddress).balanceOf(address(this));

        // Check to ensure we can only take yield from the contract and NOT users supply
        require(vaultATokenBalance > totalSupply(), 'Nothing to withdraw');
        require((vaultATokenBalance - totalSupply()) <= amount, 'Amount is larger than can be withdrawn');
 
        _withdrawFromPool(amount);

        IERC20(reserveData.aTokenAddress).transfer(receiver, amount);
    }

    function withdrawNativeCoin(address receiver, uint256 amount) public onlyOwner 
    {
        payable(receiver).transfer(amount);
    }

    function _withdrawFromPool(uint256 amount) internal  
    {
        DataTypes.ReserveData memory reserveData = IPool(_aavePoolAddress).getReserveData(asset());

        uint256 aTokenBalance = IERC20(reserveData.aTokenAddress).balanceOf(address(this));
        require(aTokenBalance >= amount, "Insufficient aToken balance");

        // Appprove IPool to burn lsts
        IERC20(reserveData.aTokenAddress).approve(_aavePoolAddress, amount);

        // Withdraw to user 
        IPool(_aavePoolAddress).withdraw(
            asset(), 
            amount, 
            address(this)
        );
        
        // Fire event
        emit AAVEWithdrawn(_msgSender(), asset(), amount, address(this));
    }  

    function totalAssets() public view override returns (uint256) 
    {
        return totalSupply(); 
    }

    function _supplyToPool(uint256 amount) internal
    {
        // Supply AAVE
        IERC20(asset()).approve(_aavePoolAddress, amount);
        IPool(_aavePoolAddress).supply(
            asset(), 
            amount, 
            address(this),
            0
        );

        // Fire event
        emit AAVESupplied(_msgSender(), asset(), amount, address(this));
    }

    function _giftSoulBoundToken(uint256 assetsDeposited, address receiver) internal
    {
        // Get receiver balance
        uint256 recieverBalance = IERC721Upgradeable(_kaijuSoulboundTokenAddress).balanceOf(receiver);

        // Check receiver doesnt already have one and the amount deposited is greater than the threshold
        if (recieverBalance <= 0 && assetsDeposited >= _giftThreshold) 
        {
            // Mint the receiver a soul bound token
            IKaijuKadoSoulBoundToken(_kaijuSoulboundTokenAddress).mint(receiver);
        }
    }

    function _convertToShares(uint256 assets, Math.Rounding) internal pure override returns (uint256) 
    {
        return assets; 
    }

    function _convertToAssets(uint256 shares, Math.Rounding) internal pure override returns (uint256) 
    {
        return shares; 
    }

    function _authorizeUpgrade(address newImplementation) internal override(UUPSUpgradeable) onlyOwner 
    {}

    receive() external payable 
    {}
}