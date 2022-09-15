# Day :one::two:

## Delegate Call
Delegate Call extecutes code in another contract in the context of the contract that called it.

```solidity 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
/*
A calls B, sends 100 wei
        B calls C, sends 50 wei
A --> B --> C
            msg.sender = B
            msg.value = 50
            execute code on C's state variables
            use ETH in C

A calls B, sends 100 wei
        B delegatecalls C
A --> B --> C
            msg.sender = A
            msg.value = 100
            execute code on B's state varaibles
            use ETH in B
*/
```
- delegate call means that it is going to be executing the code inside the contract that is being called with the state variables and other context of the contract that called.
- delegate call preserves the context, that is why when B delegate calls C, the msg.sender remains A, and msg.value = 100.
- the ether balance of C will be the ETH in B.

```solidity
contract TestDelegateCall {
  // address public owner; // it will cause unexpected results
  uint public num;
  address public sender;
  uint public value;
  address public owner; // if we add a new state variable here, it will work as expected
  
  function setVars(uint _num) external payable {
    // num = _num;
    num = 2 * _num;
    sender = msg.sender;
    value = msg.value;
  }
}

contract DelegateCall {
  uint public num;
  address public sender;
  uint public value;
  
  function setVars(address _test, uint _num) external payable {
    // (bool success, bytes memory data) = _test.delegatecall(
    abi.encodeWithSignature("setVars(uint256)", _num)
    );
    // require(success, "call failed");
    
    (bool success, bytes memory data) = _test.delegatecall(
    abi.ecodeWithSelector(TestDelegateCall.setVars.selector, _num)
    );
    require(success, "delegatecall failed");
  }
}
```
- the state variables of the contract that is called ```TestDelegateCall`` will not be updated, instead the state variables of the contract that called gets updates. Here it will be ```DelegateCall`` contract's variables.
- we can update the logic of the contract that gets called, even though we cannot change any of the code in the contract that makes the delegatecall.
- please keep in mind, when using the delegatecall to update the logic, all of the state variables have to be the same and must be in the same order.

## New 
There are two ways to create a contract from another contract.
1. Create 
2. Create2

here we are using Create

```solidity 
contract Account {
    address public bank;
    address public owner;
    
    constructor(address _owner) payable {
        bank = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory {
    Account[] public accounts;
    
    function createAccount(address _owner) external payable {
        Account account = new Account{value: 111}(_owner); // transfering 111 wei while creating a new Account
        accounts.push(account);
    }
}
```
- here we are deploying contract ```Account``` from another contract ```AccountFactory``` using the function ```createAccount```, the input of this function will be address ```_owner``` which is passed in as the constructor input of the ```Account``` contract at the time of deployment.
- to deploy another contract from within a contract we use the keyword ```new``` followed by the name of the contract we are deploying. Inside the paranthesis we pass in the inputs to pass to the constructor.
- to assign this newly deployed Account contract as a variable, here we type ```Account account = new Acc...```.
- we create an array of accounts to store the contracts that we deploy, ```Account[] public accounts```.
- after we deploy the contract, we push the account in the Account[] array by typing ```accounts.push(account)```.

## Library
Library allows us to seperate and reuse code, it also allows us to enhance data types.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

library Math {
    function max(uint x, uint y) internal view returns(uint) {
        return x >= y ? x : y;
    }
}

contract Test {
    function testMax(uint x, uint y) external view returns(uint) {
        return Math.max(x, y);            
    }
}

contract 

```
- we create a library ```Math``` and use it inside the function ```testMax```
- libraries do not have state-variables, if we make the library public than we have to deploy the library seperately from the contract.
-```Math.max(inputs)``` is how we use library in a different contract 

### Using library with State variables
Here we are also enchancing a data type

```solidity

library ArrayLib {
    function find(uint[] storage, uint x) internal view returns(uint) {
        for(uint i = 0; i<arr.length; i++) {
            if(arr[i] == x) {
                return i;
            }
        } revert("not found");
    }
}

contract TestArray {
    using ArrayLib for uint[];
    uint[] public arr = [1,2,3];
    
    function testFind() external view returns(uint i) {
        // return ArrayLib.find(arr, 2);
        return arr.find(2);
    }
}
```
- since we are calling the function ```find``` in library on the state-variable ```arr```, its data location is storage. 
- ```using ArrayLib for uint[]``` means that for data type uint[] (array of uint), attach all the functionalities defined inside the library ```ArrayLib```, so by declaring the library that we are ```using```,  ```for``` a data type, we can enhance the data type and call the function on the data type.

## Keccak256 Hash function






