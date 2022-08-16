//SPDX-License-Identifier: MIT
// @author: 0xRonin

pragma solidity ^0.8.0;

/*
@ notice: Contract with two functions 
deposit: which adds balance to an address, and
checkBalance(): which returns balance in the address
*/

contract Balance {
    mapping(address => uint) public balanceOf; // @dev: mapping address to uint with name balanceOf

    function deposit(address addr, uint amount) public {
        // @notice: when do we specifically use public, internal, external, private
        balanceOf[addr] += amount; // @dev: adding balance multiple times
    }

    function checkBalance(address addr) public view returns (uint) {
        // @notice: when we use view and pure
        return balanceOf[addr]; // @dev: returns the balance in the address
    }
}
