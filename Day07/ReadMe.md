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
We cannot get the size of a Mapping and cannot iterate through a mapping to get all the elements of the mapping, UNLESS we internally keep track of all of the keys in the mapping. 


