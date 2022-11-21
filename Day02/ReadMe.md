# Day :two: 

## Variables 

There are three types of variables in solidity
1. Local Variables
2. State Variables
3. Global Variables

### State Variables
- State variables are the variables which store data on the blockchain.
- State variables are declared inside of a contract but outside of a function.

```solidity
contract StateVariables {
  uint public stateVariable = 123;
  
  function() {
  
  }
}
```
### Local Variables
- Local variables are only used/declared inside a function.
- They exist only while the functon is executing.

- example #1
```solidity
contract StateVariables {
  uint public stateVariable = 123;
  
  function foo() {
    uint localVaraible = 777;
  }
}
```
- example #2
```solidity
contract LocalVariables {
  uint public i;
  bool public b;
  address public addr;
  
  function foo() external {
    uint a = 777;
    bool f = false;
    // code
    a += 334;
    f = true;
    
    i = 21000000;
    b = true;
    addr = address(1);
  }
}
```

Once the contract is deployed you can only find the State Variables ```i``` and ```b``` and the data stored still remains in the blockchain and persists even after the function is done executing, However the Local Variables no longer exists.

### Global Variables
- Global variables store the informations such as blockchain, transactions and the account that sends the transactions.

```solidity
contract GlobalVariables {
  function globalVars() external view returns(address, uint, uint){
      address sender = msg.sender;
      uint timestamp = block.timestamp;
      uint blockNum = block.number;
      return (sender, timestamp, blockNum);
  }
}

```

- ```view``` is like pure, it is a read-only function. Unlike pure functions, view functions can read data from state variables and global variables.
- ```msg.sender``` is a global variable that stores the addresss that calls this function, its datatype is address.
- ```block.timestamp``` stores the unix timestamp of when this fucntion was called, its datatype is uint.
- ```block.number``` stores the current [block number](https://www.youtube.com/watch?v=_160oMzblY8&t=2s), its datatype is uint.
- ```sender, timestamp, blockNum``` are the defined Global Variables.

### Difference between View and Pure functions

The main difference is that view functions can read data from the blockchain while pure functions do not read anything from the blockchain.

```solidity
contract ViewAndPureFunctions {
  uint public num;
  function viewFunc() external view returns(uint){
      return num;
  }
  
  function pureFunc() external pure returns(uint){
    return 1;
  }
  // example of view function
  function addToNum(uint x) external view returns(uint){
    return num + x;
  }
  // example of pure function
  function add(uint a, uint b) external pure returns(uint){
    return a + b;
  }
 }

```
- view function doesn't modify any state variables or write anything to the blockchain, making it a ```read-only``` function reading state variables, local and global variable.
- pure function is a ```read-only``` function, it can read only local variables, it does not modify anything on the blockchain. And also ```does not read``` any data from the blockchain such as a state variable or any information from the blockchain.

> - View Functions: Functions can be declared view in which case they promise not to modify the state.
> - Pure Functions: Functions can be declared pure in which case they promise not to read from or modify the state.


### :star: Simple Counter Dapp
This smart contract increments and decrements count;

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Counter {
    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}
```
- we create a state variable called ```count``` and declare it ```public``` which means we can access the state variable after the contract is deployed.
- there are two functions; ```inc()``` to increment the count and ```dec()``` to decrement the count.
- they are both ```external``` which means we will be able to call the functions after the contract is deployed.
- these functions are neither view nor pure functions, they both are ```write``` functions because we are going to be modifying the count state variable.

run the program on [Remix IDE](https://remix.ethereum.org/) to check your code.

Congratulations :tada: you have created a Counter dapp!

<div align=center><a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day01"><< Day 1
<a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day03"> Day 3 >></div>
