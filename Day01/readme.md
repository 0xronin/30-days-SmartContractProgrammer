# Day :one:

## License Identifier

You have to start with a SPDX License Identifier at the top of your solidity file.

`// SPDX-License-Identifier: MIT`

We use [MIT](https://spdx.org/licenses/MIT) in the license name because it is granted free-of-charge and without restrictions.

## Pragma 
We use pragma to define the solidity verison

```solidity 
pragma solidity ^0.8.0;
// Anything above 0.8.0

pragma solidity >=0.8.0 <0.9.0;
// Anything between 0.8.0 to 0.9.0 where 0.9.0 is not included.

pragma solidity 0.8.8;
// Only Version 0.8.8
```
## Comments
```solidity
// You can write comments like this

/*
You can write 
multi-line comments 
like this
*/
```

## Contract Structure 

Solidity’s code is encapsulated in contracts which means a contract in Solidity is a collection of code (its functions) and data (its state) that resides at a specific address on the Ethereum blockchain. A contract is a fundamental block of building an application on Ethereum. [source](https://www.geeksforgeeks.org/what-is-smart-contract-in-solidity/)

```solidity
contract ContractName {

}
```
While naming the contract it is considered best practice to Capitalize the first Letter and use CamelCase.

## First Smart Contract

```solidity 

// SPDX-License-Identifier: MIT

pragma solidity 0.8.7; // compiler version

contract HelloWorld {
  string public greeting = "Hello World!";
}

```

- ```string``` is the data-type.
- ```public``` tells we have read-access to this variable after we deploy the smart contract.
>When using public on a state variable a getter is automatically created for us with a function of the same name.
- ```greeting``` is the name of the variable.

Once the contract is deployed, the variable ```greeting``` will be stored on the blockchain.
We can call ```greeting``` from the contract ```HelloWorld``` and the value "Hello World!" is returned.

Congratulations, you have written your first Smart Contract!

## Data Types 

The data types in solidity are of two types 
- Values: It means the data stores a value. ex: int, string, bool etc.
- references: stores a reference to where the actual data is stored. ex: array, mapping, etc.

### Common Value types

```solidity

contract ValueTypes {
  bool public b = true;
  uint public u = 123; // uint = uint256 0 to 2**256 - 1
                       //        uint8   0 to 2**8 - 1
                       //        uint16  0 to 2**16 - 1
  int public i = -123; //  int = int256 -2** 255 to 2**255 -1
                       //        int128 -2**127 to 2**127 -1
  int public minInt = type(int).min // minimum integer
  int public maxInt = type(int).max // maximum integer
  
  address public addr = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
  bytes32 public b32 = 0x000000000000000000000000697cb3a91d22f4cb39aeea7eb4a410fedd0bbe06
}
```
- ```bool``` boolean, stores either true(1) or false(0).
- ```uint``` unsigned integer stores zero or positive numbers.
- ```int``` integers stored negative, zero and positive numbers.
- ```min/max value``` finds what the minimum or maximum value of a datatype is.
- ```address``` is used to store the value of any address.
- ```bytes32``` this data type is used when working with the hash function ```keccak256```


```for future reference``` converting bytes32 address to address
```solidity
contract Conversion {
    function test(bytes32 _input) external pure returns (address) {
        return address(uint160(uint256(_input)));
    }
}
```

## Functions

Basic syntax
```solidity
contract FunctionIntro {
  function add(uint a, uint b) external pure returns(uint){
    retunrn a + b;
  }
  
  function sub(uint a, uint b) external pure returns(uint){
    return a - b;
  }
```

- ```(input_datatype input_name, input_datatype input_name, ...)``` The function contains the input datatype and the name of the input inside the paranthesis.
- ```external``` when we deploy the contract we will be able to call this function.
> External visibility is quite similar to the public visibility for functions. External is better than public if you know that you are only calling the function externally (outside the EVM). Public visibility requires more gas because it can be called externally and internally, which complicates the assembly code
- ```pure``` means this function is read only, it does not write anything to the blockchain.
- ```returns()``` declares the type of output returned which is written inside the paranthesis.

> Extra Knowledge: 
The ABI for a contract with a public uint would be: 
```solidity
contract Contract {
	uint public myNum;
}
// ABI
[
	{
		"inputs": [],
		"name": "myNum",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
```

<div align=center><a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day02">Day 2 >></a></div>
