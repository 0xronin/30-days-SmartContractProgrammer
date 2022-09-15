// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Staker {
    // mappings
    mapping(address => uint) public balances;
    mapping(address => uint) public stakeTimestamp;

    address payable public owner;
    uint public stakePeriod = block.timestamp + 120 seconds;
    uint public claimPeriod = block.timestamp + 240 seconds;
    uint public reward = 0.001 ether;

    event Stake(address indexed stakers, uint amount);
    event Withdraw(address indexed withdrawers, uint amount);

    constructor() {
        owner = payable(msg.sender);
    }

    // modifiers 
    // stakingDeadLineReached
    modifier stakingDeadLineReached(bool reached) {
        uint timeRemaining = stakePeriodLeft();
        if(reached) {
            require(timeRemaining == 0, "Staking Deadline Not Reached");
        } else {
            require(timeRemaining > 0, "Staking Deadline Reached");
        }
        _;
    }

    // claimDeadlineReached
    modifier claimDeadlineReached(bool reached) {
        uint timeRemaining = claimPeriodLeft();
        if(reached) {
            require(timeRemaining == 0, "Claim Deadline Not Reached");
        } else {
            require(timeRemaining > 0, "Claim Deadline Reached");
        }
        _;
    }


    // stake function
    /* @notice - only allowed during the staking period
    */
    function stake() public payable stakingDeadLineReached(false) {
        require(msg.value > 0, "Send some ETH to stake");
        balances[msg.sender] += msg.value;
        stakeTimestamp[msg.sender] = block.timestamp;
        emit Stake(msg.sender, msg.value);
    }


    // withdraw function 
    /* @notice - only allowed during the claim period
    */
    function withdraw() public stakingDeadLineReached(true) claimDeadlineReached(false) {
        require(balances[msg.sender] > 0, "Nothing to Withdraw");

        uint balanceStaked = balances[msg.sender];
        uint balanceWithRewards = balanceStaked + (block.timestamp - stakeTimestamp[msg.sender])*reward;

        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: balanceWithRewards}("");
        require(success, "Failed");

        emit Withdraw(msg.sender, balanceWithRewards);
    }

    // stake period left
    function stakePeriodLeft() public view returns(uint) {
        if(block.timestamp >= stakePeriod){
            return 0;
        } else {
            return (stakePeriod - block.timestamp);
        }
    }

    // claim period left
    function claimPeriodLeft() public view returns(uint) {
        if(block.timestamp >= claimPeriod) {
            return 0;
        } else {
            return (claimPeriod - block.timestamp);
        }
    }

    function drain() public payable {
        require(block.timestamp > claimPeriod, "Cannot witdraw before Locking");
        require(msg.sender == owner, "Not the owner");
        owner.transfer(address(this).balance);
    }

    
    // receive function
    receive() external payable {

    }
}
