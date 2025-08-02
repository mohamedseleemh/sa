import React, { useState } from 'react';
import { Package, CreditCard, Inbox, TrendingUp, Users, CheckCircle, Activity, Calendar, BarChart3, DollarSign, Clock, Globe, Zap, Settings, Eye, Plus } from 'lucide-react';
import { useData } from '../../context/DataContext';
import { useTheme } from '../../context/ThemeContext';
import LoadingSpinner from '../ui/LoadingSpinner';
import ErrorMessage from '../ui/ErrorMessage';

const Dashboard: React.FC = () => {
  const { services, paymentMethods, orders, loading, error, refreshData } = useData();
  const { theme } = useTheme();
  const [selectedPeriod, setSelectedPeriod] = useState<'today' | 'week' | 'month'>('week');

  if (loading) {
    return <LoadingSpinner size="lg" text="جاري تحميل البيانات..." />;
  }

  if (error) {
    return <ErrorMessage message={error} onRetry={refreshData} />;
  }

  const activeServices = services.filter(service => service.active);
  const activePaymentMethods = paymentMethods.filter(method => method.active);
  const activeOrders = orders.filter(order => !order.archived);
  const archivedOrders = orders.filter(order => order.archived);

  // إحصائيات إضافية
  const todayOrders = orders.filter(order => {
    const today = new Date();
    const orderDate = new Date(order.timestamp);
    return orderDate.toDateString() === today.toDateString();
  }).length;

  const thisWeekOrders = orders.filter(order => {
    const weekAgo = new Date();
    weekAgo.setDate(weekAgo.getDate() - 7);
    return new Date(order.timestamp) >= weekAgo;
  }).length;
  const stats = [
    {
      title: 'الخدمات النشطة',
      value: activeServices.length,
      total: services.length,
      icon: Package,
      color: 'from-blue-500 to-blue-600',
      bgColor: 'bg-blue-50',
      textColor: 'text-blue-700'
    },
    {
      title: 'طرق الدفع',
      value: activePaymentMethods.length,
      total: paymentMethods.length,
      icon: CreditCard,
      color: 'from-green-500 to-green-600',
      bgColor: 'bg-green-50',
      textColor: 'text-green-700'
    },
    {
      title: 'الطلبات الجديدة',
      value: activeOrders.length,
      total: orders.length,
      icon: Inbox,
      color: 'from-orange-500 to-orange-600',
      bgColor: 'bg-orange-50',
      textColor: 'text-orange-700'
    },
    {
      title: 'الطلبات المؤرشفة',
      value: archivedOrders.length,
      total: orders.length,
      icon: CheckCircle,
      color: 'from-purple-500 to-purple-600',
      bgColor: 'bg-purple-50',
      textColor: 'text-purple-700'
    },
    {
      title: 'طلبات اليوم',
      value: todayOrders,
      total: orders.length,
      icon: Calendar,
      color: 'from-yellow-500 to-yellow-600',
      bgColor: 'bg-yellow-50',
      textColor: 'text-yellow-700'
    },
    {
      title: 'طلبات الأسبوع',
      value: thisWeekOrders,
      total: orders.length,
      icon: BarChart3,
      color: 'from-indigo-500 to-indigo-600',
      bgColor: 'bg-indigo-50',
      textColor: 'text-indigo-700'
    }
  ];

  const recentOrders = orders
    .filter(order => !order.archived)
    .sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime())
    .slice(0, 5);

  const getPeriodLabel = () => {
    switch (selectedPeriod) {
      case 'today': return 'اليوم';
      case 'week': return '��ذا الأسبوع';
      case 'month': return 'هذا الشهر';
      default: return 'هذا الأسبوع';
    }
  };

  return (
    <div className="space-y-8">
      {/* Enhanced Page Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className={`text-3xl font-bold mb-2 ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>لوحة التحكم</h1>
          <p className={theme === 'dark' ? 'text-gray-300' : 'text-gray-600'}>مرحباً بك في لوحة تحكم KYCtrust</p>
        </div>

        <div className="flex items-center space-x-reverse space-x-4">
          {/* Period Selector */}
          <div className={`flex bg-gray-100 rounded-lg p-1 ${theme === 'dark' ? 'bg-gray-700' : 'bg-gray-100'}`}>
            {[
              { id: 'today', label: 'اليوم' },
              { id: 'week', label: 'الأسبوع' },
              { id: 'month', label: 'الشهر' }
            ].map((period) => (
              <button
                key={period.id}
                onClick={() => setSelectedPeriod(period.id as any)}
                className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  selectedPeriod === period.id
                    ? 'bg-white text-blue-600 shadow-sm dark:bg-gray-600 dark:text-blue-400'
                    : theme === 'dark'
                    ? 'text-gray-300 hover:text-white'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
              >
                {period.label}
              </button>
            ))}
          </div>

          <button className="bg-gradient-to-r from-blue-600 to-indigo-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all duration-300 flex items-center space-x-reverse space-x-2">
            <Plus className="h-5 w-5" />
            <span>إضافة سريعة</span>
          </button>
        </div>
      </div>

      {/* Enhanced Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-6">
        {stats.map((stat, index) => (
          <div key={index} className={`rounded-xl shadow-sm p-6 border hover:shadow-md transition-all duration-300 ${theme === 'dark' ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-100'}`}>
            <div className="flex items-center justify-between mb-4">
              <div className={`p-3 rounded-xl bg-gradient-to-r ${stat.color}`}>
                <stat.icon className="h-6 w-6 text-white" />
              </div>
              <div className="text-right">
                <p className={`text-2xl font-bold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>{stat.value}</p>
                <p className={`text-sm ${theme === 'dark' ? 'text-gray-400' : 'text-gray-500'}`}>من أصل {stat.total}</p>
              </div>
            </div>
            <h3 className={`text-lg font-semibold text-right ${theme === 'dark' ? 'text-gray-200' : 'text-gray-800'}`}>{stat.title}</h3>
            <div className={`mt-2 w-full rounded-full h-2 ${theme === 'dark' ? 'bg-gray-700' : 'bg-gray-200'}`}>
              <div
                className={`bg-gradient-to-r ${stat.color} h-2 rounded-full transition-all duration-500`}
                style={{ width: `${Math.min((stat.value / stat.total) * 100, 100)}%` }}
              ></div>
            </div>
          </div>
        ))}
      </div>

      {/* Quick Metrics Row */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        {[
          { title: 'إجمالي العائدات', value: '2,450 جنيه', change: '+12%', icon: DollarSign, color: 'text-green-600', bg: 'bg-green-50' },
          { title: 'متوسط وقت الاستجابة', value: '3.2 دقيقة', change: '-8%', icon: Clock, color: 'text-blue-600', bg: 'bg-blue-50' },
          { title: 'معدل النجاح', value: '97.5%', change: '+2%', icon: TrendingUp, color: 'text-purple-600', bg: 'bg-purple-50' },
          { title: 'عملاء جدد', value: '24', change: '+18%', icon: Users, color: 'text-orange-600', bg: 'bg-orange-50' }
        ].map((metric, index) => (
          <div key={index} className={`rounded-xl shadow-sm p-6 border ${theme === 'dark' ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-100'}`}>
            <div className="flex items-center justify-between">
              <div className={`p-3 rounded-xl ${theme === 'dark' ? 'bg-gray-700' : metric.bg}`}>
                <metric.icon className={`h-6 w-6 ${theme === 'dark' ? 'text-gray-300' : metric.color}`} />
              </div>
              <div className={`text-xs px-2 py-1 rounded-full ${metric.change.startsWith('+') ? 'bg-green-100 text-green-600' : 'bg-red-100 text-red-600'}`}>
                {metric.change}
              </div>
            </div>
            <div className="mt-4">
              <p className={`text-2xl font-bold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>{metric.value}</p>
              <p className={`text-sm ${theme === 'dark' ? 'text-gray-400' : 'text-gray-600'}`}>{metric.title}</p>
            </div>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Recent Orders */}
        <div className={`rounded-xl shadow-sm border ${theme === 'dark' ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-100'}`}>
          <div className={`p-6 border-b ${theme === 'dark' ? 'border-gray-700' : 'border-gray-100'}`}>
            <div className="flex items-center justify-between">
              <h2 className={`text-xl font-bold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>آخر الطلبات</h2>
              <div className="flex items-center space-x-reverse space-x-2">
                <Activity className="h-5 w-5 text-blue-600" />
                <span className="text-sm text-blue-600 font-medium">مباشر</span>
              </div>
            </div>
          </div>
          <div className="p-6">
            {recentOrders.length === 0 ? (
              <div className="text-center py-8">
                <Inbox className={`h-12 w-12 mx-auto mb-4 ${theme === 'dark' ? 'text-gray-600' : 'text-gray-300'}`} />
                <p className={theme === 'dark' ? 'text-gray-400' : 'text-gray-500'}>لا توجد طلبات جديدة</p>
              </div>
            ) : (
              <div className="space-y-4">
                {recentOrders.map((order) => (
                  <div key={order.id} className={`flex items-center justify-between p-4 rounded-lg border hover:shadow-md transition-all ${
                    theme === 'dark'
                      ? 'bg-gradient-to-r from-gray-700 to-blue-900/20 border-gray-600'
                      : 'bg-gradient-to-r from-gray-50 to-blue-50 border-gray-200'
                  }`}>
                    <div className="flex-1">
                      <div className="flex items-center space-x-reverse space-x-2 mb-1">
                        <div className="w-2 h-2 bg-green-400 rounded-full animate-pulse"></div>
                        <h3 className={`font-semibold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>{order.customerName}</h3>
                      </div>
                      <p className="text-sm text-blue-600 font-medium">{order.serviceName}</p>
                      {order.notes && (
                        <p className={`text-xs mt-1 ${theme === 'dark' ? 'text-gray-400' : 'text-gray-500'}`}>{order.notes}</p>
                      )}
                    </div>
                    <div className="text-left">
                      <div className="bg-orange-100 text-orange-800 px-2 py-1 rounded-full text-xs font-medium mb-1">
                        جديد
                      </div>
                      <p className={`text-sm ${theme === 'dark' ? 'text-gray-400' : 'text-gray-500'}`}>
                        {new Date(order.timestamp).toLocaleDateString('ar-EG')}
                      </p>
                      <p className={`text-xs ${theme === 'dark' ? 'text-gray-500' : 'text-gray-400'}`}>
                        {new Date(order.timestamp).toLocaleTimeString('ar-EG')}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Performance Charts */}
        <div className={`rounded-xl shadow-sm border ${theme === 'dark' ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-100'}`}>
          <div className={`p-6 border-b ${theme === 'dark' ? 'border-gray-700' : 'border-gray-100'}`}>
            <div className="flex items-center justify-between">
              <h2 className={`text-xl font-bold ${theme === 'dark' ? 'text-white' : 'text-gray-900'}`}>أداء {getPeriodLabel()}</h2>
              <BarChart3 className="h-5 w-5 text-blue-600" />
            </div>
          </div>
          <div className="p-6">
            <div className="space-y-6">
              {[
                { label: 'طلبات مكتملة', value: 24, max: 30, color: 'bg-green-500' },
                { label: 'طلبات قيد المعالجة', value: 8, max: 30, color: 'bg-yellow-500' },
                { label: 'عملاء جدد', value: 15, max: 20, color: 'bg-blue-500' },
                { label: 'معدل الرضا', value: 18, max: 20, color: 'bg-purple-500' }
              ].map((item, index) => (
                <div key={index}>
                  <div className="flex justify-between items-center mb-2">
                    <span className={`text-sm font-medium ${theme === 'dark' ? 'text-gray-300' : 'text-gray-700'}`}>{item.label}</span>
                    <span className={`text-sm ${theme === 'dark' ? 'text-gray-400' : 'text-gray-500'}`}>{item.value}</span>
                  </div>
                  <div className={`w-full rounded-full h-2 ${theme === 'dark' ? 'bg-gray-700' : 'bg-gray-200'}`}>
                    <div
                      className={`h-2 rounded-full ${item.color} transition-all duration-500`}
                      style={{ width: `${(item.value / item.max) * 100}%` }}
                    ></div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Enhanced Quick Actions */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {[
          { title: 'إحصائيات متقدمة', desc: 'عرض تفصيلي للأداء والتحليلات', icon: BarChart3, color: 'blue', action: 'عرض التقرير' },
          { title: 'إدارة العملاء', desc: 'تتبع وإدارة جميع طلبات العملاء', icon: Users, color: 'green', action: 'إدارة الطلبات' },
          { title: 'تحديث الخدمات', desc: 'إضافة وتعديل الخدمات المتاحة', icon: Package, color: 'purple', action: 'إدارة الخدمات' },
          { title: 'إعدادات الموقع', desc: 'تخصيص وإعداد جميع أجزاء الموقع', icon: Settings, color: 'orange', action: 'تخصيص الموقع' }
        ].map((item, index) => (
          <div key={index} className={`rounded-xl p-6 border transition-all duration-300 hover:shadow-lg cursor-pointer ${
            theme === 'dark'
              ? 'bg-gray-800 border-gray-700 hover:border-gray-600'
              : `bg-gradient-to-br from-${item.color}-50 to-${item.color}-100 border-${item.color}-200 hover:from-${item.color}-100 hover:to-${item.color}-200`
          }`}>
            <div className={`p-3 rounded-xl w-fit mb-4 ${
              theme === 'dark'
                ? 'bg-gray-700'
                : `bg-${item.color}-500/10`
            }`}>
              <item.icon className={`h-6 w-6 ${
                theme === 'dark'
                  ? 'text-gray-300'
                  : `text-${item.color}-600`
              }`} />
            </div>
            <h3 className={`text-lg font-semibold mb-2 ${theme === 'dark' ? 'text-white' : `text-${item.color}-900`}`}>{item.title}</h3>
            <p className={`text-sm mb-4 ${theme === 'dark' ? 'text-gray-400' : `text-${item.color}-700`}`}>{item.desc}</p>
            <button className={`text-sm font-medium flex items-center space-x-reverse space-x-2 ${
              theme === 'dark'
                ? 'text-blue-400 hover:text-blue-300'
                : `text-${item.color}-600 hover:text-${item.color}-700`
            } transition-colors`}>
              <span>{item.action}</span>
              <Eye className="h-4 w-4" />
            </button>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Dashboard;
