'use client';
import { useTheme } from 'next-themes';
import { useEffect, useState } from 'react';

export default function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => setMounted(true), []);

  if (!mounted) return null;

  const isDark = theme === 'dark';

  return (
    <button
      className="ml-4 px-3 py-1 rounded bg-gray-800 text-gray-100 dark:bg-gray-200 dark:text-gray-900 border border-gray-600 dark:border-gray-400 transition"
      onClick={() => setTheme(isDark ? 'light' : 'dark')}
      aria-label="Toggle dark mode"
      type="button"
    >
      {isDark ? '☀️ Light' : '🌙 Dark'}
    </button>
  );
}
