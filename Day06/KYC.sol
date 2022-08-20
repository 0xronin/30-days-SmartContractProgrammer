// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract KYC {

    mapping (address => uint) balanceOf; 
 
    mapping (address => customer) Kyc;

    struct customer {
        string name;
        uint age;
    }

    function msgSender() public view returns(address) {
        return msg.sender;
    }

    function deposit(uint balance) public {
        balanceOf[msgSender()] = balance;
    }

    function checkBalance() public view returns(uint) {
        return balanceOf[msgSender()];
    }

    function setUserDetails(string memory name, uint age) public {
        Kyc[msgSender()] = customer(
            name,
            age
        );
    }

    function getUserDetail() public view returns(string memory, uint) {
        return (Kyc[msgSender()].name, Kyc[msgSender()].age);
    }
}
