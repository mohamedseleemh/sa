import React, { useState } from 'react';
import {
  Shield, Settings, Package, CreditCard, Inbox, BarChart3, RefreshCw,
  Users, FileText, Database, Palette, Edit3, User, Move, Paintbrush,
  Sliders, Grip, Layers, Layout, Grid
} from 'lucide-react';
import LoginForm from './LoginForm';
import Dashboard from './Dashboard';
import ServicesManager from './ServicesManager';
import PaymentMethodsManager from './PaymentMethodsManager';
import OrdersManager from './OrdersManager';
import SiteSettingsManager from './SiteSettingsManager';
import AdminSettingsManager from './AdminSettingsManager';
import DragDropManager from './DragDropManager';
import ThemeManager from './ThemeManager';
import LandingPageEditor from './LandingPageEditor';
import ServicesLayoutEditor from './ServicesLayoutEditor';
import { AnalyticsPanel } from './AnalyticsPanel';
import UsersManager from './UsersManager';
import ReportsManager from './ReportsManager';
import { BackupManager } from './BackupManager';
import LandingPageCustomizer from './LandingPageCustomizer';
import PageBuilder from './VisualEditor/PageBuilder';
import { useData } from '../../context/DataContext';
import { useTheme } from '../../context/ThemeContext';

type TabType = 'dashboard' | 'services' | 'services-layout' | 'payments' | 'orders' | 'analytics' | 'users' | 'reports' | 'backup' | 'customizer' | 'builder' | 'landing-editor' | 'drag-drop' | 'themes' | 'admin-settings' | 'settings';

const AdminPanel: React.FC = () => {
  const { refreshData, loading } = useData();
  const { language } = useTheme();
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [activeTab, setActiveTab] = useState<TabType>('dashboard');

  const handleLogin = () => {
    setIsAuthenticated(true);
  };

  const handleLogout = () => {
    setIsAuthenticated(false);
    setActiveTab('dashboard');
  };

  if (!isAuthenticated) {
    return <LoginForm onLogin={handleLogin} />;
  }

  const tabs = [
    { id: 'dashboard' as TabType, name: 'لوحة الت��كم', icon: Shield },
    { id: 'builder' as TabType, name: 'منشئ الصفحات', icon: Edit3 },
    { id: 'landing-editor' as TabType, name: 'محرر الهبوط', icon: Layout },
    { id: 'services' as TabType, name: 'إدارة الخدمات', icon: Package },
    { id: 'services-layout' as TabType, name: 'تخطيط الخدمات', icon: Grid },
    { id: 'payments' as TabType, name: 'طرق الدفع', icon: CreditCard },
    { id: 'orders' as TabType, name: 'الطلبات', icon: Inbox },
    { id: 'analytics' as TabType, name: 'التحليلات', icon: BarChart3 },
    { id: 'drag-drop' as TabType, name: 'السحب والإفلات', icon: Move },
    { id: 'themes' as TabType, name: 'الثيمات', icon: Paintbrush },
    { id: 'users' as TabType, name: 'إدارة المستخدمين', icon: Users },
    { id: 'reports' as TabType, name: 'التقارير', icon: FileText },
    { id: 'backup' as TabType, name: 'النسخ الاحتياطية', icon: Database },
    { id: 'customizer' as TabType, name: 'تخصيص الموقع', icon: Palette },
    { id: 'admin-settings' as TabType, name: 'إعدادات المدير', icon: User },
    { id: 'settings' as TabType, name: 'إعدادات الموقع', icon: Settings },
  ];

  const renderContent = () => {
    switch (activeTab) {
      case 'dashboard':
        return <Dashboard />;
      case 'builder':
        return <PageBuilder />;
      case 'landing-editor':
        return <LandingPageEditor />;
      case 'services':
        return <ServicesManager />;
      case 'services-layout':
        return <ServicesLayoutEditor />;
      case 'payments':
        return <PaymentMethodsManager />;
      case 'orders':
        return <OrdersManager />;
      case 'analytics':
        return <AnalyticsPanel />;
      case 'drag-drop':
        return <DragDropManager />;
      case 'themes':
        return <ThemeManager />;
      case 'users':
        return <UsersManager />;
      case 'reports':
        return <ReportsManager />;
      case 'backup':
        return <BackupManager />;
      case 'customizer':
        return <LandingPageCustomizer />;
      case 'admin-settings':
        return <AdminSettingsManager />;
      case 'settings':
        return <SiteSettingsManager />;
      default:
        return <Dashboard />;
    }
  };

  return (
    <div className="min-h-screen bg-gray-50" dir={language === 'ar' ? 'rtl' : 'ltr'}>
      <div className="flex">
        {/* Sidebar */}
        <div className="w-64 bg-white shadow-lg">
          <div className="p-6 border-b border-gray-200">
            <div className="flex items-center space-x-reverse space-x-3">
              <div className="bg-gradient-to-r from-blue-600 to-indigo-600 p-2 rounded-lg">
                <Shield className="h-6 w-6 text-white" />
              </div>
              <div>
                <h1 className="text-lg font-bold text-gray-900">KYCtrust</h1>
                <p className="text-sm text-gray-600">لوحة التحكم</p>
              </div>
            </div>
          </div>
          
          <nav className="mt-6 px-3">
            <div className="space-y-1">
              {tabs.map((tab) => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`w-full flex items-center px-3 py-3 text-sm font-medium rounded-lg transition-colors ${
                    activeTab === tab.id
                      ? 'bg-blue-50 text-blue-700 border-l-4 border-blue-700'
                      : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                  }`}
                >
                  <tab.icon className={`ml-3 h-5 w-5 ${
                    activeTab === tab.id ? 'text-blue-700' : 'text-gray-400'
                  }`} />
                  {tab.name}
                </button>
              ))}
            </div>
          </nav>
          
          {/* Logout Button */}
          <div className="absolute bottom-0 w-64 p-4 border-t border-gray-200 bg-white">
            <div className="flex items-center justify-between">
              <button
                onClick={refreshData}
                disabled={loading}
                className="p-2 text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors disabled:opacity-50"
                title="تحديث البيانات"
              >
                <RefreshCw className={`h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
              </button>
              
              <button
                onClick={handleLogout}
                className="px-4 py-2 text-sm font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors"
              >
                تسجيل الخروج
              </button>
            </div>
          </div>
        </div>

        {/* Main Content */}
        <div className="flex-1 p-8">
          {renderContent()}
        </div>
      </div>
    </div>
  );
};

export default AdminPanel;
