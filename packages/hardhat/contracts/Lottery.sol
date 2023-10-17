//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";


contract Lottery is AutomationCompatibleInterface  {

    // state variables:
    address public owner;
    address payable[] public players;
    uint public lotteryId;
    uint public lotteryEndTime;
    mapping (uint => address payable) public lotteryHistory;

     /**
     * Use an interval in seconds and a timestamp to slow execution of Upkeep
     */
    uint public immutable interval;
    uint public lastTimeStamp;

    constructor(uint updateInterval) {
        interval = updateInterval;
        lastTimeStamp = block.timestamp;


        owner = msg.sender;
        lotteryId = 1;
        // Set the lottery end time to 5 minutes from deployment
        lotteryEndTime = block.timestamp + 5 minutes;
    }
     // Chainlink Functions
    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */)
    {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

   function performUpkeep(bytes calldata /* performData */) external override {
    if ((block.timestamp - lastTimeStamp) > interval) {
        lastTimeStamp = block.timestamp;

        // PickWinner Logic:
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance); 
        lotteryHistory[lotteryId] = players[index];
        lotteryId++;

        // reset the state of the contract
        players = new address payable[](0);
        
        // Check if there are enough players for the new lottery
        require(players.length > 0, "Not enough participants for the new lottery");

        // Check if the lotteryEndTime + 10 minutes has passed
        if (block.timestamp > lotteryEndTime + 10 minutes) {
            // Start a new lottery
            lotteryEndTime = block.timestamp + 5 minutes;
        }
    }
   }

    // Get lotteryEndTime in readable numbers
    function getTimeLeft() public view returns (uint daysLeft, uint hoursLeft, uint minutesLeft) {
        uint timeRemaining = lotteryEndTime - block.timestamp;
        daysLeft = timeRemaining / 1 days;
        hoursLeft = (timeRemaining % 1 days) / 1 hours;
        minutesLeft = (timeRemaining % 1 hours) / 1 minutes;

        return (daysLeft, hoursLeft, minutesLeft);
    }

    function getWinnerByLottery(uint lottery) public view returns (address payable) {
        return lotteryHistory[lottery];
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function enterLottery() public payable {
        // require that after [lotteryEndTime]  players can no longer enter to this lottery
        require(block.timestamp < lotteryEndTime, "Lottery entry period has ended, Please enter current/new one");
        require(msg.value > .01 ether, "Deposit must be greater > .01 ether to enter");

        // address of player entering lottery
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

}
