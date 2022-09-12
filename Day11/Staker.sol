// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// there will be a staking period and claiming period 

contract Staker {

    event Stake(address indexed _staker, uint _amount);
    event Withdraw(address indexed _withdrawer, uint _amount);

    // mappings
    mapping(address => uint) public balances;
    mapping(address => uint) public stakingTimestamp;
    mapping(address => bool) public hasClaimed;

    address payable public owner;
    uint public stakePeriod = block.timestamp + 120 seconds;
    uint public claimPeriod = block.timestamp + 240 seconds;
    uint public reward = 0.01 ether; // reward/second for staking

    // modifier for staking deadline reached
    modifier stakingDeadlineReached(bool reached) {
        uint timeLeft = stakeTimeLeft();
        if(reached == true) {
            require(timeLeft == 0, "Staking deadline not reached");
        } else {
            require(timeLeft > 0, "Staking deadline reached");
        }
        _;
    }

    // modifier for claiming deadline reached
    modifier claimingDeadlineReached(bool reached) {
        uint timeLeft = claimTimeLeft();
        if(reached == true) {
            require(timeLeft == 0, "Claiming deadline not reached");
        } else {
            require(timeLeft > 0, "Claiming deadline reached");
        }
        _;
    }
    
    constructor() {
        owner = payable(msg.sender);
    }

    // stake function
    function stake() public payable stakingDeadlineReached(false) {
        balances[msg.sender] += msg.value;
        stakingTimestamp[msg.sender] = block.timestamp;
        emit Stake(msg.sender, msg.value);
    }

    // withdraw function
    function withdraw() external payable stakingDeadlineReached(true) claimingDeadlineReached(false) {
        require(hasClaimed[msg.sender]== false, "Already Claimed");
        uint balanceStaked = balances[msg.sender];
        uint claimAmount = balanceStaked + (block.timestamp - stakingTimestamp[msg.sender])* reward;

        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: claimAmount}("");
        hasClaimed[msg.sender] = true;
        require(success, "Failed");
        emit Withdraw(msg.sender, claimAmount);
    }

    // drain function
    function drain() public claimingDeadlineReached(true) {
        require(msg.sender == owner, "Not the owner");
        owner.transfer(address(this).balance);
    }

    // stake time left function
    function stakeTimeLeft() public view returns(uint) {
        require(msg.value > 0, "Send some ETH");
        if(block.timestamp > stakePeriod) {
            return 0;
        } else {
            return (stakePeriod - block.timestamp);
        }
    }

    // claim time left function
    function claimTimeLeft() public view returns(uint) {
        if(block.timestamp > claimPeriod) {
            return 0;
        } else {
            return (claimPeriod - block.timestamp);
        }
    }

    // receive function
    receive() external payable {}
}
