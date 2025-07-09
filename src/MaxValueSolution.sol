// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/ISolution.sol";

import "../dependencies/forge-std-1.9.7/src/console.sol";
import "./ProgrammingCompetition.sol";

contract MaxValueSolution is ISolution {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function solution(bytes calldata args) external pure override returns (bytes memory) {
        console.log("Running MaxValueSolution with args");
        console.logBytes(args);
        uint[] memory arr = abi.decode(args, (uint[]));
        require(arr.length > 0, "Array must not be empty");
        uint max = arr[0];
        for (uint i = 1; i < arr.length; i++) {
            if (arr[i] > max) {
                max = arr[i];
            }
        }
        return abi.encode(max);
    }

    function submitSolution() external {
        address competitionAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        ProgrammingCompetition competition = ProgrammingCompetition(payable(competitionAddress));
        uint problemId = 2;
        address mySolutionContract = address(this);
        competition.evaluateSolution(problemId, mySolutionContract);
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
