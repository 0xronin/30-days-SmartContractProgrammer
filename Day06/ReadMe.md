# Day :six:

## Array

- Array in solidity can be dynamic or fixed size.
- Arrays are initialized and various operations can be performed like ```insert (push), get, update, delete, pop, length```
- Array can be created in memory and can be returned from function 

```solidity 
contract Array{
  uint[] public nums = [1, 2, 3];
  uint[4] public numsFixed = [4, 5, 6, 7];
  
  function example() external {
    nums.push(4); // [1,2,3,4]
    uint x = nums[1]; // x = 2
    nums[2] = 777 // [1,2,777,4]
    delete nums[1]; // [1,0,777,4]
    nums.pop(); // [1.0,777]
    uint len = nums.length; // 3
    
    // create array in memory
    uint[] memory a = new uint[](5);
    a[1] = 123;
  }
  
  function returnArray() external view returns(uint[] memory) {
   return nums;
  }
  
}

```

- A dynamic array can be initialized as a state variable. Dynamic means that the size of the arary can change. We create a dynamic array of uint using sqaure brackets ```uint[]```. We initialize the dynamic array by typing ```nums = [1, 2, 3]```, this is dynamic array with elements 1, 2 and 3.
- The fixed size array means the size of array cannot change once it's set. The syntax is similar ```uint[4]```, the size of the fixed array is specified inside the brackets. We initialize the fixed array by typing ```numsFixed = [4, 5, 6, 7]```, in a fixed array if the size of an array do not match with the number of elements in the array, it will throw an error.
- Operations in an array
    - Inserting elements in an array: ```nums.push(4)```. push inserts the element at the end of the array.
    - to get an element at an index: ```nums[1]```. This will return the element from nums array at index 1. We can also assign it to a variable```uint x = nums[2]```
    - to update the value of element at an index ```nums[2] = 777```, updates the value from 3 to 777.
    - to delete the value of element at an index ``` delete nums[1]```, this deletes the value and sets it to it's default value. Here the default value of uint is 0.
    - to shrink the size/length of an array we use the method ```nums.pop()```, pop removes the last element of the array.
    - to get the length of an array we use ```nums.length```.
- An array in memory has to be a fixed size. The syntax ```uint[] memory a = new uint[](5)```. An array in memeory named ```a``` is initialized with a fixed size of 5. We can only update a value and get the value from an array in memory.
- A function can return array as output. The return type is an array of uint and it is memory ```returns(uint[] memory)``` which means we want to copy the state variable ```nums``` into memory and then return it.
- Returning an array from a function is not recommended, it's reason is to keep the for loop small. The bigger the array, the more gas it will consume, if the array is too big it will use all the gas and function will be unusable.

### Array Remove An Element By Shifting

When we use th ```delete``` to clear element from an array, it does not removes the element but only resets it to it's default value.
The basic idea of this method is to shift all the elements to the left and pop the last element.

```solidity
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ArrayShift {
  uint[] public arr;
  
  function example() public {
    arr = [1,2,3];
    delete arr[1]; // [1,0,3]
  }
  
  // [1,2,3] ... remove 2 --> [1,3,3] --> [1,3]
  // [1,2,3,4,5,6] ... remove 3 --> [1,2,4,5,6,6] --> [1,2,4,5,6]
  // [1] ... remove 1 --> [1] --> []
  
  function remove(uint _index) public {
    require(_index < arr.length, "Index out of bound");
    
    for (uint i = _index; i< arr.length - 1; i++){
      arr[i] = arr[i+1];
    } arr.pop();
  }
  
  function test() external {
    arr = [1,2,3,4,5];
    remove(2) // item at index 2; that is 3
    // [1,2,4,5]
    assert(arr[0] == 1);
    assert(arr[1] == 2);
    assert(arr[2] == 4);
    assert(arr[3] == 5);
    assert(arr.length == 4);
    
    arr = [1];
    remove(0); // []
    assert(arr.length == 0);
  }
}
```

- in the test we have array ```[1,2,3,4,5]``` and we want to remove the element at index(2) that is 3.
- we shift all the elements to the right of the element we want to remove to the left. ```arr[i] = arr[i+1]```
- after shifting all the elements over to the left we will have an array looking like this ```[1,2,4,5,5]```
- finally we pop ```arr.pop()``` the last element and get the desired array ```[1,2,4,5]```
- we check our algo by running the function ```test()```

### Array Remove An Element By Replacing Last
Shifting is not an gas-efficient way to remove an element from an array, the idea here is to shuffle the elements by replacing the element we want to remove with the last element. However the order of the elements in the array is not reserved when using this menthod.

```solidity
contract ArrayReplaceLast {
  uint[] public arr;
  
  // [1,2,3,4] --> remove(1) --> [1,4,3]
  // [1,4,3] --> remove(2) --> [1,4]
  
  function remove(uint i) public {
    arr[i] = arr[arr.length - 1];
    arr.pop();
  }
  
  function test() external {
    arr = [1,2,3,4];
    
    remove(1); // [1,4,3]
    assert(arr.length == 3);
    assert(arr[0] == 1);
    assert(arr[1] == 4);
    assert(arr[2] == 3);
    
    remove(2);
    // [1,4]
    assert(arr.length == 2);
    assert(arr[0] == 1);
    assert(arr[1] == 4);
  }
}
```

- the element we want to remove is replaced with the last element ```arr[i] = arr[arr.length - 1]```
- finally we pop the last element ```arr.pop()```
- we check our algo by running the function ```test()```

<div align=center><a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day05"><< Day 5
<a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day07"> Day 7 >></div>

