
// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    // Struct to represent an in-game item with a name, cost, and availability status
    struct Item {
        string name;
        uint256 cost;
        bool available;
    }

    // Mapping to store items with a unique item ID as the key
    mapping(uint256 => Item) public items;

    // Mapping to track how many of each item a player owns
    mapping(address => mapping(uint256 => uint256)) public playerItems;

    // Counter to keep track of the next item ID, ensuring unique IDs
    uint256 public nextItemId;

    // Events to log actions related to items, such as adding, updating, removing, and redeeming
    event ItemAdded(uint256 itemId, string name, uint256 cost);
    event ItemUpdated(uint256 itemId, string name, uint256 cost);
    event ItemRemoved(uint256 itemId);
    event ItemRedeemed(address indexed player, uint256 itemId, uint256 cost, uint256 quantity);

    // Constructor to initialize the token with a name and symbol, and set the initial owner
    constructor(address initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner) {
        // Start item IDs from 1 to avoid using 0 as a valid ID
        nextItemId = 1;
    }

    // Function that allows the owner to mint new tokens and assign them to a specified address
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Override function to set token decimals to 0, ensuring no fractional tokens
    function decimals() public pure override returns (uint8) {
        return 0;
    }

    // Function to retrieve the balance of the caller's account
    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    // Function to allow players to transfer their tokens to another address
    function transferTokens(address receiver, uint256 value) external {
        require(balanceOf(msg.sender) >= value, "Insufficient Degen Tokens");
        transfer(receiver, value);
    }

    // Function to enable token burning by any player, reducing their balance by the specified amount
    function burnTokens(uint256 value) external {
        require(balanceOf(msg.sender) >= value, "Insufficient Degen Tokens");
        burn(value);
    }

    // Function for the owner to add new items to the in-game store with a specified name and cost
    function addItem(string memory name, uint256 cost) public onlyOwner {
        items[nextItemId] = Item(name, cost, true);
        emit ItemAdded(nextItemId, name, cost);
        nextItemId++;
    }

    // Function for the owner to update the details of an existing item, such as name and cost
    function updateItem(uint256 itemId, string memory name, uint256 cost) public onlyOwner {
        require(items[itemId].available, "Item does not exist");
        items[itemId] = Item(name, cost, true);
        emit ItemUpdated(itemId, name, cost);
    }

    // Function for the owner to remove an item from the store, marking it as unavailable
    function removeItem(uint256 itemId) public onlyOwner {
        require(items[itemId].available, "Item does not exist");
        items[itemId].available = false;
        emit ItemRemoved(itemId);
    }

    // Function for players to redeem tokens for items in the store by burning the required amount
    function redeemTokens(uint256 itemId, uint256 quantity) external {
        require(items[itemId].available, "Item is not available");
        uint256 totalCost = items[itemId].cost * quantity;
        require(balanceOf(msg.sender) >= totalCost, "Insufficient Degen Tokens");
        burn(totalCost);
        playerItems[msg.sender][itemId] += quantity;
        emit ItemRedeemed(msg.sender, itemId, totalCost, quantity);
    }

    // Function to retrieve the details of a specific item by its ID, including name, cost, and availability
    function getItem(uint256 itemId) external view returns (string memory name, uint256 cost, bool available) {
        require(items[itemId].available, "Item does not exist");
        Item memory item = items[itemId];
        return (item.name, item.cost, item.available);
    }

    // Function to retrieve all available items in the store, filtering out unavailable ones
    function getAllItems() external view returns (Item[] memory) {
        uint256 itemCount = 0;
        for (uint256 i = 1; i < nextItemId; i++) {
            if (items[i].available) {
                itemCount++;
            }
        }

        Item[] memory availableItems = new Item[](itemCount);
        uint256 index = 0;
        for (uint256 i = 1; i < nextItemId; i++) {
            if (items[i].available) {
                availableItems[index] = items[i];
                index++;
            }
        }

        return availableItems;
    }

    // Function to retrieve the quantity of a specific item that a player owns
    function getPlayerItemQuantity(address player, uint256 itemId) external view returns (uint256) {
        return playerItems[player][itemId];
    }
}
