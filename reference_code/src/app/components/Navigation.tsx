import { Activity, Heart, FileText, Home } from 'lucide-react';
import { Link, useLocation } from 'react-router';

export function Navigation() {
  const location = useLocation();

  const navItems = [
    { path: '/', icon: Home, label: 'Check-in' },
    { path: '/pet', icon: Heart, label: 'Pet' },
    { path: '/history', icon: Activity, label: 'History' },
    { path: '/report', icon: FileText, label: 'Report' },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-4 py-3">
      <div className="max-w-4xl mx-auto flex justify-around items-center">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = location.pathname === item.path;
          return (
            <Link
              key={item.path}
              to={item.path}
              className={`flex flex-col items-center gap-1 px-4 py-2 rounded-lg transition-colors ${
                isActive
                  ? 'text-blue-600 bg-blue-50'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              <Icon className="w-6 h-6" />
              <span className="text-xs">{item.label}</span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
