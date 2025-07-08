// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/ISolution.sol";
import "./ProgrammingCompetition.sol";


contract AdditionSolution is ISolution {
    function solution(bytes calldata args) external pure override returns (bytes memory) {
        // Decode the two numbers from the input
        (uint a, uint b) = abi.decode(args, (uint, uint));
        
        // Calculate the result
        uint result = a + b;
        
        // Return the encoded result
        return abi.encode(result);
    }

    // Submit a solution
    function submitSolution() external {
       // Replace with actual competition contract address
        address competitionAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;


        ProgrammingCompetition competition = ProgrammingCompetition(payable(competitionAddress));
        competition.evaluateSolution(
            1, // problemId
            // address(mySolutionContract)
            address(this) // This contract's address
        );
    }

    receive() external payable {}
}