# Lottery Smartcontract

This is a  lottery smart-contract that allows for users to enter, win, check lottery histoy, get winner by lottery, & receive
the lottery pot.

# Chainlink implemantation:

I've used chainlink VRF & Automation so the contract checks if there is enought players to enter the lottery & after a certin time period(intervals)
the contract automatically sends the funds to the winner after certain time is passed and uses Chainlink VRR randomness for fairness.
Starts a new lottery with new players already predetermined. There is no need for the deployer to manually call the function to pick a winner & start a
new lottery thanks to Chainlink automation.
