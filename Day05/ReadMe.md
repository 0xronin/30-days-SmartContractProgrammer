# Day:five:

## Constructor 
Constructor are special functions that are called only once when the contract is deployed. 

Mainly used to initialize state variables.

```solidity 
contract Constructor {
  address public owner;
  uint public x;
  
  constructor(uint _x) {
    owner = msg.sender;
    x = _x;
    // code
  }
}

```
- Here we have a state variable type address named ```owner``` and a uint named ```x```.
- We are using ```constructor``` to initialize owner and state variable uint x.
- We define by using the keyword ```constructor``` and inside the parathesis we can put in the inputs, here it is ```_x```.
- Inside the curly braces of a constructor, we can write any code just like a regular function.
- We initailize the state variable owner to the address that deployed this contract. We do that by typing ```owner = msg.sender```.
- ```msg.sender``` will be the account that deployed this contract, here we are saying that, set the owner to the account that deployed this constract.
- We also set the state variable ```x``` to ```_x``` from the input.
- Unlike a regular function that can be called multiple times, the contrctor can be called only once when we deploy the contract.
