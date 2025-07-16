'use client'
import React, { useEffect, useState } from "react";
import { notFound } from 'next/navigation';
import { JsonRpcProvider, Contract, formatEther } from "ethers";
import { programmingCompetitionAbi, programmingCompetitionAddress } from "@/constants/contract";
import SubmitSolutionButton from "@/app/components/SubmitSolutionButton";

const provider = new JsonRpcProvider("http://127.0.0.1:8545");

export default function ChallengeDetailPage({ params }: { params: { id: string } }) {
  const id = Number(params.id);
  const [problem, setProblem] = useState<any>(null);
  const [exists, setExists] = useState<boolean | null>(null);
  const [error, setError] = useState(false);

  useEffect(() => {
    if (isNaN(id)) {
      setExists(false);
      return;
    }
    const fetchData = async () => {
      try {
        const contract = new Contract(programmingCompetitionAddress, programmingCompetitionAbi, provider);
        const exists = await contract.problemExists(id);
        setExists(exists);
        if (!exists) return;
        const problem = await contract.getProblem(id);
        setProblem(problem);
      } catch (err) {
        console.error("Error loading challenge:", err);
        setError(true);
      }
    };
    fetchData();
  }, [id]);

  if (isNaN(id) || exists === false || error) {
    return notFound();
  }
  if (!problem) {
    return <div className="min-h-screen flex items-center justify-center">Loading...</div>;
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
      <main className="max-w-3xl mx-auto py-10 px-4">
        <h1 className="text-3xl font-bold mb-4 text-gray-900 dark:text-gray-100">
          {problem.title}
        </h1>
        <p className="mb-6 text-gray-700 dark:text-gray-300 whitespace-pre-line">
          {problem.description}
        </p>

        <div className="text-sm text-gray-600 dark:text-gray-400 space-y-2">
          <p><strong>Problem ID:</strong> {id}</p>
          <p><strong>Creator:</strong> {problem.creator}</p>
          <p><strong>Prize:</strong> {formatEther(problem.prize)} ETH</p>
          <p><strong>Status:</strong> {problem.isSolved ? "Solved ✅" : "Unsolved ❌"}</p>
        </div>

        {!problem.isSolved && <SubmitSolutionButton />}
      </main>
    </div>
  );
}
