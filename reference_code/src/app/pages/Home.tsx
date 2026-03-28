import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { CheckCircle, Calendar } from 'lucide-react';
import { ChatInterface } from '../components/ChatInterface';
import { Navigation } from '../components/Navigation';
import { Card } from '../components/ui/card';
import { Button } from '../components/ui/button';
import { addHealthLog, hasLoggedToday, getAppData, HealthLog } from '../utils/storage';

export function Home() {
  const [alreadyLogged, setAlreadyLogged] = useState(false);
  const [showChat, setShowChat] = useState(false);
  const [streak, setStreak] = useState(0);
  const navigate = useNavigate();

  useEffect(() => {
    const logged = hasLoggedToday();
    setAlreadyLogged(logged);
    const data = getAppData();
    setStreak(data.currentStreak);
  }, []);

  const handleComplete = (responses: Record<string, string>) => {
    const log: HealthLog = {
      id: Date.now().toString(),
      date: new Date().toLocaleDateString(),
      timestamp: Date.now(),
      initialFeeling: responses['initial'] || '',
      responses,
      completed: true,
    };

    addHealthLog(log);
    setAlreadyLogged(true);
    
    // Refresh streak
    const data = getAppData();
    setStreak(data.currentStreak);

    // Navigate to pet after 2 seconds
    setTimeout(() => {
      navigate('/pet', { state: { justLogged: true } });
    }, 2000);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 pb-20">
      <div className="max-w-4xl mx-auto p-4 pt-8">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            WellBeing Tracker
          </h1>
          <p className="text-gray-600">Take care of yourself, take care of your pet</p>
        </div>

        {/* Already logged today */}
        {alreadyLogged && !showChat ? (
          <Card className="p-8 text-center space-y-4">
            <div className="flex justify-center">
              <CheckCircle className="w-16 h-16 text-green-500" />
            </div>
            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-2">
                Great job!
              </h2>
              <p className="text-gray-600">
                You've already checked in today. Come back tomorrow!
              </p>
            </div>
            <div className="pt-4">
              <div className="inline-flex items-center gap-2 px-4 py-2 bg-blue-50 rounded-full">
                <Calendar className="w-5 h-5 text-blue-600" />
                <span className="font-semibold text-blue-600">
                  {streak} Day Streak 🔥
                </span>
              </div>
            </div>
            <div className="pt-4">
              <Button onClick={() => navigate('/pet')} size="lg">
                Visit Your Pet
              </Button>
            </div>
          </Card>
        ) : !showChat ? (
          <Card className="p-8 text-center space-y-6">
            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-2">
                Ready for your daily check-in?
              </h2>
              <p className="text-gray-600">
                Answer a few questions about how you're feeling today
              </p>
            </div>
            <Button onClick={() => setShowChat(true)} size="lg">
              Start Check-in
            </Button>
          </Card>
        ) : (
          <Card className="h-[600px] overflow-hidden">
            <ChatInterface onComplete={handleComplete} />
          </Card>
        )}
      </div>

      <Navigation />
    </div>
  );
}