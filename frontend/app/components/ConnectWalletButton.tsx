"use client";
import { useWallet } from '../context/WalletContext';

export default function ConnectWalletButton() {
  const { account, connect, error } = useWallet();

  return (
    <div className="flex items-center gap-2">
      {account ? (
        <span className="text-green-600 dark:text-green-400 font-mono text-sm">{account.slice(0, 6)}...{account.slice(-4)}</span>
      ) : (
        <button
          className="px-4 py-2 bg-blue-600 dark:bg-blue-500 text-white dark:text-gray-100 rounded hover:bg-blue-700 dark:hover:bg-blue-600"
          onClick={connect}
        >
          Connect Wallet
        </button>
      )}
      {error && <span className="text-red-500 text-xs ml-2">{error}</span>}
    </div>
  );
}
