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

```solidity
contract TestDelegateCall {
  // address public owner; // it will cause unexpected results
  uint public num;
  address public sender;
  uint public value;
  address public owner; // if we add a new state variable here, it will work as expected
  
  function setVars(uint _num) external payable {
    // num = _num;
    num = 2 * _num;
    sender = msg.sender;
    value = msg.value;
  }
}

contract DelegateCall {
  uint public num;
  address public sender;
  uint public value;
  
  function setVars(address _test, uint _num) external payable {
    // (bool success, bytes memory data) = _test.delegatecall(
    abi.encodeWithSignature("setVars(uint256)", _num)
    );
    // require(success, "call failed");
    
    (bool success, bytes memory data) = _test.delegatecall(
    abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
    );
    require(success, "delegatecall failed");
  }
}
```
- the state variables of the contract that is called ```TestDelegateCall``` will not be updated, instead the state variables of the contract that called gets updates. Here it will be ```DelegateCall``` contract's variables.
- we can update the logic of the contract that gets called, even though we cannot change any of the code in the contract that makes the delegatecall.
- please keep in mind, when using the delegatecall to update the logic, all of the state variables have to be the same and must be in the same order.

## New 
There are two ways to create a contract from another contract.
1. Create 
2. Create2

here we are using Create

```solidity 
contract Account {
    address public bank;
    address public owner;
    
    constructor(address _owner) payable {
        bank = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory {
    Account[] public accounts;
    
    function createAccount(address _owner) external payable {
        Account account = new Account{value: 111}(_owner); // transfering 111 wei while creating a new Account
        accounts.push(account);
    }
}
```
- here we are deploying contract ```Account``` from another contract ```AccountFactory``` using the function ```createAccount```, the input of this function will be address ```_owner``` which is passed in as the constructor input of the ```Account``` contract at the time of deployment.
- to deploy another contract from within a contract we use the keyword ```new``` followed by the name of the contract we are deploying. Inside the parenthesis we pass in the inputs to pass to the constructor.
- to assign this newly deployed Account contract as a variable, here we type ```Account account = new Acc...```.
- we create an array of accounts to store the contracts that we deploy, ```Account[] public accounts```.
- after we deploy the contract, we push the account in the Account[] array by typing ```accounts.push(account)```.

## Library
Library allows us to seperate and reuse code, it also allows us to enhance data types.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

library Math {
    function max(uint x, uint y) internal view returns(uint) {
        return x >= y ? x : y;
    }
}

contract Test {
    function testMax(uint x, uint y) external view returns(uint) {
        return Math.max(x, y);            
    }
}

contract 

```
- we create a library ```Math``` and use it inside the function ```testMax```
- libraries do not have state-variables, if we make the library public than we have to deploy the library seperately from the contract.
-```Math.max(inputs)``` is how we use library in a different contract 

### Using library with State variables
Here we are also enchancing a data type

```solidity

library ArrayLib {
    function find(uint[] storage, uint x) internal view returns(uint) {
        for(uint i = 0; i<arr.length; i++) {
            if(arr[i] == x) {
                return i;
            }
        } revert("not found");
    }
}

contract TestArray {
    using ArrayLib for uint[];
    uint[] public arr = [1,2,3];
    
    function testFind() external view returns(uint i) {
        // return ArrayLib.find(arr, 2);
        return arr.find(2);
    }
}
```
- since we are calling the function ```find``` in library on the state-variable ```arr```, its data location is storage. 
- ```using ArrayLib for uint[]``` means that for data type uint[] (array of uint), attach all the functionalities defined inside the library ```ArrayLib```, so by declaring the library that we are ```using```,  ```for``` a data type, we can enhance the data type and call the function on the data type.

## Keccak256 Hash function
Keccak256 is a cryptographic hash function that is wildly used in Solidity. Uses cases are to sign a signature, unique ID, and can be used to create a contract that is protected from front-running(Commit-Reveal Scheme).

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract HashFunc() {
    function hash(string memory text, uint num, address addr) external pure returns(bytes32) {
        return keccak256(abi.encodePacked(text, num, addr));
    }
    
    function encode(string memory text0, sting memory text1) external pure returns(bytes memory) {
        return abi.encode(text0, text1);
    }
    
    function encodePacked(string memory text0, sting memory text1) external pure returns(bytes memory) {
        return abi.encodePacked(text0, text1);
    }
    
    function collision(string memory text0, string memory text1) external pure returns(bytes32) {
        return keccak256(abi.encodePacked(text0, text1)); // for text0: "AAA", text1: "ABBB" 
                                                          // and text0: "AAAA", text1: "BBB" 
                                                          // the hash output will be same
    }
    
    // function collision(string memory text0, string memory text1) external pure returns(bytes32) {
    //    return keccak256(abi.encode(text0, text1));
    // }
    
    function collisionFixed(string memory text0, uint x, string memory text1) external pure returns(bytes32) {
        return keccak256(abi.encode(text0, x, text1));
    }
}
```
- ```encode``` simply encode data to bytes, while ```encodePacked``` compresses this data.
- However, there can be a situation of hash collision while using encodePacked.
> Hash collision: The output of the hash is same, even though the inputs are different. This happens when two dynamic data types are passed next to each other inside the function encodePacked.
- to avoid collision, we can use ```encode``` instead of encodePacked, alternatively if we have other inputs in the hash function we can rearrange the inputs so that no two dynamic data types are next to each other.

## Verify Signature
The process of verifying a signature in solidity is in 4 steps:
1. message to sign
2. hash (message)
3. sign(hash(message), private key) | done offchain using wallet
4. ecrecover(hash(message), signature) == signer

We create a function called Verify, which will take in a message, signature and a signer, and verify that the signature is valid.

```solidity
contract VerifySign {
    function verify(address _signer, string memory _message, bytes memory _sig)
            external pure returns(bool)
        {
            bytes32 messageHash = getMessageHash(_message);
            bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
            
            return recover(ethSignedMessageHash, _sig) == _signer;
        }
        
        function getMessageHash(string memory _message) public pure returns(bytes32) {
            return keccak256(abi.encodePacked(_message));
        }
        
        function getEthSignedMessageHash(bytes32 _messageHash) public pure returns(bytes32) {
            return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            _messageHash
            ));
        }
        
        function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) 
            public pure returns(address) 
        {
            (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
            return ecrecover(_ethSignedMessageHash, v, r, s);
        }
        
        function _split(bytes memory _sig) internal pure
            returns(bytes32 r, bytes32 s, uint8 v)
        {
            require(_sig.length == 65, "invalid signature length");
            
            assembly {
                r := mload(add(_sig, 32))
                s := mload(add(_sig, 64))
                v := byte(0, mload(add(_sig, 96)))
            }
        }

}
```
- when we sign the message off-chain, the message that is signed is not messageHash, it is ethSignedMessageHash.
- in the recover fucntion, we take ethSignedMessageHash verify it with _sig, this will recover the signer, so we will check whether the signer that was returned is equal to the signer from input.
- when we sign the messageHash, this hash will be prefixed with some strings ```"\x19Ethereum Signed Message:\n32"```and hashed again, that would be the actual message that is signed off-chain.
- we split the signature into 3 parts ```(bytes32 r, bytes32 s, uint8 v)```, the ```r``` and ```s``` are cryptographic parameters used for digital signatures and parameter v is recovery identifier variable. We pass these parameters to the function ```ecrecover```, which returns the address of the signed giving the signed message, v, r and s as inputs.
- we create the ```split``` function to split the signature into the three parameters v, r and s.
- we do a check on the signature to make sure it is valid, by checking the signature length to be equal to 65. Since bytes32 r is of 32 length, bytes32 s is of 32 length, and uint8 v is of 1 length.
- we get the parameters r, s, v from the signature _sig, by using ```assembly```
- ```_sig``` is a dynamic data, this is because it has a variable length, and for dynamic data type the first 32 bytes stores the length of the data. The variable _sig is not the actual signature, it is a pointer to where the signature is stored in memory.
- we get the value of r by typing ```r``` assigned to ```mload```, this will load to memory 32 bytes from the pointer that we provide in this input, the first 32 bytes of the _sig is the length of the _sig and we need to skip it by typing ```add(_sig, 32)```, here we are saying that from the pointer of _sig, skip the first 32 bytes because it holds the length of the array, after we skip the first 32 bytes the value for ```r``` is stored in the next 32 bytes. 
- similarly, we get the value for s and v. Note that for the value of v we dont need 32 bytes so we get only the 1st byte after s by typing ```byte(0, mload(add(_sig, 96)))```. The value of r, s and v are implicitly-returned.

## :star: Access Control App
A Smart Contract for making contract Deployer as ADMIN. ADMIN can further grant or revoke roles to other accounts.

```solidity 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract AccessControl {
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    // role => account => bool 
    mapping(bytes32 => mapping(address => bool)) public roles;

    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN")); // ADMIN hash = 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant USER = keccak256(abi.encodePacked("USER")); // USER hash = 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96

    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "not authorized");
        _;
    }

    constructor() {
        _grantRole(ADMIN, msg.sender);
    }

    // grant roles internal function
    function _grantRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }

    // grant role external function
    function grantRole(bytes32 _role, address _account) external onlyRole(ADMIN) {
        _grantRole(_role, _account);
    }

    // revoke roles
    function revokeRole(bytes32 _role, address _account) external onlyRole(ADMIN) {
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }
}
```
<div align=center><a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day11"><< Day 11
<a href="https://github.com/0xronin/30-days-SmartContractProgrammer/tree/main/Day13"> Day 13 >></div>
