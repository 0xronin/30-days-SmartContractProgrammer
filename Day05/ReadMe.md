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

## :star: Building Ownership App
This app will be using some of the concepts we have learned so far.
- state varaibles
- global variables
- function modifier
- function
- error handling

```solidity 
contract Ownable{
  address public owner;
  
  constructor() {
  owner = msg.sender;
  }
  
  modifier onlyOwner() {
    require(msg.sender == owner, "You are not the owner");
    _;
  }
  
  function setOwner(address _newOwner) external onlyOwner {
    require(_newOwner != address(0), "Invalid Address!");
    owner = _newOwner;
  }
  
  function onlyOwnerCanCallThisFunc() external onlyOwner {
    // code
  }
  
  function anyOneCanCall() external {
    // code
  }
 
}

```
- First we declare a state variable called ```owner```.
- Inside the constructor we will intialize the state varaible ```owner``` to ```msg.sender``` the account which has deployed this contract.
- We create a function ```modifier``` where only the owner can call the function and name it ```onlyOwner```. We require(put a check) that ```msg.sender``` is equal to the current owner. If it is not, then we will return a message saying ```"You are not the owner"```.
- If the msg.sender is the owner then we move on and execute the rest of the code, here we type ```_;``` to move to the function which called the modifier.
- We write the function to set a new owner, only the owner will be able to call this function.
- ```setOwner()``` function will take single input of the new owner which we want to set, ```address  _newAddress```, function will be external meaning we will be able to call this fucntion and attach the ```onlyOwner``` modifier, which makes this function callable by only the owner of this contract and set the new owner.
- We don't want the new owner to be zero address so we validate the input by typing ```require(_newOwner != address(0)``` and if it a zero address we throw a message saying ```Invalid Address!```.
- Now we know that the caller of this function is the owner and the new address is not a zero address, so we will move on and execute the code inside the function.
- We set a new owner by typing ```owner = _newOwner``` which is the input address passed by the current owner, making it the new owner.
- We also have examples of functions which only the owner can call, and the function that anyone can call. It's really useful while writing smart contracts.







