# Day :four:

## Error 
There are three ways to throw an error in solidity:
- require
- revert
- assert 

In occurence of error the gas gets refunded and any state variables that were updated will be reverted.

Starting with solidity 0.8 we can use ```custom errors``` to throw error to save gas.


### Require
Require is mostly used to validate inputs, and for access control, which means controlling who gets to call the function.

```solidity

contract Error {
  function testRequire(uint _i) public pure {
    require( _i <= 10, "i > 10");
    // more code 
  }
}

```
- require(```condition```, ```"error message"```). If the condition is not meet it throws an error message. If it passes it goes to more code.

### Revert
Revert is a better option if the conditions are nested and there are a lot of if statements.

```solidity

contract Error {
  function testRevert(uint _i) public pure {
    if( _i > 1) {
      // code 
      if( _i > 2){
        // more code 
        if(_i > 10){
          revert("i > 10");
        }
      }
    }
  }
}

```

### Assert 
Assert is used to check the condition that will always be true. If the condition evalutes to false then it means there might be a bug in the smart contract.

```solidity

contract Error {
  uint public num = 123;
  function testAssert() public view {
    assert(num === 123);
  }
  
  function foo(uint _i) public {
  num += 1;
  require( _i < 10)
  }
  
}

```

- When an error is thrown there will be a gas refund. If you sent 1000 gas and the function used 100 gas, upon failure 900 gas would be refunded.
- In the function ```foo()```, if we pass i = 13, it will update the state variable, and checks the condition, when check fails, it reverts the value of the state varaiable to it's initial value.


### Custom Errors
Custom errors are used to save gas. The longer the error message the more gas it will use. Custom errors can only be used with revert.

```solidity

contract Error {

  error MyError(address caller, uint i);
  
  function testCustomError(uint _i) public view {
    if(_i > 10) {
      revert MyError(msg.sender, _i);
    }
  }
  
}

```
- We can log the data inside the custom error.
- Here we log the caller of the function in the input that was passed in.
- The first parameter inside ```MyError()``` is named ```caller``` with type ```address```.
- The second parameter is the value of input i passed by the caller.
- Inside the custom error that is thrown/reverted, ```msg.sender``` is the caller and value of i thrown is ```_i```.
- ```msg.sender``` is a global variable, so we need to change ```pure``` to ```view``` because pure only reads local variables.

## Function Modifier
Function Modifier allows us to reuse code. It can wrap a function in such a way that some code are executed and then the actual function is executed and afterwards more code is executed.

### Basic Function Modifier
```solidity

// example without using modifier 
contract FunctionModifier {

  bool public paused;
  uint public count;
  
  function setPause(bool _paused) external {
    paused = _paused;
  }
  
  function inc() external {
    require(!paused, "paused");
    count += 1;
  }
  
  function dec() external {
    require(!paused, "paused");
    count -= 1;
  }
}

```
- The functions ```inc()``` and ```dec()``` can only be called if the contract is not paused.


Using the function modifier we can put the ```require``` statement in a single place and reuse the logic.
```solidity

// example using modifier 
contract FunctionModifier {

  bool public paused;
  uint public count;
  
  function setPause(bool _paused) external {
    paused = _paused;
  }
  
  modifier whenNotPaused() {
    require(!paused, "paused");
    _;
  }
  
  function inc() external whenNotPaused {
    count += 1;
  }
  
  function dec() external whenNotPaused {
    count -= 1;
  }
}

```
- start with ```modifier``` then nameOfTheModifier().
- within the curly braces we write the logic for check, here we used ```require```.
- the ```_;``` tells solidity to call the actual function that modifier has wrapped.
- the last step is to declare the modifier in the function signature by appending it. 
> function inc( ) external ```whenNotPaused``` { } // same with dec( )

### Function Modifiers with Input 

```solidity
modifier cap(uint _x) {
  require(_x < 100, "x >=100");
  _;
}

function incBy(uint _x) external whenNotPaused cap(_x) {
  count += x;
}
```
- the function ```incBy()``` will only increment the count if the contract is ```not paused``` and also do a check on the input, here it makes sure the input is less than 100. This is how you pass inputs in modifier.

### Function Modifiers sandwiching a function
This means some code will be executed inside the function modifier, then the actual function will be called and afterwards it will execute more inside the function modifier.

```solidity
modifier sandwich() {

  // some code
  count += 10;
  _;
  // more code
  count *= 2;
}

function foo() external sandwich {
  count += 1;
}
```

- when we call ```foo()``` it will first execute the ```sandwich``` modifier increasing the count by 10, then call the main function foo() and increment the count by 1 and then finally multiply the count by 2.

## Constructors


