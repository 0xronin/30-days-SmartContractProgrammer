# Day :three:

## Default Values
If we do not assign a value to a variable, then that variable will have a default value.

```solidity

contract DefaultValues { // creating state variables
  bool public b; // false
  uint public u; // 0
  int public i; // 0
  address public a; // 0x0000000000000000000000000000000000000000 (a sequence of 40 zeroes)
  bytes32 public b32; // 0x0000000000000000000000000000000000000000000000000000000000000000 32byte hexadecimal representation of zero
  // a sequence of 64 zeroes
}

```
The default values of ```mapping```, ```structs```, ```enums``` and ```fixed sized arrays``` will be discussed in later sections.

## Constants 
A state variable that never changes must be declared as constants. By doing so we will be able to save gas, when a function is called that uses that state variable.

```solidity

contract Constatns {
  address public constant MY_ADDRESS = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
  uint public constant MY_UINT = 123;
}

contract Var {
  address public my_address = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045; // not using constant keyword
}

```
- ```constant``` keyword is used to declare a constant.
- It is best-practice to CAPITALIZE the name of the constant.
- The gas execution cost for calling ```MY_ADDRESS``` in the contract ```Constants``` will be cheaper than ```Var```.

## If Else

The way If else is used in solidity is similar to JavaScript.

```solidity

contract IfElse {

  function example(uint _x) external pure returns (uint) {
    if(_x < 10){
      return 1;
    }
    else if (_x < 20) {
      return 2;
    }
    else {
      return 3;
    }
  }
  
  function ternary(uint _x) external pure returns (uint) {
   // if(x < 10) {
   //   return 1;
   // } return 2;
  }
  
  return _x < 10 ? 1 : 2; 

}

```

We can also use ```If-else``` using ternary operators. The example is shown in the ternary function.
When we have a simple If-else condition it is a better choice to use ternary operator.


## For Loops and While Loops

```solidity 

contract ForAndWhileLoops {

  function loops() {
    for (uint i = 0; i < 10; i++) {
      // code
      if (i == 3) {
        continue;
      }
      // more code
      if (i == 5) {
        break;
      }
    }
    
    uint j = 0;
    while (j < 10) {
      // code
      j++;
    }
  }
  
  function sum(uint _n) external pure returns(uint) {
    uint s;
    for(uint i = 1; i<= _n; i++) {
      s += i;
    } return s;
  }
  
}

```

- In the ```loops()``` function, the for loop starts at 0, runs // code and // more code, does the same when i = 1 and i = 2; but when it reaches i = 3, it skips more code because of the ```continue``` keyword. It runs code and more code for i = 4 but when reaches i = 5 it doesn't run more code and break out of the for loop because of the ```break``` keyword and doesn't run for i = 6 to 10.
- The ``` while``` loop in the loops() function starts at 0 and while i < 10 runs the code; Here it increments the value of j while j < 10.
- In the function ```sum()``` it returns the sum of all the number from 1 to n. 
- In solidity we usually try to use as few loop as possible, since more loops translates to higher gas cost for execution of function.


<div align=center><a href="https://github.com/0xronin/My-Blockchain-Developement-Journey/tree/main/Day30-FOCUS_SOLIDITY/Day02"><< Day 2
<a href="https://github.com/0xronin/My-Blockchain-Developement-Journey/tree/main/Day30-FOCUS_SOLIDITY/Day04"> Day 4 >></div>


