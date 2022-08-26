# Day 8️⃣
## Enum
Struct allows us to express multiple choices, the boolean data type allows us to express true and false, but if we want to express more choices then we use ```enum```.

```solidity

contract Enum {
  enum Status {
    None,
    Pending,
    Shipped,
    Completed,
    Rejected,
    Canceled
  }
  
  Status public status;
  
  struct Order {
    address buyer;
    Status status;
  }
  
  Order[] public orders;
  
  function get() view external returns(Status) {
    return status;
  }
  
  function set(Status _status) external {
    status = _status;
  }
  
  function ship() external {
    status = Status.Shipped;
  }
  
  function reset() external {
    delete status;
  }
 
}
```

- in this example we create an enum that represents a shipping staus. we use the keyword ```enum``` and name it ```Status``` and inside the curly braces we have the choices.
- we can use this enum as a state-variable ```Status public status```, we can use it inside a struct ```struct Order { address buyer; Status status; }```, we create an array of struct Order ```Order[] public orders```
- we use the function ```get()``` to return enum from a function, the returned value ```status``` is the state-variable that we defined, ```set()``` is used to take enum as input and set the status to the enum from the input.
- we can update enum to a specific enum as shown in function ```ship()```
- we can reset the value of enum to it's default value as shown in function ```reset()```. The default value of enum is the first choice that is defined inside the curly braces.

## Deploy Any Contract
