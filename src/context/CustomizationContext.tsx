import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import toast from 'react-hot-toast';

export interface HeroSection {
  title: string;
  titleGradient: string;
  subtitle: string;
  button1Text: string;
  button2Text?: string;
  badgeText: string;
  showStats: boolean;
  statsData: {
    clients: string;
    successRate: string;
    support: string;
    speed: string;
  };
}

export interface GlobalSettings {
  primaryColor: string;
  secondaryColor: string;
  accentColor: string;
  fontFamily: string;
  borderRadius: string;
  spacing: string;
}

export interface PageElement {
  id: string;
  type: 'hero' | 'services' | 'features' | 'testimonials' | 'stats' | 'cta' | 'text' | 'image' | 'video' | 'form';
  position: { x: number; y: number };
  size: { width: number; height: number };
  content: any;
  styles: {
    backgroundColor?: string;
    textColor?: string;
    borderRadius?: number;
    padding?: number;
    margin?: number;
    animation?: string;
    fontSize?: number;
    fontWeight?: string;
    borderWidth?: number;
    borderColor?: string;
    fontFamily?: string;
  };
  visible: boolean;
  order: number;
}

export interface CustomizationData {
  hero: HeroSection;
  globalSettings: GlobalSettings;
  pageElements: PageElement[];
  pageLayout: {
    sections: string[];
    theme: string;
    customCSS?: string;
  };
}

interface CustomizationContextType {
  customization: CustomizationData;
  loading: boolean;
  error: string | null;
  updateHeroSection: (hero: HeroSection) => Promise<void>;
  updateGlobalSettings: (settings: GlobalSettings) => Promise<void>;
  updatePageElements: (elements: PageElement[]) => Promise<void>;
  updatePageLayout: (layout: any) => Promise<void>;
  addPageElement: (element: PageElement) => Promise<void>;
  updatePageElement: (id: string, updates: Partial<PageElement>) => Promise<void>;
  deletePageElement: (id: string) => Promise<void>;
  refreshCustomization: () => void;
  publishPage: () => Promise<void>;
}

// Default customization data
const defaultCustomization: CustomizationData = {
  hero: {
    title: 'مستقبل الخدمات',
    titleGradient: 'المالية الرقمية',
    subtitle: 'نحن نعيد تعريف الخدمات المالية الرقمية من خلال تقديم حلول مبتكرة وآمنة ومتطورة تلبي احتياجاتك المالية بكفاءة عالية وموثوقية استثنائية',
    button1Text: 'ابدأ رحلتك معنا',
    button2Text: 'استكشف الخدمات',
    badgeText: 'منصة رائدة في الخدمات المالية الرقمية',
    showStats: true,
    statsData: {
      clients: '15,000+',
      successRate: '99.9%',
      support: '24/7',
      speed: '< 5 دقائق'
    }
  },
  globalSettings: {
    primaryColor: '#3b82f6',
    secondaryColor: '#6366f1',
    accentColor: '#8b5cf6',
    fontFamily: 'Cairo',
    borderRadius: '1rem',
    spacing: '1.5rem'
  },
  pageElements: [],
  pageLayout: {
    sections: ['hero', 'services', 'features', 'testimonials', 'faq'],
    theme: 'modern',
    customCSS: ''
  }
};

const CustomizationContext = createContext<CustomizationContextType | undefined>(undefined);

export const CustomizationProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [customization, setCustomization] = useState<CustomizationData>(defaultCustomization);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Load customization from localStorage on mount
  useEffect(() => {
    try {
      const saved = localStorage.getItem('kyctrust_customization');
      if (saved) {
        const parsed = JSON.parse(saved);
        setCustomization({ ...defaultCustomization, ...parsed });
      }
    } catch (error) {
      console.error('Error loading customization:', error);
    }
  }, []);

  const saveToStorage = (data: CustomizationData) => {
    try {
      localStorage.setItem('kyctrust_customization', JSON.stringify(data));
    } catch (error) {
      console.error('Error saving customization:', error);
    }
  };

  const updateHeroSection = async (hero: HeroSection): Promise<void> => {
    try {
      setLoading(true);
      const newCustomization = { ...customization, hero };
      setCustomization(newCustomization);
      saveToStorage(newCustomization);
      setError(null);
    } catch (error) {
      const errorMessage = 'فشل في حفظ إعدادات القسم الرئيسي';
      setError(errorMessage);
      throw new Error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const updateGlobalSettings = async (settings: GlobalSettings): Promise<void> => {
    try {
      setLoading(true);
      const newCustomization = { ...customization, globalSettings: settings };
      setCustomization(newCustomization);
      saveToStorage(newCustomization);
      setError(null);

      // Apply CSS variables to the document
      const root = document.documentElement;
      root.style.setProperty('--primary-color', settings.primaryColor);
      root.style.setProperty('--secondary-color', settings.secondaryColor);
      root.style.setProperty('--accent-color', settings.accentColor);
      root.style.setProperty('--font-family', settings.fontFamily);
      root.style.setProperty('--border-radius', settings.borderRadius);
      root.style.setProperty('--spacing', settings.spacing);

    } catch (error) {
      const errorMessage = 'فشل في حفظ الإعدادات العامة';
      setError(errorMessage);
      throw new Error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const updatePageElements = async (elements: PageElement[]): Promise<void> => {
    try {
      setLoading(true);
      const newCustomization = { ...customization, pageElements: elements };
      setCustomization(newCustomization);
      saveToStorage(newCustomization);
      setError(null);
    } catch (error) {
      const errorMessage = 'فشل في حفظ عناصر الصفحة';
      setError(errorMessage);
      throw new Error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const updatePageLayout = async (layout: any): Promise<void> => {
    try {
      setLoading(true);
      const newCustomization = { ...customization, pageLayout: { ...customization.pageLayout, ...layout } };
      setCustomization(newCustomization);
      saveToStorage(newCustomization);
      setError(null);
    } catch (error) {
      const errorMessage = 'فشل في حفظ تخطيط الصفحة';
      setError(errorMessage);
      throw new Error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const addPageElement = async (element: PageElement): Promise<void> => {
    try {
      const newElements = [...customization.pageElements, element];
      await updatePageElements(newElements);
    } catch (error) {
      throw new Error('فشل في إضافة الع��صر');
    }
  };

  const updatePageElement = async (id: string, updates: Partial<PageElement>): Promise<void> => {
    try {
      const newElements = customization.pageElements.map(el =>
        el.id === id ? { ...el, ...updates } : el
      );
      await updatePageElements(newElements);
    } catch (error) {
      throw new Error('فشل في تحديث العنصر');
    }
  };

  const deletePageElement = async (id: string): Promise<void> => {
    try {
      const newElements = customization.pageElements.filter(el => el.id !== id);
      await updatePageElements(newElements);
    } catch (error) {
      throw new Error('فشل في حذف العنصر');
    }
  };

  const publishPage = async (): Promise<void> => {
    try {
      setLoading(true);
      // Here you would typically send the data to your backend
      localStorage.setItem('kyctrust_published_page', JSON.stringify(customization));

      // Trigger a page refresh to apply changes
      window.dispatchEvent(new CustomEvent('pagePublished', {
        detail: customization
      }));

      setError(null);
    } catch (error) {
      const errorMessage = 'فشل في نشر الصفحة';
      setError(errorMessage);
      throw new Error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const refreshCustomization = () => {
    try {
      const saved = localStorage.getItem('kyctrust_customization');
      if (saved) {
        const parsed = JSON.parse(saved);
        setCustomization({ ...defaultCustomization, ...parsed });
      } else {
        setCustomization(defaultCustomization);
      }
      setError(null);
    } catch (error) {
      console.error('Error refreshing customization:', error);
      setError('فشل في تحديث البيانات');
    }
  };

  const value: CustomizationContextType = {
    customization,
    loading,
    error,
    updateHeroSection,
    updateGlobalSettings,
    updatePageElements,
    updatePageLayout,
    addPageElement,
    updatePageElement,
    deletePageElement,
    refreshCustomization,
    publishPage
  };

  return (
    <CustomizationContext.Provider value={value}>
      {children}
    </CustomizationContext.Provider>
  );
};

export const useCustomization = (): CustomizationContextType => {
  const context = useContext(CustomizationContext);
  if (context === undefined) {
    throw new Error('useCustomization must be used within a CustomizationProvider');
  }
  return context;
};
