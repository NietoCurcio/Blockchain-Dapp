import Header from './components/Header';
import COMPONENT from './components/callIncrement';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
      <Header />
      <main className="max-w-2xl mx-auto py-8 px-4">
        <h1 className="text-3xl font-bold mb-6 text-center text-gray-900 dark:text-gray-100">Welcome to the Code Challenge DApp</h1>
        <p className="text-center text-gray-600 dark:text-gray-300 mb-8">Solve programming challenges, compete, and earn rewards on the blockchain.</p>
        <div className="flex justify-center">
          <a href="/challenges" className="px-6 py-3 bg-blue-600 dark:bg-blue-500 text-white dark:text-gray-100 rounded shadow hover:bg-blue-700 dark:hover:bg-blue-600 font-semibold">View Challenges</a>
        </div>
      </main>
    </div>
  );
}