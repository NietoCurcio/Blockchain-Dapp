// app/page.tsx or app/page.js if using JS

'use client'

import { useEffect, useState } from 'react'
import { ethers } from 'ethers'

// ABI with just the increment function
const abi = [
  "function increment() external"
]

const CONTRACT_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3"

export default function Page() {
  const [provider, setProvider] = useState<ethers.BrowserProvider | null>(null)
  const [signer, setSigner] = useState<ethers.Signer | null>(null)

  useEffect(() => {
    if (typeof window.ethereum !== 'undefined') {
      const newProvider = new ethers.BrowserProvider(window.ethereum)
      setProvider(newProvider)

      newProvider.getSigner().then(setSigner)
    }
  }, [])

  const sendIncrementTx = async () => {
    if (!provider || !signer) {
      alert('MetaMask not connected')
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
      <button
        onClick={sendIncrementTx}
        className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
      >
        Increment
      </button>
    </main>
  )
}
