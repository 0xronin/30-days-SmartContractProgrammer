# Day 7️⃣

## Mapping
Mapping is like a dictionary in python or object in JavaScript or hashmap in Java.
It has a key type and a value type.
It allows for efficient lookup, to find whether data is included in the mapping or not.
We can create nested mappings, and set, get and delete data in a mapping.

```solidity
contract Mapping {
  mapping (address => uint) public balances;
  mapping (address => mapping(address => bool)) public isFriend;
  
  function examples() external {
    balances[msg.sender] = 123;
    uint bal = balances[msg.sender];
    uint bal2 = balances[address(1)]; // 0
    
    balances[msg.sender] += 456; // 123 + 456 = 579
    delete balances[msg.sender]; // 0
    
    isFriend[msg.sender][address(this)] = true;
  }
}
```

- we declare a mapping called ```balances``` by using the keyword ```mapping``` followed by the paranthesis, inside the paranthesis we define the key type and the value type. ```mapping(address => uint) public balances``` this mapping represents balance of each address. With the address we can lookup the balance of the address.
- we can create nested mapping, the mapping in the example is called ```isFriend``` which goes from address to another mapping which goes from address to boolean ```mapping (address => mapping(address => bool)) public isFriend```
- we can set value to a certain key in a mapping by ```balances[msg.sender] = 123```
- we can get the value from a mapping by ```uint bal = balances[msg.sender]```
- we can also get value for a mapping that has not been set yet ```uint bal2 = balances[address(1)]```. It returns default value
- we can update a mapping ```balances[msg.sender] += 456```
- we can clear a value stored in a mapping by using the delete keyword ```delete balances[msg.sender]```, delete resets to default value.
- to make ```msg.sender``` isFriend of this contract ```Mapping``` we write ```isFriend[msg.sender][address(this)] = true```

### Iterable Mapping 
We cannot get the size of a Mapping and cannot iterate through a mapping to get all the elements of the mapping, unless we internally keep track of all of the keys in the mapping. 

Let's build a mapping we can iterate through. We can get the size of the mapping, and run a for loop to get elements in the mapping.

```solidity

contract IterableMapping {
  mapping(address => uint) public balances;
  mapping(address => bool) public inserted;
  address[] public keys;
  
  function set(address _key, uint _val) external {
    balances[_key] = _val;
    
    if(!inserted[_key]) {
      inserted[_key] = true;
      keys.push(_key);
    }
  }
  
  function getSize() external view returns(uint) {
    return keys.length;
  }
  
  function first() external view returns(uint) {
    return balances[keys[0]];
  }
  
  function last() external view returns(uint) {
    return balances[keys[keys.length - 1]];
  }
  
  function get(uint _i) external view returns(uint) {
    return balances[keys[_i]];
  }
}
```

- we have a mapping called ```balances``` from address to uint which represents the balance of an address
- to get the size of the mapping and to iterate through it we need some new data, we need a new mapping that keeps track of whether a key is inserted or not ```mapping(address => bool) public inserted```
- to keep track of all the keys we inserted we create an array of type address ```address[] public keys```
- to set the value in the mappings we create a ```set()``` function where we update the balances mapping ```balances[_key] = _val```
- to keep track whether this key is newly inserted or not ```if(!inserted[_key])``` and if inserted ```inserted[_key] = true``` we append the key to the keys array ```keys.push(_key)```, doing so we will have an array or keys which we can further use to get all the values stored in the balances mapping through the functions ```first(), last(), getSize(), get(uint _i)```.


> Public and external differs in terms of gas usage. The former use more than the latter when used with large arrays of data. This is due to the fact that Solidity copies arguments to memory on a public function while external read from calldata which is cheaper than memory allocation.

## Struct
Struct allows us to group data together.

```solidity

contract Structs {

  struct Car {
    string model;
    uint year;
    address owner;
  }
  
  // Initializing Struct
  Car public car;
  Car[] public cars;
  mapping(address => Car[]) public carsByOwner;
  
  function examples() external {
    Car memory toyota = Car("Toyota", 1990, msg.sender);
    Car memory lambo = Car({year: 1980, model: "Lamborghini", owner: msg.sender});
    Car memory tesla; // model will be empty string, year will be 0 and owner will be address 0
    tesla.model = "Tesla";
    tesla.year = 2010;
    tesla.owner = msg.sender;
    
    cars.push(toyota);
    cars.push(lambo);
    cars.push(tesla);
    
    cars.push(Car("Ferrari", 2020, msg.sender));
    
    Car storage _car = cars[0];
    _car.year = 1999;
    delete _car.owner;
    
    delete cars[1];
  }

}
```

- we have created a struct called ```Car``` and inside we put model, year and owner.
- we can use struct as a state-variable by calling ```Car public car```, we can create an array of structs by typing ```Car[] public cars```, and we can define a mapping from owner to cars by typing ```mapping (address => Car[]) public carsByOwner```.
- Initializing: There are three ways to initialize a struct
    - the first is similar to how we execute a function, by putting all the parameters inside the paranthesis ```Car memory toyota = Car("Toyota", 1990, msg.sender)``` we create a variable with name ```toyota``` of type ```Car```struct inside ```memory``` meaning this variable will only exist while this function is called. The parameters have to be in the order they are declared initially.
    - another way is to pass key-value pairs inside the paranthesis ```Car memory lambo = Car({year: 1980, model: "Lamborghini", owner: msg.sender})```. The order does not matter.
    - third way to initialize a struct is to just define it, and the struct will have defalut values ```Car memory tesla```. We can push data in the tesla Car struct ```tesla.model = "Tesla"; tesla.year = 2010; tesla.owner = msg.sender;```
- after the function is finished executing these structs will be gone because of ```memory```, so we need to put these structs in a state variable so that we are able to get the structs from the smart contract by pushing the structs into the car array ```cars.push(toyota); cars.push(lambo); cars.push(tesla);```.
- We can also create a struct wihtout having to initialize it as memory and save it as a state-variable, we can directly create a struct and push it immediately into the array by doing the following ```cars.push(Car("Ferrari", 2020, msg.sender))```.
- getting, updating and deleting from struct is ```Car storage _car = cars[0]; _car.year = 1999; delete _car.owner; delete cars[1];```. We use ```storage``` because we want to update the variable stored inside this smart contract.


<div align=center><a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day06"><< Day 6
<a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day08"> Day 8 >></div>
