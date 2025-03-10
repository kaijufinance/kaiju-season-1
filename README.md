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
| Kaiju Kado Soul Bound Token (Upgradable) | [0x3256e19f4568ea10ac76f348364931d1c988342b](https://sepolia.etherscan.io/address/0x3256e19f4568ea10ac76f348364931d1c988342b#code)     | Sepolia       | 
| Kaiju Kado Soul Bound Token Proxy | [0x2871cf297eee43b8c11bb0e2f6025d99c5f51606](https://sepolia.etherscan.io/address/0x2871cf297eee43b8c11bb0e2f6025d99c5f51606#code)     | Sepolia       | 
| Kaiju USDC Token Vault Proxy |  [0x3d8c0c0b653291cf3dd476d2e46611b9fb42b688](https://sepolia.etherscan.io/address/0x3d8c0c0b653291cf3dd476d2e46611b9fb42b688#code)    | Sepolia       | 
| Kaiju USDC Token Vault (Upgradable) | [0xf7c169e64094c468b96a549c7fd1d9a5468b120a](https://sepolia.etherscan.io/address/0xf7c169e64094c468b96a549c7fd1d9a5468b120a#code)     | Sepolia       | 
| Kaiju USDT Token Vault Proxy |  [0x2407abca3276571103f3e06a128a1085c4ed389e](https://sepolia.etherscan.io/address/0x2407abca3276571103f3e06a128a1085c4ed389e#code)    | Sepolia       | 
| Kaiju USDT Token Vault (Upgradable) | [0xe5d4344890eb4331bfba6f5c727d21c6da5ddcb7](https://sepolia.etherscan.io/address/0xe5d4344890eb4331bfba6f5c727d21c6da5ddcb7#code)     | Sepolia       | 
| Kaiju WETH Token Vault Proxy | [](https://sepolia.etherscan.io/address/#code)     | Sepolia       | 
| Kaiju WETH Token Vault (Upgradable) | [](https://sepolia.etherscan.io/address/#code)     | Sepolia       | 

### Test Deploy/Setup Steps :construction_worker:

Step 1. TBC.

[USDC Faucet](https://app.aave.com/faucet/)

#### Configuration Contracts

| Contract      | Address       | Network       |
| ------------- | ------------- | ------------- |
| AAVE Pool Proxy |  [0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951](https://sepolia.etherscan.io/address/0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951#readProxyContract)   | Sepolia       | 
| USDC (ERC20) | [0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8](https://sepolia.etherscan.io/address/0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8)   | Sepolia       | 
| aUSDC (ERC20) | [0x16da4541ad1807f4443d92d26044c1147406eb80](https://sepolia.etherscan.io/token/0x16da4541ad1807f4443d92d26044c1147406eb80#readProxyContract)   | Sepolia       | 
| DAI (ERC20) |  [0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357](https://sepolia.etherscan.io/address/0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357)  | Sepolia       | 
| aDAI (ERC20) | [](https://sepolia.etherscan.io/token/#readProxyContract)   | Sepolia       | 
| LINK (ERC20) |  [0xf8Fb3713D459D7C1018BD0A49D19b4C44290EBE5](https://sepolia.etherscan.io/address/0xf8Fb3713D459D7C1018BD0A49D19b4C44290EBE5)  | Sepolia       |
| aLink (ERC20) | [](https://sepolia.etherscan.io/token/#readProxyContract)   | Sepolia       | 
| USDT (ERC20) |  [0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8](https://sepolia.etherscan.io/address/0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8)  | Sepolia       | 
| aUSDT (ERC20) | [](https://sepolia.etherscan.io/token/#readProxyContract)   | Sepolia       | 
| WBTC (ERC20) |  [0x29f2D40B0605204364af54EC677bD022dA425d03](https://sepolia.etherscan.io/address/0x29f2D40B0605204364af54EC677bD022dA425d03)  | Sepolia       | 
| aWBTC (ERC20) | [](https://sepolia.etherscan.io/token/#readProxyContract)   | Sepolia       | 
| WETH (ERC20) |  [0xC558DBdd856501FCd9aaF1E62eae57A9F0629a3c](https://sepolia.etherscan.io/address/0xC558DBdd856501FCd9aaF1E62eae57A9F0629a3c)  | Sepolia       |
| aWETH (ERC20) | [0x5b071b590a59395fE4025A0Ccc1FcC931AAc1830](https://sepolia.etherscan.io/token/0x5b071b590a59395fE4025A0Ccc1FcC931AAc1830#readProxyContract)   | Sepolia       | 
| AWUSDT (ERC20) |   [0xaA8E23Fb1079EA71e0a56F48a2aA51851D8433D0](https://sepolia.etherscan.io/address/0xaA8E23Fb1079EA71e0a56F48a2aA51851D8433D0) | Sepolia       |
| aLink (ERC20) | [](https://sepolia.etherscan.io/token/#readProxyContract)   | Sepolia       | 
| AAVE (ERC20) |  [0x88541670E55cC00bEEFD87eB59EDd1b7C511AC9a](https://sepolia.etherscan.io/address/0x88541670E55cC00bEEFD87eB59EDd1b7C511AC9a)  | Sepolia       |
| aAAVE (ERC20) | [](https://sepolia.etherscan.io/token/#readProxyContract)   | Sepolia       | 
| EURS (ERC20) |  [0x6d906e526a4e2Ca02097BA9d0caA3c382F52278E](https://sepolia.etherscan.io/address/0x6d906e526a4e2Ca02097BA9d0caA3c382F52278E)  | Sepolia       | 
| aEURS (ERC20) | [](https://sepolia.etherscan.io/token/#readProxyContract)   | Sepolia       | 
| GHO (ERC20) |  [0xc4bF5CbDaBE595361438F8c6a187bDc330539c60](https://sepolia.etherscan.io/address/0xc4bF5CbDaBE595361438F8c6a187bDc330539c60)  | Sepolia       | 
| aGHO (ERC20) | [](https://sepolia.etherscan.io/token/#readProxyContract)   | Sepolia       | 

Note: Calling the AAVE Pool, we can get all the supported reserve addresses (getReservesList). 

### Notes :clipboard:

TBC.
