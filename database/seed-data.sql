-- KYCtrust Platform - Initial Data Seeding
-- إدراج البيانات الأولية لمنصة KYCtrust

-- ================================
-- Insert default site settings
-- إدراج إعدادات الموقع الافتراضية
-- ================================

INSERT INTO site_settings (
    site_title,
    site_title_en,
    site_description,
    site_description_en,
    hero_title,
    hero_title_en,
    hero_subtitle,
    hero_subtitle_en,
    order_notice,
    order_notice_en,
    primary_color,
    secondary_color,
    accent_color,
    contact_email,
    contact_phone,
    contact_whatsapp,
    social_links,
    business_hours,
    features,
    stats,
    seo_settings,
    analytics_settings,
    notification_settings
) VALUES (
    'KYCtrust - منصة موثوقة',
    'KYCtrust - Trusted Platform',
    'منصة موثوقة ل��خدمات المالية الرقمية - نحن نعيد تعريف المستقبل المالي',
    'Trusted Digital Financial Services Platform - Redefining the Financial Future',
    'مستقبل الخدمات المالية الرقمية',
    'The Future of Digital Financial Services',
    'نحن نعيد تعريف الخدمات المالية الرقمية من خلال تقديم حلول مبتكرة وآمنة ومتطورة تلبي احتياجات العصر الحديث',
    'We are redefining digital financial services through innovative, secure, and advanced solutions that meet modern era needs',
    'سيتم التواصل معك خلال 24 ساعة لتأكيد الطلب وبدء العمل',
    'We will contact you within 24 hours to confirm your order and start working',
    '#3B82F6',
    '#6366F1',
    '#8B5CF6',
    'info@kyctrust.com',
    '+966501234567',
    '+966501234567',
    '{"twitter": "https://twitter.com/kyctrust", "linkedin": "https://linkedin.com/company/kyctrust", "telegram": "https://t.me/kyctrust", "instagram": "https://instagram.com/kyctrust"}',
    '{"sunday": "09:00-17:00", "monday": "09:00-17:00", "tuesday": "09:00-17:00", "wednesday": "09:00-17:00", "thursday": "09:00-17:00", "friday": "14:00-17:00", "saturday": "09:00-17:00"}',
    '{"security": {"title": "أمان متقدم", "title_en": "Advanced Security", "description": "حماية بمستوى البنوك مع تشفير عالي الجودة", "description_en": "Bank-level protection with high-quality encryption"}, "speed": {"title": "سرعة في التنفيذ", "title_en": "Fast Execution", "description": "إنجاز الطلبات في أقل من 5 دقائق", "description_en": "Complete orders in less than 5 minutes"}, "support": {"title": "دعم على مدار الساعة", "title_en": "24/7 Support", "description": "فريق دعم متخصص متاح 24/7", "description_en": "Professional support team available 24/7"}, "trust": {"title": "موثوقية عالية", "title_en": "High Reliability", "description": "معدل نجاح 99.9% في جميع الخدمات", "description_en": "99.9% success rate in all services"}}',
    '{"clients": 10000, "orders": 25000, "success_rate": 99.9, "countries": 50}',
    '{"title": "KYCtrust - منصة موثوقة للخدمات المالية الرقمية", "description": "احصل على أفضل الخدمات المالية الرقمية من منصة KYCtrust الموثوقة. خدمات سريعة وآمنة ومتط��رة.", "keywords": "خدمات مالية، رقمية، KYCtrust، موثوقة، آمنة، سريعة"}',
    '{"google_analytics": "", "facebook_pixel": "", "hotjar": "", "enabled": false}',
    '{"email_notifications": true, "sms_notifications": false, "push_notifications": true, "order_notifications": true, "marketing_notifications": false}'
) ON CONFLICT DO NOTHING;

-- ================================
-- Insert default services
-- إدراج الخدمات الافتراضية
-- ================================

INSERT INTO services (name, name_en, description, description_en, price, price_numeric, category, icon, color, order_index, active, featured) VALUES
('خدمات KYC المتقدمة', 'Advanced KYC Services', 'خدمات تحقق هوية متطورة ومعتمدة دولياً للأفراد والشركات', 'Advanced and internationally certified identity verification services for individuals and companies', '$299', 299.00, 'kyc', 'shield-check', '#3B82F6', 1, true, true),
('تحليل المخاطر المالية', 'Financial Risk Analysis', 'تقييم شامل للمخاطر المالية باستخدام أحدث التقنيات والخوارزميات', 'Comprehensive financial risk assessment using latest technologies and algorithms', '$199', 199.00, 'analysis', 'trending-up', '#10B981', 2, true, true),
('خدمات AML المتخصصة', 'Specialized AML Services', 'خدمات مكافحة غسيل الأموال وتمويل الإرهاب وفقاً للمعايير الدولية', 'Anti-money laundering and terrorism financing services according to international standards', '$399', 399.00, 'compliance', 'shield', '#EF4444', 3, true, true),
('استشارات الامتثال المالي', 'Financial Compliance Consulting', 'استشارات متخصصة في الامتثال للوائح المالية المحلية والدولية', 'Specialized consulting in compliance with local and international financial regulations', '$499', 499.00, 'consulting', 'book-open', '#8B5CF6', 4, true, false),
('تدقيق الحسابات الرقمية', 'Digital Account Auditing', 'خدمات تدقيق شاملة للحسابات والمحافظ الرقمية', 'Comprehensive auditing services for digital accounts and wallets', '$349', 349.00, 'audit', 'search', '#F59E0B', 5, true, false),
('حلول الدفع الآمنة', 'Secure Payment Solutions', 'تطوير وتنفيذ حلول دفع آمنة ومتطورة للشركات', 'Development and implementation of secure and advanced payment solutions for companies', '$799', 799.00, 'payment', 'credit-card', '#06B6D4', 6, true, true);

-- ================================
-- Insert default payment methods
-- إدراج طرق الدفع الافتراضية
-- ================================

INSERT INTO payment_methods (name, name_en, description, description_en, details, details_en, type, icon, color, order_index, active, account_info, instructions, instructions_en) VALUES
('التحويل البنكي المحلي', 'Local Bank Transfer', 'تحويل مصرفي آمن وسريع داخل المملكة', 'Safe and fast bank transfer within the Kingdom', 'بنك الراجحي - فرع الرياض الرئيسي', 'Al Rajhi Bank - Main Riyadh Branch', 'bank', 'building-2', '#22C55E', 1, true, 
'{"account_name": "KYCtrust Financial Services", "account_number": "123456789012", "iban": "SA1234567890123456789012", "swift": "RJHISARI", "bank_name": "بنك الراجحي", "branch": "فرع الرياض الرئيسي"}',
'قم بتحويل المبلغ إلى الحساب المذكور وأرسل إيصال التحويل عبر واتساب',
'Transfer the amount to the mentioned account and send the transfer receipt via WhatsApp'),

('محفظة STC Pay', 'STC Pay Wallet', 'دفع سريع وآمن عبر محفظة STC Pay', 'Fast and secure payment via STC Pay wallet', 'رقم المحفظة: +966501234567', 'Wallet Number: +966501234567', 'wallet', 'wallet', '#E11D48', 2, true,
'{"wallet_number": "+966501234567", "account_name": "KYCtrust Services", "type": "business"}',
'ادفع المبلغ عبر STC Pay وأرسل لقطة شاشة للعملية',
'Pay the amount via STC Pay and send a screenshot of the transaction'),

('تحويل Wise', 'Wise Transfer', 'تحويل دولي سريع وبأسعار تنافسية', 'Fast international transfer with competitive rates', 'حساب Wise للتحويلات الدولية', 'Wise account for international transfers', 'international', 'globe', '#6366F1', 3, true,
'{"email": "payments@kyctrust.com", "account_type": "business", "currencies": ["USD", "EUR", "GBP", "SAR"]}',
'استخدم البريد الإلكتروني payments@kyctrust.com للتحويل عبر Wise',
'Use email payments@kyctrust.com for transfer via Wise'),

('العملات المشفرة', 'Cryptocurrency', 'دفع آمن بالعملات المشفرة المعتمدة', 'Secure payment with approved cryptocurrencies', 'USDT, Bitcoin, Ethereum', 'USDT, Bitcoin, Ethereum', 'crypto', 'coins', '#F59E0B', 4, true,
'{"btc_address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh", "eth_address": "0x742d35Cc6661C0532E6c1d7d6c8a8d9F8A8F8D2E", "usdt_address": "TQn9Y2khEsLJW3Jse6F8J8J8J8J8J8J8J8"}',
'اختر العملة المناسبة وأرسل المبلغ إلى العنوان المحدد',
'Choose the appropriate currency and send the amount to the specified address');

-- ================================
-- Insert default admin user
-- إدراج مستخدم إداري افتراضي
-- ================================

INSERT INTO admin_users (
    email, 
    password_hash, 
    name, 
    role, 
    permissions, 
    active,
    email_verified
) VALUES (
    'admin@kyctrust.com',
    crypt('admin123456', gen_salt('bf')),
    'مدير النظام',
    'admin',
    ARRAY['manage_services', 'manage_orders', 'manage_payments', 'manage_settings', 'manage_admins', 'view_analytics', 'manage_templates', 'manage_themes'],
    true,
    true
) ON CONFLICT (email) DO NOTHING;

-- ================================
-- Insert default theme
-- إدراج الثيم الافتراضي
-- ================================

INSERT INTO themes (
    name,
    name_en,
    description,
    description_en,
    colors,
    fonts,
    spacing,
    animations,
    is_default,
    is_active,
    category
) VALUES (
    'الثيم الافتراضي',
    'Default Theme',
    'الثيم الافتراضي للمنصة مع الألوا�� والخطوط المناسبة',
    'Default theme for the platform with appropriate colors and fonts',
    '{"primary": "#3B82F6", "secondary": "#6366F1", "accent": "#8B5CF6", "success": "#10B981", "warning": "#F59E0B", "error": "#EF4444", "background": "#FFFFFF", "surface": "#F8FAFC", "text": "#1F2937"}',
    '{"heading": "Cairo", "body": "system-ui", "mono": "Courier New"}',
    '{"xs": "0.25rem", "sm": "0.5rem", "md": "1rem", "lg": "1.5rem", "xl": "3rem"}',
    '{"duration": "300ms", "easing": "cubic-bezier(0.25, 0.8, 0.25, 1)"}',
    true,
    true,
    'default'
) ON CONFLICT DO NOTHING;

-- ================================
-- Insert sample page template
-- إدراج قالب صفحة تجريبي
-- ================================

INSERT INTO page_templates (
    name,
    name_en,
    description,
    description_en,
    type,
    template_data,
    is_default,
    is_published,
    category
) VALUES (
    'الصفحة الرئيسية الافتراضية',
    'Default Landing Page',
    'قالب الصفحة الرئيسية الافتراضي مع جميع الأقسام الأساسية',
    'Default landing page template with all essential sections',
    'landing',
    '{"hero": {"title": "مستقبل الخدمات المالية الرقمية", "subtitle": "نحن نعيد تعريف الخدمات المالية الرقمية", "cta": "ابدأ الآن"}, "features": {"title": "لماذا نحن؟", "items": [{"title": "أمان متقدم", "description": "حماية بمستوى البنوك"}, {"title": "سرعة في التنفيذ", "description": "إنجاز في أقل من 5 دقائق"}, {"title": "دعم 24/7", "description": "فريق دعم متخصص"}]}, "services": {"title": "خدماتنا", "subtitle": "نقدم مجموعة شاملة من الخدمات المالية الرقمية"}, "testimonials": {"title": "آراء العملاء", "items": []}, "contact": {"title": "تواصل معنا", "subtitle": "نحن هنا لمساعدتك"}}',
    true,
    true,
    'business'
) ON CONFLICT DO NOTHING;

-- ================================
-- Insert sample analytics events
-- إدراج أحداث تحليلات تجريبية
-- ================================

INSERT INTO analytics_events (event_type, event_category, event_action, page_url, page_title, metadata) VALUES
('page_view', 'navigation', 'view', '/', 'الصفحة الرئيسية', '{"section": "hero"}'),
('page_view', 'navigation', 'view', '/admin', 'لوحة الإدارة', '{"section": "dashboard"}'),
('user_interaction', 'engagement', 'click', '/', 'الصفحة الرئيسية', '{"element": "cta_button", "text": "ابدأ الآن"}'),
('service_view', 'services', 'view', '/', 'الصفحة الرئيسية', '{"service_name": "خدمات KYC المتقدمة"}'),
('order_started', 'conversion', 'start', '/', 'الصفحة الرئيسية', '{"service": "خدمات KYC المتقدمة", "step": "selection"}'
);

-- ================================
-- Update sequences to avoid conflicts
-- تحديث التسلسلات لتجنب التعارضات
-- ================================

-- This ensures auto-generated IDs don't conflict with our inserted data
SELECT setval(pg_get_serial_sequence('services', 'order_index'), COALESCE(MAX(order_index), 0) + 1, false) FROM services;
SELECT setval(pg_get_serial_sequence('payment_methods', 'order_index'), COALESCE(MAX(order_index), 0) + 1, false) FROM payment_methods;

-- ================================
-- Success message
-- رسالة نجاح الإعداد
-- ================================

SELECT 'Initial data seeded successfully! 🌱' as status;
SELECT 'تم إدراج البيانات الأولية بنجاح! 🌱' as status_ar;

-- Show summary of inserted data
SELECT 
    (SELECT COUNT(*) FROM services) as services_count,
    (SELECT COUNT(*) FROM payment_methods) as payment_methods_count,
    (SELECT COUNT(*) FROM admin_users) as admin_users_count,
    (SELECT COUNT(*) FROM site_settings) as site_settings_count,
    (SELECT COUNT(*) FROM themes) as themes_count,
    (SELECT COUNT(*) FROM page_templates) as templates_count;
