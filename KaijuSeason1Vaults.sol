// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import { MultiTokenBucketMiniVaultsUpgradeable } from "./UpgradableMultiTokenBucketMiniVaults.sol";

contract KaijuSeason1Vaults is Initializable, UUPSUpgradeable, MultiTokenBucketMiniVaultsUpgradeable
{
    function initialize(address aaveAddress) public initializer 
    {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        __MultiTokenBucketMiniVaultsUpgradeable_init(aaveAddress);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
