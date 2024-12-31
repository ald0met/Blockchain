// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KotET {
    address payable public king; // Change to address payable
    uint public claimPrice = 100 ether; // Use ether for clarity
    address payable owner;

    constructor() {
        owner = payable(msg.sender);
        king = payable(msg.sender); // Initialize king as payable
    }

    function sweepCommission(uint amount) public {
        require(msg.sender == owner, "Only the owner can sweep commissions");
        require(amount <= address(this).balance, "Insufficient balance");
        owner.transfer(amount);
    }

    // Fallback function to accept Ether
    receive() external payable {
        require(msg.value >= claimPrice, "Insufficient claim price");

        uint compensation = calculateCompensation();
        require(address(this).balance >= compensation, "Insufficient balance for compensation");

        // Update the king before sending Ether to prevent reentrancy
        king.transfer(compensation);
        king = payable(msg.sender); // Update king to the new sender
        claimPrice = calculateNewPrice();
    }

    function calculateCompensation() internal view returns (uint) {
        // Implement your compensation logic here
        return claimPrice; // Example: return the current claim price
    }

    function calculateNewPrice() internal view returns (uint) {
        // Implement your price calculation logic here
        return claimPrice * 2; // Example: double the claim price
    }
}