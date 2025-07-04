'use client'
import { useParams } from 'next/navigation';

// Placeholder challenge data (should be replaced with real data or fetched from contract)
const challenges = [
  {
    id: '1',
    title: 'Sum of Two Numbers',
    description: 'Write a function that returns the sum of two numbers.'
  },
  {
    id: '2',
    title: 'Reverse a String',
    description: 'Reverse the given string.'
  },
  {
    id: '3',
    title: 'Find Maximum',
    description: 'Find the maximum value in an array.'
  }
];

export default function ChallengeDetailPage() {
  const params = useParams();
  const id = Array.isArray(params.id) ? params.id[0] : params.id;
  const challenge = challenges.find((c) => c.id === id);

  if (!challenge) {
    return (
      <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
        <main className="max-w-2xl mx-auto py-8 px-4">
          <h1 className="text-2xl font-bold text-gray-900 dark:text-gray-100">Challenge Not Found</h1>
        </main>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
      <main className="max-w-2xl mx-auto py-8 px-4">
        <h1 className="text-3xl font-bold mb-4 text-gray-900 dark:text-gray-100">{challenge.title}</h1>
        <p className="text-gray-700 dark:text-gray-300 mb-6">{challenge.description}</p>
        {/* Add more challenge details and interaction here */}
      </main>
    </div>
  );
}
