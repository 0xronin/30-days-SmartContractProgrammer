# Day 9️⃣
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
