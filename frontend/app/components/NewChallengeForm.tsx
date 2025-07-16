'use client';
import { useState, FormEvent, ChangeEvent, JSX } from 'react';
import { ethers } from 'ethers';
import { useWallet } from '../context/WalletContext';
import { programmingCompetitionAbi, programmingCompetitionAddress } from "../../constants/contract";

export default function NewChallengeForm(): JSX.Element {
  const { account, signer } = useWallet();
  const [title, setTitle] = useState<string>('');
  const [description, setDescription] = useState<string>('');
  const [testCasesHex, setTestCasesHex] = useState<string>('');
  const [expectedResultsHash, setExpectedResultsHash] = useState<string>('');
  const [prize, setPrize] = useState<string>('');
  const [loading, setLoading] = useState<boolean>(false);
  const [status, setStatus] = useState<string | null>(null);

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setStatus(null);

    try {
      if (!signer) throw new Error('Wallet not connected');

      const contract = new ethers.Contract(
        programmingCompetitionAddress,
        programmingCompetitionAbi,
        signer
      );
      
      const connectedAddress = account;
      const ownerAddress: string = await contract.owner();

      if (connectedAddress?.toLowerCase() !== ownerAddress.toLowerCase()) {
        throw new Error("Only the contract owner can submit a challenge.");
      }
      
      // Fetch current problem IDs to compute next problemId
      const problemIds: bigint[] = await contract.getAllProblemIds();
      const nextProblemId: number = Number(problemIds.length) + 1;

      // Convert stringified hex array into real string[] for testCases
      const testCases: string[] = JSON.parse(testCasesHex);
      if (!Array.isArray(testCases) || testCases.some(tc => typeof tc !== "string")) {
        throw new Error("Test cases must be a JSON array of hex strings");
      }

      await contract.registerProblem(
        BigInt(nextProblemId),
        expectedResultsHash,
        testCases,
        title,
        description,
        { value: ethers.parseEther(prize) }
      );

      setStatus('Challenge submitted successfully!');
      setTitle("");
      setDescription("");
      setTestCasesHex("");
      setExpectedResultsHash("");
    } catch (err: any) {
      console.error(err);
      setStatus(`Error: ${err.message || 'Failed to submit'}`);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-2xl mx-auto py-10 px-4">
      <h1 className="text-2xl font-bold mb-6">Submit New Challenge</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <input
          type="text"
          placeholder="Title"
          value={title}
          onChange={(e: ChangeEvent<HTMLInputElement>) => setTitle(e.target.value)}
          className="w-full px-4 py-2 border rounded"
          required
        />
        <textarea
          placeholder="Description"
          value={description}
          onChange={(e: ChangeEvent<HTMLTextAreaElement>) => setDescription(e.target.value)}
          className="w-full px-4 py-2 border rounded"
          required
        />
        <textarea
          placeholder='Test cases (hex array format, e.g., ["0x1234...", "0xabcd..."])'
          value={testCasesHex}
          onChange={(e: ChangeEvent<HTMLTextAreaElement>) => setTestCasesHex(e.target.value)}
          className="w-full px-4 py-2 border rounded font-mono text-sm"
          required
        />
        <input
          type="text"
          placeholder="Expected Results Hash (bytes32)"
          value={expectedResultsHash}
          onChange={(e: ChangeEvent<HTMLInputElement>) => setExpectedResultsHash(e.target.value)}
          className="w-full px-4 py-2 border rounded font-mono"
          required
        />
        <input
          type="number"
          step="0.01"
          min="0"
          placeholder="Prize in ETH"
          value={prize}
          onChange={(e: ChangeEvent<HTMLInputElement>) => setPrize(e.target.value)}
          className="w-full px-4 py-2 border rounded"
          required
        />
        <button
          type="submit"
          disabled={loading}
          className="px-6 py-2 bg-green-600 text-white rounded hover:bg-green-700 disabled:opacity-50"
        >
          {loading ? "Submitting..." : "Submit Challenge"}
        </button>
        {status && (
          <p
            className={`mt-2 text-sm text-center ${status === 'Challenge submitted successfully!' ? 'text-green-600' : 'text-red-500'}`}
          >
            {status}
          </p>
        )}
      </form>
    </div>
  );
}
