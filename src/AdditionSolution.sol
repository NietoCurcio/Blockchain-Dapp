// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/ISolution.sol";
import "../dependencies/forge-std-1.9.7/src/console.sol";
import "./ProgrammingCompetition.sol";


contract AdditionSolution is ISolution {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }


    function solution(bytes calldata args) external pure override returns (bytes memory) {
        (uint a, uint b) = abi.decode(args, (uint, uint));
        
        uint result = a + b;
        
        return abi.encode(result);
    }

    function submitSolution() external {
        console.log("Submitting solution from:", msg.sender);
        address competitionAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;

        ProgrammingCompetition competition = ProgrammingCompetition(payable(competitionAddress));

        uint problemId = 1;
        address mySolutionContract = address(this);

        console.log("Evaluating solution for problem ID:", problemId);
        competition.evaluateSolution(problemId, mySolutionContract);
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}