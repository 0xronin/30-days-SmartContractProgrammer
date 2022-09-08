## Call Other Contracts
Here in the example below we are going to call functions from the ```TestContract``` from inside the ```CallTestContract```.
For the inputs in the function, we pass in the address of the contract we are calling, along with other input if present.

There are several ways to call other contracts
1. The first way is to initialize the contract, we do that by typing the contract name and pass in the address of the contract in the input to initialize it. ```TestContract(_test)``` and the function we want to call in writter after a period ```.``` like ```TestContract(_test).setX(_x)```, this here will call the TestContract deployed at the address _test and it's going to call the function setX with the input _x.
2. Another way is to pass in the contract as a type directly replacing the address keyword, for example ```setX(TestContract _test, uint _x)```


```solidity
contract TestContract {
    uint public x;
    uint public value = 123;
    
    function setX(uint _x) external {
        x = _x;
    }
    
    funtion getX() external view returns(uint) {
        return x;
    }
    
    function setXandReceiveEther(uint _x) external payable {
        x = _x;
        value = msg.value;
    }
    
    function getXandValue() external view returns(uint, uint) {
        return (x, value);
    }
}

contract CallTestContract {
    function setX(TestContract _test, uint _x) external {
        _test.setX(_x);
    }
    
    // another way of calling a function from another contract
    function getX(address _test) external view returns(uint) {
        uint x = TestContract(_test).getX();
        return x;
    }
    
    // another way to return 
    // function getX(address _test) external view returns(uint) {
    //    return TestContract(_test).getX();
    //}
    
    // another way to return 
    // function getX(address _test) external view returns(uint x) {
    //    x = TestContract(_test).getX();
    //}
    
    function setXandSendEther(address _test, uint _x) external payable {
        TestContract(_test).setXandReceiveEther{value: msg.value}(_x);
    }
    
    function getXandValue(TestContract _test) external view returns(uint x, uint value) {
        (x, value) = _test.getXandValue();
    }
}

```

## Interface
