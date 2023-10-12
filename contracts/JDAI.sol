// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract jDAI is IERC20 {
    string public name = "Pegged JAI"; // Token name
    string public symbol = "jDAI"; // Token symbol
    uint8 public decimals = 18; // Token decimals
    uint256 public totalSupply; // Total token supply
    mapping(address => uint256) public balanceOf; // User balances

    mapping(address => mapping(address => uint256)) private _allowances; // Allowance mapping

    constructor(uint256 initialSupply) {
        totalSupply = initialSupply * 1e18; // Convert initialSupply to wei
        balanceOf[msg.sender] = totalSupply; // Assign the initial supply to the contract creator
    }

    // Transfer tokens to another address
    function transfer(address to, uint256 value) external override returns (bool) {
        require(to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value); // Emit a Transfer event
        return true;
    }

    // Get the allowance granted by the owner to the spender
    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    // Approve a spender to spend tokens on behalf of the owner
    function approve(address spender, uint256 value) external override returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    // Transfer tokens from one address to another
    function transferFrom(address from, address to, uint256 value) external override returns (bool) {
        require(from != address(0), "Invalid address");
        require(to != address(0), "Invalid address");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(_allowances[from][msg.sender] >= value, "Allowance exceeded");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        _approve(from, msg.sender, _allowances[from][msg.sender] - value);
        emit Transfer(from, to, value); // Emit a Transfer event
        return true;
    }

    // Internal function to approve a spender with a specified allowance
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "Invalid address");
        require(spender != address(0), "Invalid address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount); // Emit an Approval event
    }
}
