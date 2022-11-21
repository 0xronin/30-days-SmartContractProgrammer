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
- We define by using the keyword ```constructor``` and inside the parenthesis we can put in the inputs, here it is ```_x```.
- Inside the curly braces of a constructor, we can write any code just like a regular function.
- We initailize the state variable owner to the address that deployed this contract. We do that by typing ```owner = msg.sender```.
- ```msg.sender``` will be the account that deployed this contract, here we are saying that, set the owner to the account that deployed this contract.
- We also set the state variable ```x``` to ```_x``` from the input.
- Unlike a regular function that can be called multiple times, the constructor can be called only once when we deploy the contract.

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
- We don't want the new owner to be zero address so we validate the input by typing ```require(_newOwner != address(0)``` and if it a zero address we throw a message saying ```"Invalid Address!"```.
- Now we know that the caller of this function is the owner and the new address is not a zero address, so we will move on and execute the code inside the function.
- We set the new owner by typing ```owner = _newOwner``` which is the input address passed by the current owner, making it the new owner.
- We also have examples of functions which only the owner can call, and the function that anyone can call. It's really useful while writing smart contracts.

### :tada: Congratulations! You have created a smart contract to transfer the ownership of a contract, check it on Remix on your own.

## Function Outputs

Functions in solidity can return multiple outputs, it can be 
1. Named outputs
2. Destructing Assignments: If you we to capture the output in another function then we use destructuring assignments.

```solidity
contract FunctionOutput {

  fucntion returnMany() public pure returns(uint, bool){
    return (1, true);
  }
  
  function named() public pure returns(uint x, bool b){
    x = 1;
    b = true;
  }
  
  function destructuringAssignments() public pure {
  (uint x, bool b) = returnMany();
  (, bool _b) = returnMany();
  }
}

```

- the function ```returnMany()``` returns multiple outputs. There is no inputs, we use ```public``` instead of ```external``` because we will be using this function in another function inside this contract. This function is read only so we are using ```pure```.
- the ```returns( )``` is how we declare this function will return multiple outputs. Inside the parenthesis we declare the types of outputs. Inside the function body we will match the return type.
- We can also name the outputs, by declaring the name after the data type ```returns(uint x, bool b)```. When we have named outputs we can implicitly return the outputs. We can assign the value to the named output. Writing functions like this will save us a little bit of gas. This is because there is one less copying to do.
- Destructring assignments is how we capture the outputs in a function. Inside the ```destrcturingAssignment()``` we call the ```returnMany()``` function. To capture the output of returnMany() as a varaible for the destructuringAssignment() function, we use parenthesis and inside the parenthesis we declare the variables that we want to capture ```(uint x, bool b) = returnMany();```.
- If we only need the second output, we can omit the first variable like this ```(, bool _b) = returnMany();```, name _b is used to avoid the name conflict.

<div align=center><a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day04"><< Day 4
<a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day06"> Day 6 >></div>





