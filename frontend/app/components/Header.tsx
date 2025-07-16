import React from 'react';
import AccordionMenu from './AccordionMenu';
import ConnectWalletButton from './ConnectWalletButton';
import ThemeToggle from './ThemeToggle';
import Link from "next/link";

export default function Header() {
  return (
    <header className="w-full flex items-center justify-between px-6 py-4 bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800 shadow-sm">
      <div className="flex items-center">
        <AccordionMenu />
        <Link href="/" className="ml-4 text-2xl font-bold text-blue-700 dark:text-blue-300">
          Code Challenge DApp
        </Link>
      </div>
      <div className="flex items-center gap-2">
        <ConnectWalletButton />
        <ThemeToggle />
      </div>
    </header>
  );
}
