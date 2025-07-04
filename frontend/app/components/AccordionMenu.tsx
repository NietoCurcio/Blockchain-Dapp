'use client'

import React, { useState } from 'react';
import Link from 'next/link';

const navItems = [
  { label: 'Home', href: '/' },
  { label: 'My Challenges', href: '/my-challenges' },
  { label: 'Create Challenge', href: '/challenges/new' },
  { label: 'Challenges', href: '/challenges' },
];

export default function AccordionMenu() {
  const [open, setOpen] = useState(false);

  return (
    <div className="relative">
      <button
        className="px-4 py-2 text-lg font-semibold bg-gray-100 dark:bg-gray-800 dark:text-gray-100 rounded hover:bg-gray-200 dark:hover:bg-gray-700 border border-gray-300 dark:border-gray-700"
        onClick={() => setOpen(!open)}
        aria-expanded={open}
      >
        ☰ Menu
      </button>
      {open && (
        <div className="absolute left-0 mt-2 w-48 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded shadow-lg z-10">
          {navItems.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-800 dark:text-gray-100"
              onClick={() => setOpen(false)}
            >
              {item.label}
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
