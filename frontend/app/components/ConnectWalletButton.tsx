"use client";
import { useState } from 'react';
import { ethers } from 'ethers';

export default function ConnectWalletButton() {
  const [account, setAccount] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function connectWallet() {
    if (!(window as any).ethereum) {
      setError('MetaMask not detected');
      return;
    }
    try {
      const provider = new ethers.BrowserProvider((window as any).ethereum);
      const accounts = await provider.send('eth_requestAccounts', []);
      setAccount(accounts[0]);
      setError(null);
    } catch (err: any) {
      setError(err.message || 'Connection failed');
    }
  }

  return (
    <div className="flex items-center gap-2">
      {account ? (
        <span className="text-green-600 dark:text-green-400 font-mono text-sm">{account.slice(0, 6)}...{account.slice(-4)}</span>
      ) : (
        <button
          className="px-4 py-2 bg-blue-600 dark:bg-blue-500 text-white dark:text-gray-100 rounded hover:bg-blue-700 dark:hover:bg-blue-600"
          onClick={connectWallet}
        >
          Connect Wallet
        </button>
      )}
      {error && <span className="text-red-500 dark:text-red-400 text-xs ml-2">{error}</span>}
    </div>
  );
}
