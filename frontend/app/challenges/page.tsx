import Link from 'next/link';

// Placeholder challenge data
const challenges = [
	{
		id: 1,
		title: 'Sum of Two Numbers',
		description: 'Write a function that returns the sum of two numbers.',
	},
	{
		id: 2,
		title: 'Reverse a String',
		description: 'Reverse the given string.',
	},
	{
		id: 3,
		title: 'Find Maximum',
		description: 'Find the maximum value in an array.',
	},
];

export default function ChallengesPage() {
	return (
		<div className="min-h-screen bg-gray-50 dark:bg-gray-950">
			<main className="max-w-2xl mx-auto py-8 px-4">
				<h1 className="text-3xl font-bold mb-6 text-center text-gray-900 dark:text-gray-100">
					Programming Challenges
				</h1>
				<div className="space-y-6">
					{challenges.map((challenge) => (
						<div
							key={challenge.id}
							className="bg-white dark:bg-gray-900 rounded shadow p-6 flex flex-col gap-2 border border-gray-200 dark:border-gray-800"
						>
							<h2 className="text-xl font-semibold text-gray-900 dark:text-gray-100">
								{challenge.title}
							</h2>
							<p className="text-gray-600 dark:text-gray-300">
								{challenge.description}
							</p>
							<Link
								href={`/challenges/${challenge.id}`}
								className="self-end text-blue-600 dark:text-blue-400 hover:underline font-medium mt-2"
							>
								View Challenge →
							</Link>
						</div>
					))}
				</div>
			</main>
		</div>
	);
}
