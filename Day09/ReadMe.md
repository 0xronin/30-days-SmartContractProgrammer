# Day 9️⃣

## Event 
Events allow you to write data on the blockchain, this data can later not be retrieved by smart contract. The main purpose of Event is to log that something happened. It can be a cheap alternative to storing a data as state variable.

 The event is declared by the keyword ```event``` and is logged to the blockchain by wtiting the keyword ```emit```.
 
 If we want to search for a particular event by the paramater that was logged, then we use the keyword ```indexed```. Please Note that only upto 3 parameters can be indexed.
 
```solidity 
contract Event {
    event Log(string message, uint val);
    event IndexedLog(adress indexed sender, uint val);
    
    function example() exteranal {
        emit Log("foo", 1234);
        emit IndexedLog(msg.sender, 789);
    }
    
    // Building a chat app
    event Message(address indexed _from, address indexed _to, string message);
    
    function sendMessage(address to, string calldata message) external {
        emit Message(msg.sender, to, message);
    }
}
```
## Inheritance

Inheritance is used when we want to use the code/functionality from one contract in other contract, also allowing us to customize the functions. For a contract to inherit another contract we use the keyword ```is```, in the example code below contract B(child) is inheriting A(parent) and C is inheriting B.

The functions that are to be inherited needs to be declared as ```virtual```.
To declare that these virtual functions can be customized by the child contract are declared as ```override```.


```solidity 
contract A {
    function foo() public pure virtual returns(string memory) {
        return "A";
    }
    function bar() public pure virtual returns(string memory) {
        return "A";
    }
    function baz() public pure returns(string memory) {
        return "A";
    }
}

contract B is A {
    funciton foo() public pure override returns(string memory) {
        return "B";
    }
    function bar() public pure virtual override returns(string memory) {
        return "B";
    }
}

contract C is B {
    funciton bar() public pure override returns(string memory) {
        return "C";
    }
}
```
### Multiple Inheritance
When a contract inherits from multiple contracts, then the order of inheritance is important, which is from most base-like to derieved.

The most base-like contract is the contract that inherits the least.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Order of inheritance - most base-like to derieved
/*
   X
 / |  
Y  |
 \ |
   Z
// order of most base like to derieved
// X, Y, Z
 
   X
  / \
 Y   A
 |   |
 |   B
  \ /
   Z
   
// order of most base like to derieved
// X, Y, A, B, Z
*/

// We take X, Y and Z example

contract X {
    function foo() public pure virtual returns(string memory) {
        return "X";
    }
    function bar() public pure virtual returns(string memory) {
        return "Y";
    }
    function x() public pure returns(string memory) {
        return "X";
    }
}

contract Y is X {
    function foo() public pure virtual override returns(string memory) {
        return "Y";
    }
    function bar() public pure virtual override returns(string memory) {
        return "Y";
    }
    function y() public pure returns(string memory) {
        return "Y";
    }
}

contract Z is X, Y { // be careful to not switch the order of most base-like to most derieved otherwise 
// this contract will not compile
    funciton foo() public pure override(X, Y) returns(string memory) {
        return "Z";
    }
    funciton bar() public pure override(X, Y) returns(string memory) {
        return "Z";
    }
}


   
```
In the example above X inherits Y, and Z inherits both Y and X.

### Calling Parent Constructors
When a contract inherits from Parent contracts how do we call the constructor of the parents?

In the example below, we have a contract S and the constructor takes in an input of string called ```_name```,
And we also have a contract T and it's constructor takes in an input of string called ```_text```,
And finally we have contract U, which inherits from both S and T.

```solidity
contract S {
    string public name;
    
    constructor(string memory _name) {
        name = _name;
    }
}

contract T {
    string public text;
    
    constructor(string memory _text) {
        text = _text;
    }
}

contract U is S("s"), T("t") {

}

contract V is S, T {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {
    }
}

contract VV is S("s"), T {
    constructor(string memory _text) T(_text) {
    }
}

// Order of execution 
// 1. S
// 2. T
// 3. V0
contract V0 is S, T {
    constructor(string memory _name, string memory _text) S(_text) T(_name) {
    }
}

// Order of execution
// 1. S
// 2. T
// 3. V1

contract V1 is S, T {
    constructor(string memory _name, string memory _text) T(_text) S(_name) {
    }
}

// Order of execution
// 1. T
// 2. S
// 3. V2
contract V2 is T, S {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {
    }
}

// Order of execution
// 1. T
// 2. S
// 3. V3
contract V3 is T, S {
    constructor(string memory _name, string memory _text) T(_text) S(_name) {
    }
}

```
- There are two ways to call the parent constructor, and there is also an order in which the parent constructor is called.

Initializing the Parent Constructor
1. If you know the parameters to pass to the parent constructor, when writing the code then you can pass the parameters directly, i.e. ```static inputs```. See ```contract U```.
2. If you want to pass dynamic inputs to the constructor parameters that are to be determined when you deploy the constract, i.e., ```dynamic inputs```. See ```contract V```. 
The calling can alse be a combination of both, see ```contract VV```

### Order of Initialization of Parent Contract
The Order of initialization of parent contract is not determined by the order of parent contracts that are called in the constructor, it is determined by the ```order of inheritance```, i.e., from most base-like to most derieved. See ```contract V0```, ```contract V1```, ```contract V2``` and ```contract V3```.

### Calling Parent Funcitons
We can call parent functions directly or using the keyword ```super```. 

We will use the following inheritance graph as example. E is the base contract, F and G inherits from E and H inherits from F and G.
```solidity
/*
    E
  /   \
 F     G
  \   /
    H
*/

contract E {
    event Log(string message);
    
    function foo() public virtual {
        emit Log("E.foo");
    }
    
    function bar() public virtual {
        emit Log("E.bar");
    }
}

contract F is E {
    function foo() public virtual override {
        emit Log("F.foo"); 
        E.foo(); // called directly
    }
    
    function bar() public virtual override {
        emit Log("F.bar");
        super.bar(); // called using keyword super
    }
}

contract G is E {
    function foo() public virtual override {
        emit Log("G.foo");
        E.Foo();
    }
    function bar() public virtual override {
        emit Log("G.bar");
        super.bar();
    }
}

contract H is F, G {
    function foo() public override(F, G) {
        F.foo(); // called directly
    }
    
    function bar() public override(F, G) {
        super.bar(); // called using keyword super
    }
}
```
Here in contract H, the function foo() is direcly calling the parent functions, and function bar() is calling the parent functions using ```super``` so it will call all parents.
- In contract H, when we call the function foo, it will call F.foo() only. F.foo() will emit the event "F.foo" and will call E.foo() which will emit the event "E.foo"
- If we call the function bar on contract H, it is going to call super.bar. The parents of the contract H is both F and G. So this function will call G.bar() and also F.bar(), both of these functions again call super.bar, in which case the parent of G is E and F is also E, so lastly it's going to call function bar() on contract E.

## EXTRA LEARNING!
### Creating ERC20 Token 

```solidity 

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MiniEth is ERC20 {
    constructor(uint initial_supply) ERC20("Mini ETH", "METH") {
        _mint(msg.sender, initial_supply);
    }
}
```
> supply: All operations in the smart contract use the token base units, so to create a total supply 100 tokens you input 100 * 10 ** 18 token base units.

### Mintable ERC20 token Contract

```solidity 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MiniEth is ERC20, Ownable {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
```
