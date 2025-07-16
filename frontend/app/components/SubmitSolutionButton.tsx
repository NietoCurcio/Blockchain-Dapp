'use client';

import { useState } from 'react';
import { useWallet } from '@/app/context/WalletContext';
import { Contract } from 'ethers';

function SubmitSolutionButton() {
  const { signer } = useWallet();
  const [solutionAddress, setSolutionAddress] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');

  const handleSubmit = async () => {
    if (!signer) {
      setMessage("⚠️ Connect your wallet first.");
      return;
    }

    if (!solutionAddress || !/^0x[a-fA-F0-9]{40}$/.test(solutionAddress)) {
      setMessage("⚠️ Enter a valid contract address.");
      return;
    }

    try {
      setLoading(true);
      setMessage("");

      const abi = [
        {
          "type": "function",
          "name": "submitSolution",
          "inputs": [],
          "outputs": [],
          "stateMutability": "nonpayable"
        }
      ];

      const solutionContract = new Contract(solutionAddress, abi, signer);

      const tx = await solutionContract.submitSolution();
      setMessage("⏳ Transaction sent. Waiting for confirmation...");

      const receipt = await tx.wait();
      if (receipt.status === 1) {
        setMessage("✅ Solution submitted successfully!");
      } else {
        setMessage("❌ Transaction failed.");
      }

    } catch (err: any) {
      console.error(err);
      setMessage(err.message || "Error submitting solution.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="mt-8 border-t pt-6">
      <h2 className="text-lg font-semibold mb-4 text-gray-800 dark:text-gray-100">Submit Your Solution</h2>
      <label className="block mb-2 text-sm text-gray-700 dark:text-gray-300">Solution Contract Address</label>
      <input
        type="text"
        placeholder="0xYourSolutionContractAddress"
        value={solutionAddress}
        onChange={(e) => setSolutionAddress(e.target.value)}
        className="w-full px-4 py-2 border rounded text-sm bg-white dark:bg-gray-900 dark:text-white"
        required
      />
      <button
        onClick={handleSubmit}
        disabled={loading}
        className="mt-4 px-6 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50"
      >
        {loading ? "Submitting..." : "Submit Solution"}
      </button>
      {message && <p className="mt-3 text-sm text-center text-gray-600 dark:text-gray-300">{message}</p>}
    </div>
  );
}

export default SubmitSolutionButton;
