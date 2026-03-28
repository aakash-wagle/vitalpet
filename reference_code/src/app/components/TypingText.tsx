import { useState, useEffect } from 'react';
import { motion } from 'motion/react';

interface TypingTextProps {
  text: string;
  speed?: number;
}

export function TypingText({ text, speed = 50 }: TypingTextProps) {
  const [displayedText, setDisplayedText] = useState('');
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    if (currentIndex < text.length) {
      const timeout = setTimeout(() => {
        setDisplayedText(prev => prev + text[currentIndex]);
        setCurrentIndex(prev => prev + 1);
      }, speed);

      return () => clearTimeout(timeout);
    } else {
      // Reset and loop after a pause
      const timeout = setTimeout(() => {
        setDisplayedText('');
        setCurrentIndex(0);
      }, 2000);

      return () => clearTimeout(timeout);
    }
  }, [currentIndex, text, speed]);

  return (
    <span className="font-medium">
      {displayedText}
      <motion.span
        animate={{ opacity: [1, 0] }}
        transition={{ duration: 0.5, repeat: Infinity, repeatType: 'reverse' }}
      >
        |
      </motion.span>
    </span>
  );
}
