import NewChallengeForm from '@/app/components/NewChallengeForm';

export default function NewChallengePage() {
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950">
      <main className="max-w-4xl mx-auto py-10 px-4">
        <NewChallengeForm />
      </main>
    </div>
  );
}
