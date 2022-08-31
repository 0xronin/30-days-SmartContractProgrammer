// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
* Bank Contract: Adds balances to address and saves details of user.
@ balanceOf mapping: maps balance to an address
@ deposit function: deposits ETH to the desired address
@ getBalance function: retrieves and displays the balance of the address 
@ addFund function: adds fund to own balance
@ withdraw function: withdraws the balance from the address
@ setUserDetails function: sets and also update details of the user 
@ getUserDetails function: retrieves user details 
@ getBalanceOfContract function: gets the balance in ETH
@ withdrawContractBalance function: withdraws the balance in contract to Contract Owners' addresss
*/

error NotOwner(string message);
error HasNotDeposited(string message);
error AmountTooSmall(string message);

contract Bank {

    event FundsDeposited(address user, uint amount);
    event ProfileUpdated(address user);
    event Log(string func, address from, uint amount, bytes data);

    address payable public owner;
    uint private constant Fee = 100;

    mapping (address => uint) balanceOf;
    mapping (address => User) userDeatils;


    struct User {
        string name;
        uint age;
    }

    constructor() {
        owner = payable(msg.sender);
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

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    function getBalance() public view returns(uint){
        return balanceOf[msg.sender];
    }

    function addFund() public payable hasDeposited fees(msg.value){
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balanceOf[msg.sender] > 0, "Nothing to withdraw");
        address payable to = payable(msg.sender);
        to.transfer(balanceOf[msg.sender]);
        balanceOf[msg.sender] = 0;
    }

    function setUserDetails(string calldata _name, uint _age) public onlyOwner{
        userDeatils[msg.sender] = User(_name, _age);
        emit ProfileUpdated(msg.sender);
    }

    function getUserDetails() public view returns(User memory) {
        return userDeatils[msg.sender];
    }

    function getBalanceOfContract() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawContractBalance() public onlyOwner {
        require((address(this).balance) > 0, "Nothing to withdraw");
        owner.transfer(address(this).balance);
    }

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

}
