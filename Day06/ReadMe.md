# Day :six:

## Array

- Array in solidity can be dynamic or fixed size.
- Arrays are initialized and various operations can be performed like ```insert (push), get, update, delete, pop, length```
- Array can be created in memory and can be returned from function 

```solidity 
contract Array{
  uint[] public nums;
  uint[3] public numsFixed;
}

```

- A dynamic array can be initialized as a state variable. Dynamic means that the size of the arary can change.
