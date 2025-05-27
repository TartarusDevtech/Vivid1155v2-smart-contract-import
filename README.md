# Vivid1155v2 Smart Contract Import

## About

Vivid1155v2 Smart Contract Import is a minimal clone factory designed to deploy and manage instances of the Vivid1155v3 contract with a focus on gas optimization. The repository provides scripts and configurations for rapid smart contract deployment, primarily targeting the Polygon network but also supporting Arbitrum, Goerli, and Mumbai testnets.

This project enables developers to:
- Deploy NFT contracts (following the ERC-1155 standard) with reduced gas fees.
- Automate the deployment and verification of smart contracts, including role-based NFTs and DAO proposals.
- Easily manage private keys and network configurations using environment variables.

## Features

- **Clone Factory**: Deploy minimal proxy clones of the Vivid1155v3 contract to save on deployment costs.
- **Gas Optimized Deployment**: Scripts and configurations are tailored for gas efficiency.
- **Multi-Network Support**: Easily deploy on Polygon, Arbitrum, Goerli, and Mumbai.
- **Automated Verification**: Built-in scripts for contract verification on Etherscan and related explorers.
- **Role and Proposal Contracts**: Deploys both RoleNFT (for access control) and DAO proposal contracts.

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/TartarusDevtech/Vivid1155v2-smart-contract-import.git
   cd Vivid1155v2-smart-contract-import
   ```

2. **Install Dependencies**

   ```bash
   yarn install
   ```

3. **Set up Environment Variables**

   - Add your private key and network RPC URLs to a `.env` file as needed.

4. **Compile Contracts**

   ```bash
   npx hardhat compile
   ```

## Usage

### Deploy Contracts

To deploy contracts (example for Polygon):

```bash
npx hardhat run scripts/deploy.js --network polygon
```

- The script will deploy both RoleNFT and DAO proposal contracts.
- Make sure your environment variables are set for the chosen network.

### Approve Tokens

To approve tokens (as required by your workflow):

```bash
npx hardhat run scripts/approve.js --network polygon
```

## Scripts

- `scripts/deploy.js`: Handles the deployment of RoleNFT and DAO proposal contracts.
- `scripts/approve.js`: Automates token approval for contract interactions.

## Configuration

- `hardhat.config.js`: Configures supported networks, Solidity version, optimizer settings, and Etherscan API integration.

## License

[MIT](LICENSE)

---

> **Note**: For more detailed usage, please refer to inline comments within the scripts or raise an issue for specific questions!
