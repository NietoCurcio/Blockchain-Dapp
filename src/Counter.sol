// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import '../dependencies/forge-std-1.9.7/src/console.sol';

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        // console.log("Incrementing number from %s to %s", number, number + 1);
        number++;
    }
}
