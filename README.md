# Degen Token

The **Degen Token** smart contract is an ERC20 token built on the Ethereum blockchain. It leverages OpenZeppelin's ERC20 implementation and introduces additional functionalities like minting, burning, and token redemption for specific in-game items. This contract also manages in-game items, allowing players to purchase and redeem items using Degen Tokens.

## Getting Started

To get started with the Degen Token smart contract, initialize a new project using `npm init` and set up the required dependencies.

### Prerequisites

To interact with the Degen Token smart contract, ensure you have the following:

- A MetaMask wallet with some AVAX tokens (for gas fees) on the Avalanche Fuji Testnet.

### Deployment

1. Deploy the Degen Token smart contract on the Avalanche Fuji Testnet using the Hardhat framework.
2. After deployment, the smart contract will create an instance of the Degen Token with the symbol "DGN".

## Functions

The Degen Token smart contract provides the following functions:

### Owner Functions

- **`mint(address to, uint256 amount)`**: Mint new Degen tokens and assign them to the specified address. Only the contract owner can call this function.
- **`addItem(string memory name, uint256 cost)`**: Add a new in-game item with a specified name and cost. Only the owner can call this function.
- **`updateItem(uint256 itemId, string memory name, uint256 cost)`**: Update the details of an existing item. Only the owner can call this function.
- **`removeItem(uint256 itemId)`**: Remove an in-game item by marking it as unavailable. Only the owner can call this function.

### Player Functions

- **`getBalance()`**: Get the token balance of the caller's address.
- **`transferTokens(address receiver, uint256 value)`**: Transfer Degen tokens from the caller's address to the specified address.
- **`burnTokens(uint256 value)`**: Burn a specified amount of Degen tokens from the caller's balance.
- **`redeemTokens(uint256 itemId, uint256 quantity)`**: Redeem tokens for in-game items by burning the required amount of tokens.
- **`getPlayerItemQuantity(address player, uint256 itemId)`**: Retrieve the quantity of a specific item that a player owns.

### View Functions

- **`getItem(uint256 itemId)`**: Retrieve details of a specific in-game item, including name, cost, and availability.
- **`getAllItems()`**: Retrieve a list of all available items in the store.

## Configuration

The Degen Token smart contract uses the Hardhat development environment. The network configurations provided include:

- **hardhat**: Local Hardhat development network.
- **fuji**: Avalanche Fuji Testnet configuration.
- **mainnet**: Avalanche Mainnet configuration.

Ensure you set up the appropriate network and account configurations in the `hardhat.config.js` file.

## License

This project is licensed under the MIT License.

## Author

Lalit Kumar
