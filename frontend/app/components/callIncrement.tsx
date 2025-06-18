'use client'

import { useState } from 'react'
import { ethers } from 'ethers'
import ConnectButton from './connectButton'

// ABI with just the increment function
const abi = [
    "function increment() external"
]

const CONTRACT_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3"

export default function Page() {
    const [provider, setProvider] = useState<ethers.BrowserProvider | null>(null)
    const [signer, setSigner] = useState<ethers.Signer | null>(null)

    const handleConnect = (prov: ethers.BrowserProvider, sig: ethers.Signer) => {
        setProvider(prov)
        setSigner(sig)
    }

    const sendIncrementTx = async () => {
        if (!provider || !signer) {
            alert('Connect your wallet first')
            return
        }

        try {
            const contract = new ethers.Contract(CONTRACT_ADDRESS, abi, signer)
            const tx = await contract.increment()
            await tx.wait()
            alert('Transaction confirmed!')
        } catch (err) {
            console.error(err)
            alert('Transaction failed!')
        }
    }

    return (
        <main className="p-8">
            <h1 className="text-2xl font-bold mb-4">Hello, Next.js!</h1>
            <ConnectButton onConnected={handleConnect} />
            <button
                onClick={sendIncrementTx}
                className="ml-4 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            >
                Increment
            </button>
        </main>
    )
}
