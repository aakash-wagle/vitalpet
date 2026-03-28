import { useState, useEffect } from 'react';
import { motion } from 'motion/react';
import { TypingText } from './TypingText';
import { getDaysSinceLastLog, getAppData, setPetName } from '../utils/storage';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from './ui/dialog';

// Import dog images
import celebratingDog from 'figma:asset/16365d4785783360057d853d2e363928f1a6be4f.png';
import greetingDog from 'figma:asset/88f1f3f4267b365b32de1cb31bc3ba26e30587a6.png';
import sadDog from 'figma:asset/a25b46980ca5d8cb61c683d8dd1eb5dc371b1b53.png';
import depressedDog from 'figma:asset/5918d0dc1879024b63987294af6545d0d7907f0d.png';
import deadDog from 'figma:asset/7e38f0c24443ca9b870ade063dc35fa8765e3f02.png';

type PetState = 'celebrating' | 'greeting' | 'sad' | 'depressed' | 'dead';

interface VirtualPetProps {
  streak: number;
  hasLoggedToday: boolean;
  justLogged?: boolean;
}

export function VirtualPet({ streak, hasLoggedToday, justLogged = false }: VirtualPetProps) {
  const [petState, setPetState] = useState<PetState>('greeting');
  const [petName, setPetNameState] = useState('Buddy');
  const [showNameDialog, setShowNameDialog] = useState(false);
  const [newName, setNewName] = useState('');
  const [wasDead, setWasDead] = useState(false);

  useEffect(() => {
    const data = getAppData();
    setPetNameState(data.petName);

    // Determine pet state based on days since last log
    const daysSince = getDaysSinceLastLog();

    // If just logged, show celebrating for a moment
    if (justLogged) {
      const wasPreviouslyDead = daysSince !== null && daysSince > 10;
      setWasDead(wasPreviouslyDead);
      
      if (wasPreviouslyDead) {
        // Dog was dead, need to rename
        setShowNameDialog(true);
      }
      
      setPetState('celebrating');
      return;
    }

    if (daysSince === null || daysSince <= 2) {
      setPetState('greeting');
    } else if (daysSince <= 5) {
      setPetState('sad');
    } else if (daysSince <= 10) {
      setPetState('depressed');
    } else {
      setPetState('dead');
    }
  }, [hasLoggedToday, justLogged]);

  const getPetImage = () => {
    switch (petState) {
      case 'celebrating':
        return celebratingDog;
      case 'greeting':
        return greetingDog;
      case 'sad':
        return sadDog;
      case 'depressed':
        return depressedDog;
      case 'dead':
        return deadDog;
      default:
        return greetingDog;
    }
  };

  const getMessage = () => {
    switch (petState) {
      case 'celebrating':
        return wasDead 
          ? `Welcome back! I'm ${petName}, your new companion!`
          : `${petName}: Yay! Thanks for checking in!`;
      case 'greeting':
        return `${petName}: Hey! Great to see you!`;
      case 'sad':
        return `${petName}: I miss you... please check in soon`;
      case 'depressed':
        return `${petName}: Where have you been? I'm really worried...`;
      case 'dead':
        return `${petName} has passed away... 💔`;
      default:
        return `${petName}: Hello!`;
    }
  };

  const handleNameSubmit = () => {
    if (newName.trim()) {
      setPetName(newName.trim());
      setPetNameState(newName.trim());
      setShowNameDialog(false);
      setWasDead(false);
    }
  };

  return (
    <>
      <div className="flex flex-col items-center space-y-6">
        {/* Pet Image with rocking animation */}
        <motion.div
          animate={{
            rotate: [-2, 2, -2],
          }}
          transition={{
            duration: 2,
            repeat: Infinity,
            ease: 'easeInOut',
          }}
          className="relative"
        >
          <motion.img
            key={petState}
            src={getPetImage()}
            alt="Virtual Pet"
            className="w-64 h-64 object-contain"
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ duration: 0.3 }}
          />
        </motion.div>

        {/* Typing Message */}
        <div className="text-center max-w-md min-h-[60px] flex items-center justify-center">
          <p className="text-lg text-gray-700">
            <TypingText text={getMessage()} speed={50} />
          </p>
        </div>

        {/* Streak Display */}
        <div className="text-center">
          <div className="text-4xl font-bold text-blue-600">{streak}</div>
          <div className="text-sm text-gray-600">Day Streak 🔥</div>
        </div>
      </div>

      {/* Name Dialog */}
      <Dialog open={showNameDialog} onOpenChange={setShowNameDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Welcome Your New Pet!</DialogTitle>
            <DialogDescription>
              Your previous pet has passed away. But good news - you have a new companion! What would you like to name them?
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 pt-4">
            <Input
              value={newName}
              onChange={(e) => setNewName(e.target.value)}
              placeholder="Enter pet name..."
              onKeyPress={(e) => e.key === 'Enter' && handleNameSubmit()}
            />
            <Button onClick={handleNameSubmit} className="w-full">
              Meet My New Pet
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}
