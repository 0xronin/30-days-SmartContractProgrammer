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
- we can update enum to a specific enum as shown in function ```ship()```.
- we can reset the value of enum to it's default value as shown in function ```reset()```. The default value of enum is the first choice that is defined inside the curly braces.

## Storage, Memory and Calldata
When we use a dynamic data-type as a variable we need to declare its data location.
* **Storage** means that the variable is a state-variable
* **Memory** means that the data is loaded on to memory
* **Calldata** is like memory, except it can only be used for function inputs.

```solidity
contract DataLocations {
  struct MyStruct {
    uint foo;
    string text;
  }
  
  mapping(address => MyStruct) public myStructs;
  
  function examplesMem (uint[] memory y, string memory s) external returns(uint[] memory) {
    myStructs[msg.sender] = MyStruct({foo: 123, text:"bar"});
    
    MyStruct storage myStruct = myStructs[msg.sender];
    myStruct.text = "foo";
    
    MyStruct memory readOnly = myStructs[msg.sender];
    readOnly.foo = 456;
    
    uint[] memory memArr = new uint[](3);
    memArr[0] = 234;
    return memArr;
  }
  
  function examplesCalldata (uint[] calldata y, string calldata s) external returns(uint[] memory) {
    _internal(y);
    
    uint[] memory memArr = new uint[](3);
    memArr[0] = 234;
    return memArr;
  }
  
  function _internal(uint[] calldata y) private {
    uint x = y[0];
  }

}
```
 
> Things to know about scope and visiblity - Private: function can only be called by the main contract. - Internal: function can only be called by the main or derived contract. - External: function can only be called by a third party. It cant be called by main or derived contracts. - Public: function can be called by anyone and anywhere.

- here we a struct called ```MyStruct``` and a mapping from address to struct called ```myStructs```
- we created and inserted ```myStruct[msg.sender] = MyStruct({foo: 123, text:"bar"})``` into mapping
- to modify a struct, we declare MyStruct followed by ```storage``` and then declaring the variable name ```MyStruct storage myStruct = myStructs[msg.sender]```, we modify the myStruct text by typing ```myStruct.text = "foo"```
> we declare a struct as storage when we want to modify the struct
- if we wanted to just read my struct, we change the keyword from storage to memory from our previous example. ```MyStruct memory readOnly = myStructs[msg.sender]```, this builds ```MyStruct``` stored at ```msg.sender``` to ```memory``` and this can also be modified ```readOnly.foo = 456```, but since the data is loaded on memory, once the function is done executing this change will not be saved.
> use **storage** to update data and use **memory** to read the data
- in function ```examplesMem()``` we pass inputs uint array ```uint[]``` its data location ```memory``` and its name ```y```, second input is ```string memory s```, we also return a dynamic datatype ```returns(uint[] memory)```
- we initialize an array uint which will be loaded in memory called ```memArr``` by typing ```uint[] memory memArr = new uint[](3)```. The memArr has 3 elements since it has a fixed size of 3.
> for arrays that are intialized in memory, we can only create fixed sized arrays. Note that we cannot create a dynamic array.
- calldata can be used for function inputs in place of memory because it has the potential to save gas. in the function ```examplesCalldata(uint[] calldata y, string calldata s)```, the datatype declared as calldata is non-modifiable, meaning we cannot change the values inside it. Hence saving gas when we pass this input into another function.
- we decalre another function called ```_internal()``` taking the ```uint[] calldata y``` as input from the ```examplesCalldata()```functions input, taking the input y and passing it into the _internal function.
- if we had used ```uint[] memory y```, it would take input y, and when it passes on to the function ```_internal(y)```, then would copy each element from the uint[] to a new uint[] inside the memory and then pass it on the function, when we use ```calldata``` then there is one less copying to do, saving us gas.
> Summary: Use ```storage``` for dynamic data that has to be updated, ```memory``` for reading or modifying the data without saving it to the blockchain and ```calldata``` for function inputs to save gas.

## ⭐ Simple Storage App

Here we create a simple app using the concept of data location that sets a string and gets a string.

```solidity
contract SimpleStorage {
  string public name;
  // using calldata instead of memory saves gas
  function setName(string calldata _name) external {
    name = _name;
  }
  
  function getName() external view returns(string memory) {
    return name;
  }
}

```
- to avoid name collision between input and state-variable we use underscore ```_name```
- since ```name``` is a public state variable we don't necessarily have to create a getter function, however it is best practice to create a getter function to return a dynamic data type.

Check Opcodes and its corresponding gas costs for the EVM [here](https://ethereum.org/en/developers/docs/evm/opcodes/)

## :star: ToDo App

