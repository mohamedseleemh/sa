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

  if (loading) {
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
      <CustomElementsRenderer />
    </div>
  );
};

export default ModernLandingPage;
