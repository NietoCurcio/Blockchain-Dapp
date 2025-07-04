"use client";
import { createContext, useContext, useEffect, useState, ReactNode } from "react";
import { ethers } from "ethers";

interface WalletContextType {
  account: string | null;
  provider: ethers.BrowserProvider | null;
  signer: ethers.Signer | null;
  connect: () => Promise<void>;
  error: string | null;
}

const WalletContext = createContext<WalletContextType | undefined>(undefined);

export function WalletProvider({ children }: { children: ReactNode }) {
  const [account, setAccount] = useState<string | null>(null);
  const [provider, setProvider] = useState<ethers.BrowserProvider | null>(null);
  const [signer, setSigner] = useState<ethers.Signer | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const connect = async () => {
    if (typeof window === "undefined" || !(window as any).ethereum) {
      setError("MetaMask not detected");
      return;
    }
    try {
      const _provider = new ethers.BrowserProvider((window as any).ethereum);
      const accounts = await _provider.send("eth_requestAccounts", []);
      const _signer = await _provider.getSigner();
      setProvider(_provider);
      setSigner(_signer);
      setAccount(accounts[0]);
      setError(null);
    } catch (err: any) {
      setError(err.message || "Connection failed");
    }
  };

  if (!mounted) return null;

  return (
    <WalletContext.Provider value={{ account, provider, signer, connect, error }}>
      {children}
    </WalletContext.Provider>
  );
}

export function useWallet() {
  const ctx = useContext(WalletContext);
  if (!ctx) throw new Error("useWallet must be used within a WalletProvider");
  return ctx;
}
