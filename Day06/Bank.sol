// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Bank {
    error AmountTooSmall(string error);

    mapping (address => uint) balanceOf;

    mapping (address => customer) Kyc;

    struct customer {
        string name;
        uint age;
    }

    uint private constant Fee = 100;

    modifier fees(uint _amount) {
        if(_amount <= Fee){
            revert AmountTooSmall("Amount must be greater than 100 wei");
        }
        _;
    }

    modifier validAmount() {
        require(balanceOf[msg.sender] > 0, "Insufficient Balance");
        _;
    }

    modifier validSend(uint _amount) {
        require(balanceOf[msg.sender] >= _amount, "Insufficient Balance");
        _;
    }

    function addFund() public payable fees(msg.value) {
        balanceOf[msg.sender] += msg.value;
    }

    function deposit(address payable _to, uint _amount) public validSend(_amount) {
        _to.transfer(_amount);
        balanceOf[msg.sender] -= _amount;
    }

    function withdraw() public validAmount {
        address payable to = payable(msg.sender);
        to.transfer(balanceOf[msg.sender]);
        balanceOf[msg.sender] = 0;
    }

    function getBalance() public view returns(uint) {
        return balanceOf[msg.sender];
    }

    function setUserDetails(string memory name, uint age) public {
        Kyc[msg.sender] = customer(
            name,
            age
        );
    }

    function getUserDetail() public view returns(string memory, uint) {
        return (Kyc[msg.sender].name, Kyc[msg.sender].age);
    }
}
