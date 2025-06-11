// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/ISolution.sol";

contract ProgrammingCompetition {
    address public owner;

    struct Problem {
        bytes32 expectedResultsHash; // Combined hash of all test case results
        uint256 prize;
        bool isSolved;
        bytes[] testCases; // Encoded arguments for each test case
    }

    mapping(uint256 => Problem) private problems;

    event ProblemRegistered(uint256 problemId, uint256 prize);
    event SolutionSubmitted(
        address participant,
        uint256 problemId,
        bool correct
    );
    event PrizePaid(address winner, uint256 problemId, uint256 prize);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerProblem(
        uint256 problemId,
        bytes32 expectedResultsHash,
        bytes[] calldata testCases
    ) external payable onlyOwner {
        require(
            problems[problemId].expectedResultsHash == bytes32(0),
            "Problem already exists"
        );
        require(msg.value > 0, "Prize must be greater than zero");
        require(testCases.length > 0, "Must provide at least one test case");

        problems[problemId] = Problem({
            expectedResultsHash: expectedResultsHash,
            prize: msg.value,
            isSolved: false,
            testCases: testCases
        });

        emit ProblemRegistered(problemId, msg.value);
    }

    function evaluateSolution(uint256 problemId, address solutionContract) external {
        Problem storage problem = problems[problemId];

        require(
            problem.expectedResultsHash != bytes32(0),
            "Problem does not exist"
        );
        require(!problem.isSolved, "Problem already solved");

        ISolution solution = ISolution(solutionContract);
        
        bytes memory allResults = "";
        bool executionFailed = false;
        
        // Run all test cases
        for (uint i = 0; i < problem.testCases.length && !executionFailed; i++) {
            try solution.solution(problem.testCases[i]) returns (bytes memory result) {
                allResults = abi.encodePacked(allResults, result);
            } catch {
                executionFailed = true;
            }
        }
        
        if (executionFailed) {
            emit SolutionSubmitted(msg.sender, problemId, false);
            return;
        }
        
        // Hash all results
        bytes32 resultsHash = keccak256(allResults);
        bool correct = (resultsHash == problem.expectedResultsHash);

        if (correct) {
            problem.isSolved = true;
            uint256 prizeAmount = problem.prize;
            problem.prize = 0;

            (bool success, ) = msg.sender.call{value: prizeAmount}("");
            require(success, "Prize transfer failed");

            emit PrizePaid(msg.sender, problemId, prizeAmount);
        }

        emit SolutionSubmitted(msg.sender, problemId, correct);
    }

    function getProblemPrize(uint256 problemId) external view returns (uint256) {
        return problems[problemId].prize;
    }

    function isProblemSolved(uint256 problemId) external view returns (bool) {
        return problems[problemId].isSolved;
    }

    function problemExists(uint256 problemId) external view returns (bool) {
        return problems[problemId].expectedResultsHash != bytes32(0);
    }

    receive() external payable {}

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool success, ) = owner.call{value: balance}("");
        require(success, "Withdrawal failed");
    }

    // Example for preparing test cases for "addition"
    function prepareAdditionProblem() external payable {
        // Create array to hold test cases
        bytes[] memory testCases = new bytes[](3);
        
        // Encode the inputs for each test case
        testCases[0] = abi.encode(1, 1);      // 1+1
        testCases[1] = abi.encode(2, 2);      // 2+2
        testCases[2] = abi.encode(5, 7);      // 5+7
        
        // Generate the expected results hash
        bytes memory allResults = "";
        
        // For 1+1=2, encode the result
        allResults = abi.encodePacked(allResults, abi.encode(2));
        
        // For 2+2=4, encode the result
        allResults = abi.encodePacked(allResults, abi.encode(4));
        
        // For 5+7=12, encode the result
        allResults = abi.encodePacked(allResults, abi.encode(12));
        
        // Hash all results together
        bytes32 expectedResultsHash = keccak256(allResults);
        
        // Register the problem
        // ProgrammingCompetition competition = ProgrammingCompetition(competitionAddress);
        ProgrammingCompetition competition = ProgrammingCompetition(payable(address(this)));
        competition.registerProblem{value: 0.1 ether}(
            1, // problemId
            expectedResultsHash,
            testCases
        );
    }
}
