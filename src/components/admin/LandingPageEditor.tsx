import React, { useState, useEffect, useRef } from 'react';
import {
  Eye, Save, RefreshCw, Settings, Palette, Type, Layout,
  Image, Video, Grid, Plus, Trash2, Edit3, Copy, Move,
  Monitor, Smartphone, Tablet, Code, Download, Upload,
  Layers, Sliders, Sparkles, Target, TrendingUp, Star,
  Users, Clock, Shield, ArrowRight, Heart, Zap,
  ChevronUp, ChevronDown, MoreVertical, RotateCcw
} from 'lucide-react';
import { DndProvider, useDrag, useDrop } from 'react-dnd';
import { HTML5Backend } from 'react-dnd-html5-backend';
import toast from 'react-hot-toast';
import { landingPageService, type LandingPageSection } from '../../services/landingPageService';

// LandingPageSection interface is now imported from landingPageService

const sectionTemplates: Partial<LandingPageSection>[] = [
  {
    type: 'hero',
    name: 'قسم البطل (Hero)',
    content: {
      title: 'مرحباً بك في موقعنا',
      subtitle: 'نقدم أفضل الخدمات الرقمية',
      description: 'وصف مختصر عن الموقع والخدمات المقدمة',
      buttonText: 'ابدأ الآن',
      buttonLink: '#services'
    },
    styles: {
      background: '#1e3a8a',
      padding: '4rem 2rem',
      margin: '0',
      borderRadius: '0',
      textAlign: 'center',
      minHeight: '80vh',
      gradient: 'linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%)'
    }
  },
  {
    type: 'services',
    name: 'قسم الخدمات',
    content: {
      title: 'خدماتنا',
      subtitle: 'نقدم مجموعة شاملة من الخدمات',
      items: [
        { title: 'خدمة 1', description: 'وصف الخدمة الأولى', icon: 'shield' },
        { title: 'خدمة 2', description: 'وصف الخدمة الثانية', icon: 'star' },
        { title: 'خدمة 3', description: 'وصف الخدمة الثالثة', icon: 'zap' }
      ]
    },
    styles: {
      background: '#ffffff',
      padding: '4rem 2rem',
      margin: '0',
      borderRadius: '0',
      textAlign: 'center',
      minHeight: 'auto'
    }
  },
  {
    type: 'about',
    name: 'قسم عن الشركة',
    content: {
      title: 'من نحن',
      subtitle: 'نبذة عن شركتنا ورؤيتنا',
      description: 'وصف مفصل عن الشركة وأهدافها ورؤيتها المستقبلية'
    },
    styles: {
      background: '#f8fafc',
      padding: '4rem 2rem',
      margin: '0',
      borderRadius: '0',
      textAlign: 'center',
      minHeight: 'auto'
    }
  },
  {
    type: 'features',
    name: 'قسم المميزات',
    content: {
      title: 'لماذا نحن مختلفون',
      subtitle: 'المميزات التي تجعلنا الخيار الأفضل',
      items: [
        { title: 'سرعة الأداء', description: 'نقدم خدمات سريعة وموثوقة', icon: 'zap' },
        { title: 'أمان عالي', description: 'حماية كاملة لبياناتك', icon: 'shield' },
        { title: 'دعم 24/7', description: 'فريق دعم متاح على مدار الساعة', icon: 'clock' }
      ]
    },
    styles: {
      background: '#ffffff',
      padding: '4rem 2rem',
      margin: '0',
      borderRadius: '0',
      textAlign: 'center',
      minHeight: 'auto'
    }
  },
  {
    type: 'cta',
    name: 'دعوة للعمل (CTA)',
    content: {
      title: 'جاهز للبدء؟',
      subtitle: 'ابدأ رحلتك معنا اليوم',
      buttonText: 'تواصل معنا الآن',
      buttonLink: '#contact'
    },
    styles: {
      background: '#3b82f6',
      padding: '4rem 2rem',
      margin: '0',
      borderRadius: '0',
      textAlign: 'center',
      minHeight: 'auto',
      gradient: 'linear-gradient(135deg, #3b82f6 0%, #1e40af 100%)'
    }
  }
];

const DraggableSection: React.FC<{
  section: LandingPageSection;
  index: number;
  moveSection: (dragIndex: number, hoverIndex: number) => void;
  onEdit: (section: LandingPageSection) => void;
  onDelete: (id: string) => void;
  onDuplicate: (section: LandingPageSection) => void;
  onToggleVisibility: (id: string) => void;
}> = ({ section, index, moveSection, onEdit, onDelete, onDuplicate, onToggleVisibility }) => {
  const ref = useRef<HTMLDivElement>(null);

  const [{ handlerId }, drop] = useDrop({
    accept: 'section',
    collect(monitor) {
      return {
        handlerId: monitor.getHandlerId(),
      };
    },
    hover(item: { index: number }, monitor) {
      if (!ref.current) return;
      const dragIndex = item.index;
      const hoverIndex = index;
      
      if (dragIndex === hoverIndex) return;
      
      const hoverBoundingRect = ref.current?.getBoundingClientRect();
      const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
      const clientOffset = monitor.getClientOffset();
      const hoverClientY = clientOffset!.y - hoverBoundingRect.top;
      
      if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY) return;
      if (dragIndex > hoverIndex && hoverClientY > hoverMiddleY) return;
      
      moveSection(dragIndex, hoverIndex);
      item.index = hoverIndex;
    },
  });

  const [{ isDragging }, drag] = useDrag({
    type: 'section',
    item: () => ({ id: section.id, index }),
    collect: (monitor) => ({
      isDragging: monitor.isDragging(),
    }),
  });

  drag(drop(ref));

  const getIconForType = (type: string) => {
    switch (type) {
      case 'hero': return <Target className="h-4 w-4" />;
      case 'services': return <Grid className="h-4 w-4" />;
      case 'about': return <Users className="h-4 w-4" />;
      case 'features': return <Star className="h-4 w-4" />;
      case 'cta': return <ArrowRight className="h-4 w-4" />;
      default: return <Layout className="h-4 w-4" />;
    }
  };

  return (
    <div
      ref={ref}
      data-handler-id={handlerId}
      className={`group relative p-4 border-2 border-dashed rounded-lg transition-all duration-200 ${
        isDragging ? 'opacity-50 rotate-2' : 'opacity-100'
      } ${
        section.visible 
          ? 'border-blue-300 bg-blue-50 dark:bg-blue-900/20 dark:border-blue-600' 
          : 'border-gray-300 bg-gray-50 dark:bg-gray-800 dark:border-gray-600'
      } hover:border-blue-400 dark:hover:border-blue-500 cursor-move`}
    >
      {/* Drag Handle */}
      <div className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity">
        <Move className="h-4 w-4 text-gray-400" />
      </div>

      {/* Section Content */}
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3 space-x-reverse">
          <div className="flex items-center justify-center w-8 h-8 bg-blue-100 dark:bg-blue-900 rounded-lg">
            {getIconForType(section.type)}
          </div>
          <div>
            <h4 className="font-medium text-gray-900 dark:text-white">
              {section.name}
            </h4>
            <p className="text-sm text-gray-500 dark:text-gray-400">
              ترتيب: {section.order} | {section.content.title || 'بلا عنوان'}
            </p>
          </div>
        </div>
        
        <div className="flex items-center space-x-2 space-x-reverse">
          <button
            onClick={() => onToggleVisibility(section.id)}
            className={`p-2 rounded ${
              section.visible 
                ? 'text-green-600 hover:bg-green-100 dark:hover:bg-green-900/50' 
                : 'text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700'
            }`}
            title={section.visible ? 'إخفاء' : 'إظهار'}
          >
            <Eye className="h-4 w-4" />
          </button>
          
          <button
            onClick={() => onEdit(section)}
            className="p-2 text-blue-600 hover:bg-blue-100 dark:hover:bg-blue-900/50 rounded"
            title="تعديل"
          >
            <Edit3 className="h-4 w-4" />
          </button>
          
          <button
            onClick={() => onDuplicate(section)}
            className="p-2 text-green-600 hover:bg-green-100 dark:hover:bg-green-900/50 rounded"
            title="نسخ"
          >
            <Copy className="h-4 w-4" />
          </button>
          
          <button
            onClick={() => onDelete(section.id)}
            className="p-2 text-red-600 hover:bg-red-100 dark:hover:bg-red-900/50 rounded"
            title="حذف"
          >
            <Trash2 className="h-4 w-4" />
          </button>
        </div>
      </div>

      {/* Preview */}
      <div className="mt-3 p-3 bg-white dark:bg-gray-900 rounded border">
        <div 
          className="text-xs rounded p-2"
          style={{ 
            background: section.styles.background,
            color: section.content.textColor || '#000',
            textAlign: section.styles.textAlign
          }}
        >
          <div className="font-medium">{section.content.title || 'عنوان القسم'}</div>
          {section.content.subtitle && (
            <div className="text-xs opacity-70 mt-1">{section.content.subtitle}</div>
          )}
        </div>
      </div>
    </div>
  );
};

export const LandingPageEditor: React.FC = () => {
  const [sections, setSections] = useState<LandingPageSection[]>([]);
  const [selectedSection, setSelectedSection] = useState<LandingPageSection | null>(null);
  const [previewMode, setPreviewMode] = useState<'desktop' | 'tablet' | 'mobile'>('desktop');
  const [activeTab, setActiveTab] = useState<'sections' | 'edit' | 'style' | 'preview'>('sections');
  const [editForm, setEditForm] = useState<Partial<LandingPageSection>>({});

  useEffect(() => {
    loadSections();
  }, []);

  const loadSections = async () => {
    try {
      const sections = await landingPageService.getLandingPageSections();
      if (sections.length > 0) {
        setSections(sections);
      } else {
        // Initialize with default sections if none exist
        const defaultSections: LandingPageSection[] = sectionTemplates.map((template, index) => ({
          id: `section-${Date.now()}-${index}`,
          order: index,
          visible: true,
          ...template,
          styles: {
            background: '#ffffff',
            padding: '4rem 2rem',
            margin: '0',
            borderRadius: '0',
            textAlign: 'center',
            minHeight: 'auto',
            ...template.styles
          },
          animation: {
            type: 'fadeIn',
            duration: '0.6s',
            delay: `${index * 0.1}s`
          }
        } as LandingPageSection));

        setSections(defaultSections);
        await saveSections(defaultSections);
      }
    } catch (error) {
      console.error('Error loading sections:', error);
      toast.error('فشل في تحميل أقسام الصفحة');

      // Fallback to localStorage
      const savedSections = localStorage.getItem('landing-page-sections');
      if (savedSections) {
        setSections(JSON.parse(savedSections));
      }
    }
  };

  const saveSections = async (newSections: LandingPageSection[]) => {
    try {
      await landingPageService.saveLandingPageSections(newSections);
      setSections(newSections);
      toast.success('تم حفظ الأقسام بنجاح');
    } catch (error) {
      console.error('Error saving sections:', error);
      toast.error('فشل في حفظ الأقسام');

      // Fallback to localStorage
      localStorage.setItem('landing-page-sections', JSON.stringify(newSections));
      setSections(newSections);
    }
  };

  const moveSection = (dragIndex: number, hoverIndex: number) => {
    const newSections = [...sections];
    const dragSection = newSections[dragIndex];
    newSections.splice(dragIndex, 1);
    newSections.splice(hoverIndex, 0, dragSection);
    
    // Update orders
    newSections.forEach((section, index) => {
      section.order = index;
    });
    
    saveSections(newSections);
  };

  const addSection = (type: string) => {
    const template = sectionTemplates.find(t => t.type === type);
    if (!template) return;

    const newSection: LandingPageSection = {
      id: `section-${Date.now()}`,
      ...template,
      order: sections.length,
      visible: true,
      animation: {
        type: 'fadeIn',
        duration: '0.6s',
        delay: '0s'
      }
    } as LandingPageSection;

    const newSections = [...sections, newSection];
    saveSections(newSections);
    toast.success('تم إضافة القسم بنجاح');
  };

  const editSection = (section: LandingPageSection) => {
    setSelectedSection(section);
    setEditForm(section);
    setActiveTab('edit');
  };

  const saveEditedSection = () => {
    if (!selectedSection || !editForm) return;

    const newSections = sections.map(section =>
      section.id === selectedSection.id ? { ...section, ...editForm } : section
    );
    
    saveSections(newSections);
    setSelectedSection(null);
    setEditForm({});
    setActiveTab('sections');
    toast.success('تم حفظ التغييرات');
  };

  const deleteSection = (id: string) => {
    if (confirm('هل أنت متأكد من حذف هذا القسم؟')) {
      const newSections = sections.filter(section => section.id !== id);
      saveSections(newSections);
      toast.success('تم حذف القسم');
    }
  };

  const duplicateSection = (section: LandingPageSection) => {
    const newSection: LandingPageSection = {
      ...section,
      id: `section-${Date.now()}`,
      name: `${section.name} (نسخة)`,
      order: sections.length
    };

    const newSections = [...sections, newSection];
    saveSections(newSections);
    toast.success('تم نسخ القسم');
  };

  const toggleSectionVisibility = (id: string) => {
    const newSections = sections.map(section =>
      section.id === id ? { ...section, visible: !section.visible } : section
    );
    saveSections(newSections);
  };

  const exportPage = () => {
    const data = {
      sections,
      exportDate: new Date().toISOString(),
      version: '1.0'
    };
    
    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `landing-page-${new Date().toISOString().split('T')[0]}.json`;
    a.click();
    URL.revokeObjectURL(url);
    
    toast.success('تم تصدير الصفحة');
  };

  const previewDevices = [
    { id: 'desktop', name: 'سطح المكتب', icon: Monitor, width: '100%' },
    { id: 'tablet', name: 'تابلت', icon: Tablet, width: '768px' },
    { id: 'mobile', name: 'هاتف', icon: Smartphone, width: '375px' }
  ];

  const tabs = [
    { id: 'sections', name: 'الأقسام', icon: Layers },
    { id: 'edit', name: 'التحرير', icon: Edit3 },
    { id: 'style', name: 'التصميم', icon: Palette },
    { id: 'preview', name: 'المعاينة', icon: Eye }
  ];

  return (
    <DndProvider backend={HTML5Backend}>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex justify-between items-center">
          <div>
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
              محرر صفحة الهبوط
            </h2>
            <p className="text-gray-600 dark:text-gray-400">
              قم بتخصيص وترتيب أقسام صفحة الهبوط باستخدام السحب والإفلات
            </p>
          </div>
          
          <div className="flex items-center space-x-3 space-x-reverse">
            <button
              onClick={exportPage}
              className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg flex items-center"
            >
              <Download className="h-4 w-4 mr-2" />
              تصدير
            </button>
            
            <button
              onClick={() => saveSections(sections)}
              className="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg flex items-center"
            >
              <Save className="h-4 w-4 mr-2" />
              حفظ
            </button>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div className="bg-blue-50 dark:bg-blue-900/20 p-4 rounded-lg">
            <div className="flex items-center">
              <div className="bg-blue-600 p-2 rounded-lg mr-3">
                <Layers className="h-5 w-5 text-white" />
              </div>
              <div>
                <p className="text-sm font-medium text-blue-900 dark:text-blue-100">إجمالي الأقسام</p>
                <p className="text-2xl font-bold text-blue-600 dark:text-blue-400">{sections.length}</p>
              </div>
            </div>
          </div>
          
          <div className="bg-green-50 dark:bg-green-900/20 p-4 rounded-lg">
            <div className="flex items-center">
              <div className="bg-green-600 p-2 rounded-lg mr-3">
                <Eye className="h-5 w-5 text-white" />
              </div>
              <div>
                <p className="text-sm font-medium text-green-900 dark:text-green-100">الأقسام المرئية</p>
                <p className="text-2xl font-bold text-green-600 dark:text-green-400">
                  {sections.filter(s => s.visible).length}
                </p>
              </div>
            </div>
          </div>
          
          <div className="bg-yellow-50 dark:bg-yellow-900/20 p-4 rounded-lg">
            <div className="flex items-center">
              <div className="bg-yellow-600 p-2 rounded-lg mr-3">
                <Sparkles className="h-5 w-5 text-white" />
              </div>
              <div>
                <p className="text-sm font-medium text-yellow-900 dark:text-yellow-100">بـ رسوم متحركة</p>
                <p className="text-2xl font-bold text-yellow-600 dark:text-yellow-400">
                  {sections.filter(s => s.animation?.type !== 'none').length}
                </p>
              </div>
            </div>
          </div>
          
          <div className="bg-purple-50 dark:bg-purple-900/20 p-4 rounded-lg">
            <div className="flex items-center">
              <div className="bg-purple-600 p-2 rounded-lg mr-3">
                <Settings className="h-5 w-5 text-white" />
              </div>
              <div>
                <p className="text-sm font-medium text-purple-900 dark:text-purple-100">قيد التحرير</p>
                <p className="text-2xl font-bold text-purple-600 dark:text-purple-400">
                  {selectedSection ? '1' : '0'}
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Left Panel - Sections Management */}
          <div className="lg:col-span-1">
            <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700">
              {/* Tabs */}
              <div className="border-b border-gray-200 dark:border-gray-700">
                <nav className="flex">
                  {tabs.map((tab) => {
                    const IconComponent = tab.icon;
                    return (
                      <button
                        key={tab.id}
                        onClick={() => setActiveTab(tab.id as any)}
                        className={`flex items-center px-4 py-3 text-sm font-medium border-b-2 flex-1 justify-center ${
                          activeTab === tab.id
                            ? 'border-blue-500 text-blue-600 dark:text-blue-400'
                            : 'border-transparent text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'
                        }`}
                      >
                        <IconComponent className="h-4 w-4 mr-1" />
                        {tab.name}
                      </button>
                    );
                  })}
                </nav>
              </div>

              <div className="p-6">
                {/* Sections Tab */}
                {activeTab === 'sections' && (
                  <div className="space-y-4">
                    <div className="flex justify-between items-center">
                      <h3 className="text-lg font-medium text-gray-900 dark:text-white">أقسام الصفحة</h3>
                      <div className="relative">
                        <select
                          onChange={(e) => e.target.value && addSection(e.target.value)}
                          value=""
                          className="text-sm bg-blue-600 text-white rounded px-3 py-1 cursor-pointer"
                        >
                          <option value="">إضافة قسم</option>
                          {sectionTemplates.map((template) => (
                            <option key={template.type} value={template.type}>
                              {template.name}
                            </option>
                          ))}
                        </select>
                      </div>
                    </div>
                    
                    <div className="space-y-3 max-h-96 overflow-y-auto">
                      {sections.map((section, index) => (
                        <DraggableSection
                          key={section.id}
                          section={section}
                          index={index}
                          moveSection={moveSection}
                          onEdit={editSection}
                          onDelete={deleteSection}
                          onDuplicate={duplicateSection}
                          onToggleVisibility={toggleSectionVisibility}
                        />
                      ))}
                    </div>
                  </div>
                )}

                {/* Edit Tab */}
                {activeTab === 'edit' && selectedSection && (
                  <div className="space-y-4">
                    <div className="flex justify-between items-center">
                      <h3 className="text-lg font-medium text-gray-900 dark:text-white">تحرير القسم</h3>
                      <div className="flex space-x-2 space-x-reverse">
                        <button
                          onClick={() => {setActiveTab('sections'); setSelectedSection(null);}}
                          className="px-3 py-1 bg-gray-600 text-white text-sm rounded"
                        >
                          إلغاء
                        </button>
                        <button
                          onClick={saveEditedSection}
                          className="px-3 py-1 bg-blue-600 text-white text-sm rounded"
                        >
                          حفظ
                        </button>
                      </div>
                    </div>
                    
                    <div className="space-y-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                          اسم القسم
                        </label>
                        <input
                          type="text"
                          value={editForm.name || ''}
                          onChange={(e) => setEditForm({...editForm, name: e.target.value})}
                          className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg
                                   bg-white dark:bg-gray-900 text-gray-900 dark:text-white"
                        />
                      </div>
                      
                      <div>
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                          العنوان الرئيسي
                        </label>
                        <input
                          type="text"
                          value={editForm.content?.title || ''}
                          onChange={(e) => setEditForm({
                            ...editForm, 
                            content: {...editForm.content, title: e.target.value}
                          })}
                          className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg
                                   bg-white dark:bg-gray-900 text-gray-900 dark:text-white"
                        />
                      </div>
                      
                      <div>
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                          العنوان الفرعي
                        </label>
                        <input
                          type="text"
                          value={editForm.content?.subtitle || ''}
                          onChange={(e) => setEditForm({
                            ...editForm, 
                            content: {...editForm.content, subtitle: e.target.value}
                          })}
                          className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg
                                   bg-white dark:bg-gray-900 text-gray-900 dark:text-white"
                        />
                      </div>
                      
                      <div>
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                          الوصف
                        </label>
                        <textarea
                          value={editForm.content?.description || ''}
                          onChange={(e) => setEditForm({
                            ...editForm, 
                            content: {...editForm.content, description: e.target.value}
                          })}
                          rows={3}
                          className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg
                                   bg-white dark:bg-gray-900 text-gray-900 dark:text-white"
                        />
                      </div>
                      
                      <div className="grid grid-cols-2 gap-3">
                        <div>
                          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                            نص الزر
                          </label>
                          <input
                            type="text"
                            value={editForm.content?.buttonText || ''}
                            onChange={(e) => setEditForm({
                              ...editForm, 
                              content: {...editForm.content, buttonText: e.target.value}
                            })}
                            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg
                                     bg-white dark:bg-gray-900 text-gray-900 dark:text-white"
                          />
                        </div>
                        
                        <div>
                          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                            رابط الزر
                          </label>
                          <input
                            type="text"
                            value={editForm.content?.buttonLink || ''}
                            onChange={(e) => setEditForm({
                              ...editForm, 
                              content: {...editForm.content, buttonLink: e.target.value}
                            })}
                            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg
                                     bg-white dark:bg-gray-900 text-gray-900 dark:text-white"
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                )}

                {/* Style Tab */}
                {activeTab === 'style' && selectedSection && (
                  <div className="space-y-4">
                    <h3 className="text-lg font-medium text-gray-900 dark:text-white">تصميم القسم</h3>
                    
                    <div className="space-y-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                          لون الخلفية
                        </label>
                        <input
                          type="color"
                          value={editForm.styles?.background || '#ffffff'}
                          onChange={(e) => setEditForm({
                            ...editForm, 
                            styles: {...editForm.styles, background: e.target.value}
                          })}
                          className="w-full h-10 border border-gray-300 dark:border-gray-700 rounded-lg"
                        />
                      </div>
                      
                      <div>
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                          محاذاة النص
                        </label>
                        <select
                          value={editForm.styles?.textAlign || 'center'}
                          onChange={(e) => setEditForm({
                            ...editForm, 
                            styles: {...editForm.styles, textAlign: e.target.value as any}
                          })}
                          className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg
                                   bg-white dark:bg-gray-900 text-gray-900 dark:text-white"
                        >
                          <option value="right">يمين</option>
                          <option value="center">وسط</option>
                          <option value="left">يسار</option>
                        </select>
                      </div>
                      
                      <div>
                        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                          المسافة الداخلية
                        </label>
                        <input
                          type="text"
                          value={editForm.styles?.padding || '4rem 2rem'}
                          onChange={(e) => setEditForm({
                            ...editForm, 
                            styles: {...editForm.styles, padding: e.target.value}
                          })}
                          placeholder="4rem 2rem"
                          className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg
                                   bg-white dark:bg-gray-900 text-gray-900 dark:text-white"
                        />
                      </div>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* Right Panel - Preview */}
          <div className="lg:col-span-2">
            <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700">
              {/* Preview Header */}
              <div className="p-4 border-b border-gray-200 dark:border-gray-700">
                <div className="flex justify-between items-center">
                  <h3 className="text-lg font-medium text-gray-900 dark:text-white">معاينة الصفحة</h3>
                  
                  <div className="flex items-center space-x-3 space-x-reverse">
                    {previewDevices.map((device) => {
                      const IconComponent = device.icon;
                      return (
                        <button
                          key={device.id}
                          onClick={() => setPreviewMode(device.id as any)}
                          className={`flex items-center px-3 py-2 rounded-lg ${
                            previewMode === device.id
                              ? 'bg-blue-600 text-white'
                              : 'bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300'
                          }`}
                        >
                          <IconComponent className="h-4 w-4 mr-1" />
                          {device.name}
                        </button>
                      );
                    })}
                  </div>
                </div>
              </div>

              {/* Preview Content */}
              <div className="p-4">
                <div 
                  className="mx-auto border border-gray-300 dark:border-gray-700 rounded-lg overflow-hidden bg-white"
                  style={{ 
                    width: previewDevices.find(d => d.id === previewMode)?.width,
                    maxWidth: '100%',
                    minHeight: '400px'
                  }}
                >
                  {sections
                    .filter(section => section.visible)
                    .sort((a, b) => a.order - b.order)
                    .map((section) => (
                      <div
                        key={section.id}
                        className={`relative transition-all duration-300 cursor-pointer ${
                          selectedSection?.id === section.id ? 'ring-2 ring-blue-500' : ''
                        }`}
                        style={{
                          background: section.styles.gradient || section.styles.background,
                          padding: section.styles.padding,
                          margin: section.styles.margin,
                          borderRadius: section.styles.borderRadius,
                          textAlign: section.styles.textAlign,
                          minHeight: section.styles.minHeight
                        }}
                        onClick={() => editSection(section)}
                      >
                        {/* Section Content Preview */}
                        <div className="text-center">
                          {section.content.title && (
                            <h2 className="text-2xl font-bold mb-4" style={{ color: section.content.textColor || '#ffffff' }}>
                              {section.content.title}
                            </h2>
                          )}
                          
                          {section.content.subtitle && (
                            <p className="text-lg mb-4 opacity-80" style={{ color: section.content.textColor || '#ffffff' }}>
                              {section.content.subtitle}
                            </p>
                          )}
                          
                          {section.content.description && (
                            <p className="mb-6 opacity-70" style={{ color: section.content.textColor || '#ffffff' }}>
                              {section.content.description}
                            </p>
                          )}
                          
                          {section.content.buttonText && (
                            <button className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                              {section.content.buttonText}
                            </button>
                          )}
                          
                          {/* Special handling for different section types */}
                          {section.type === 'services' && section.content.items && (
                            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-8">
                              {section.content.items.map((item: any, index: number) => (
                                <div key={index} className="p-4 bg-white bg-opacity-10 rounded-lg">
                                  <h4 className="font-medium mb-2">{item.title}</h4>
                                  <p className="text-sm opacity-70">{item.description}</p>
                                </div>
                              ))}
                            </div>
                          )}
                        </div>
                        
                        {/* Edit Overlay */}
                        {selectedSection?.id === section.id && (
                          <div className="absolute top-2 right-2 bg-blue-600 text-white px-2 py-1 text-xs rounded">
                            قيد التحرير
                          </div>
                        )}
                      </div>
                    ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </DndProvider>
  );
};

export default LandingPageEditor;
