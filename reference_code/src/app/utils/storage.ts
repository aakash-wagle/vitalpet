export interface HealthLog {
  id: string;
  date: string;
  timestamp: number;
  initialFeeling: string;
  responses: Record<string, string>;
  completed: boolean;
}

export interface AppData {
  logs: HealthLog[];
  currentStreak: number;
  longestStreak: number;
  lastLogDate: string | null;
  petName: string;
  lastLogTimestamp: number | null;
}

const STORAGE_KEY = 'wellbeing-tracker-data';

export const getAppData = (): AppData => {
  const stored = localStorage.getItem(STORAGE_KEY);
  if (stored) {
    return JSON.parse(stored);
  }
  return {
    logs: [],
    currentStreak: 0,
    longestStreak: 0,
    lastLogDate: null,
    petName: 'Buddy',
    lastLogTimestamp: null,
  };
};

export const saveAppData = (data: AppData): void => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
};

export const addHealthLog = (log: HealthLog): void => {
  const data = getAppData();
  data.logs.push(log);
  
  // Update streak
  const today = new Date().toDateString();
  const yesterday = new Date(Date.now() - 86400000).toDateString();
  
  if (data.lastLogDate === yesterday || data.lastLogDate === null) {
    data.currentStreak += 1;
  } else if (data.lastLogDate !== today) {
    data.currentStreak = 1;
  }
  
  data.longestStreak = Math.max(data.longestStreak, data.currentStreak);
  data.lastLogDate = today;
  data.lastLogTimestamp = Date.now();
  
  saveAppData(data);
};

export const hasLoggedToday = (): boolean => {
  const data = getAppData();
  const today = new Date().toDateString();
  return data.lastLogDate === today;
};

export const getLogsForLast30Days = (): HealthLog[] => {
  const data = getAppData();
  const thirtyDaysAgo = Date.now() - (30 * 24 * 60 * 60 * 1000);
  return data.logs.filter(log => log.timestamp >= thirtyDaysAgo);
};

export const setPetName = (name: string): void => {
  const data = getAppData();
  data.petName = name;
  saveAppData(data);
};

export const getDaysSinceLastLog = (): number | null => {
  const data = getAppData();
  if (!data.lastLogTimestamp) return null;
  const daysSince = Math.floor((Date.now() - data.lastLogTimestamp) / (24 * 60 * 60 * 1000));
  return daysSince;
};