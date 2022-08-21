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
