// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std-1.9.7/Script.sol";
import {ProgrammingCompetition} from "../src/ProgrammingCompetition.sol";
import {AdditionSolution} from "../src/AdditionSolution.sol";
import {MaxValueSolution} from "../src/MaxValueSolution.sol";
import {PostOrderSolution} from "../src/PostOrderSolution.sol";

contract DeployAndSetup is Script {
    function run() external {
        ProgrammingCompetition competition = deployCompetition();
        registerAdditionProblem(competition);
        registerMaxValueProblem(competition);
        registerPostOrderProblem(competition);
        deployAdditionSolution();
        deployMaxValueSolution();
        deployPostOrderSolution();
    }

    function registerPostOrderProblem(ProgrammingCompetition competition) internal {
        // Example: tree:    1
        //                 / \
        //                2   3
        //               / \   \
        //              4   5   6
        // Encoded as: [value, leftIdx, rightIdx], -1 for null
        int256[3][] memory nodes1 = new int256[3][](6);
        nodes1[0] = [int256(1), 1, 2]; // root: 1, left=1, right=2
        nodes1[1] = [int256(2), 3, 4]; // 2, left=3, right=4
        nodes1[2] = [int256(3), -1, 5]; // 3, right=5
        nodes1[3] = [int256(4), -1, -1]; // 4
        nodes1[4] = [int256(5), -1, -1]; // 5
        nodes1[5] = [int256(6), -1, -1]; // 6

        // Postorder: 4 5 2 6 3 1
        int256[3][] memory nodes2 = new int256[3][](3);
        nodes2[0] = [int256(7), 1, 2];
        nodes2[1] = [int256(8), -1, -1];
        nodes2[2] = [int256(9), -1, -1];
        // Postorder: 8 9 7

        int256[3][] memory nodes3 = new int256[3][](1);
        nodes3[0] = [int256(10), -1, -1];
        // Postorder: 10

        bytes[] memory testCases = new bytes[](3);
        testCases[0] = abi.encode(nodes1);
        testCases[1] = abi.encode(nodes2);
        testCases[2] = abi.encode(nodes3);

        bytes memory allResults = "";
        allResults = abi.encodePacked(allResults, abi.encode(new int256[](6)));
        allResults = abi.encodePacked(allResults, abi.encode(new int256[](3)));
        allResults = abi.encodePacked(allResults, abi.encode(new int256[](1)));
        // Fill with actual postorder results
        allResults = abi.encodePacked(
            abi.encodePacked(
                abi.encode([int256(4),5,2,6,3,1]),
                abi.encode([int256(8),9,7]),
                abi.encode([int256(10)])
            )
        );
        bytes32 expectedResultsHash = keccak256(
            abi.encodePacked(
                abi.encode([int256(4),5,2,6,3,1]),
                abi.encode([int256(8),9,7]),
                abi.encode([int256(10)])
            )
        );

        string memory title = "PostOrder Traversal";
        string memory description = "Given a binary tree encoded as an array of [value, leftIdx, rightIdx] (with -1 for null), return the postorder traversal as an array of ints. The solution function receives a bytes args parameter, which should be decoded as int256[3][] memory nodes = abi.decode(args, (int256[3][]));";

        vm.startBroadcast();
        competition.registerProblem{value: 100000000 ether}(
            3,
            expectedResultsHash,
            testCases,
            title,
            description
        );
        vm.stopBroadcast();
        console.log("PostOrder problem registered.");
    }

    function deployPostOrderSolution() internal returns (address) {
        uint256 solutionDeployerPrivateKey = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;
        address solutionDeployer = vm.addr(solutionDeployerPrivateKey);
        console.log("Deploying PostOrderSolution from:", solutionDeployer);

        vm.startBroadcast(solutionDeployerPrivateKey);
        address solution = address(new PostOrderSolution());
        vm.stopBroadcast();

        console.log("PostOrderSolution deployed at:", solution);
        return solution;
    }

    function registerMaxValueProblem(ProgrammingCompetition competition) internal {
        bytes[] memory testCases = new bytes[](3);
        uint[] memory arr1 = new uint[](5);
        arr1[0] = 3;
        arr1[1] = 1;
        arr1[2] = 2;
        arr1[3] = 0;
        arr1[4] = 5;

        uint[] memory arr2 = new uint[](6);
        arr2[0] = 10;
        arr2[1] = 2;
        arr2[2] = 7;
        arr2[3] = 4;
        arr2[4] = 80;
        arr2[5] = 1;

        uint[] memory arr3 = new uint[](10);
        arr3[0] = 42;
        arr3[1] = 13;
        arr3[2] = 7;
        arr3[3] = 0;
        arr3[4] = 50;
        arr3[5] = 8;
        arr3[6] = 2;
        arr3[7] = 9;
        arr3[8] = 6;
        arr3[9] = 3;

        testCases[0] = abi.encode(arr1);
        testCases[1] = abi.encode(arr2);
        testCases[2] = abi.encode(arr3);

        bytes memory allResults = "";
        allResults = abi.encodePacked(allResults, abi.encode(5));
        allResults = abi.encodePacked(allResults, abi.encode(80));
        allResults = abi.encodePacked(allResults, abi.encode(50));
        bytes32 expectedResultsHash = keccak256(allResults);

        string memory title = "Find Maximum";
        string memory description = "Find the maximum value in an array. The solution function receives a bytes args parameter, which should be decoded as a uint[]: uint[] memory arr = abi.decode(args, (uint[])); Return the maximum value in the array.";

        vm.startBroadcast();
        competition.registerProblem{value: 100000000 ether}(
            2,
            expectedResultsHash,
            testCases,
            title,
            description
        );
        vm.stopBroadcast();
        console.log("Max value problem registered.");
    }
    function deployMaxValueSolution() internal returns (MaxValueSolution) {
        uint256 solutionDeployerPrivateKey = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;
        address solutionDeployer = vm.addr(solutionDeployerPrivateKey);
        console.log("Deploying MaxValueSolution from:", solutionDeployer);

        vm.startBroadcast(solutionDeployerPrivateKey);
        MaxValueSolution solution = new MaxValueSolution();
        vm.stopBroadcast();

        console.log("MaxValueSolution deployed at:", address(solution));
        return solution;
    }

    function deployCompetition() internal returns (ProgrammingCompetition) {
        vm.startBroadcast();
        ProgrammingCompetition competition = new ProgrammingCompetition();
        vm.stopBroadcast();
        console.log("ProgrammingCompetition deployed at:", address(competition));
        return competition;
    }

    function registerAdditionProblem(ProgrammingCompetition competition) internal {
        bytes[] memory testCases = new bytes[](3);
        testCases[0] = abi.encode(1, 1);
        testCases[1] = abi.encode(2, 2);
        testCases[2] = abi.encode(5, 7);

        for (uint i = 0; i < testCases.length; i++) {
            console.log(string(abi.encodePacked("test_case[", i, "]: ")));
            console.logBytes(testCases[i]);
        }

        bytes memory allResults = "";
        bytes memory expectedResult0 = abi.encode(2);
        bytes memory expectedResult1 = abi.encode(4);
        bytes memory expectedResult2 = abi.encode(12);
        allResults = abi.encodePacked(allResults, expectedResult0);
        allResults = abi.encodePacked(allResults, expectedResult1);
        allResults = abi.encodePacked(allResults, expectedResult2);

        bytes32 expectedResultsHash = keccak256(allResults);
        console.log("expectedResultsHash:");
        console.logBytes32(expectedResultsHash);

        string memory title = "Addition Problem";
        string memory description = "Solve the addition of two numbers. The expected results are the sum of the inputs provided in the test cases. The solution function receives a bytes args parameter, which should be decoded as two uints: (uint a, uint b) = abi.decode(args, (uint, uint));";

        vm.startBroadcast();
        competition.registerProblem{value: 100000000 ether}(
            1,
            expectedResultsHash,
            testCases,
            title,
            description
        );
        vm.stopBroadcast();
        console.log("Addition problem registered.");
    }

    function deployAdditionSolution() internal returns (AdditionSolution) {
        uint256 solutionDeployerPrivateKey = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;
        address solutionDeployer = vm.addr(solutionDeployerPrivateKey);
        console.log("Deploying AdditionSolution from:", solutionDeployer);

        vm.startBroadcast(solutionDeployerPrivateKey);
        AdditionSolution solution = new AdditionSolution();
        vm.stopBroadcast();

        console.log("AdditionSolution deployed at:", address(solution));
        return solution;
    }
}
