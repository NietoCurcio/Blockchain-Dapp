// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std-1.9.7/Test.sol";
import {ProgrammingCompetition} from "../src/ProgrammingCompetition.sol";
import {AdditionSolution} from "../src/AdditionSolution.sol";


contract ProgrammingCompetitionTest is Test {
    ProgrammingCompetition public competition;
    AdditionSolution public solution;
    address public owner = address(this);
    address public participant = address(0xBEEF);

    string internal constant TITLE = "Addition Problem";
    string internal constant DESCRIPTION = "Solve the addition of two numbers. The expected results are the sum of the inputs provided in the test cases. The solution function receives a bytes args parameter, which should be decoded as two uints: (uint a, uint b) = abi.decode(args, (uint, uint));";

    function setUp() public {
        competition = new ProgrammingCompetition();
        solution = new AdditionSolution();
    }

    function test_RegisterProblemAndPrize() public {
        bytes[] memory testCases = new bytes[](3);
        testCases[0] = abi.encode(1, 1);
        testCases[1] = abi.encode(2, 2);
        testCases[2] = abi.encode(5, 7);

        bytes memory allResults = abi.encodePacked(abi.encode(2), abi.encode(4), abi.encode(12));
        bytes32 expectedResultsHash = keccak256(allResults);

        competition.registerProblem{value: 1 ether}(1, expectedResultsHash, testCases, TITLE, DESCRIPTION);
        assertEq(competition.getProblemPrize(1), 1 ether);
        assertTrue(competition.problemExists(1));
        assertFalse(competition.isProblemSolved(1));
    }

    function test_EvaluateSolution_Correct() public {
        // Register problem
        bytes[] memory testCases = new bytes[](3);
        testCases[0] = abi.encode(1, 1);
        testCases[1] = abi.encode(2, 2);
        testCases[2] = abi.encode(5, 7);
        bytes memory allResults = abi.encodePacked(abi.encode(2), abi.encode(4), abi.encode(12));
        bytes32 expectedResultsHash = keccak256(allResults);
        competition.registerProblem{value: 1 ether}(1, expectedResultsHash, testCases, TITLE, DESCRIPTION);

        // Evaluate correct solution
        vm.prank(participant);
        competition.evaluateSolution(1, address(solution));
        assertTrue(competition.isProblemSolved(1));
        assertEq(competition.getProblemPrize(1), 0);
    }

    function test_EvaluateSolution_Incorrect() public {
        // Register problem
        bytes[] memory testCases = new bytes[](1);
        testCases[0] = abi.encode(1, 1);
        bytes memory allResults = abi.encodePacked(abi.encode(3)); // Wrong result
        bytes32 expectedResultsHash = keccak256(allResults);
        competition.registerProblem{value: 1 ether}(2, expectedResultsHash, testCases, TITLE, DESCRIPTION);

        // Evaluate with correct solution (should fail)
        vm.prank(participant);
        competition.evaluateSolution(2, address(solution));
        assertFalse(competition.isProblemSolved(2));
        assertEq(competition.getProblemPrize(2), 1 ether);
    }

    function test_EvaluateSolution_FailsOnException() public {
        // Register problem with invalid test case (decoding will fail)
        bytes[] memory testCases = new bytes[](1);
        testCases[0] = hex"deadbeef";
        bytes memory allResults = abi.encodePacked(abi.encode(0));
        bytes32 expectedResultsHash = keccak256(allResults);
        competition.registerProblem{value: 1 ether}(3, expectedResultsHash, testCases, TITLE, DESCRIPTION);

        // Evaluate with solution (should not revert, but not solve)
        vm.prank(participant);
        competition.evaluateSolution(3, address(solution));
        assertFalse(competition.isProblemSolved(3));
        assertEq(competition.getProblemPrize(3), 1 ether);
    }

    function test_Withdraw() public {
        // Register a problem, leave prize unclaimed
        bytes[] memory testCases = new bytes[](1);
        testCases[0] = abi.encode(1, 1);
        bytes memory allResults = abi.encodePacked(abi.encode(2));
        bytes32 expectedResultsHash = keccak256(allResults);
        competition.registerProblem{value: 1 ether}(4, expectedResultsHash, testCases, TITLE, DESCRIPTION);

        // Withdraw remaining balance (should be 0, as all funds are in prize)
        vm.expectRevert("No funds to withdraw");
        competition.withdraw();
    }
}
