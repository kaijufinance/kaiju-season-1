// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import { MultiTokenVaultsUpgradable } from "./MultiTokenVaultsUpgradable.sol";

contract KaijuSeason1Vaults is Initializable, UUPSUpgradeable, UpgradableMultiTokenVaults
{
    function initialize(address aaveAddress) public initializer 
    {
        __Ownable_init(_msgSender());
        __UUPSUpgradeable_init();
        __UpgradableMultiTokenVaults_init(aaveAddress);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
