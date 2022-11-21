# Day :one::one:
## Call Other Contracts
Here in the example below we are going to call functions from the ```TestContract``` from inside the ```CallTestContract```.
For the inputs in the function, we pass in the address of the contract we are calling, along with other input if present.

There are several ways to call other contracts
1. The first way is to initialize the contract, we do that by typing the contract name and pass in the address of the contract in the input to initialize it. ```TestContract(_test)``` and the function we want to call in write after a period ```.``` like ```TestContract(_test).setX(_x)```, this here will call the TestContract deployed at the address _test and it's going to call the function setX with the input _x.
2. Another way is to pass in the contract as a type directly replacing the address keyword, for example ```setX(TestContract _test, uint _x)```


```solidity
contract TestContract {
    uint public x;
    uint public value = 123;
    
    function setX(uint _x) external {
        x = _x;
    }
    
    funtion getX() external view returns(uint) {
        return x;
    }
    
    function setXandReceiveEther(uint _x) external payable {
        x = _x;
        value = msg.value;
    }
    
    function getXandValue() external view returns(uint, uint) {
        return (x, value);
    }
}

contract CallTestContract {
    function setX(TestContract _test, uint _x) external {
        _test.setX(_x);
    }
    
    // another way of calling a function from another contract
    function getX(address _test) external view returns(uint) {
        uint x = TestContract(_test).getX();
        return x;
    }
    
    // another way to return 
    // function getX(address _test) external view returns(uint) {
    //    return TestContract(_test).getX();
    //}
    
    // another way to return 
    // function getX(address _test) external view returns(uint x) {
    //    x = TestContract(_test).getX();
    //}
    
    function setXandSendEther(address _test, uint _x) external payable {
        TestContract(_test).setXandReceiveEther{value: msg.value}(_x);
    }
    
    function getXandValue(TestContract _test) external view returns(uint x, uint value) {
        (x, value) = _test.getXandValue();
    }
}

```

## Interface
Solidity allows you to call other contracts without having it's code by using an Interface.

Suppose we have the contract Counter deployed on blockchain and we need to call the function from this contract which may be of  hundreds of lines of code.

```solidity
// SPDX-License-Idetifier: MIT
pragma solidity ^0.8.7;

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
Considering this contract ```Counter``` is already deployed in the mainnet/testnet/blockchain.

We create an Interface of the Counter contract in order to call the Counter, supposing we do not have the code for the Counter contract.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface ICounter {
    function count() external view returns(uint);
    function inc() external;
}

contract CallInterface {
    uint public count;
    
    function examples(address _counter) external {
        ICounter(_counter).inc(); // this will increament the count
        count = ICounter(_counter).count(); // this will set new count 
        
    }
}
```
Inside the interface here we are calling two functions 
- function count() which returns the count stored inside the ```Counter``` contract
- inc() 

## Call
Call is a low-level function, and we have already used it to send ether to another contract. Here we will see how to use ```call``` to call functions in another contract.

In this example we are calling the ```contract TestCall```, using ```call``` from ```contract Call```

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract TestCall {
    string public message;
    uint public x;
    
    event Log(string message);
    
    fallback() external payable {
        emit Log("fallback was called");
    }
    
    function foo(string memory _message, uint _x) external payable returns(bool, uint) {
        message = _message;
        x = _x;
        return(true, 999);
    }
}

contract Call {
    bytes public data;
    
    function callFoo(address _test) external payable {
        (bool successs, bytes memory _data) = _test.call{value: 111 /*gas: 5000*/ }(abi.encodeWithSignature( 
            "foo(string,uint256)", "my message", 123
        ));
        require(success, "failed to call");
        data = _data;
    }
    
    // example of using call to call a function that does not exist inside the contract TestCall
    // since the TestCall contract has a fallback function so it will be executed and emit the Log() event
    
    function callDoesNotExist(address _test) external {
        (bool success, ) = _test.call(abi.encodeWithSignature("doesNotExist()"));
        require(success, "falied to call");
    }
    
}
```
- first we are going to call the function ```foo()```, so we create a function ```callFoo()``` in the Call contract, the input of the callFoo() function will be the addresss of the deployed TestCall contract called ```_test```. 
- we use the low-level call function, by typing _test.call(), inside the parenthesis we need to ecode the function ```abi.encodeWithSignature()``` we are calling followed by the inputs we are going to be passing
- the first input for ```abi.encodeWithSignature()``` will be the function we going to be calling which is ```foo()``` this function takes in a string and uint256 as input. ```Be careful to not put any spaces between the input inside the called function```.
- next we need to pass the inputs which is type string and type uint respectively. 
- when we use call it is going to return two outputs, the first output will be a boolean that tells whether the call was successful or not, and the second output will be any output that was returned from calling the function foo(), and it will be in bytes.
- when we are using ```call``` to call functions, we can specify the gas we are going to be sending and also the amount of ether we are going to be sending. ```call{value: 111 gas: 5000}```
- using call, we can also call functions that do not exist. Keep in mind the contract we are calling this non-existent function from must have a fallback function to execute.

<div align=center><a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day10"><< Day 10
<a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day12"> Day 12 >></div>
