// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/*
@notice: Contract MyBalance deposits an amount to the account which calls deposit() function; 
and returns balance of the account which calls the checkBalance() function
*/

contract MyBalance {
    mapping(address => uint) balanceOf; // mapping address to uint named balanceOf

    function msgSender() public view returns (address) {
        // this function returns an address which is the caller of the function
        return msg.sender; // msg.sender is a global variable which returns the address which calls this function.
    }

    function deposit(uint amount) public {
        balanceOf[msgSender()] = amount; // deposits amount to the caller of the deposit function
    }

    function checkBalance() public view returns (uint) {
        return balanceOf[msgSender()]; // returs the balance/amount of the address who is calling the function
    }
}
