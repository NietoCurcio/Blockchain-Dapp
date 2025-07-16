'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';
import { programmingCompetitionAbi, programmingCompetitionAddress } from '@/constants/contract';
import { ethers } from 'ethers';

type Challenge = {
	id: BigInt;
	title: string;
	description: string;
}

export default function ChallengesPage() {
	const [challenges, setChallenges] = useState<Challenge[]>([]);
	const [loading, setLoading] = useState<boolean>(true);

	const rpcProvider = new ethers.JsonRpcProvider('http://localhost:8545');

	useEffect(() => {
		const fetchChallenges = async () => {
			setLoading(true);
			try {
				const contract = new ethers.Contract(
					programmingCompetitionAddress,
					programmingCompetitionAbi,
					rpcProvider
				);

				const problemIds: BigInt[] = await contract.getAllProblemIds();

				const fetched: Challenge[] = await Promise.all(
					problemIds.map(async (id) => {
						const challenge = await contract.getProblem(id);
						return {
							id,
							title: challenge.title,
							description: challenge.description
						};
					})
				);

				setChallenges(fetched);
			} catch (error) {
				console.error('Failed to fetch challenges:', error);
			} finally {
				setLoading(false);
			}
		};

		fetchChallenges();
	}, []);

	return (
		<div className="min-h-screen bg-gray-50 dark:bg-gray-950">
			<main className="max-w-2xl mx-auto py-8 px-4">
				<h1 className="text-3xl font-bold mb-6 text-center text-gray-900 dark:text-gray-100">
					Programming Challenges
				</h1>

				{loading ? (
					<p className="text-center text-gray-600 dark:text-gray-300">Loading...</p>
				) : challenges.length === 0 ? (
					<p className="text-center text-gray-600 dark:text-gray-300">No challenges found.</p>
				) : (
					<div className="space-y-6">
						{challenges.map((challenge) => (
							<div
								key={challenge.id.toString()}
								className="bg-white dark:bg-gray-900 rounded shadow p-6 flex flex-col gap-2 border border-gray-200 dark:border-gray-800"
							>
								<h2 className="text-xl font-semibold text-gray-900 dark:text-gray-100">
									{challenge.title}
								</h2>
								<p className="text-gray-600 dark:text-gray-300">
									{challenge.description}
								</p>
								<Link
									href={`/challenges/${challenge.id.toString()}`}
									className="self-end text-blue-600 dark:text-blue-400 hover:underline font-medium mt-2"
								>
									View Challenge →
								</Link>
							</div>
						))}
					</div>
				)}
			</main>
		</div>
	);
}
