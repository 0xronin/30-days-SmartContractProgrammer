# Day :one::zero:
## Visibility

Visibility defines how contract or other contracts have access to state varaibles and functions.
There are four visibilities:
1. private - only inside contract that defines it
2. internal - only inside contract and child contracts
3. public - inside and outside contract
4. external - only from outside contract

```solidity 

/*
 _____________________
| A                   |
| private pri()       |
| internal inter()    |   <------- C
| public pub()        |     pub() and ext()
| external ext()      |
|_____________________|

 _____________________
| B is A              |
| inter()             |   <-------- C
| pub()               |     pub() and ext()
|_____________________|

*/

contract VisibilityBase {
  uint private x = 0;
  uint internal y = 1;
  uint public z = 2;
  
  function privateFunc() private pure returns(uint) {
  }
  
  function internalFunc() internal pure returns(uint) {
  }
  
  function publicFunc() public pure returns(uint) {
  }
  
  function externalFunc() external pure returns(uint) {
  }
  
  function examples() external view {
    x + y + z;
    
    privateFunc();
    internalFunc();
    publicFunc();
    
    // externalFun(); will give a compilation error 
    // this.externalFunc();
  }
  
  contract VisibilityChild is VisibilityBase {
    function examples2() external view {
      // we don't have access to the state-variable x
      y + z;
      
      internalFunc();
      publicFunc();
      
      // we cannot access the externalFunc()
    }
  }
}
```

- We cannot access the external function inside the contract that defines it.
- We can call the external function within the example function by using ```this``` keyword, what it is doing here is, instead of directly calling the externalFunc(), by prefixing this function with the keyword  this, this code is making an external call into the VisibilityBase contract, this line of code is like calling another contract, except you are calling into ```this``` contract. This method is gas inefficient, so it must be avoided.

## Immutable

Suppose we want to intialize a state-variable when a contract is deployed, and once it is deployed the state-variable is never supposed to change. Then we declare that state varaible as ```immutable```. We are also able to save some gas doing this.

```solidity
contract Immutable {
  address public immutable owner;
  
  constructor() {
   owner = msg.sender;
  }
  // without immutable gas: 45718
  // with immutable gas: 43585
  
  uint public x;
  function foo() external {
    require(msg.sender == owner);
    x += 1;
  }
  
}
```
- Immutable variables can only be initialized when the contract is deployed and here we won't be to change the ```owner``` later on after deployment of contract.
- Immutable variables are like constants, except that you can initialize it only once when the contract is deployed.

### Payable
The payable keyword adds functionality to send and receive Ether.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Payable {
    address payable public owner;
    
    constructor() {
     owner = payable(msg.sender); // we need to cast msg.sender as payable address because 
     // owner has been declared as a payable address
    }
    
    function deposit() external payable {}
    
    // helper function to get balance
    function getBalance() external view returns(uint) {
        return address(this).balance;
    }
}
```
If we omit the keyword payable from deposit function, then it will no longer be able to receive ether.

### Fallback and Receive
Fallback is a special function that gets called when a function that we call does not exist inside the contract, the main use-case of a fallback function is to enable direct sending of ether, i.e., it allows sending of ether to this contract. To enable this functionality we need to declare the fallback function as payable.

```solidity
contract Fallback {
    fallback() external payable {}
}
```
Another variation of fallback function is receive function. The difference between fallback and receive is that, receive is executed when the data that was sent is empty.

- Ether is sent, if msg.data is empty: receive function will be executed.
- Ether is sent, msg.data is there: fallback function will be executed.
- Ether is sent, receive is not present: fallback function will be executed.

```solidity
contract Fallback {
    event Log(string func, address sender, uint value, bytes data);
    fallback() external payable {
     emit Log("fallback", msg.sender, msg.value, msg.data);
    }
        
    receive() external payable {
     emit Log("receive", msg.sender, msg.value, "");
    }
        
}
```
### 3 Ways to Send Ether
There are 3 ways in Solidity to send ether
- transfer - 2300 gas, reverts
- send - 2300 gas, returns bool
- call - all gas, returns bool and data

To be able to send ether from a contract, it must be able to first receive ether. One way is by having a ```payable constructor```, another is by having a ```payable fallback```. Having only the receive fuction means this contract will be able to receive ether, and if a function that is not present in this contract is called it will revert.

```solidity
contract SendEther {
    constructor() payable {}
    
    // fallback() external payable {}
    receive() external payable {}
    
    // sending Ether out of this contract 
    
    function sendViaTransfer(address payable _to) external payable { // gas left after calling this function : 2260
        _to.transfer(123);
    }
    
    function sendViaSend(address payable _to) external payable { // gas left after calling this function : 2260
        bool sent = _to.send(123);
        require(sent, "Failed to send");
    }
    
    function sendViaCall(address payable _to) external payable { // gas left after calling this function : 78719075
        (bool success, ) = _to.call{value: 123}("");
        require(success, "Failed to send");
    }
}

contract EthReceiver {
    event Log(uint amount, uint gas);
    
    receive() external payable {
        emit Log(msg.value, gasleft());
    }
}
```
The most recommended way of sending Ether is to use ```call```, since it saves a lot of gas.

## :star: Ether Wallet App
We will be able to send ether to this contract, but only the owner(deployer) of the contract will be able to send ether out of this contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract EtherWallet {
    address payable public owner;
    
    constructor() {
     owner = payable(msg.sender);
    }
    
    receive() external payable {}
    
    function withdraw(uint _amount) external {
     require(msg.sender == owner, "Not owner");
     // owner.transfer(_amount);
     // payable(msg.sender).transfer(_amount);
     (bool success, ) = msg.sender.call{value: _amount}("");
     require(success, "Failed to send");
    }
    
    // helper function getBalance displays the amount of ether stored in the contract
    function getBalance() external view returns(uint) {
     return address(this).balance;
    }
}
```
Gas Optimization:
- one of the ways to optimize for gas is to replace the state variables inside memory. owner is a state variable which can be replaced with msg.sender.
- we can use ```call``` instead of transfer to send ether.

<div align=center><a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day09"><< Day 9
<a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day11"> Day 11 >></div>
