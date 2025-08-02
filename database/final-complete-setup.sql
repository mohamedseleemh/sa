-- ================================
-- KYCtrust Platform - FINAL COMPLETE SETUP
-- إعداد منصة KYCtrust الشامل النهائي
-- ================================
-- 
-- This script sets up EVERYTHING for KYCtrust platform:
-- هذا السكريپت يعد كل شيء لمنصة KYCtrust:
-- 
-- 1. Database structure (tables, indexes, triggers)
-- 2. Row Level Security (RLS) policies  
-- 3. Complete initial data (services, payments, admin)
-- 4. Views and functions
-- 
-- INSTRUCTIONS:
-- 1. Open Supabase SQL Editor
-- 2. Copy and paste this ENTIRE script
-- 3. Click "Run" 
-- 4. Wait for completion message
-- 
-- تعليمات:
-- 1. افتح محرر SQL في Supabase
-- 2. انسخ والصق هذا السكريپت كاملاً
-- 3. اضغط "تشغيل"
-- 4. انتظر رسالة الإكمال
-- 
-- ================================

-- Start transaction
BEGIN;

-- Show start message
SELECT 
    '🚀 Starting KYCtrust Complete Database Setup...' as status,
    '🚀 بدء إعداد قاعدة بيانات KYCtrust الكاملة...' as status_ar,
    NOW() as started_at;

-- ================================
-- STEP 1: ENABLE EXTENSIONS
-- الخطوة 1: تفعيل الامتدادات
-- ================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

SELECT '✅ Extensions enabled | تم تفعيل الامتدادات' as step_1;

-- ================================
-- STEP 2: DROP EXISTING TABLES (CAREFUL!)
-- الخطوة 2: حذف الجداول الموجودة (احذر!)
-- ================================

DROP TABLE IF EXISTS analytics_events CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS site_settings CASCADE;
DROP TABLE IF EXISTS payment_methods CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS admin_users CASCADE;
DROP TABLE IF EXISTS page_templates CASCADE;
DROP TABLE IF EXISTS themes CASCADE;
DROP TABLE IF EXISTS rls_settings CASCADE;

SELECT '✅ Existing tables dropped | تم حذف الجداول الموجودة' as step_2;

-- ================================
-- STEP 3: CREATE ALL TABLES
-- الخطوة 3: إنشاء جميع الجداول
-- ================================

-- Services Table
CREATE TABLE services (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    description_en TEXT,
    price TEXT NOT NULL,
    price_numeric DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'USD',
    category VARCHAR(50),
    icon VARCHAR(50),
    color VARCHAR(50) DEFAULT '#3B82F6',
    order_index INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    featured BOOLEAN DEFAULT false,
    tags TEXT[] DEFAULT '{}',
    requirements TEXT,
    delivery_time VARCHAR(50) DEFAULT '24 hours',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Payment Methods Table
CREATE TABLE payment_methods (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    description_en TEXT,
    details TEXT,
    details_en TEXT,
    type VARCHAR(50) DEFAULT 'bank',
    icon VARCHAR(50),
    color VARCHAR(50) DEFAULT '#22C55E',
    account_info JSONB DEFAULT '{}',
    instructions TEXT,
    instructions_en TEXT,
    order_index INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    fees JSONB DEFAULT '{}',
    limits JSONB DEFAULT '{}',
    processing_time VARCHAR(50) DEFAULT '1-3 business days',
    supported_currencies TEXT[] DEFAULT '{"USD","SAR","EUR"}',
    min_amount DECIMAL(10,2) DEFAULT 0,
    max_amount DECIMAL(10,2),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Orders Table
CREATE TABLE orders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    customer_name TEXT NOT NULL,
    customer_email VARCHAR(255),
    customer_phone VARCHAR(20),
    customer_country VARCHAR(100) DEFAULT 'Saudi Arabia',
    service_id UUID REFERENCES services(id) ON DELETE SET NULL,
    service_name TEXT NOT NULL,
    service_price TEXT,
    payment_method_id UUID REFERENCES payment_methods(id) ON DELETE SET NULL,
    payment_method_name TEXT,
    notes TEXT,
    customer_notes TEXT,
    admin_notes TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'cancelled', 'refunded')),
    priority VARCHAR(10) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    amount DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'USD',
    payment_status VARCHAR(20) DEFAULT 'pending',
    payment_reference TEXT,
    delivery_info JSONB DEFAULT '{}',
    tracking_info JSONB DEFAULT '{}',
    attachments TEXT[] DEFAULT '{}',
    tags TEXT[] DEFAULT '{}',
    estimated_delivery DATE,
    completed_at TIMESTAMP WITH TIME ZONE,
    archived BOOLEAN DEFAULT false,
    archived_at TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Site Settings Table
CREATE TABLE site_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    site_title TEXT NOT NULL DEFAULT 'KYCtrust',
    site_title_en TEXT DEFAULT 'KYCtrust',
    site_description TEXT DEFAULT 'منصة موثوقة للخدمات المالية الرقمية',
    site_description_en TEXT DEFAULT 'Trusted Digital Financial Services Platform',
    primary_color VARCHAR(7) DEFAULT '#3B82F6',
    secondary_color VARCHAR(7) DEFAULT '#6366F1',
    accent_color VARCHAR(7) DEFAULT '#8B5CF6',
    hero_title TEXT DEFAULT 'مستقبل الخدمات المالية الرقمية',
    hero_title_en TEXT DEFAULT 'The Future of Digital Financial Services',
    hero_subtitle TEXT DEFAULT 'نحن نعيد تعريف الخدمات المالية الرقمية من خلال تقديم حلول مبتكرة وآمنة ومتطورة',
    hero_subtitle_en TEXT DEFAULT 'We are redefining digital financial services through innovative, secure, and advanced solutions',
    order_notice TEXT DEFAULT 'سيتم التواصل معك خلال 24 ساعة لتأكيد الطلب',
    order_notice_en TEXT DEFAULT 'We will contact you within 24 hours to confirm your order',
    contact_email VARCHAR(255) DEFAULT 'info@kyctrust.com',
    contact_phone VARCHAR(20) DEFAULT '+966501234567',
    contact_whatsapp VARCHAR(20) DEFAULT '+966501234567',
    social_links JSONB DEFAULT '{}',
    business_hours JSONB DEFAULT '{}',
    features JSONB DEFAULT '{}',
    stats JSONB DEFAULT '{}',
    testimonials JSONB DEFAULT '{}',
    faqs JSONB DEFAULT '{}',
    seo_settings JSONB DEFAULT '{}',
    analytics_settings JSONB DEFAULT '{}',
    notification_settings JSONB DEFAULT '{}',
    security_settings JSONB DEFAULT '{}',
    maintenance_mode BOOLEAN DEFAULT false,
    maintenance_message TEXT,
    active BOOLEAN DEFAULT true,
    version VARCHAR(10) DEFAULT '2.0.0',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Admin Users Table
CREATE TABLE admin_users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name TEXT NOT NULL,
    role VARCHAR(20) DEFAULT 'admin' CHECK (role IN ('super_admin', 'admin', 'manager', 'operator')),
    permissions TEXT[] DEFAULT ARRAY['read'],
    avatar TEXT,
    phone VARCHAR(20),
    last_login TIMESTAMP WITH TIME ZONE,
    login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP WITH TIME ZONE,
    email_verified BOOLEAN DEFAULT false,
    two_factor_enabled BOOLEAN DEFAULT false,
    two_factor_secret TEXT,
    session_token TEXT,
    reset_token TEXT,
    reset_token_expires TIMESTAMP WITH TIME ZONE,
    preferences JSONB DEFAULT '{}',
    timezone VARCHAR(50) DEFAULT 'Asia/Riyadh',
    language VARCHAR(5) DEFAULT 'ar',
    theme VARCHAR(20) DEFAULT 'light',
    active BOOLEAN DEFAULT true,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Analytics Events Table
CREATE TABLE analytics_events (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    event_category VARCHAR(50),
    event_action VARCHAR(50),
    event_label TEXT,
    event_value DECIMAL(10,2),
    user_id UUID,
    session_id VARCHAR(100),
    user_agent TEXT,
    ip_address INET,
    country VARCHAR(100),
    city VARCHAR(100),
    device_type VARCHAR(20),
    browser VARCHAR(50),
    os VARCHAR(50),
    page_url TEXT NOT NULL,
    page_title TEXT,
    referrer_url TEXT,
    utm_source VARCHAR(100),
    utm_medium VARCHAR(100),
    utm_campaign VARCHAR(100),
    utm_term VARCHAR(100),
    utm_content VARCHAR(100),
    metadata JSONB DEFAULT '{}',
    custom_properties JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Page Templates Table
CREATE TABLE page_templates (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    description_en TEXT,
    type VARCHAR(50) DEFAULT 'landing',
    template_data JSONB NOT NULL DEFAULT '{}',
    preview_image TEXT,
    category VARCHAR(50),
    tags TEXT[] DEFAULT '{}',
    is_default BOOLEAN DEFAULT false,
    is_published BOOLEAN DEFAULT true,
    version VARCHAR(10) DEFAULT '1.0.0',
    author VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Themes Table
CREATE TABLE themes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    description_en TEXT,
    colors JSONB NOT NULL DEFAULT '{}',
    fonts JSONB DEFAULT '{}',
    spacing JSONB DEFAULT '{}',
    animations JSONB DEFAULT '{}',
    custom_css TEXT,
    preview_image TEXT,
    is_default BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT false,
    category VARCHAR(50),
    tags TEXT[] DEFAULT '{}',
    version VARCHAR(10) DEFAULT '1.0.0',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS Settings Table
CREATE TABLE rls_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    environment VARCHAR(20) DEFAULT 'development',
    strict_mode BOOLEAN DEFAULT false,
    rate_limiting_enabled BOOLEAN DEFAULT false,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

SELECT '✅ All tables created | تم إنشاء جميع الجداول' as step_3;

-- ================================
-- STEP 4: CREATE INDEXES
-- الخطوة 4: إنشاء الفهارس
-- ================================

-- Services indexes
CREATE INDEX idx_services_active ON services(active);
CREATE INDEX idx_services_category ON services(category);
CREATE INDEX idx_services_order ON services(order_index);
CREATE INDEX idx_services_featured ON services(featured);

-- Payment methods indexes
CREATE INDEX idx_payment_methods_active ON payment_methods(active);
CREATE INDEX idx_payment_methods_type ON payment_methods(type);

-- Orders indexes
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_orders_customer_email ON orders(customer_email);
CREATE INDEX idx_orders_service_id ON orders(service_id);
CREATE INDEX idx_orders_archived ON orders(archived);

-- Analytics indexes
CREATE INDEX idx_analytics_event_type ON analytics_events(event_type);
CREATE INDEX idx_analytics_created_at ON analytics_events(created_at);
CREATE INDEX idx_analytics_user_id ON analytics_events(user_id);
CREATE INDEX idx_analytics_session_id ON analytics_events(session_id);

-- Admin users indexes
CREATE INDEX idx_admin_users_email ON admin_users(email);
CREATE INDEX idx_admin_users_active ON admin_users(active);

-- Unique constraints
CREATE UNIQUE INDEX idx_site_settings_single ON site_settings((active)) WHERE active = true;
CREATE UNIQUE INDEX idx_themes_active ON themes((is_active)) WHERE is_active = true;

SELECT '✅ Indexes created | تم إ��شاء الفهارس' as step_4;

-- ================================
-- STEP 5: CREATE FUNCTIONS AND TRIGGERS
-- الخطوة 5: إنشاء الدوال والمشغلات
-- ================================

-- Update timestamp function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Order number generation function
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
DECLARE
    prefix TEXT := 'KYC';
    date_part TEXT;
    random_part TEXT;
    new_number TEXT;
BEGIN
    date_part := TO_CHAR(NOW(), 'YYYYMMDD');
    random_part := LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0');
    new_number := prefix || date_part || random_part;
    
    WHILE EXISTS (SELECT 1 FROM orders WHERE order_number = new_number) LOOP
        random_part := LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0');
        new_number := prefix || date_part || random_part;
    END LOOP;
    
    NEW.order_number := new_number;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payment_methods_updated_at BEFORE UPDATE ON payment_methods FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_site_settings_updated_at BEFORE UPDATE ON site_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_admin_users_updated_at BEFORE UPDATE ON admin_users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_page_templates_updated_at BEFORE UPDATE ON page_templates FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_themes_updated_at BEFORE UPDATE ON themes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER generate_order_number_trigger 
    BEFORE INSERT ON orders 
    FOR EACH ROW 
    WHEN (NEW.order_number IS NULL OR NEW.order_number = '')
    EXECUTE FUNCTION generate_order_number();

SELECT '✅ Functions and triggers created | تم إنشاء الدوال والمشغلات' as step_5;

-- ================================
-- STEP 6: ENABLE ROW LEVEL SECURITY
-- الخطوة 6: تفعيل أمان مستوى الصفوف
-- ================================

-- Enable RLS
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE page_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE themes ENABLE ROW LEVEL SECURITY;

-- Create policies (allowing all for development)
CREATE POLICY "Allow all operations" ON services FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON payment_methods FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON orders FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON site_settings FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON admin_users FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON analytics_events FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON page_templates FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON themes FOR ALL USING (true);

SELECT '✅ Row Level Security enabled | تم تفعيل أمان مستوى الصفوف' as step_6;

-- ================================
-- STEP 7: INSERT INITIAL DATA
-- الخطوة 7: إدراج البيانات الأولية
-- ================================

-- Insert RLS settings
INSERT INTO rls_settings (environment, strict_mode) VALUES ('development', false);

-- Insert site settings
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
    contact_email,
    contact_phone,
    contact_whatsapp,
    features,
    stats
) VALUES (
    'KYCtrust - منصة موثوقة للخدمات المالية الرقمية',
    'KYCtrust - Trusted Digital Financial Services Platform',
    'منصة موثوقة تقدم أفضل الخدمات المالية الرقمية مع ضمان الأمان والجودة والسرعة',
    'Trusted platform providing the best digital financial services with guaranteed security, quality, and speed',
    'مستقبل الخدمات المالية الرقمية',
    'The Future of Digital Financial Services',
    'نحن نعيد تعريف الخدمات المالية الرقمية من خلال تقديم حلول مبتكرة وآمنة ومتطورة',
    'We are redefining digital financial services through innovative, secure, and advanced solutions',
    'سيتم التواصل معك خلال 24 ساعة لتأكيد الطلب وبدء العمل',
    'We will contact you within 24 hours to confirm your order and start working',
    'info@kyctrust.com',
    '+966501234567',
    '+966501234567',
    '{"security": {"title": "أمان متقدم", "title_en": "Advanced Security", "description": "حماية بمستوى البنوك", "icon": "shield-check"}, "speed": {"title": "سرعة في التنفيذ", "title_en": "Fast Execution", "description": "إنجاز في أقل من 5 دقائق", "icon": "zap"}, "support": {"title": "دعم 24/7", "title_en": "24/7 Support", "description": "فريق دعم متخصص", "icon": "headphones"}, "trust": {"title": "موثوقية عالية", "title_en": "High Reliability", "description": "معدل نجاح 99.9%", "icon": "award"}}',
    '{"total_clients": 15000, "completed_orders": 35000, "success_rate": 99.9, "countries_served": 50}'
);

-- Insert services
INSERT INTO services (name, name_en, description, description_en, price, price_numeric, category, icon, color, order_index, active, featured) VALUES
('خدمات KYC المتقدمة', 'Advanced KYC Services', 'خدمات تحقق هوية متطورة ومعتمدة دولياً للأفراد والشركات', 'Advanced and internationally certified identity verification services', '$299', 299.00, 'kyc', 'shield-check', '#3B82F6', 1, true, true),
('تحليل المخاطر المالية', 'Financial Risk Analysis', 'تقييم شامل للمخاطر المالية باستخدام أحدث التقنيات', 'Comprehensive financial risk assessment using latest technologies', '$199', 199.00, 'analysis', 'trending-up', '#10B981', 2, true, true),
('خدمات AML المتخصصة', 'Specialized AML Services', 'خدمات مكافحة غسيل الأموال وتمويل الإرهاب', 'Anti-money laundering and terrorism financing services', '$399', 399.00, 'compliance', 'shield', '#EF4444', 3, true, true),
('استشارات الامتثال المالي', 'Financial Compliance Consulting', 'استشارات متخصصة في الامتثال للوائح المالية', 'Specialized consulting in compliance with financial regulations', '$499', 499.00, 'consulting', 'book-open', '#8B5CF6', 4, true, false),
('تدقيق الحسابات الرقمية', 'Digital Account Auditing', 'خدمات تدقيق شاملة للحسابات والمحافظ الرقمية', 'Comprehensive auditing services for digital accounts and wallets', '$349', 349.00, 'audit', 'search', '#F59E0B', 5, true, false),
('حلول الدفع الآمنة', 'Secure Payment Solutions', 'تطوير وتنفيذ حلول دفع آمنة ومتطورة', 'Development and implementation of secure and advanced payment solutions', '$799', 799.00, 'payment', 'credit-card', '#06B6D4', 6, true, true);

-- Insert payment methods
INSERT INTO payment_methods (name, name_en, description, description_en, details, type, icon, color, order_index, active, account_info, instructions, instructions_en, min_amount, max_amount) VALUES
('التحويل البنكي المحلي', 'Local Bank Transfer', 'تحويل مصرفي آمن وسريع داخل المملكة', 'Safe and fast bank transfer within the Kingdom', 'بنك الراجحي - فرع الرياض الرئيسي', 'bank', 'building-2', '#22C55E', 1, true,
'{"account_name": "KYCtrust Financial Services", "account_number": "123456789012", "iban": "SA1234567890123456789012", "swift": "RJHISARI"}',
'قم بتحويل المبلغ إلى الحساب المذكور وأرسل إيصال التحويل',
'Transfer the amount to the mentioned account and send the transfer receipt',
100.00, 50000.00),

('محفظة STC Pay', 'STC Pay Wallet', 'دفع سريع وآمن عبر محفظة STC Pay', 'Fast and secure payment via STC Pay wallet', 'رقم المحفظة: +966501234567', 'wallet', 'wallet', '#E11D48', 2, true,
'{"wallet_number": "+966501234567", "account_name": "KYCtrust Services"}',
'ادفع المبلغ عبر STC Pay وأرسل لقطة شاشة للعملية',
'Pay the amount via STC Pay and send a screenshot of the transaction',
50.00, 10000.00),

('تحويل Wise', 'Wise Transfer', 'تحويل دولي سريع وبأسعار تن��فسية', 'Fast international transfer with competitive rates', 'حساب Wise للتحويلات الدولية', 'international', 'globe', '#6366F1', 3, true,
'{"email": "payments@kyctrust.com", "account_type": "business"}',
'استخدم البريد الإلكتروني payments@kyctrust.com للتحويل عبر Wise',
'Use email payments@kyctrust.com for transfer via Wise',
50.00, 50000.00),

('العملات المشفرة', 'Cryptocurrency', 'دفع آمن بالعملات المشفرة المعتمدة', 'Secure payment with approved cryptocurrencies', 'USDT, Bitcoin, Ethereum', 'crypto', 'coins', '#F59E0B', 4, true,
'{"btc_address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh", "usdt_address": "TQn9Y2khEsLJW3Jse6F8J8J8J8J8J8J8J8"}',
'اختر العملة المناسبة وأرسل المبلغ إلى العنوان المحدد',
'Choose the appropriate currency and send the amount to the specified address',
10.00, 100000.00);

-- Insert admin user
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
    crypt('KYCtrust2024!Admin', gen_salt('bf')),
    'مدير النظام الرئيسي',
    'super_admin',
    ARRAY['manage_services', 'manage_orders', 'manage_payments', 'manage_settings', 'manage_admins', 'view_analytics', 'manage_templates', 'manage_themes'],
    true,
    true
);

-- Insert default theme
INSERT INTO themes (
    name,
    name_en,
    description,
    description_en,
    colors,
    fonts,
    is_default,
    is_active,
    category
) VALUES (
    'الثيم الافتراضي المتقدم',
    'Advanced Default Theme',
    'الثيم الافتراضي للمنصة مع تصميم حديث وألوان متناسقة',
    'Default platform theme with modern design and harmonious colors',
    '{"primary": "#3B82F6", "secondary": "#6366F1", "accent": "#8B5CF6", "success": "#10B981", "warning": "#F59E0B", "error": "#EF4444"}',
    '{"heading": "Cairo", "body": "system-ui", "mono": "Courier New"}',
    true,
    true,
    'default'
);

-- Insert sample analytics events
INSERT INTO analytics_events (event_type, event_category, event_action, page_url, page_title, metadata) VALUES
('page_view', 'navigation', 'view', '/', 'الصفحة الرئيسية', '{"section": "hero"}'),
('service_view', 'services', 'view', '/', 'الصفحة الرئيسية', '{"service_name": "خدمات KYC المتقدمة"}'),
('user_interaction', 'engagement', 'click', '/', 'الصفحة الرئيسية', '{"element": "cta_button"}');

SELECT '✅ Initial data inserted | تم إدراج البيانات الأولية' as step_7;

-- ================================
-- STEP 8: CREATE VIEWS
-- الخطوة 8: إنشاء الإطلالات
-- ================================

-- Order statistics view
CREATE OR REPLACE VIEW order_stats AS
SELECT 
    status,
    COUNT(*) as count,
    AVG(amount) as avg_amount,
    SUM(amount) as total_amount
FROM orders 
WHERE archived = false
GROUP BY status;

-- Service performance view
CREATE OR REPLACE VIEW service_performance AS
SELECT 
    s.id,
    s.name,
    s.category,
    COUNT(o.id) as total_orders,
    AVG(o.amount) as avg_order_value,
    SUM(o.amount) as total_revenue
FROM services s
LEFT JOIN orders o ON s.id = o.service_id
WHERE s.active = true
GROUP BY s.id, s.name, s.category;

-- Daily analytics view
CREATE OR REPLACE VIEW daily_analytics AS
SELECT 
    DATE(created_at) as date,
    COUNT(*) as total_events,
    COUNT(DISTINCT session_id) as unique_sessions,
    COUNT(CASE WHEN event_type = 'page_view' THEN 1 END) as page_views
FROM analytics_events
GROUP BY DATE(created_at)
ORDER BY date DESC;

SELECT '✅ Views created | تم إنشاء الإطلالات' as step_8;

-- Commit transaction
COMMIT;

-- ================================
-- FINAL SUCCESS MESSAGE
-- رسالة النجاح النهائية
-- ================================

SELECT 
    '🎉 KYCtrust Database Setup COMPLETED Successfully!' as status,
    '🎉 تم إعداد قاعدة بيانات KYCtrust بنجاح تماماً!' as status_ar,
    NOW() as completed_at;

-- Show summary
SELECT 
    'FINAL DATABASE SUMMARY | ملخص قاعدة البيانات النهائي' as summary,
    (SELECT COUNT(*) FROM services) as services_count,
    (SELECT COUNT(*) FROM payment_methods) as payment_methods_count,
    (SELECT COUNT(*) FROM admin_users) as admin_users_count,
    (SELECT COUNT(*) FROM site_settings) as site_settings_count,
    (SELECT COUNT(*) FROM themes) as themes_count,
    (SELECT COUNT(*) FROM analytics_events) as analytics_events_count;

-- Show next steps
SELECT 
    '📋 NEXT STEPS | الخطوات التالية' as next_steps,
    '1. Update .env.local file with your Supabase credentials' as step_1,
    '2. Run: npm run dev' as step_2,
    '3. Visit: http://localhost:5173' as step_3,
    '4. Admin login: admin@kyctrust.com / KYCtrust2024!Admin' as step_4,
    '5. Test the application!' as step_5;

-- Final check
SELECT 
    CASE 
        WHEN COUNT(*) = 8 THEN '✅ ALL TABLES CREATED SUCCESSFULLY!'
        ELSE '❌ SOME TABLES MISSING!'
    END as table_check
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('services', 'payment_methods', 'orders', 'site_settings', 'admin_users', 'analytics_events', 'page_templates', 'themes');

-- ================================
-- END OF SCRIPT
-- نهاية السكريپت
-- ================================
