import { useState, useEffect } from 'react';
import { format } from 'date-fns';
import { Navigation } from '../components/Navigation';
import { Card } from '../components/ui/card';
import { getAppData, HealthLog } from '../utils/storage';
import { ChevronDown, ChevronUp } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

export function History() {
  const [logs, setLogs] = useState<HealthLog[]>([]);
  const [expandedLog, setExpandedLog] = useState<string | null>(null);

  useEffect(() => {
    const data = getAppData();
    // Sort logs by timestamp descending (most recent first)
    const sortedLogs = [...data.logs].sort((a, b) => b.timestamp - a.timestamp);
    setLogs(sortedLogs);
  }, []);

  const toggleExpand = (id: string) => {
    setExpandedLog(expandedLog === id ? null : id);
  };

  const getFeelingColor = (feeling: string) => {
    const colors: Record<string, string> = {
      'Great': 'bg-green-100 text-green-800',
      'Good': 'bg-blue-100 text-blue-800',
      'Okay': 'bg-yellow-100 text-yellow-800',
      'Not Great': 'bg-orange-100 text-orange-800',
      'Poor': 'bg-red-100 text-red-800',
    };
    return colors[feeling] || 'bg-gray-100 text-gray-800';
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 pb-20">
      <div className="max-w-4xl mx-auto p-4 pt-8">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">History</h1>
          <p className="text-gray-600">Your check-in history</p>
        </div>

        {/* Logs */}
        {logs.length === 0 ? (
          <Card className="p-8 text-center">
            <p className="text-gray-600">No check-ins yet. Start your first one!</p>
          </Card>
        ) : (
          <div className="space-y-3">
            {logs.map((log) => (
              <Card key={log.id} className="overflow-hidden">
                <button
                  onClick={() => toggleExpand(log.id)}
                  className="w-full p-4 text-left hover:bg-gray-50 transition-colors"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-2">
                        <span className="text-sm text-gray-600">
                          {format(new Date(log.timestamp), 'MMM dd, yyyy')}
                        </span>
                        <span
                          className={`px-2 py-1 rounded-full text-xs font-medium ${getFeelingColor(
                            log.initialFeeling
                          )}`}
                        >
                          {log.initialFeeling}
                        </span>
                      </div>
                      <div className="text-sm text-gray-500">
                        {format(new Date(log.timestamp), 'h:mm a')}
                      </div>
                    </div>
                    {expandedLog === log.id ? (
                      <ChevronUp className="w-5 h-5 text-gray-400" />
                    ) : (
                      <ChevronDown className="w-5 h-5 text-gray-400" />
                    )}
                  </div>
                </button>

                <AnimatePresence>
                  {expandedLog === log.id && (
                    <motion.div
                      initial={{ height: 0, opacity: 0 }}
                      animate={{ height: 'auto', opacity: 1 }}
                      exit={{ height: 0, opacity: 0 }}
                      transition={{ duration: 0.2 }}
                      className="border-t border-gray-200"
                    >
                      <div className="p-4 space-y-2 bg-gray-50">
                        {Object.entries(log.responses).map(([key, value]) => (
                          <div key={key} className="text-sm">
                            <span className="font-medium text-gray-700 capitalize">
                              {key}:
                            </span>{' '}
                            <span className="text-gray-600">{value}</span>
                          </div>
                        ))}
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </Card>
            ))}
          </div>
        )}
      </div>

      <Navigation />
    </div>
  );
}
