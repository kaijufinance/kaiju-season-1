// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC4626Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { IPool } from "@aave/core-v3/contracts/interfaces/IPool.sol";
import { DataTypes } from "@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import { IRewardsController } from "@aave/periphery-v3/contracts/rewards/interfaces/IRewardsController.sol";

contract TokenVault is Initializable, OwnableUpgradeable, ERC4626Upgradeable, ReentrancyGuardUpgradeable, UUPSUpgradeable
{
    address public _aavePoolAddress;
    address public _aaveRewardsControllerAddress;

    function initialize(
        IERC20 asset, 
        string memory name, 
        string memory symbol, 
        address aavePoolAddress,
        address aaveRewardsControllerAddress
    ) public initializer 
    {
        __ERC4626_init(asset);
        __ERC20_init(name, symbol);
        __ReentrancyGuard_init();

        _aavePoolAddress = aavePoolAddress;
        _aaveRewardsControllerAddress = aaveRewardsControllerAddress;
    }

    event AAVESupplied(address indexed user, address indexed token, uint256 amount, address tokenVaultAddress);
    event AAVEWithdrawn(address indexed user, address indexed token, uint256 amount, address tokenVaultAddress);

    function deposit(uint256 assets, address receiver) public nonReentrant override returns (uint256) {
        uint256 maxAssets = maxDeposit(receiver);
        if (assets > maxAssets) {
            revert ERC4626ExceededMaxDeposit(receiver, assets, maxAssets);
        }

        uint256 shares = previewDeposit(assets);
        _deposit(_msgSender(), receiver, assets, shares);

        IERC20(asset()).approve(_aavePoolAddress, assets);
       _supplyToPool(assets, address(this));

        return shares;
    }

    function withdraw(uint256 assets, address receiver, address owner) public nonReentrant override returns (uint256) {
        uint256 maxAssets = maxWithdraw(owner);
        if (assets > maxAssets) {
            revert ERC4626ExceededMaxWithdraw(owner, assets, maxAssets);
        }

        _withdrawFromPool(assets, receiver);

        uint256 shares = previewWithdraw(assets);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return shares;
    }

    function claimYield() public onlyOwner 
    {
        address[] memory assets = new address[](1);
        assets[0] = asset();

        IRewardsController(_aaveRewardsControllerAddress).claimRewards(
            assets,
            type(uint256).max,
            msg.sender,
            address(this)
        );
    }

    function withdrawYield(address receiver) public onlyOwner {
        uint amount = address(this).balance;
        
        (bool success, ) = payable(receiver).call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    function _withdrawFromPool(uint256 amount, address receiver) internal nonReentrant  
    {
        // Appprove IPool to burn lsts
        DataTypes.ReserveData memory reserveData = IPool(_aavePoolAddress).getReserveData(asset());
        IERC20(reserveData.aTokenAddress).approve(_aavePoolAddress, amount);

        // Withdraw to user 
        IPool(_aavePoolAddress).withdraw(asset(), amount, receiver);
        
        // Fire event
        emit AAVEWithdrawn(_msgSender(), asset(), amount, address(this));
    }  

    function _supplyToPool(uint256 amount, address tokenVaultAddress) internal nonReentrant
    {
        // Supply AAVE
        IPool(_aavePoolAddress).supply(asset(), amount, tokenVaultAddress, 0);

        // Fire event
        emit AAVESupplied(_msgSender(), asset(), amount, tokenVaultAddress);
    }

    function _authorizeUpgrade(address newImplementation) internal override(UUPSUpgradeable) onlyOwner {}
}
