# Day :one::two:

## Delegate Call
Delegate Call extecutes code in another contract in the context of the contract that called it.

```solidity 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
/*
A calls B, sends 100 wei
        B calls C, sends 50 wei
A --> B --> C
            msg.sender = B
            msg.value = 50
            execute code on C's state variables
            use ETH in C

A calls B, sends 100 wei
        B delegatecalls C
A --> B --> C
            msg.sender = A
            msg.value = 100
            execute code on B's state varaibles
            use ETH in B
*/
```
- delegate call means that it is going to be executing the code inside the contract that is being called with the state variables and other context of the contract that called.
- delegate call preserves the context, that is why when B delegate calls C, the msg.sender remains A, and msg.value = 100.
- the ether balance of C will be the ETH in B.

```
contract Test DelegateCall {
  uint public num;
  address public sender;
  uint public value;
  
  function setVars(uint _num) external payable {
    num = _num;
    sender = msg.sender;
    value = msg.value;
  }
}

contract DelegateCall {
  uint public num;
  address public sender;
  uint public value;
  
  function setVars(address _test, uint _num) external payable {
    // (bool success, bytes memory data) = _test.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
    // require(success, "call failed");
    
    (bool success, bytes memory data) = _test.delegatecall(abi.ecodeWithSelector(TestDelegateCall.setVars.selector, _num));
    require(success, "delegatecall failed");
  }
}
























