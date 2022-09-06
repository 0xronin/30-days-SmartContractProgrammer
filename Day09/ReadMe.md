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


--
## Creating ERC20 Token 

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
