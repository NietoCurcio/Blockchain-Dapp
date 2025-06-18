'use client'

import { useEffect, useState } from 'react'
import { ethers } from 'ethers'

type Props = {
    onConnected: (provider: ethers.BrowserProvider, signer: ethers.Signer) => void
}

export default function ConnectButton({ onConnected }: Props) {
    const [account, setAccount] = useState<string | null>(null)

    const connectWallet = async () => {
        if (typeof window.ethereum === 'undefined') {
            alert('MetaMask not detected')
            return
        }

        try {
            const provider = new ethers.BrowserProvider(window.ethereum)
            const accounts = await provider.send('eth_requestAccounts', [])
            const signer = await provider.getSigner()
            setAccount(accounts[0])
            onConnected(provider, signer)
        } catch (err) {
            console.error(err)
            alert('Failed to connect wallet')
        }
    }

    return (
        <button
            onClick={connectWallet}
            className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700"
        >
            {account ? `Connected: ${account.slice(0, 6)}...${account.slice(-4)}` : 'Connect Wallet'}
        </button>
    )
}
