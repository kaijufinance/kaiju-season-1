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

### Test Deploy/Setup Steps :construction_worker:

#### Configuration Contracts

| Contract      | Address       | Network       |
| ------------- | ------------- | ------------- |
| AAVE Pool Proxy |  [0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951)](https://sepolia.etherscan.io/address/0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951#readProxyContract)   | Sepolia       | 
| USDC | [0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8](https://sepolia.etherscan.io/address/0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8)   | Sepolia       | 

Calling the AAVE Pool, we can get all the supported reserve addresses (getReservesList). 

### Notes :clipboard:

TBC.
