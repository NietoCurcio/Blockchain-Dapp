// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/ISolution.sol";
import "../dependencies/forge-std-1.9.7/src/console.sol";

contract ProgrammingCompetition {
    address public owner;

    struct Problem {
        address creator;
        bytes32 expectedResultsHash;
        string title;
        string description;
        uint256 prize;
        bool isSolved;
        bytes[] testCases;
    }

    mapping(uint256 => Problem) public problems;

    uint256[] public problemIds;

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
        bytes[] calldata testCases,
        string calldata title,
        string calldata description
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
            testCases: testCases,
            title: title,
            description: description,
            creator: msg.sender
        });

        problemIds.push(problemId);

        emit ProblemRegistered(problemId, msg.value);
    }

    function evaluateSolution(uint256 problemId, address solutionContract) external {
        console.log("Evaluating solution for problem ID:", problemId);
        Problem storage problem = problems[problemId];

        require(
            problem.expectedResultsHash != bytes32(0),
            "Problem does not exist"
        );
        require(!problem.isSolved, "Problem already solved");

        ISolution solution = ISolution(solutionContract);
        
        bytes memory allResults = "";
        bool executionFailed = false;

        console.log("Running test cases for problem ID:", problemId);
        for (uint i = 0; i < problem.testCases.length && !executionFailed; i++) {
            try solution.solution(problem.testCases[i]) returns (bytes memory result) {
                console.log("Test case", i);
                allResults = abi.encodePacked(allResults, result);
            } catch {
                console.log("Test case", i, "failed with exception");
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

        console.log("Expected Results Hash:");
        console.logBytes32(problem.expectedResultsHash);
        console.logBytes32(resultsHash);
        console.log("Solution is correct:", correct);

        if (correct) {
            problem.isSolved = true;
            uint256 prizeAmount = problem.prize;

            (bool success, ) = msg.sender.call{value: prizeAmount}("");
            require(success, "Prize transfer failed");

            emit PrizePaid(msg.sender, problemId, prizeAmount);
        }

        emit SolutionSubmitted(msg.sender, problemId, correct);
    }

    function getProblem(uint256 problemId) external view returns (
        address creator,
        bytes32 expectedResultsHash,
        string memory title,
        string memory description,
        uint256 prize,
        bool isSolved,
        bytes[] memory testCases
    ) {
        Problem storage problem = problems[problemId];
        return (
            problem.creator,
            problem.expectedResultsHash,
            problem.title,
            problem.description,
            problem.prize,
            problem.isSolved,
            problem.testCases
        );
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

    function getAllProblemIds() external view returns (uint256[] memory) {
        return problemIds;
    }

    receive() external payable {}

    function withdraw() external onlyOwner {
        // TODO: Lock the prizes for unsolved problems so owner cannot withdraw them
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool success, ) = owner.call{value: balance}("");
        require(success, "Withdrawal failed");
    }
}
