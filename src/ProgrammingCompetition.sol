// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProgrammingCompetition {
    address public owner;

    struct Problem {
        bytes32 expectedOutputHash;
        uint256 prize;
        bool isSolved;
    }

    mapping(uint256 => Problem) public problems;

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
        bytes32 expectedOutputHash
    ) external payable onlyOwner {
        require(
            problems[problemId].expectedOutputHash == bytes32(0),
            "Problem already exists"
        );
        require(msg.value > 0, "Prize must be greater than zero");

        problems[problemId] = Problem({
            expectedOutputHash: expectedOutputHash,
            prize: msg.value,
            isSolved: false
        });

        emit ProblemRegistered(problemId, msg.value);
    }

    function submitSolution(uint256 problemId, bytes32 solutionHash) external {
        Problem storage problem = problems[problemId];

        require(
            problem.expectedOutputHash != bytes32(0),
            "Problem does not exist"
        );
        require(!problem.isSolved, "Problem already solved");

        bool correct = (solutionHash == problem.expectedOutputHash);

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

    receive() external payable {}

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool success, ) = owner.call{value: balance}("");
        require(success, "Withdrawal failed");
    }
}
