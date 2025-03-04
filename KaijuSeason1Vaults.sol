// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import { MultiTokenVaultsUpgradable } from "./MultiTokenVaultsUpgradable.sol";

contract KaijuSeason1Vaults is Initializable, UUPSUpgradeable, MultiTokenVaultsUpgradable
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    
    function initialize() public initializer 
    {
        __Ownable_init(_msgSender());
        __UUPSUpgradeable_init();
        __UpgradableMultiTokenVaults_init();
        __ReentrancyGuard_init();
        __AccessControl_init();
    }

    function _authorizeUpgrade(address newImplementation) internal override(UUPSUpgradeable, MultiTokenVaultsUpgradable) onlyOwner {}
}
