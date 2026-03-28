import { useState, useEffect } from 'react';
import { format } from 'date-fns';
import { Navigation } from '../components/Navigation';
import { Card } from '../components/ui/card';
import { Button } from '../components/ui/button';
import { getLogsForLast30Days, getAppData } from '../utils/storage';
import { Download, Share2 } from 'lucide-react';
import { toast } from 'sonner';

export function Report() {
  const [logs, setLogs] = useState<any[]>([]);
  const [stats, setStats] = useState({
    totalLogs: 0,
    averageFeeling: '',
    streak: 0,
    mostCommonSymptom: '',
  });

  useEffect(() => {
    const last30DaysLogs = getLogsForLast30Days();
    setLogs(last30DaysLogs);

    // Calculate stats
    const data = getAppData();
    const feelings = last30DaysLogs.map((log) => log.initialFeeling);
    const symptoms = last30DaysLogs
      .map((log) => log.responses['symptoms'])
      .filter((s) => s && s !== 'None');

    const feelingCounts: Record<string, number> = {};
    feelings.forEach((f) => {
      feelingCounts[f] = (feelingCounts[f] || 0) + 1;
    });

    const symptomCounts: Record<string, number> = {};
    symptoms.forEach((s) => {
      symptomCounts[s] = (symptomCounts[s] || 0) + 1;
    });

    const mostCommonFeeling = Object.keys(feelingCounts).reduce(
      (a, b) => (feelingCounts[a] > feelingCounts[b] ? a : b),
      'N/A'
    );

    const mostCommonSymptom =
      Object.keys(symptomCounts).length > 0
        ? Object.keys(symptomCounts).reduce((a, b) =>
            symptomCounts[a] > symptomCounts[b] ? a : b
          )
        : 'None reported';

    setStats({
      totalLogs: last30DaysLogs.length,
      averageFeeling: mostCommonFeeling,
      streak: data.currentStreak,
      mostCommonSymptom,
    });
  }, []);

  const generateReportText = () => {
    let report = `WellBeing Tracker - 30 Day Report\n`;
    report += `Generated: ${format(new Date(), 'MMM dd, yyyy')}\n\n`;
    report += `=== Summary ===\n`;
    report += `Total Check-ins: ${stats.totalLogs}\n`;
    report += `Current Streak: ${stats.streak} days\n`;
    report += `Most Common Feeling: ${stats.averageFeeling}\n`;
    report += `Most Common Symptom: ${stats.mostCommonSymptom}\n\n`;
    report += `=== Daily Logs ===\n\n`;

    logs.forEach((log) => {
      report += `Date: ${format(new Date(log.timestamp), 'MMM dd, yyyy')}\n`;
      report += `Feeling: ${log.initialFeeling}\n`;
      Object.entries(log.responses).forEach(([key, value]) => {
        if (key !== 'initial') {
          report += `  ${key}: ${value}\n`;
        }
      });
      report += `\n`;
    });

    return report;
  };

  const handleDownload = () => {
    const reportText = generateReportText();
    const blob = new Blob([reportText], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `wellbeing-report-${format(new Date(), 'yyyy-MM-dd')}.txt`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    toast.success('Report downloaded!');
  };

  const handleShare = async () => {
    const reportText = generateReportText();

    if (navigator.share) {
      try {
        await navigator.share({
          title: 'WellBeing Report',
          text: reportText,
        });
        toast.success('Report shared!');
      } catch (err) {
        // User cancelled or error occurred
        console.error('Share failed:', err);
      }
    } else {
      // Fallback: copy to clipboard
      navigator.clipboard.writeText(reportText);
      toast.success('Report copied to clipboard!');
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 pb-20">
      <div className="max-w-4xl mx-auto p-4 pt-8">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">30-Day Report</h1>
          <p className="text-gray-600">Share with your doctor</p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          <Card className="p-4 text-center">
            <div className="text-3xl font-bold text-blue-600">{stats.totalLogs}</div>
            <div className="text-sm text-gray-600">Check-ins</div>
          </Card>
          <Card className="p-4 text-center">
            <div className="text-3xl font-bold text-purple-600">{stats.streak}</div>
            <div className="text-sm text-gray-600">Current Streak</div>
          </Card>
          <Card className="p-4 text-center col-span-2">
            <div className="text-xl font-bold text-green-600">{stats.averageFeeling}</div>
            <div className="text-sm text-gray-600">Most Common Feeling</div>
          </Card>
        </div>

        {/* Report Preview */}
        <Card className="p-6 mb-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Report Preview</h2>
          <div className="bg-gray-50 p-4 rounded-lg max-h-64 overflow-y-auto">
            <pre className="text-sm text-gray-700 whitespace-pre-wrap font-mono">
              {logs.length > 0 ? generateReportText() : 'No data for the last 30 days.'}
            </pre>
          </div>
        </Card>

        {/* Actions */}
        {logs.length > 0 && (
          <div className="flex gap-3">
            <Button onClick={handleDownload} className="flex-1" variant="default">
              <Download className="w-4 h-4 mr-2" />
              Download Report
            </Button>
            <Button onClick={handleShare} className="flex-1" variant="outline">
              <Share2 className="w-4 h-4 mr-2" />
              Share Report
            </Button>
          </div>
        )}
      </div>

      <Navigation />
    </div>
  );
}
