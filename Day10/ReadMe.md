## Visibility

Visibility defines how contract or other contracts have access to state varaibles and functions.
There are four visibilities:
1. private - only inside contract that defines it
2. internal - only inside contract and child contracts
3. public - inside and outside contract
4. external - only from outside contract

```solidity 

/*
 _____________________
| A                   |
| private pri()       |
| internal inter()    |   <------- C
| public pub()        |     pub() and ext()
| external ext()      |
|_____________________|

 _____________________
| B is A              |
| inter()             |   <-------- C
| pub()               |     pub() and ext()
|_____________________|

*/

contract VisibilityBase {
  uint private x = 0;
  uint internal y = 1;
  uint public z = 2;
  
  function privateFunc() private pure returns(uint) {
  }
  
  function internalFunc() internal pure returns(uint) {
  }
  
  function publicFunc() public pure returns(uint) {
  }
  
  function externalFunc() external pure returns(uint) {
  }
  
  function examples() external view {
    x + y + z;
    
    privateFunc();
    internalFunc();
    publicFunc();
    
    // externalFun(); will give a compilation error 
    // this.externalFunc();
  }
  
  contract VisibilityChild is VisibilityBase {
    function examples2() external view {
      // we don't have access to the state-variable x
      y + z;
      
      internalFunc();
      publicFunc();
      
      // we cannot access the externalFunc()
    }
  }
}
```

- We cannot access the external function inside the contract that defines it.
- We can call the external function within the example function by using ```this``` keyword, what it is doing here is, instead of directly calling the externalFunc(), by prefixing this function with the keyword  this, this code is making an external call into the VisibilityBase contract, this line of code is like calling another contract, except you are calling into ```this``` contract. This method is gas inefficient, so it must be avoided.

## Immutable

Suppose we want to intialize a state-variable when a contract is deployed, and once it is deployed the state-variable is never supposed to change. Then we declare that state varaible as ```immutable```. We are also able to save some gas doing this.

```solidity
contract Immutable {
  address public immutable owner = msg.sender;
  
  // without immutable gas: 45718
  // with immutable gas: 43585
  
  uint public x;
  function foo() external {
    require(msg.sender == owner);
    x += 1;
  }
  
}
```
Immutable variables can only be initialized when the contract is deployed and here we won't be to change the ```owner``` later on after deployment of contract.
















