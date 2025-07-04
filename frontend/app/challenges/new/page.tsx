'use client';
import { useState } from 'react';
import { AbiCoder } from 'ethers/abi';
import { keccak256 } from 'ethers/crypto';
import { parseEther } from 'ethers/utils';
import { useWallet } from '@/app/context/WalletContext';


export default function NewChallengePage() {
  const { signer } = useWallet();

  const [problemId, setProblemId] = useState('');
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [testCases, setTestCases] = useState([
    { inputA: '', inputB: '', expected: '' },
    { inputA: '', inputB: '', expected: '' },
    { inputA: '', inputB: '', expected: '' },
  ]);
  const [status, setStatus] = useState('');

  const abi = new AbiCoder();

  const handleTestChange = (index: number, field: string, value: string) => {
    const newCases = [...testCases];
    newCases[index] = { ...newCases[index], [field]: value };
    setTestCases(newCases);
  };

  const handleSubmit = async () => {
    try {
      if (!signer) throw new Error('Wallet not connected');
      
      const encodedTestCases = testCases.map(tc =>
        abi.encode(['uint256', 'uint256'], [Number(tc.inputA), Number(tc.inputB)])
      );
      
      // Encode all expected outputs
      const allEncodedOutputs = testCases
        .map(tc => abi.encode(['uint256'], [Number(tc.expected)]).replace(/^0x/, ''))
        .join('');

      const finalHash = keccak256(`0x${allEncodedOutputs}`);

      const contractAddress = '0xYourContractAddressHere'; // Substitua pelo endereço do seu contrato
      
      const contractABI = [ // ABI mínima
        'function registerProblem(uint256 problemId, bytes32 expectedResultsHash, bytes[] testCases) external payable',
      ];

      const contract = new (await import('ethers')).Contract(contractAddress, contractABI, signer);

      const tx = await contract.registerProblem(
        Date.now(), // Use timestamp as problemId temporarily
        finalHash,
        encodedTestCases,
        { value: parseEther('0.0001') }
      );

      await tx.wait();
      setStatus('Challenge submitted successfully!');
    } catch (err: any) {
      console.error(err);
      setStatus(`Erro: ${err.message}`);
    }
  };

  return (
    <div className="max-w-3xl mx-auto py-8 px-4">
      <h1 className="text-2xl font-bold mb-4 text-gray-900 dark:text-gray-100">Novo Desafio</h1>

      <label className="block mb-2 font-medium text-gray-700 dark:text-gray-300">Título</label>
      <input
        className="w-full p-2 mb-4 rounded border dark:bg-gray-800 dark:text-white"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
      />

      <label className="block mb-2 font-medium text-gray-700 dark:text-gray-300">Descrição</label>
      <textarea
        className="w-full p-2 mb-4 rounded border dark:bg-gray-800 dark:text-white"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
      />

      <h2 className="text-lg font-semibold mb-2 text-gray-900 dark:text-gray-100">Testes</h2>
      {testCases.map((tc, i) => (
        <div key={i} className="mb-4 p-4 rounded border dark:border-gray-700 bg-gray-50 dark:bg-gray-900">
          <label className="block mb-1 text-sm text-gray-700 dark:text-gray-300">Input A</label>
          <input
            className="w-full p-2 mb-2 rounded dark:bg-gray-800 dark:text-white"
            value={tc.inputA}
            onChange={(e) => handleTestChange(i, 'inputA', e.target.value)}
            type="number"
          />
          <label className="block mb-1 text-sm text-gray-700 dark:text-gray-300">Input B</label>
          <input
            className="w-full p-2 mb-2 rounded dark:bg-gray-800 dark:text-white"
            value={tc.inputB}
            onChange={(e) => handleTestChange(i, 'inputB', e.target.value)}
            type="number"
          />
          <label className="block mb-1 text-sm text-gray-700 dark:text-gray-300">Resultado Esperado</label>
          <input
            className="w-full p-2 rounded dark:bg-gray-800 dark:text-white"
            value={tc.expected}
            onChange={(e) => handleTestChange(i, 'expected', e.target.value)}
            type="number"
          />
        </div>
      ))}

      <button
        onClick={handleSubmit}
        className="mt-4 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded"
      >
        Enviar Desafio
      </button>

      {status && <p className="mt-4 text-sm text-gray-800 dark:text-gray-200">{status}</p>}
    </div>
  );
}
