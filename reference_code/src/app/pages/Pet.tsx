import { useState, useEffect } from 'react';
import { Navigation } from '../components/Navigation';
import { VirtualPet } from '../components/VirtualPet';
import { Card } from '../components/ui/card';
import { getAppData, hasLoggedToday } from '../utils/storage';
import { Button } from '../components/ui/button';
import { useNavigate, useLocation } from 'react-router';

export function Pet() {
  const [streak, setStreak] = useState(0);
  const [longestStreak, setLongestStreak] = useState(0);
  const [logged, setLogged] = useState(false);
  const [justLogged, setJustLogged] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const data = getAppData();
    setStreak(data.currentStreak);
    setLongestStreak(data.longestStreak);
    setLogged(hasLoggedToday());
    
    // Check if user just logged in
    if (location.state?.justLogged) {
      setJustLogged(true);
      // Reset the justLogged state after a moment
      setTimeout(() => setJustLogged(false), 5000);
    }
  }, [location]);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 pb-20">
      <div className="max-w-4xl mx-auto p-4 pt-8">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Your Pet</h1>
          <p className="text-gray-600">Keep logging daily to keep your pet happy!</p>
        </div>

        {/* Pet Card */}
        <Card className="p-8 mb-6">
          <VirtualPet streak={streak} hasLoggedToday={logged} justLogged={justLogged} />
        </Card>

        {/* Stats */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          <Card className="p-4 text-center">
            <div className="text-3xl font-bold text-blue-600">{streak}</div>
            <div className="text-sm text-gray-600">Current Streak</div>
          </Card>
          <Card className="p-4 text-center">
            <div className="text-3xl font-bold text-purple-600">{longestStreak}</div>
            <div className="text-sm text-gray-600">Longest Streak</div>
          </Card>
        </div>

        {/* CTA */}
        {!logged && (
          <Card className="p-6 text-center bg-yellow-50 border-yellow-200">
            <p className="text-gray-700 mb-4">
              Your pet is waiting for your daily check-in!
            </p>
            <Button onClick={() => navigate('/')} variant="default">
              Check In Now
            </Button>
          </Card>
        )}
      </div>

      <Navigation />
    </div>
  );
}