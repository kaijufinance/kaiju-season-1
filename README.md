<p align="left">
  <img width="80" height="80" src="https://github.com/user-attachments/assets/d800ec9e-fa93-4ef8-95c7-7b95775fd67e">
</p>

# Kaiju Season 1 

A set of staking contracts for Kaiju season 1. 

## Contracts :page_facing_up:

### Multi Asset Vaults

A contract that allows users to add funds to a set of vaults which can be used in conjunction with Kaiju season 1. A vault must be deployed then added to this dapp.

On deposit of an asset:
- Users must approve the spend of the vault contract (spend being deposit amount)
- We take the funds approved and send to the respective supported vault
- We send the funds to AAVE for staking
- AAVE will transfer LST to the vault
- We transfer a vault ERC20 (share) to represent the users stake with us

On withdraw of an asset:
- Users must approve the spend of the share from the vault contract (spend being withdraw amount)
- We burn the share/s
- We approve the spend of LST from the vault to AAVE
- We remove the funds from AAVE (being staked)
- We send the withdrawn funds from the respective supported vault to the reciever

### Vault 

Description TBC.

## Test Dapps :construction:

Deployers Address: [0x61E8CDFe71851717e5D3382F61Cd70f7B8Dc6039](https://sepolia.etherscan.io/address/0x61E8CDFe71851717e5D3382F61Cd70f7B8Dc6039)

| Contract      | Address       | Network       |
| ------------- | ------------- | ------------- |
| Kaiju Vaults Proxy | [0xbcbd735a5b007a9356824a2dc64cbd0443d9cf89](https://sepolia.etherscan.io/address/0xbcbd735a5b007a9356824a2dc64cbd0443d9cf89#code)     | Sepolia       | 
| Kaiju Vaults (Upgradable) | [0x6F9D26A8fC01BBa5F1A28345812D578f26d1b93d](https://sepolia.etherscan.io/address/0x6F9D26A8fC01BBa5F1A28345812D578f26d1b93d#code)     | Sepolia       | 
| Kaiju USDC Vault Proxy | [](https://sepolia.etherscan.io/address/#code)     | Sepolia       | 
| Kaiju USDC Vault (Upgradable) | [](https://sepolia.etherscan.io/address/#code)     | Sepolia       | 
| Kaiju WETH Vault Proxy | [](https://sepolia.etherscan.io/address/#code)     | Sepolia       | 
| Kaiju WETH Vault (Upgradable) | [](https://sepolia.etherscan.io/address/#code)     | Sepolia       | 

### Test Deploy/Setup Steps :construction_worker:

Step 1. TBC.

#### Configuration Contracts

| Contract      | Address       | Network       |
| ------------- | ------------- | ------------- |
| AAVE Pool Proxy |  [0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951)](https://sepolia.etherscan.io/address/0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951#readProxyContract)   | Sepolia       | 
| USDC (ERC20) | [0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8](https://sepolia.etherscan.io/address/0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8)   | Sepolia       | 
| DAI (ERC20) |  [0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357](https://sepolia.etherscan.io/address/0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357)  | Sepolia       | 
| LINK (ERC20) |  [0xf8Fb3713D459D7C1018BD0A49D19b4C44290EBE5](https://sepolia.etherscan.io/address/0xf8Fb3713D459D7C1018BD0A49D19b4C44290EBE5)  | Sepolia       | 
| USDT (ERC20) |  [0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8](https://sepolia.etherscan.io/address/0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8)  | Sepolia       | 
| WBTC (ERC20) |  [0x29f2D40B0605204364af54EC677bD022dA425d03](https://sepolia.etherscan.io/address/0x29f2D40B0605204364af54EC677bD022dA425d03)  | Sepolia       | 
| WETH (ERC20) |  [0xC558DBdd856501FCd9aaF1E62eae57A9F0629a3c](https://sepolia.etherscan.io/address/0xC558DBdd856501FCd9aaF1E62eae57A9F0629a3c)  | Sepolia       | 
| USDT (ERC20) |   [0xaA8E23Fb1079EA71e0a56F48a2aA51851D8433D0](https://sepolia.etherscan.io/address/0xaA8E23Fb1079EA71e0a56F48a2aA51851D8433D0) | Sepolia       | 
| AAVE (ERC20) |  [0x88541670E55cC00bEEFD87eB59EDd1b7C511AC9a](https://sepolia.etherscan.io/address/0x88541670E55cC00bEEFD87eB59EDd1b7C511AC9a)  | Sepolia       | 
| EURS (ERC20) |  [0x6d906e526a4e2Ca02097BA9d0caA3c382F52278E](https://sepolia.etherscan.io/address/0x6d906e526a4e2Ca02097BA9d0caA3c382F52278E)  | Sepolia       | 
| GHO (ERC20) |  [0xc4bF5CbDaBE595361438F8c6a187bDc330539c60](https://sepolia.etherscan.io/address/0xc4bF5CbDaBE595361438F8c6a187bDc330539c60)  | Sepolia       | 

Note: Calling the AAVE Pool, we can get all the supported reserve addresses (getReservesList). 

### Notes :clipboard:

TBC.
