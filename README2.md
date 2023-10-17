# Lottery Smartcontract

This is a lottery smart contract that allows users to participate, win, review lottery history, check winners by lottery, and claim the lottery prize.


# Chainlink implemantation:

I've integrated Chainlink VRF and Automation functionalities into the contract. It ensures that there are enough players participating in the lottery before it commences. 
After a specific interval, the contract automatically distributes the winnings to the chosen winner. Additionally, the use of Chainlink VRF ensures a fair and transparent random selection process. 
The contract initiates a new lottery with a fresh set of predetermined players. Thanks to Chainlink's automation, there is no need for manual intervention from the deployer to select a winner and start a new lottery.
