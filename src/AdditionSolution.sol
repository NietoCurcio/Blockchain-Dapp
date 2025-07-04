// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/ISolution.sol";
import "./ProgrammingCompetition.sol";


contract AdditionSolution is ISolution {
    function solution(bytes calldata args) external view override returns (bytes memory) {
        // Decode the two numbers from the input
        (uint a, uint b) = abi.decode(args, (uint, uint));
        
        // Calculate the result
        uint result = a + b;
        
        // Return the encoded result
        return abi.encode(result);
    }

    // Submit a solution
    function submitSolution() external {
        address competitionAddress = 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707; // Replace with actual competition contract address


        ProgrammingCompetition competition = ProgrammingCompetition(payable(competitionAddress));
        competition.evaluateSolution(
            1, // problemId
            // address(mySolutionContract)
            address(this) // This contract's address
        );
    }

    receive() external payable {}
}