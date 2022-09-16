# Day :one::three:
## Deleting Contracts
In solidity there is a function called selfdestruct, that when called deletes the contract from the blockchain. When we call selfdestruct on a contract apart from deleting the contract it also force sends the ETH present in the contract to any other address, even if that address does not have a fallback function.

```solidity 
contract Kill {
  
  constructor() payable {}
   
  function kill() external {
    selfdestruct(payable(msg.sender));
  }
  
  function testCall() external pure returns(uint) {
    return 123;
  }
}

contract Helper {
  function getBalance() external view returns(uint) {
    return address(this).balance;
  }
  // function to call kill function present in the Kill contract
  function kill(Kill _kill) external { // passing in the address of the Kill contract as input
    _kill.kill();
  }
}
```

## :star: Piggy Bank Dapp
This Piggy Bank Smart Contract allows anyone to deposit ETH, and only the owner can withdraw the ETH. Once the owner witdraws the ETH this contract is self-destructed.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

    // anyone can deposit ETH, but only the owner can withdraw the ETH and the contract is self destructed.

contract PiggyBank {
    event Deposit(uint indexed amount, address indexed sender);
    event Withdraw(uint indexed amount, address indexed withdrawer);
    address public owner = msg.sender;

    receive() external payable {
        emit Deposit(msg.value, msg.sender);
    }

    function withdraw() public {
        require(msg.sender == owner, "not the owner");
        emit Withdraw(address(this).balance, msg.sender);
        selfdestruct(payable(msg.sender));
    }
}
```







