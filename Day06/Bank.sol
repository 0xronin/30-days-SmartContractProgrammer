// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
* Bank Contract: Adds balances to address and saves details of user.
@ balanceOf mapping: maps balance to an address
@ deposit function: deposits balances to the desired address
@ getBalance function: retrieves and displays the balance of the address 
@ addFund function: adds fund to own balance
@ withdraw function: withdraws the balance from the address
@ setUserDetails function: sets and also update details of the user 
@ getUserDetails function: retrieves user details 
*/

error NotOwner(string message);
error HasNotDeposited(string message);
error AmountTooSmall(string message);

contract Bank {

    event FundsDeposited(address user, uint amount);
    event ProfileUpdated(address user);

    address public owner;
    uint private constant Fee = 100;

    mapping (address => uint) balanceOf;
    mapping (address => User) userDeatils;


    struct User {
        string name;
        uint age;
    }

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if(msg.sender != owner) {
            revert NotOwner("You are not the owner");
        }
        _;
    }

    modifier hasDeposited() {
        if(balanceOf[msg.sender] <= 0) {
            revert HasNotDeposited("Please first deposit balance using deposit");
        }
        _;
    }

    modifier fees(uint _amount) {
        if(_amount < Fee) {
            revert AmountTooSmall("Amount must be greater than 100 wei");
        }
        _;
    }

    function deposit(uint _amount) public {
        balanceOf[msg.sender] += _amount;
        emit FundsDeposited(msg.sender, _amount);
    }

    function getBalance() public view returns(uint){
        return balanceOf[msg.sender];
    }

    function addFund(uint _amount) public hasDeposited fees(_amount){
        balanceOf[msg.sender] += _amount;
    }

    function withdraw() public onlyOwner {
        require(balanceOf[msg.sender] > 0, "Nothing to withdraw");
        balanceOf[msg.sender] = 0;
    }

    function setUserDetails(string calldata _name, uint _age) public onlyOwner{
        userDeatils[msg.sender] = User(_name, _age);
        emit ProfileUpdated(msg.sender);
    }

    function getUserDetails() public view returns(User memory) {
        return userDeatils[msg.sender];
    }

}
