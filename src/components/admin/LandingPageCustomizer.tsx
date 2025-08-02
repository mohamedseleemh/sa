import React, { useState } from 'react';
import { Save, Eye, Settings, Palette, Type, Layout, Image, Sparkles, Move, Plus, Trash2, Edit2, Code, Monitor } from 'lucide-react';
import { useCustomization } from '../../context/CustomizationContext';
import { useTheme } from '../../context/ThemeContext';
import LoadingSpinner from '../ui/LoadingSpinner';
import ErrorMessage from '../ui/ErrorMessage';
import PageBuilder from './VisualEditor/PageBuilder';
import LivePreview from './VisualEditor/LivePreview';
import toast from 'react-hot-toast';

const LandingPageCustomizer: React.FC = () => {
  const { customization, loading, error, updateHeroSection, updateGlobalSettings, refreshCustomization } = useCustomization();
  const { theme } = useTheme();
  const [activeTab, setActiveTab] = useState<'hero' | 'global' | 'sections' | 'features' | 'builder' | 'code'>('hero');
  const [isPreviewMode, setIsPreviewMode] = useState(false);
  const [isLivePreviewOpen, setIsLivePreviewOpen] = useState(false);

  const [heroForm, setHeroForm] = useState(customization?.hero || {
    title: '',
    titleGradient: '',
    subtitle: '',
    button1Text: '',
    button2Text: '',
    badgeText: '',
    showStats: true,
    statsData: {
      clients: '5000+',
      successRate: '99.9%',
      support: '24/7',
      speed: '< 5 دقائق'
    }
  });

  const [globalForm, setGlobalForm] = useState(customization?.globalSettings || {
    primaryColor: '#3b82f6',
    secondaryColor: '#6366f1',
    accentColor: '#8b5cf6',
    fontFamily: 'Cairo',
    borderRadius: '1rem',
    spacing: '1.5rem'
  });

  React.useEffect(() => {
    if (customization) {
      setHeroForm(customization.hero);
      setGlobalForm(customization.globalSettings);
    }
  }, [customization]);

  const handleSaveHero = async () => {
    try {
      await updateHeroSection(heroForm);
      toast.success('تم حفظ إعدادات القسم الرئيسي بنجاح');
    } catch (error) {
      toast.error('فشل في حفظ الإعدادات');
    }
  };

  const handleSaveGlobal = async () => {
    try {
      await updateGlobalSettings(globalForm);
      toast.success('تم حفظ الإعدادات العامة بنجاح');
      
      // Apply global settings to CSS variables
      const root = document.documentElement;
      root.style.setProperty('--primary-color', globalForm.primaryColor);
      root.style.setProperty('--secondary-color', globalForm.secondaryColor);
      root.style.setProperty('--accent-color', globalForm.accentColor);
    } catch (error) {
      toast.error('فشل في حفظ ��لإعدادات');
    }
  };

  const colorPresets = [
    { name: 'Blue Ocean', primary: '#3b82f6', secondary: '#6366f1', accent: '#8b5cf6' },
    { name: 'Green Forest', primary: '#10b981', secondary: '#059669', accent: '#0d9488' },
    { name: 'Purple Galaxy', primary: '#8b5cf6', secondary: '#a855f7', accent: '#c084fc' },
    { name: 'Orange Sunset', primary: '#f59e0b', secondary: '#ea580c', accent: '#dc2626' },
    { name: 'Pink Rose', primary: '#ec4899', secondary: '#be185d', accent: '#9d174d' },
  ];

  if (loading) {
    return <LoadingSpinner size="lg" text="جاري تحميل إعدادات التخصيص..." />;
  }

  if (error) {
    return <ErrorMessage message={error} onRetry={refreshCustomization} />;
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className={`text-2xl font-bold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
            تخصيص صفحة الهبوط
          </h1>
          <p className={theme === 'dark' ? 'text-gray-300' : 'text-gray-600'}>
            قم بتخصيص جميع عناصر صفحة الهبوط والتحكم في التصميم
          </p>
        </div>
        
        <div className="flex items-center space-x-reverse space-x-4">
          <button
            onClick={() => setIsPreviewMode(!isPreviewMode)}
            className={`flex items-center space-x-reverse space-x-2 px-4 py-2 rounded-xl font-medium transition-colors ${
              isPreviewMode
                ? 'bg-blue-600 text-white'
                : theme === 'dark'
                ? 'bg-gray-700 text-gray-300 hover:bg-gray-600'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            <Eye className="h-4 w-4" />
            <span>{isPreviewMode ? 'إنهاء المعاينة' : 'معاينة مباشرة'}</span>
          </button>
          
          <button
            onClick={() => setIsLivePreviewOpen(true)}
            className="bg-gradient-to-r from-purple-600 to-indigo-600 text-white px-6 py-2 rounded-xl font-semibold hover:shadow-lg transition-all duration-300 flex items-center space-x-reverse space-x-2"
          >
            <Monitor className="h-4 w-4" />
            <span>معاينة مباشرة</span>
          </button>

          <button
            onClick={() => window.open('/', '_blank')}
            className="bg-gradient-to-r from-green-600 to-emerald-600 text-white px-6 py-2 rounded-xl font-semibold hover:shadow-lg transition-all duration-300"
          >
            عرض الموقع
          </button>
        </div>
      </div>

      {/* Tabs */}
      <div className={`border-b ${theme === 'dark' ? 'border-gray-700' : 'border-gray-200'}`}>
        <nav className="flex space-x-reverse space-x-8">
          {[
            { id: 'hero', name: 'القسم الرئيسي', icon: Layout },
            { id: 'global', name: 'الإعدادات العامة', icon: Settings },
            { id: 'builder', name: 'محرر الصفحة', icon: Code },
            { id: 'sections', name: 'ترتيب الأقسام', icon: Move },
            { id: 'features', name: 'المميزات', icon: Sparkles },
            { id: 'code', name: 'الكود المخصص', icon: Type },
          ].map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              className={`flex items-center space-x-reverse space-x-2 py-4 px-2 border-b-2 font-medium text-sm transition-colors ${
                activeTab === tab.id
                  ? 'border-blue-500 text-blue-600'
                  : theme === 'dark'
                  ? 'border-transparent text-gray-400 hover:text-gray-300'
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
            >
              <tab.icon className="h-4 w-4" />
              <span>{tab.name}</span>
            </button>
          ))}
        </nav>
      </div>

      {/* Content */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Settings Panel */}
        <div className={`p-6 rounded-xl border ${
          theme === 'dark' 
            ? 'bg-gray-800 border-gray-700' 
            : 'bg-white border-gray-200'
        }`}>
          
          {/* Hero Section Tab */}
          {activeTab === 'hero' && (
            <div className="space-y-6">
              <div className="flex items-center space-x-reverse space-x-3 mb-6">
                <Layout className="h-5 w-5 text-blue-600" />
                <h2 className={`text-lg font-semibold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
                  تخصيص القسم الرئيسي
                </h2>
              </div>

              <div className="space-y-4">
                <div>
                  <label className={`block text-sm font-medium mb-2 ${
                    theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                  }`}>
                    العنوان الرئيسي
                  </label>
                  <input
                    type="text"
                    value={heroForm.title}
                    onChange={(e) => setHeroForm({ ...heroForm, title: e.target.value })}
                    className={`w-full px-4 py-3 rounded-xl border focus:ring-2 focus:ring-blue-500 transition-colors ${
                      theme === 'dark'
                        ? 'bg-gray-700 border-gray-600 text-white'
                        : 'bg-white border-gray-300 text-gray-900'
                    }`}
                    placeholder="مثل: مستقبل الخدمات"
                  />
                </div>

                <div>
                  <label className={`block text-sm font-medium mb-2 ${
                    theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                  }`}>
                    العنوان المتدرج
                  </label>
                  <input
                    type="text"
                    value={heroForm.titleGradient}
                    onChange={(e) => setHeroForm({ ...heroForm, titleGradient: e.target.value })}
                    className={`w-full px-4 py-3 rounded-xl border focus:ring-2 focus:ring-blue-500 transition-colors ${
                      theme === 'dark'
                        ? 'bg-gray-700 border-gray-600 text-white'
                        : 'bg-white border-gray-300 text-gray-900'
                    }`}
                    placeholder="مثل: المالية الرقمية"
                  />
                </div>

                <div>
                  <label className={`block text-sm font-medium mb-2 ${
                    theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                  }`}>
                    النص التوضيحي
                  </label>
                  <textarea
                    value={heroForm.subtitle}
                    onChange={(e) => setHeroForm({ ...heroForm, subtitle: e.target.value })}
                    rows={4}
                    className={`w-full px-4 py-3 rounded-xl border focus:ring-2 focus:ring-blue-500 transition-colors resize-none ${
                      theme === 'dark'
                        ? 'bg-gray-700 border-gray-600 text-white'
                        : 'bg-white border-gray-300 text-gray-900'
                    }`}
                    placeholder="وصف موجز عن الخدمات..."
                  />
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className={`block text-sm font-medium mb-2 ${
                      theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                    }`}>
                      نص الزر الأول
                    </label>
                    <input
                      type="text"
                      value={heroForm.button1Text}
                      onChange={(e) => setHeroForm({ ...heroForm, button1Text: e.target.value })}
                      className={`w-full px-4 py-3 rounded-xl border focus:ring-2 focus:ring-blue-500 transition-colors ${
                        theme === 'dark'
                          ? 'bg-gray-700 border-gray-600 text-white'
                          : 'bg-white border-gray-300 text-gray-900'
                      }`}
                      placeholder="ابدأ الآن"
                    />
                  </div>

                  <div>
                    <label className={`block text-sm font-medium mb-2 ${
                      theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                    }`}>
                      نص الزر الثاني
                    </label>
                    <input
                      type="text"
                      value={heroForm.button2Text}
                      onChange={(e) => setHeroForm({ ...heroForm, button2Text: e.target.value })}
                      className={`w-full px-4 py-3 rounded-xl border focus:ring-2 focus:ring-blue-500 transition-colors ${
                        theme === 'dark'
                          ? 'bg-gray-700 border-gray-600 text-white'
                          : 'bg-white border-gray-300 text-gray-900'
                      }`}
                      placeholder="استكشف الخدمات"
                    />
                  </div>
                </div>

                <div>
                  <label className={`block text-sm font-medium mb-2 ${
                    theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                  }`}>
                    نص الشارة
                  </label>
                  <input
                    type="text"
                    value={heroForm.badgeText}
                    onChange={(e) => setHeroForm({ ...heroForm, badgeText: e.target.value })}
                    className={`w-full px-4 py-3 rounded-xl border focus:ring-2 focus:ring-blue-500 transition-colors ${
                      theme === 'dark'
                        ? 'bg-gray-700 border-gray-600 text-white'
                        : 'bg-white border-gray-300 text-gray-900'
                    }`}
                    placeholder="منصة رائدة في الخدمات المالية"
                  />
                </div>

                {/* Stats Settings */}
                <div>
                  <div className="flex items-center justify-between mb-4">
                    <label className={`text-sm font-medium ${
                      theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                    }`}>
                      عرض الإحصائيات
                    </label>
                    <input
                      type="checkbox"
                      checked={heroForm.showStats}
                      onChange={(e) => setHeroForm({ ...heroForm, showStats: e.target.checked })}
                      className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                    />
                  </div>

                  {heroForm.showStats && (
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="block text-xs font-medium mb-1 text-gray-500">العملاء</label>
                        <input
                          type="text"
                          value={heroForm.statsData.clients}
                          onChange={(e) => setHeroForm({
                            ...heroForm,
                            statsData: { ...heroForm.statsData, clients: e.target.value }
                          })}
                          className={`w-full px-3 py-2 rounded-lg border text-sm ${
                            theme === 'dark'
                              ? 'bg-gray-700 border-gray-600 text-white'
                              : 'bg-white border-gray-300 text-gray-900'
                          }`}
                        />
                      </div>

                      <div>
                        <label className="block text-xs font-medium mb-1 text-gray-500">معدل النجاح</label>
                        <input
                          type="text"
                          value={heroForm.statsData.successRate}
                          onChange={(e) => setHeroForm({
                            ...heroForm,
                            statsData: { ...heroForm.statsData, successRate: e.target.value }
                          })}
                          className={`w-full px-3 py-2 rounded-lg border text-sm ${
                            theme === 'dark'
                              ? 'bg-gray-700 border-gray-600 text-white'
                              : 'bg-white border-gray-300 text-gray-900'
                          }`}
                        />
                      </div>

                      <div>
                        <label className="block text-xs font-medium mb-1 text-gray-500">الدعم</label>
                        <input
                          type="text"
                          value={heroForm.statsData.support}
                          onChange={(e) => setHeroForm({
                            ...heroForm,
                            statsData: { ...heroForm.statsData, support: e.target.value }
                          })}
                          className={`w-full px-3 py-2 rounded-lg border text-sm ${
                            theme === 'dark'
                              ? 'bg-gray-700 border-gray-600 text-white'
                              : 'bg-white border-gray-300 text-gray-900'
                          }`}
                        />
                      </div>

                      <div>
                        <label className="block text-xs font-medium mb-1 text-gray-500">السرعة</label>
                        <input
                          type="text"
                          value={heroForm.statsData.speed}
                          onChange={(e) => setHeroForm({
                            ...heroForm,
                            statsData: { ...heroForm.statsData, speed: e.target.value }
                          })}
                          className={`w-full px-3 py-2 rounded-lg border text-sm ${
                            theme === 'dark'
                              ? 'bg-gray-700 border-gray-600 text-white'
                              : 'bg-white border-gray-300 text-gray-900'
                          }`}
                        />
                      </div>
                    </div>
                  )}
                </div>

                <button
                  onClick={handleSaveHero}
                  className="w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all duration-300 flex items-center justify-center space-x-reverse space-x-2"
                >
                  <Save className="h-5 w-5" />
                  <span>حفظ إعدادات القسم الرئيسي</span>
                </button>
              </div>
            </div>
          )}

          {/* Global Settings Tab */}
          {activeTab === 'global' && (
            <div className="space-y-6">
              <div className="flex items-center space-x-reverse space-x-3 mb-6">
                <Palette className="h-5 w-5 text-blue-600" />
                <h2 className={`text-lg font-semibold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
                  الإعدادات العامة والألوان
                </h2>
              </div>

              {/* Color Presets */}
              <div>
                <label className={`block text-sm font-medium mb-3 ${
                  theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                }`}>
                  مجموعات الألوان الجاهزة
                </label>
                <div className="grid grid-cols-1 gap-3">
                  {colorPresets.map((preset, index) => (
                    <button
                      key={index}
                      onClick={() => setGlobalForm({
                        ...globalForm,
                        primaryColor: preset.primary,
                        secondaryColor: preset.secondary,
                        accentColor: preset.accent
                      })}
                      className={`flex items-center justify-between p-3 rounded-lg border transition-all hover:shadow-md ${
                        theme === 'dark'
                          ? 'border-gray-600 hover:border-gray-500 bg-gray-700'
                          : 'border-gray-200 hover:border-gray-300 bg-white'
                      }`}
                    >
                      <span className={`font-medium ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
                        {preset.name}
                      </span>
                      <div className="flex space-x-reverse space-x-2">
                        <div 
                          className="w-6 h-6 rounded-full border border-gray-300"
                          style={{ backgroundColor: preset.primary }}
                        />
                        <div 
                          className="w-6 h-6 rounded-full border border-gray-300"
                          style={{ backgroundColor: preset.secondary }}
                        />
                        <div 
                          className="w-6 h-6 rounded-full border border-gray-300"
                          style={{ backgroundColor: preset.accent }}
                        />
                      </div>
                    </button>
                  ))}
                </div>
              </div>

              {/* Custom Colors */}
              <div className="grid grid-cols-1 gap-4">
                <div>
                  <label className={`block text-sm font-medium mb-2 ${
                    theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                  }`}>
                    اللون الأساسي
                  </label>
                  <div className="flex items-center space-x-reverse space-x-3">
                    <input
                      type="color"
                      value={globalForm.primaryColor}
                      onChange={(e) => setGlobalForm({ ...globalForm, primaryColor: e.target.value })}
                      className="h-12 w-16 rounded-lg border border-gray-300 cursor-pointer"
                    />
                    <input
                      type="text"
                      value={globalForm.primaryColor}
                      onChange={(e) => setGlobalForm({ ...globalForm, primaryColor: e.target.value })}
                      className={`flex-1 px-4 py-3 rounded-xl border focus:ring-2 focus:ring-blue-500 transition-colors ${
                        theme === 'dark'
                          ? 'bg-gray-700 border-gray-600 text-white'
                          : 'bg-white border-gray-300 text-gray-900'
                      }`}
                    />
                  </div>
                </div>

                <div>
                  <label className={`block text-sm font-medium mb-2 ${
                    theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                  }`}>
                    اللون الثانوي
                  </label>
                  <div className="flex items-center space-x-reverse space-x-3">
                    <input
                      type="color"
                      value={globalForm.secondaryColor}
                      onChange={(e) => setGlobalForm({ ...globalForm, secondaryColor: e.target.value })}
                      className="h-12 w-16 rounded-lg border border-gray-300 cursor-pointer"
                    />
                    <input
                      type="text"
                      value={globalForm.secondaryColor}
                      onChange={(e) => setGlobalForm({ ...globalForm, secondaryColor: e.target.value })}
                      className={`flex-1 px-4 py-3 rounded-xl border focus:ring-2 focus:ring-blue-500 transition-colors ${
                        theme === 'dark'
                          ? 'bg-gray-700 border-gray-600 text-white'
                          : 'bg-white border-gray-300 text-gray-900'
                      }`}
                    />
                  </div>
                </div>

                <div>
                  <label className={`block text-sm font-medium mb-2 ${
                    theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                  }`}>
                    لون الإبراز
                  </label>
                  <div className="flex items-center space-x-reverse space-x-3">
                    <input
                      type="color"
                      value={globalForm.accentColor}
                      onChange={(e) => setGlobalForm({ ...globalForm, accentColor: e.target.value })}
                      className="h-12 w-16 rounded-lg border border-gray-300 cursor-pointer"
                    />
                    <input
                      type="text"
                      value={globalForm.accentColor}
                      onChange={(e) => setGlobalForm({ ...globalForm, accentColor: e.target.value })}
                      className={`flex-1 px-4 py-3 rounded-xl border focus:ring-2 focus:ring-blue-500 transition-colors ${
                        theme === 'dark'
                          ? 'bg-gray-700 border-gray-600 text-white'
                          : 'bg-white border-gray-300 text-gray-900'
                      }`}
                    />
                  </div>
                </div>
              </div>

              <button
                onClick={handleSaveGlobal}
                className="w-full bg-gradient-to-r from-purple-600 to-indigo-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all duration-300 flex items-center justify-center space-x-reverse space-x-2"
              >
                <Save className="h-5 w-5" />
                <span>حفظ الإعدادات العامة</span>
              </button>
            </div>
          )}

          {/* Sections Tab */}
          {activeTab === 'sections' && (
            <div className="space-y-6">
              <div className="flex items-center space-x-reverse space-x-3 mb-6">
                <Move className="h-5 w-5 text-blue-600" />
                <h2 className={`text-lg font-semibold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
                  ترتيب أقسام الصفحة
                </h2>
              </div>

              <div className="space-y-4">
                {[
                  { id: 'hero', name: 'القسم الرئيسي', enabled: true },
                  { id: 'services', name: 'الخدمات', enabled: true },
                  { id: 'features', name: 'المميزات', enabled: true },
                  { id: 'testimonials', name: 'آراء العملاء', enabled: true },
                  { id: 'faq', name: 'الأسئلة الشائعة', enabled: true },
                  { id: 'contact', name: 'التواصل', enabled: false }
                ].map((section, index) => (
                  <div key={section.id} className={`p-4 rounded-lg border ${theme === 'dark' ? 'bg-gray-700 border-gray-600' : 'bg-gray-50 border-gray-200'}`}>
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-reverse space-x-3">
                        <div className="w-6 h-6 bg-blue-600 rounded text-white text-xs flex items-center justify-center font-bold">
                          {index + 1}
                        </div>
                        <span className={`font-medium ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
                          {section.name}
                        </span>
                      </div>
                      <div className="flex items-center space-x-reverse space-x-2">
                        <input
                          type="checkbox"
                          checked={section.enabled}
                          className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                        />
                        <button className="p-1 text-gray-400 hover:text-gray-600">
                          <Move className="h-4 w-4" />
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>

              <button className="w-full bg-gradient-to-r from-green-600 to-emerald-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all duration-300">
                حفظ ترتيب الأقسام
              </button>
            </div>
          )}

          {/* Page Builder Tab */}
          {activeTab === 'builder' && (
            <div className="h-[600px]">
              <PageBuilder />
            </div>
          )}

          {/* Custom Code Tab */}
          {activeTab === 'code' && (
            <div className="space-y-6">
              <div className="flex items-center space-x-reverse space-x-3 mb-6">
                <Type className="h-5 w-5 text-blue-600" />
                <h2 className={`text-lg font-semibold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
                  إدارة الكود المخصص
                </h2>
              </div>

              <div className="space-y-6">
                {/* Custom CSS */}
                <div>
                  <label className={`block text-sm font-medium mb-3 ${
                    theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                  }`}>
                    CSS مخصص
                  </label>
                  <textarea
                    rows={10}
                    className={`w-full px-4 py-3 rounded-xl border font-mono text-sm ${
                      theme === 'dark'
                        ? 'bg-gray-700 border-gray-600 text-white'
                        : 'bg-white border-gray-300 text-gray-900'
                    }`}
                    placeholder="/* أ��ف CSS مخصص هنا */
.custom-class {
  background: linear-gradient(45deg, #667eea, #764ba2);
  border-radius: 10px;
  padding: 20px;
}

.hero-custom {
  background-image: url('your-image.jpg');
  background-size: cover;
}"
                  />
                  <p className={`text-xs mt-2 ${theme === 'dark' ? 'text-gray-400' : 'text-gray-500'}`}>
                    سيتم تطبيق هذا CSS على الصفحة الرئيسية. استخدم بحذر.
                  </p>
                </div>

                {/* Custom JavaScript */}
                <div>
                  <label className={`block text-sm font-medium mb-3 ${
                    theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                  }`}>
                    JavaScript مخصص
                  </label>
                  <textarea
                    rows={8}
                    className={`w-full px-4 py-3 rounded-xl border font-mono text-sm ${
                      theme === 'dark'
                        ? 'bg-gray-700 border-gray-600 text-white'
                        : 'bg-white border-gray-300 text-gray-900'
                    }`}
                    placeholder="// أضف JavaScript مخصص هنا
// تتبع Google Analytics
gtag('config', 'GA_MEASUREMENT_ID');

// تخصيصات إضافية
document.addEventListener('DOMContentLoaded', function() {
  // الكود هنا
});"
                  />
                  <p className={`text-xs mt-2 ${theme === 'dark' ? 'text-gray-400' : 'text-gray-500'}`}>
                    كود JavaScript سيتم تشغيله على الصفحة. تأكد من صحة الكود.
                  </p>
                </div>

                {/* Meta Tags */}
                <div>
                  <label className={`block text-sm font-medium mb-3 ${
                    theme === 'dark' ? 'text-gray-300' : 'text-gray-700'
                  }`}>
                    Meta Tags إضافية
                  </label>
                  <textarea
                    rows={6}
                    className={`w-full px-4 py-3 rounded-xl border font-mono text-sm ${
                      theme === 'dark'
                        ? 'bg-gray-700 border-gray-600 text-white'
                        : 'bg-white border-gray-300 text-gray-900'
                    }`}
                    placeholder='<!-- Meta tags إضافية -->
<meta name="robots" content="index, follow">
<meta name="author" content="KYCtrust">
<meta property="og:image" content="https://your-domain.com/image.jpg">
<meta name="twitter:card" content="summary_large_image">'
                  />
                  <p className={`text-xs mt-2 ${theme === 'dark' ? 'text-gray-400' : 'text-gray-500'}`}>
                    Meta tags إضافية للـ SEO ووسائل التواصل الاجتماعي.
                  </p>
                </div>

                <button className="w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all duration-300">
                  حفظ الكود المخصص
                </button>
              </div>
            </div>
          )}

          {/* Features Tab */}
          {activeTab === 'features' && (
            <div className="space-y-6">
              <div className="flex items-center space-x-reverse space-x-3 mb-6">
                <Sparkles className="h-5 w-5 text-blue-600" />
                <h2 className={`text-lg font-semibold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
                  إدارة المميزات
                </h2>
              </div>

              <div className="space-y-4">
                {[
                  {
                    title: 'أمان متقدم',
                    description: 'تشفير متقدم وحماية شاملة',
                    icon: '🛡️',
                    enabled: true
                  },
                  {
                    title: 'سرعة البرق',
                    description: 'معالجة فورية في أقل من 5 دقائق',
                    icon: '⚡',
                    enabled: true
                  },
                  {
                    title: 'موثوقية عالية',
                    description: 'ضمان الجودة وإرجاع الأموال',
                    icon: '🏆',
                    enabled: true
                  },
                  {
                    title: 'تغطية عالمية',
                    description: 'متاح في أكثر من 150 دولة',
                    icon: '🌍',
                    enabled: false
                  }
                ].map((feature, index) => (
                  <div key={index} className={`p-4 rounded-lg border ${theme === 'dark' ? 'bg-gray-700 border-gray-600' : 'bg-gray-50 border-gray-200'}`}>
                    <div className="flex items-start justify-between">
                      <div className="flex items-start space-x-reverse space-x-3">
                        <div className="text-2xl">{feature.icon}</div>
                        <div>
                          <input
                            type="text"
                            value={feature.title}
                            className={`font-medium bg-transparent border-none p-0 focus:ring-0 ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}
                          />
                          <input
                            type="text"
                            value={feature.description}
                            className={`block text-sm bg-transparent border-none p-0 focus:ring-0 mt-1 ${theme === 'dark' ? 'text-gray-400' : 'text-gray-600'}`}
                          />
                        </div>
                      </div>
                      <div className="flex items-center space-x-reverse space-x-2">
                        <input
                          type="checkbox"
                          checked={feature.enabled}
                          className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                        />
                        <button className="text-red-500 hover:text-red-700">
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>

              <button className={`w-full border-2 border-dashed rounded-xl p-4 ${theme === 'dark' ? 'border-gray-600 text-gray-400 hover:border-gray-500' : 'border-gray-300 text-gray-500 hover:border-gray-400'} transition-colors`}>
                <Plus className="h-5 w-5 mx-auto mb-2" />
                إضافة ميزة جديدة
              </button>

              <button className="w-full bg-gradient-to-r from-purple-600 to-indigo-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all duration-300">
                حفظ المميزات
              </button>
            </div>
          )}
        </div>

        {/* Preview Panel */}
        <div className={`p-6 rounded-xl border ${
          theme === 'dark' 
            ? 'bg-gray-800 border-gray-700' 
            : 'bg-white border-gray-200'
        }`}>
          <div className="flex items-center space-x-reverse space-x-3 mb-6">
            <Eye className="h-5 w-5 text-green-600" />
            <h2 className={`text-lg font-semibold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
              معاينة التغييرات
            </h2>
          </div>

          {activeTab === 'hero' && (
            <div className={`p-6 rounded-xl ${
              theme === 'dark' 
                ? 'bg-gradient-to-br from-gray-900 to-blue-900/20' 
                : 'bg-gradient-to-br from-blue-50 to-indigo-50'
            }`}>
              {/* Preview Badge */}
              <div className={`inline-flex items-center px-4 py-2 backdrop-blur-sm border rounded-full text-sm font-semibold mb-4 ${
                theme === 'dark' 
                  ? 'bg-gray-800/80 border-blue-500/50 text-blue-300' 
                  : 'bg-white/80 border-blue-200/50 text-blue-700'
              }`}>
                <Sparkles className="h-3 w-3 ml-2 text-yellow-500" />
                <span>{heroForm.badgeText}</span>
              </div>

              {/* Preview Title */}
              <h1 className={`text-2xl md:text-3xl font-bold mb-3 leading-tight ${
                theme === 'dark' ? 'text-white' : 'text-gray-900'
              }`}>
                <span className="block">{heroForm.title}</span>
                <span className="bg-gradient-to-r from-blue-600 via-purple-600 to-indigo-600 bg-clip-text text-transparent">
                  {heroForm.titleGradient}
                </span>
              </h1>

              {/* Preview Subtitle */}
              <p className={`text-sm md:text-base mb-6 leading-relaxed ${
                theme === 'dark' ? 'text-gray-300' : 'text-gray-600'
              }`}>
                {heroForm.subtitle}
              </p>

              {/* Preview Buttons */}
              <div className="flex flex-col sm:flex-row gap-3 mb-6">
                <button className="flex-1 bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-2 rounded-xl font-semibold text-sm">
                  {heroForm.button1Text}
                </button>
                <button className={`flex-1 backdrop-blur-sm px-4 py-2 rounded-xl font-semibold text-sm border ${
                  theme === 'dark' 
                    ? 'bg-gray-800/80 text-gray-200 border-gray-600/50' 
                    : 'bg-white/80 text-gray-700 border-gray-200/50'
                }`}>
                  {heroForm.button2Text}
                </button>
              </div>

              {/* Preview Stats */}
              {heroForm.showStats && (
                <div className="grid grid-cols-2 gap-4">
                  {[
                    { value: heroForm.statsData.clients, label: 'عميل راضٍ' },
                    { value: heroForm.statsData.successRate, label: 'معدل النجاح' },
                    { value: heroForm.statsData.support, label: 'دعم متواصل' },
                    { value: heroForm.statsData.speed, label: 'سرعة التنفيذ' },
                  ].map((stat, index) => (
                    <div key={index} className={`text-center p-3 rounded-xl ${
                      theme === 'dark' ? 'bg-gray-800/50' : 'bg-white/50'
                    }`}>
                      <div className={`text-lg font-bold ${
                        theme === 'dark' ? 'text-white' : 'text-gray-900'
                      }`}>
                        {stat.value}
                      </div>
                      <div className={`text-xs ${
                        theme === 'dark' ? 'text-gray-400' : 'text-gray-600'
                      }`}>
                        {stat.label}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {activeTab === 'global' && (
            <div className="space-y-4">
              {/* Color Preview */}
              <div className="grid grid-cols-3 gap-4">
                <div className="text-center">
                  <div 
                    className="w-full h-16 rounded-xl mb-2 border border-gray-300"
                    style={{ backgroundColor: globalForm.primaryColor }}
                  />
                  <span className="text-sm font-medium">اللون الأساسي</span>
                </div>
                <div className="text-center">
                  <div 
                    className="w-full h-16 rounded-xl mb-2 border border-gray-300"
                    style={{ backgroundColor: globalForm.secondaryColor }}
                  />
                  <span className="text-sm font-medium">اللون الثانوي</span>
                </div>
                <div className="text-center">
                  <div 
                    className="w-full h-16 rounded-xl mb-2 border border-gray-300"
                    style={{ backgroundColor: globalForm.accentColor }}
                  />
                  <span className="text-sm font-medium">لون الإب��از</span>
                </div>
              </div>

              {/* Button Preview */}
              <div className="space-y-3">
                <button 
                  className="w-full text-white px-6 py-3 rounded-xl font-semibold"
                  style={{ 
                    background: `linear-gradient(to right, ${globalForm.primaryColor}, ${globalForm.secondaryColor})` 
                  }}
                >
                  زر بالألوان الجديدة
                </button>
                
                <button 
                  className="w-full text-white px-6 py-3 rounded-xl font-semibold"
                  style={{ backgroundColor: globalForm.accentColor }}
                >
                  زر بلون الإبراز
                </button>
              </div>
            </div>
          )}

          {activeTab === 'sections' && (
            <div className="space-y-4">
              <h3 className={`text-lg font-semibold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
                معاينة ترتيب الأقسام
              </h3>
              <div className="space-y-2">
                {[
                  { name: '1. القسم الرئيسي', color: 'bg-blue-500' },
                  { name: '2. الخدمات', color: 'bg-green-500' },
                  { name: '3. المميزات', color: 'bg-purple-500' },
                  { name: '4. آراء العملاء', color: 'bg-yellow-500' },
                  { name: '5. الأسئلة الشائعة', color: 'bg-red-500' }
                ].map((section, index) => (
                  <div key={index} className={`p-3 rounded-lg ${section.color} text-white font-medium text-center`}>
                    {section.name}
                  </div>
                ))}
              </div>
            </div>
          )}

          {activeTab === 'features' && (
            <div className="space-y-4">
              <h3 className={`text-lg font-semibold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
                معاينة المميزات
              </h3>
              <div className="grid grid-cols-2 gap-4">
                {[
                  { icon: '🛡️', title: 'أمان متقد��' },
                  { icon: '⚡', title: 'سرعة البرق' },
                  { icon: '🏆', title: 'موثوقية عالية' },
                  { icon: '🌍', title: 'تغطية عالمية' }
                ].map((feature, index) => (
                  <div key={index} className={`p-4 rounded-lg border text-center ${theme === 'dark' ? 'bg-gray-700 border-gray-600' : 'bg-white border-gray-200'}`}>
                    <div className="text-2xl mb-2">{feature.icon}</div>
                    <div className={`font-medium ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>
                      {feature.title}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Live Preview Modal */}
      <LivePreview
        isOpen={isLivePreviewOpen}
        onClose={() => setIsLivePreviewOpen(false)}
      />
    </div>
  );
};

export default LandingPageCustomizer;
