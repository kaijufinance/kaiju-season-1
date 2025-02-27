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
import { IAAVE } from "./interfaces/IAAVE.sol";

contract TokenVault is Initializable, OwnableUpgradeable, ERC4626Upgradeable, ReentrancyGuardUpgradeable 
{
    function initialize(IERC20 asset) public initializer {
        __ERC4626_init(asset);
        __ERC20_init("Test Vault Token", "TSTvTKN");
        __ReentrancyGuard_init();
    }

    event AAVESupplied(address indexed user, address indexed token, uint256 amount, address tokenVaultAddress);
    event AAVEWithdrawn(address indexed user, address indexed token, uint256 amount, address tokenVaultAddress);

    function deposit(uint256 assets, address receiver) public override returns (uint256) {
        uint256 maxAssets = maxDeposit(receiver);
        if (assets > maxAssets) {
            revert ERC4626ExceededMaxDeposit(receiver, assets, maxAssets);
        }

        uint256 shares = previewDeposit(assets);
        _deposit(_msgSender(), receiver, assets, shares);

       _supplyToPool(asset(), assets, address(this));

        return shares;
    }

    function withdraw(uint256 assets, address receiver, address owner) public override returns (uint256) {
        uint256 maxAssets = maxWithdraw(owner);
        if (assets > maxAssets) {
            revert ERC4626ExceededMaxWithdraw(owner, assets, maxAssets);
        }

        _withdrawFromPool(asset(), assets, receiver);

        uint256 shares = previewWithdraw(assets);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return shares;
    }

    function claimYield() public onlyOwner 
    {
        IAAVE(asset()).claimRewards(address(this), type(uint256).max);
    }

    function withdrawYield(address receiver) public onlyOwner {
        uint amount = address(this).balance;
        
        (bool success, ) = payable(receiver).call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    function _withdrawFromPool(address token, uint256 amount, address tokenVaultAddress) internal 
    {
        // Withdraw to user 
        IAAVE(asset()).withdraw(token, amount, _msgSender());

        // Fire event
        emit AAVEWithdrawn(_msgSender(), token, amount, tokenVaultAddress);
    }  

    function _supplyToPool(address token, uint256 amount, address tokenVaultAddress) internal 
    {
        // Supply AAVE
        IAAVE(asset()).supply(token, amount, tokenVaultAddress, 0);

        // Fire event
        emit AAVESupplied(_msgSender(), token, amount, tokenVaultAddress);
    }
}
