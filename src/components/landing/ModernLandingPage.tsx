import React, { useState, useEffect, useMemo, useCallback } from 'react';
import {
  Shield, CheckCircle, CreditCard, MessageCircle, Star, ArrowRight,
  Clock, Users, Award, Zap, Globe, TrendingUp, Lock, Heart,
  Sparkles, Phone, Mail, MapPin, Menu, X, Rocket, Target,
  ChevronDown, CheckSquare, Eye, Instagram, Twitter, Linkedin, Youtube,
  Play, Download, Upload, Layers, Palette, Code, Settings,
  Database, Server, Wifi, Monitor, Smartphone, Tablet, Package
} from 'lucide-react';
import { useData } from '../../context/DataContext';
import { useTheme } from '../../context/ThemeContext';
import { useCustomization } from '../../context/CustomizationContext';
import { useTranslation } from '../../utils/translations';
import { landingPageService, type LandingPageSection } from '../../services/landingPageService';
import ModernHeroSection from './ModernHeroSection';
import OrderModal from '../modals/OrderModal';
import LoadingSpinner from '../ui/LoadingSpinner';
import ErrorMessage from '../ui/ErrorMessage';
import ServicesShowcase from '../modals/ServicesShowcase';
import ThemeToggle from '../ui/ThemeToggle';
import LanguageToggle from '../ui/LanguageToggle';
import CounterAnimation from '../animations/CounterAnimation';
import SEOOptimizer from '../optimization/SEOOptimizer';
import PerformanceTracker from '../optimization/PerformanceTracker';

const ModernLandingPage: React.FC = () => {
  // Hooks
  const { services, paymentMethods, siteSettings, loading, error, refreshData } = useData();
  const { theme, language } = useTheme();
  const { customization } = useCustomization();
  const { t } = useTranslation(language);

  // State
  const [selectedService, setSelectedService] = useState<{name: string, price: string} | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isServicesOpen, setIsServicesOpen] = useState(false);
  const [scrollY, setScrollY] = useState(0);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [activeSection, setActiveSection] = useState('home');
  const [landingSections, setLandingSections] = useState<LandingPageSection[]>([]);
  const [sectionsLoading, setSectionsLoading] = useState(true);
  const [isVisible, setIsVisible] = useState(false);

  // Load landing page sections from database
  useEffect(() => {
    const loadSections = async () => {
      try {
        setSectionsLoading(true);
        const sections = await landingPageService.getLandingPageSections();
        setLandingSections(sections.filter(section => section.visible));
      } catch (error) {
        console.error('Error loading landing sections:', error);
        setLandingSections([]);
      } finally {
        setSectionsLoading(false);
      }
    };

    loadSections();
    setIsVisible(true);
  }, []);

  // Memoized data
  const activeServices = useMemo(() => 
    services.filter(service => service.active).sort((a, b) => a.order - b.order),
    [services]
  );

  const activePaymentMethods = useMemo(() => 
    paymentMethods.filter(method => method.active),
    [paymentMethods]
  );

  const featuredServices = useMemo(() =>
    activeServices.slice(0, 6),
    [activeServices]
  );

  // Scroll handling
  useEffect(() => {
    const handleScroll = () => {
      setScrollY(window.scrollY);
      
      // Update active section based on scroll position
      const sections = ['home', 'about', 'services', 'features', 'testimonials', 'contact'];
      const currentSection = sections.find(section => {
        const element = document.getElementById(section);
        if (element) {
          const rect = element.getBoundingClientRect();
          return rect.top <= 100 && rect.bottom >= 100;
        }
        return false;
      });
      
      if (currentSection && currentSection !== activeSection) {
        setActiveSection(currentSection);
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, [activeSection]);

  // Service selection handlers
  const handleServiceSelect = useCallback((service: any) => {
    setSelectedService({ name: service.name, price: service.price.toString() });
    setIsModalOpen(true);
  }, []);

  const handleWhatsAppContact = useCallback((service?: any) => {
    const message = service 
      ? `مرحباً، أود الاستفسار عن خدمة: ${service.name}`
      : 'مرحباً، أود الاستفسار عن خدماتكم';
    
    const whatsappNumber = siteSettings?.company_phone?.replace(/\s+/g, '') || '+966501234567';
    const whatsappUrl = `https://wa.me/${whatsappNumber}?text=${encodeURIComponent(message)}`;
    window.open(whatsappUrl, '_blank');
  }, [siteSettings?.company_phone]);

  if (loading || sectionsLoading) {
    return <LoadingSpinner />;
  }

  if (error) {
    return <ErrorMessage message={error} onRetry={refreshData} />;
  }

  return (
    <div className="min-h-screen bg-white dark:bg-gray-900 text-gray-900 dark:text-white" dir={language === 'ar' ? 'rtl' : 'ltr'}>
      <SEOOptimizer 
        title={siteSettings?.company_name || "KYCtrust - خدمات التحقق الرقمية المتطورة"}
        description="منصة رائدة في خدمات التحقق الرقمية والخدمات المالية المتطورة مع تقنيات حديثة وأمان عالي"
        keywords="KYC, التحقق الرقمي, الخدمات المالية, الأمان الرقمي, التكنولوجيا المالية"
      />
      <PerformanceTracker />

      {/* Advanced Navigation */}
      <nav className={`fixed top-0 w-full z-50 transition-all duration-500 ${
        scrollY > 100 
          ? 'bg-white/95 dark:bg-gray-900/95 backdrop-blur-xl shadow-2xl border-b border-gray-200/50 dark:border-gray-700/50' 
          : 'bg-transparent'
      }`}>
        <div className="container mx-auto px-6">
          <div className="flex items-center justify-between h-20">
            {/* Logo */}
            <div className="flex items-center space-x-reverse space-x-3 group">
              <div className="relative">
                <div className="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 p-3 rounded-2xl shadow-lg group-hover:shadow-xl transition-all duration-300 group-hover:scale-110">
                  <Shield className="h-8 w-8 text-white" />
                </div>
                <div className="absolute -top-1 -right-1 w-4 h-4 bg-green-500 rounded-full animate-pulse"></div>
              </div>
              <div>
                <span className="text-2xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent">
                  {siteSettings?.company_name || 'KYCtrust'}
                </span>
                <p className="text-xs text-gray-500 dark:text-gray-400">خدمات رقمية متطورة</p>
              </div>
            </div>

            {/* Navigation Links - Desktop */}
            <div className="hidden lg:flex items-center space-x-reverse space-x-8">
              {[
                { id: 'home', label: 'الرئيسية', icon: Rocket },
                { id: 'about', label: 'من نحن', icon: Users },
                { id: 'services', label: 'خدماتنا', icon: Package },
                { id: 'features', label: 'المميزات', icon: Star },
                { id: 'testimonials', label: 'آراء الع��لاء', icon: Heart },
                { id: 'contact', label: 'تواصل معنا', icon: MessageCircle }
              ].map((item) => (
                <a
                  key={item.id}
                  href={`#${item.id}`}
                  className={`relative flex items-center space-x-reverse space-x-2 px-4 py-2 rounded-xl font-medium transition-all duration-300 ${
                    activeSection === item.id
                      ? 'text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/30'
                      : 'text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 hover:bg-gray-100 dark:hover:bg-gray-800'
                  }`}
                >
                  <item.icon className="h-4 w-4" />
                  <span>{item.label}</span>
                  {activeSection === item.id && (
                    <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full"></div>
                  )}
                </a>
              ))}
            </div>

            {/* Action Buttons - Desktop */}
            <div className="hidden lg:flex items-center space-x-reverse space-x-4">
              <button
                onClick={() => setIsServicesOpen(true)}
                className="flex items-center px-4 py-2 text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors font-medium"
              >
                <Eye className="h-4 w-4 ml-2" />
                عرض جميع الخدمات
              </button>
              <button
                onClick={() => handleWhatsAppContact()}
                className="flex items-center px-6 py-3 bg-gradient-to-r from-green-500 to-green-600 text-white rounded-xl font-semibold hover:from-green-600 hover:to-green-700 transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
              >
                <MessageCircle className="h-4 w-4 ml-2" />
                واتساب
              </button>
              <button
                onClick={() => handleWhatsAppContact()}
                className="flex items-center px-6 py-3 bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 text-white rounded-xl font-semibold hover:shadow-lg transition-all duration-300 transform hover:scale-105"
              >
                <Rocket className="h-4 w-4 ml-2" />
                ابدأ الآن
              </button>
              <ThemeToggle />
              <LanguageToggle />
            </div>

            {/* Mobile Menu Button */}
            <div className="lg:hidden flex items-center space-x-reverse space-x-4">
              <LanguageToggle />
              <ThemeToggle />
              <button
                onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
                className="p-3 rounded-xl bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
              >
                {isMobileMenuOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
              </button>
            </div>
          </div>

          {/* Mobile Menu */}
          {isMobileMenuOpen && (
            <div className="lg:hidden bg-white dark:bg-gray-900 border-t border-gray-200 dark:border-gray-700 shadow-xl">
              <div className="px-6 py-6 space-y-4">
                {[
                  { id: 'home', label: 'الرئيسية', icon: Rocket },
                  { id: 'about', label: 'من نحن', icon: Users },
                  { id: 'services', label: 'خدماتنا', icon: Package },
                  { id: 'features', label: 'المميزات', icon: Star },
                  { id: 'contact', label: 'تواصل معنا', icon: MessageCircle }
                ].map((item) => (
                  <a
                    key={item.id}
                    href={`#${item.id}`}
                    onClick={() => setIsMobileMenuOpen(false)}
                    className="flex items-center space-x-reverse space-x-3 px-4 py-3 rounded-xl text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors font-medium"
                  >
                    <item.icon className="h-5 w-5" />
                    <span>{item.label}</span>
                  </a>
                ))}
                <div className="pt-4 border-t border-gray-200 dark:border-gray-700 space-y-3">
                  <button
                    onClick={() => {
                      setIsServicesOpen(true);
                      setIsMobileMenuOpen(false);
                    }}
                    className="w-full flex items-center justify-center px-4 py-3 bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 rounded-xl font-medium"
                  >
                    <Eye className="h-4 w-4 ml-2" />
                    عرض جميع الخدمات
                  </button>
                  <button
                    onClick={() => {
                      handleWhatsAppContact();
                      setIsMobileMenuOpen(false);
                    }}
                    className="w-full flex items-center justify-center px-4 py-3 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-xl font-semibold"
                  >
                    <Rocket className="h-4 w-4 ml-2" />
                    ابدأ رحلتك معنا
                  </button>
                  <LanguageToggle />
                </div>
              </div>
            </div>
          )}
        </div>
      </nav>

      {/* Modern Hero Section */}
      <ModernHeroSection
        title="مرحباً بك في عصر"
        titleGradient="الخدمات الرقمية المتطورة"
        subtitle="نحن نقود التحول الرقمي بحلول مبتكرة وموثوقة"
        description="منصة شاملة تجمع بين أحدث التقنيات والخبرة العميقة لتقديم خدمات رقمية استثنائية تلبي جميع احتياجاتك المالية والتجارية بأعلى معايير الجودة والأمان والابتكار"
        primaryButtonText="استكشف خدماتنا"
        secondaryButtonText="شاهد العرض التوضيحي"
        onPrimaryClick={() => handleWhatsAppContact()}
        onSecondaryClick={() => setIsServicesOpen(true)}
        showStats={true}
        backgroundType="animated"
        showFloatingElements={true}
        theme="modern"
      />

      {/* About Section */}
      <section id="about" className="py-24 bg-gray-50 dark:bg-gray-800/50">
        <div className="container mx-auto px-6">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
            <div className={`transition-all duration-1000 ${isVisible ? 'opacity-100 translate-x-0' : 'opacity-0 -translate-x-12'}`}>
              <div className="bg-gradient-to-r from-blue-100 to-purple-100 dark:from-blue-900/30 dark:to-purple-900/30 p-8 rounded-3xl">
                <div className="grid grid-cols-2 gap-6">
                  <div className="text-center p-6 bg-white dark:bg-gray-800 rounded-2xl shadow-lg">
                    <div className="bg-gradient-to-r from-blue-500 to-purple-600 p-4 rounded-full w-16 h-16 mx-auto mb-4 flex items-center justify-center">
                      <Users className="h-8 w-8 text-white" />
                    </div>
                    <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
                      <CounterAnimation value={15000} />+
                    </h3>
                    <p className="text-gray-600 dark:text-gray-400 text-sm">عميل راضٍ</p>
                  </div>
                  <div className="text-center p-6 bg-white dark:bg-gray-800 rounded-2xl shadow-lg">
                    <div className="bg-gradient-to-r from-green-500 to-teal-600 p-4 rounded-full w-16 h-16 mx-auto mb-4 flex items-center justify-center">
                      <Shield className="h-8 w-8 text-white" />
                    </div>
                    <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">99.9%</h3>
                    <p className="text-gray-600 dark:text-gray-400 text-sm">معدل الأمان</p>
                  </div>
                  <div className="text-center p-6 bg-white dark:bg-gray-800 rounded-2xl shadow-lg">
                    <div className="bg-gradient-to-r from-orange-500 to-red-600 p-4 rounded-full w-16 h-16 mx-auto mb-4 flex items-center justify-center">
                      <Clock className="h-8 w-8 text-white" />
                    </div>
                    <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">24/7</h3>
                    <p className="text-gray-600 dark:text-gray-400 text-sm">دعم متواصل</p>
                  </div>
                  <div className="text-center p-6 bg-white dark:bg-gray-800 rounded-2xl shadow-lg">
                    <div className="bg-gradient-to-r from-purple-500 to-pink-600 p-4 rounded-full w-16 h-16 mx-auto mb-4 flex items-center justify-center">
                      <Award className="h-8 w-8 text-white" />
                    </div>
                    <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
                      <CounterAnimation value={8} />+
                    </h3>
                    <p className="text-gray-600 dark:text-gray-400 text-sm">سنوات خبرة</p>
                  </div>
                </div>
              </div>
            </div>

            <div className={`transition-all duration-1000 delay-300 ${isVisible ? 'opacity-100 translate-x-0' : 'opacity-0 translate-x-12'}`}>
              <div className="inline-flex items-center px-4 py-2 bg-blue-100 dark:bg-blue-900/30 rounded-full mb-6">
                <Star className="h-4 w-4 text-blue-600 ml-2" />
                <span className="text-blue-600 dark:text-blue-400 text-sm font-medium">من نحن</span>
              </div>
              
              <h2 className="text-4xl md:text-5xl font-bold mb-6 text-gray-900 dark:text-white leading-tight">
                نحن رواد في مجال
                <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent"> التكنولوجيا المالية</span>
              </h2>
              
              <p className="text-xl text-gray-600 dark:text-gray-300 mb-8 leading-relaxed">
                منذ تأسيسنا، نلتزم بتقديم خدمات رقمية متطورة تجمع بين الابتكار والأمان والموثوقية. نحن نؤمن بأن التكنولوجيا يجب أن تكون في خدمة الإنسان وتسهل حياته اليومية.
              </p>
              
              <div className="space-y-4 mb-8">
                {[
                  'تكنولوجيا متطورة وحلول مبتكرة',
                  'فريق خبراء متخصص ومعتمد',
                  'أمان عالي وحماية شاملة للبيانات',
                  'دعم فني متواصل ومتميز'
                ].map((feature, index) => (
                  <div key={index} className="flex items-center space-x-reverse space-x-3">
                    <div className="bg-gradient-to-r from-green-500 to-teal-600 p-1 rounded-full">
                      <CheckCircle className="h-5 w-5 text-white" />
                    </div>
                    <span className="text-gray-700 dark:text-gray-300 font-medium">{feature}</span>
                  </div>
                ))}
              </div>
              
              <button
                onClick={() => handleWhatsAppContact()}
                className="flex items-center px-8 py-4 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-2xl font-semibold text-lg shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:scale-105"
              >
                تعرف على قصتنا
                <ArrowRight className="mr-2 h-5 w-5" />
              </button>
            </div>
          </div>
        </div>
      </section>

      {/* Enhanced Services Section */}
      <section id="services" className="py-24 bg-white dark:bg-gray-900">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <div className="inline-flex items-center px-4 py-2 bg-purple-100 dark:bg-purple-900/30 rounded-full mb-6">
              <Package className="h-4 w-4 text-purple-600 ml-2" />
              <span className="text-purple-600 dark:text-purple-400 text-sm font-medium">خدماتنا المتميزة</span>
            </div>
            
            <h2 className="text-4xl md:text-5xl font-bold mb-6 text-gray-900 dark:text-white">
              خدمات شاملة تلبي
              <span className="bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent"> جميع احتياجاتك</span>
            </h2>
            
            <p className="text-xl text-gray-600 dark:text-gray-300 max-w-3xl mx-auto">
              نقدم مجموعة متكاملة من الخدمات الرقمية المتطورة المصممة خصيصاً لتحقيق أهدافك وتطلعاتك
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {featuredServices.map((service, index) => (
              <div
                key={service.id}
                className={`group bg-gradient-to-br from-white to-gray-50 dark:from-gray-800 dark:to-gray-900 rounded-3xl p-8 shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:scale-105 border border-gray-100 dark:border-gray-700 relative overflow-hidden ${
                  index % 2 === 0 ? 'hover:rotate-1' : 'hover:-rotate-1'
                }`}
              >
                {/* Background Decoration */}
                <div className="absolute -top-20 -right-20 w-40 h-40 bg-gradient-to-r from-blue-400/20 to-purple-400/20 rounded-full blur-3xl group-hover:scale-150 transition-transform duration-500"></div>
                
                <div className="relative z-10">
                  <div className="flex items-center justify-between mb-6">
                    <div className={`bg-gradient-to-r ${
                      index % 3 === 0 ? 'from-blue-500 to-cyan-600' :
                      index % 3 === 1 ? 'from-purple-500 to-pink-600' :
                      'from-green-500 to-teal-600'
                    } p-4 rounded-2xl shadow-lg group-hover:shadow-xl transition-all duration-300 group-hover:scale-110`}>
                      <Shield className="h-8 w-8 text-white" />
                    </div>
                    <div className="text-left">
                      <span className="text-3xl font-bold text-blue-600 dark:text-blue-400">
                        {service.price}
                      </span>
                      <span className="text-sm text-gray-500 dark:text-gray-400 mr-1">
                        {service.currency || '$'}
                      </span>
                    </div>
                  </div>
                  
                  <h3 className="text-2xl font-bold mb-4 text-gray-900 dark:text-white group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                    {service.name}
                  </h3>
                  
                  <p className="text-gray-600 dark:text-gray-300 mb-6 leading-relaxed">
                    {service.description}
                  </p>
                  
                  <div className="space-y-3 mb-8">
                    {service.features && Array.isArray(service.features) && service.features.slice(0, 3).map((feature, featureIndex) => (
                      <div key={featureIndex} className="flex items-center space-x-reverse space-x-2">
                        <CheckCircle className="h-4 w-4 text-green-500 flex-shrink-0" />
                        <span className="text-sm text-gray-600 dark:text-gray-400">{feature}</span>
                      </div>
                    ))}
                  </div>
                  
                  <button
                    onClick={() => handleServiceSelect(service)}
                    className="w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white py-4 rounded-2xl font-semibold hover:shadow-lg transition-all duration-300 transform hover:scale-105 group-hover:from-purple-600 group-hover:to-pink-600"
                  >
                    اطلب الخدمة الآن
                  </button>
                </div>
              </div>
            ))}
          </div>
          
          <div className="text-center mt-12">
            <button
              onClick={() => setIsServicesOpen(true)}
              className="inline-flex items-center px-8 py-4 bg-gradient-to-r from-gray-800 to-gray-900 dark:from-gray-700 dark:to-gray-800 text-white rounded-2xl font-semibold hover:shadow-lg transition-all duration-300 transform hover:scale-105"
            >
              عرض جميع الخدمات
              <ArrowRight className="mr-2 h-5 w-5" />
            </button>
          </div>
        </div>
      </section>

      {/* Enhanced Features Section */}
      <section id="features" className="py-24 bg-gradient-to-br from-blue-50 to-purple-50 dark:from-gray-800 dark:to-gray-900">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <div className="inline-flex items-center px-4 py-2 bg-green-100 dark:bg-green-900/30 rounded-full mb-6">
              <Star className="h-4 w-4 text-green-600 ml-2" />
              <span className="text-green-600 dark:text-green-400 text-sm font-medium">مميزاتنا الفريدة</span>
            </div>
            
            <h2 className="text-4xl md:text-5xl font-bold mb-6 text-gray-900 dark:text-white">
              لماذا نحن
              <span className="bg-gradient-to-r from-green-600 to-teal-600 bg-clip-text text-transparent"> الخيار الأفضل؟</span>
            </h2>
            
            <p className="text-xl text-gray-600 dark:text-gray-300 max-w-3xl mx-auto">
              نتميز بمجموعة من الخصائص والمميزات التي تجعلنا الرائدين في مجالنا
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[
              {
                icon: Zap,
                title: 'سرعة في الأداء',
                description: 'تنفيذ سريع وفعال لجميع العمليات مع ضمان الدقة والجودة',
                color: 'from-yellow-500 to-orange-600',
                bgColor: 'from-yellow-50 to-orange-50 dark:from-yellow-900/20 dark:to-orange-900/20'
              },
              {
                icon: Shield,
                title: 'أمان متقدم',
                description: 'حماية شاملة للبيانات بأحدث تقنيات التشفير والأمان السيبراني',
                color: 'from-blue-500 to-indigo-600',
                bgColor: 'from-blue-50 to-indigo-50 dark:from-blue-900/20 dark:to-indigo-900/20'
              },
              {
                icon: Clock,
                title: 'دعم متواصل',
                description: 'فريق دعم متخصص متاح على مدار الساعة لمساعدتك في أي وقت',
                color: 'from-purple-500 to-pink-600',
                bgColor: 'from-purple-50 to-pink-50 dark:from-purple-900/20 dark:to-pink-900/20'
              },
              {
                icon: Globe,
                title: 'تغطية شامل��',
                description: 'خدمات متوفرة في جميع أنحاء المملكة مع إمكانية التوسع عالمياً',
                color: 'from-green-500 to-teal-600',
                bgColor: 'from-green-50 to-teal-50 dark:from-green-900/20 dark:to-teal-900/20'
              },
              {
                icon: TrendingUp,
                title: 'نمو مستمر',
                description: 'تطوير وتحديث مستمر للخدمات مواكبة لأحدث التقنيات والمعايير',
                color: 'from-red-500 to-pink-600',
                bgColor: 'from-red-50 to-pink-50 dark:from-red-900/20 dark:to-pink-900/20'
              },
              {
                icon: Award,
                title: 'جودة معتمدة',
                description: 'حاصلون على شهادات الجودة والاعتماد من أبرز المؤسسات الدولية',
                color: 'from-indigo-500 to-purple-600',
                bgColor: 'from-indigo-50 to-purple-50 dark:from-indigo-900/20 dark:to-purple-900/20'
              }
            ].map((feature, index) => (
              <div
                key={index}
                className={`group p-8 rounded-3xl shadow-lg hover:shadow-2xl transition-all duration-500 transform hover:scale-105 bg-gradient-to-br ${feature.bgColor} border border-gray-200/50 dark:border-gray-700/50`}
              >
                <div className={`bg-gradient-to-r ${feature.color} p-4 rounded-2xl w-16 h-16 mx-auto mb-6 flex items-center justify-center shadow-lg group-hover:shadow-xl transition-all duration-300 group-hover:scale-110`}>
                  <feature.icon className="h-8 w-8 text-white" />
                </div>
                
                <h3 className="text-xl font-bold mb-4 text-gray-900 dark:text-white text-center group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                  {feature.title}
                </h3>
                
                <p className="text-gray-600 dark:text-gray-300 text-center leading-relaxed">
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Enhanced Testimonials Section */}
      <section id="testimonials" className="py-24 bg-white dark:bg-gray-900">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <div className="inline-flex items-center px-4 py-2 bg-pink-100 dark:bg-pink-900/30 rounded-full mb-6">
              <Heart className="h-4 w-4 text-pink-600 ml-2" />
              <span className="text-pink-600 dark:text-pink-400 text-sm font-medium">آراء عملائنا</span>
            </div>
            
            <h2 className="text-4xl md:text-5xl font-bold mb-6 text-gray-900 dark:text-white">
              ماذا يقول
              <span className="bg-gradient-to-r from-pink-600 to-purple-600 bg-clip-text text-transparent"> عملاؤنا عنا؟</span>
            </h2>
            
            <p className="text-xl text-gray-600 dark:text-gray-300 max-w-3xl mx-auto">
              اكتشف تجارب العملاء الحقيقية وكيف ساعدناهم في تحقيق أهدافهم
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[
              {
                name: 'أحمد محمد',
                role: 'مدير شركة تقنية',
                content: 'خدمة استثنائية وفريق محترف. ساعدونا في تطوير منصتنا الرقمية بكفاءة عالية ووقت قياسي.',
                rating: 5,
                avatar: '👨‍💼'
              },
              {
                name: 'فاطمة العلي',
                role: 'رائدة أعمال',
                content: 'أنصح بشدة بخدماتهم. الدعم الفني متميز والحلول مبتكرة ومناسبة لاحتياجات السوق.',
                rating: 5,
                avatar: '👩‍💼'
              },
              {
                name: 'خالد السعود',
                role: 'مطور تطبيقات',
                content: 'تعاملت معهم في عدة مشاريع، وفي كل مرة أكتشف مستوى جديد من الاحترافية والابتكار.',
                rating: 5,
                avatar: '👨‍💻'
              }
            ].map((testimonial, index) => (
              <div
                key={index}
                className="group bg-gradient-to-br from-white to-gray-50 dark:from-gray-800 dark:to-gray-900 p-8 rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:scale-105 border border-gray-100 dark:border-gray-700"
              >
                <div className="flex items-center space-x-reverse space-x-4 mb-6">
                  <div className="text-4xl">{testimonial.avatar}</div>
                  <div>
                    <h4 className="text-lg font-bold text-gray-900 dark:text-white">{testimonial.name}</h4>
                    <p className="text-gray-600 dark:text-gray-400 text-sm">{testimonial.role}</p>
                  </div>
                </div>
                
                <div className="flex space-x-1 space-x-reverse mb-4">
                  {[...Array(testimonial.rating)].map((_, i) => (
                    <Star key={i} className="h-5 w-5 text-yellow-400 fill-current" />
                  ))}
                </div>
                
                <p className="text-gray-600 dark:text-gray-300 leading-relaxed italic">
                  "{testimonial.content}"
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Contact Section */}
      <section id="contact" className="py-24 bg-gradient-to-br from-blue-900 to-purple-900">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <div className="inline-flex items-center px-4 py-2 bg-white/10 backdrop-blur-sm rounded-full mb-6">
              <MessageCircle className="h-4 w-4 text-blue-300 ml-2" />
              <span className="text-blue-300 text-sm font-medium">تواصل معنا</span>
            </div>
            
            <h2 className="text-4xl md:text-5xl font-bold mb-6 text-white">
              جاهز لبدء
              <span className="bg-gradient-to-r from-yellow-400 to-pink-400 bg-clip-text text-transparent"> رحلتك معنا؟</span>
            </h2>
            
            <p className="text-xl text-blue-100 max-w-3xl mx-auto mb-12">
              نحن هنا لمساعدتك في تحقيق أهدافك. تواصل معنا اليوم ودعنا نبدأ رحلة النجاح سوياً
            </p>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
              {[
                {
                  icon: Phone,
                  title: 'اتصل بنا',
                  content: siteSettings?.company_phone || '+966 50 123 4567',
                  action: () => window.open(`tel:${siteSettings?.company_phone}`, '_blank')
                },
                {
                  icon: MessageCircle,
                  title: 'واتساب',
                  content: 'تواصل سريع ومباشر',
                  action: () => handleWhatsAppContact()
                },
                {
                  icon: Mail,
                  title: 'البريد الإلكتروني',
                  content: siteSettings?.company_email || 'info@kyctrust.com',
                  action: () => window.open(`mailto:${siteSettings?.company_email}`, '_blank')
                }
              ].map((contact, index) => (
                <button
                  key={index}
                  onClick={contact.action}
                  className="group p-6 bg-white/10 backdrop-blur-sm rounded-2xl border border-white/20 hover:bg-white/20 transition-all duration-300 transform hover:scale-105"
                >
                  <contact.icon className="h-8 w-8 text-blue-300 mx-auto mb-4 group-hover:scale-110 transition-transform" />
                  <h3 className="text-lg font-semibold text-white mb-2">{contact.title}</h3>
                  <p className="text-blue-200 text-sm">{contact.content}</p>
                </button>
              ))}
            </div>
            
            <button
              onClick={() => handleWhatsAppContact()}
              className="inline-flex items-center px-12 py-6 bg-gradient-to-r from-green-500 to-green-600 text-white rounded-2xl font-bold text-xl shadow-2xl hover:shadow-3xl transition-all duration-300 transform hover:scale-105"
            >
              ابدأ محادثة الآن
              <MessageCircle className="mr-3 h-6 w-6" />
            </button>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 dark:bg-black text-white py-16">
        <div className="container mx-auto px-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-12">
            <div className="md:col-span-2">
              <div className="flex items-center space-x-reverse space-x-3 mb-6">
                <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-3 rounded-2xl">
                  <Shield className="h-8 w-8 text-white" />
                </div>
                <div>
                  <h3 className="text-2xl font-bold">{siteSettings?.company_name || 'KYCtrust'}</h3>
                  <p className="text-gray-400">خدمات رقمية متطورة</p>
                </div>
              </div>
              <p className="text-gray-300 leading-relaxed mb-6">
                نحن شركة رائدة في مجال الخدمات الرقمية والتكنولوجيا المالية، نقدم حلولاً مبتكرة وموثوقة لعملائنا.
              </p>
              <div className="flex space-x-reverse space-x-4">
                {[
                  { icon: Instagram, href: '#' },
                  { icon: Twitter, href: '#' },
                  { icon: Linkedin, href: '#' },
                  { icon: Youtube, href: '#' }
                ].map((social, index) => (
                  <a
                    key={index}
                    href={social.href}
                    className="p-3 bg-gray-800 rounded-xl hover:bg-gradient-to-r hover:from-blue-600 hover:to-purple-600 transition-all duration-300 transform hover:scale-110"
                  >
                    <social.icon className="h-5 w-5" />
                  </a>
                ))}
              </div>
            </div>
            
            <div>
              <h4 className="text-lg font-semibold mb-6">روابط سريعة</h4>
              <ul className="space-y-3">
                {['الرئيسية', 'خدماتنا', 'من نحن', 'اتصل بنا'].map((link, index) => (
                  <li key={index}>
                    <a href="#" className="text-gray-400 hover:text-white transition-colors">
                      {link}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
            
            <div>
              <h4 className="text-lg font-semibold mb-6">تواصل معنا</h4>
              <ul className="space-y-3">
                <li className="flex items-center space-x-reverse space-x-3">
                  <Phone className="h-4 w-4 text-gray-400" />
                  <span className="text-gray-400">{siteSettings?.company_phone || '+966 50 123 4567'}</span>
                </li>
                <li className="flex items-center space-x-reverse space-x-3">
                  <Mail className="h-4 w-4 text-gray-400" />
                  <span className="text-gray-400">{siteSettings?.company_email || 'info@kyctrust.com'}</span>
                </li>
              </ul>
            </div>
          </div>
          
          <div className="border-t border-gray-800 pt-8 text-center">
            <p className="text-gray-400">
              © 2024 {siteSettings?.company_name || 'KYCtrust'}. جميع الحقوق محفوظة.
            </p>
          </div>
        </div>
      </footer>

      {/* Modals */}
      {isModalOpen && (
        <OrderModal
          isOpen={isModalOpen}
          onClose={() => {
            setIsModalOpen(false);
            setSelectedService(null);
          }}
          service={selectedService}
          paymentMethods={activePaymentMethods}
        />
      )}

      {isServicesOpen && (
        <ServicesShowcase
          isOpen={isServicesOpen}
          onClose={() => setIsServicesOpen(false)}
          services={activeServices}
          onServiceSelect={handleServiceSelect}
        />
      )}

      {/* Scroll to top button */}
      {scrollY > 500 && (
        <button
          onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
          className="fixed bottom-8 left-8 p-4 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-full shadow-2xl hover:shadow-3xl transition-all duration-300 transform hover:scale-110 z-50"
        >
          <ArrowRight className="h-6 w-6 rotate-90" />
        </button>
      )}
    </div>
  );
};

export default ModernLandingPage;
