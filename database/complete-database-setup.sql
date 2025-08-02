-- KYCtrust Platform - Complete Database Setup for Supabase
-- إعداد قاعدة البيانات الكاملة لمنصة KYCtrust في Supabase

-- ================================
-- IMPORTANT: Run this in Supabase SQL Editor
-- مهم: قم بتشغيل هذا في محرر SQL الخاص بـ Supabase
-- ================================

-- Step 1: Enable Extensions
-- الخطوة 1: تفعيل الامتدادات
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ================================
-- Drop existing tables if they exist (CAREFUL!)
-- حذف الجداول الموجودة إن وجدت (احذر!)
-- ================================

DROP TABLE IF EXISTS analytics_events CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS site_settings CASCADE;
DROP TABLE IF EXISTS payment_methods CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS admin_users CASCADE;
DROP TABLE IF EXISTS page_templates CASCADE;
DROP TABLE IF EXISTS themes CASCADE;

-- ================================
-- 1. Services Table | جدول الخدمات
-- ================================

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

-- Create indexes for services
CREATE INDEX idx_services_active ON services(active);
CREATE INDEX idx_services_category ON services(category);
CREATE INDEX idx_services_order ON services(order_index);
CREATE INDEX idx_services_featured ON services(featured);

-- ================================
-- 2. Payment Methods Table | جدول طرق الدفع
-- ================================

CREATE TABLE payment_methods (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    description_en TEXT,
    details TEXT,
    details_en TEXT,
    type VARCHAR(50) DEFAULT 'bank', -- bank, wallet, card, crypto, other
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

-- Create indexes for payment methods
CREATE INDEX idx_payment_methods_active ON payment_methods(active);
CREATE INDEX idx_payment_methods_type ON payment_methods(type);
CREATE INDEX idx_payment_methods_order ON payment_methods(order_index);

-- ================================
-- 3. Orders Table | جدول الطلبات
-- ================================

CREATE TABLE orders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    customer_name TEXT NOT NULL,
    customer_email VARCHAR(255),
    customer_phone VARCHAR(20),
    customer_country VARCHAR(100) DEFAULT 'Saudi Arabia',
    customer_city VARCHAR(100),
    service_id UUID REFERENCES services(id) ON DELETE SET NULL,
    service_name TEXT NOT NULL,
    service_price TEXT,
    payment_method_id UUID REFERENCES payment_methods(id) ON DELETE SET NULL,
    payment_method_name TEXT,
    notes TEXT,
    customer_notes TEXT,
    admin_notes TEXT,
    internal_notes TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'cancelled', 'refunded', 'on_hold')),
    priority VARCHAR(10) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    amount DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'USD',
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded', 'partial')),
    payment_reference TEXT,
    payment_proof TEXT, -- File URL for payment proof
    delivery_info JSONB DEFAULT '{}',
    tracking_info JSONB DEFAULT '{}',
    completion_details JSONB DEFAULT '{}',
    attachments TEXT[] DEFAULT '{}',
    tags TEXT[] DEFAULT '{}',
    estimated_delivery DATE,
    actual_delivery DATE,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    archived BOOLEAN DEFAULT false,
    archived_at TIMESTAMP WITH TIME ZONE,
    archived_by UUID,
    source VARCHAR(50) DEFAULT 'website', -- website, admin, api, import
    customer_ip INET,
    user_agent TEXT,
    referrer TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for orders
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
CREATE INDEX idx_orders_priority ON orders(priority);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_orders_customer_email ON orders(customer_email);
CREATE INDEX idx_orders_customer_phone ON orders(customer_phone);
CREATE INDEX idx_orders_service_id ON orders(service_id);
CREATE INDEX idx_orders_payment_method_id ON orders(payment_method_id);
CREATE INDEX idx_orders_archived ON orders(archived);
CREATE INDEX idx_orders_order_number ON orders(order_number);

-- ================================
-- 4. Site Settings Table | جدول إعدادات الموقع
-- ================================

CREATE TABLE site_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    site_title TEXT NOT NULL DEFAULT 'KYCtrust',
    site_title_en TEXT DEFAULT 'KYCtrust',
    site_description TEXT DEFAULT 'منصة موثوقة للخدمات المالية الرقمية',
    site_description_en TEXT DEFAULT 'Trusted Digital Financial Services Platform',
    site_logo TEXT,
    site_favicon TEXT,
    site_banner TEXT,
    
    -- Colors & Branding
    primary_color VARCHAR(7) DEFAULT '#3B82F6',
    secondary_color VARCHAR(7) DEFAULT '#6366F1',
    accent_color VARCHAR(7) DEFAULT '#8B5CF6',
    success_color VARCHAR(7) DEFAULT '#10B981',
    warning_color VARCHAR(7) DEFAULT '#F59E0B',
    error_color VARCHAR(7) DEFAULT '#EF4444',
    
    -- Hero Section
    hero_title TEXT DEFAULT 'مستقبل الخدمات المالية الرقمية',
    hero_title_en TEXT DEFAULT 'The Future of Digital Financial Services',
    hero_subtitle TEXT DEFAULT 'نحن نعيد تعريف الخدمات المالية الرقمية من خلال تقديم حلول مبتكرة وآمنة ومتطورة',
    hero_subtitle_en TEXT DEFAULT 'We are redefining digital financial services through innovative, secure, and advanced solutions',
    hero_image TEXT,
    hero_video TEXT,
    
    -- Order Settings
    order_notice TEXT DEFAULT 'سيتم التواصل معك خلال 24 ساعة لتأكيد الطلب',
    order_notice_en TEXT DEFAULT 'We will contact you within 24 hours to confirm your order',
    min_order_amount DECIMAL(10,2) DEFAULT 0,
    max_order_amount DECIMAL(10,2),
    order_prefix VARCHAR(10) DEFAULT 'KYC',
    
    -- Contact Information
    contact_email VARCHAR(255) DEFAULT 'info@kyctrust.com',
    contact_phone VARCHAR(20) DEFAULT '+966501234567',
    contact_whatsapp VARCHAR(20) DEFAULT '+966501234567',
    contact_telegram VARCHAR(100),
    contact_address TEXT,
    contact_address_en TEXT,
    contact_hours TEXT DEFAULT 'السبت - الخميس: 9:00 ص - 6:00 م',
    contact_hours_en TEXT DEFAULT 'Saturday - Thursday: 9:00 AM - 6:00 PM',
    
    -- Social Links
    social_links JSONB DEFAULT '{}',
    
    -- Business Information
    business_hours JSONB DEFAULT '{}',
    company_info JSONB DEFAULT '{}',
    legal_info JSONB DEFAULT '{}',
    
    -- Features & Stats
    features JSONB DEFAULT '{}',
    stats JSONB DEFAULT '{}',
    testimonials JSONB DEFAULT '{}',
    faqs JSONB DEFAULT '{}',
    
    -- SEO Settings
    seo_settings JSONB DEFAULT '{}',
    meta_keywords TEXT,
    meta_author TEXT DEFAULT 'KYCtrust',
    
    -- Analytics & Tracking
    analytics_settings JSONB DEFAULT '{}',
    google_analytics_id VARCHAR(100),
    facebook_pixel_id VARCHAR(100),
    
    -- Notification Settings
    notification_settings JSONB DEFAULT '{}',
    email_templates JSONB DEFAULT '{}',
    
    -- Security Settings
    security_settings JSONB DEFAULT '{}',
    allowed_countries TEXT[] DEFAULT '{}',
    blocked_countries TEXT[] DEFAULT '{}',
    
    -- Maintenance
    maintenance_mode BOOLEAN DEFAULT false,
    maintenance_message TEXT,
    maintenance_message_en TEXT,
    maintenance_start TIMESTAMP WITH TIME ZONE,
    maintenance_end TIMESTAMP WITH TIME ZONE,
    
    -- System
    active BOOLEAN DEFAULT true,
    version VARCHAR(10) DEFAULT '2.0.0',
    last_backup TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ensure only one active settings record
CREATE UNIQUE INDEX idx_site_settings_single ON site_settings((active)) WHERE active = true;

-- ================================
-- 5. Admin Users Table | جدول المستخدمين الإداريين
-- ================================

CREATE TABLE admin_users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name TEXT NOT NULL,
    avatar TEXT,
    phone VARCHAR(20),
    role VARCHAR(20) DEFAULT 'admin' CHECK (role IN ('super_admin', 'admin', 'manager', 'operator', 'viewer')),
    permissions TEXT[] DEFAULT ARRAY['read'],
    department VARCHAR(50),
    
    -- Authentication
    last_login TIMESTAMP WITH TIME ZONE,
    login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP WITH TIME ZONE,
    password_changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    email_verified BOOLEAN DEFAULT false,
    email_verified_at TIMESTAMP WITH TIME ZONE,
    
    -- Two Factor Authentication
    two_factor_enabled BOOLEAN DEFAULT false,
    two_factor_secret TEXT,
    two_factor_backup_codes TEXT[],
    
    -- Session Management
    session_token TEXT,
    session_expires TIMESTAMP WITH TIME ZONE,
    refresh_token TEXT,
    
    -- Password Reset
    reset_token TEXT,
    reset_token_expires TIMESTAMP WITH TIME ZONE,
    
    -- Preferences
    preferences JSONB DEFAULT '{}',
    timezone VARCHAR(50) DEFAULT 'Asia/Riyadh',
    language VARCHAR(5) DEFAULT 'ar',
    theme VARCHAR(20) DEFAULT 'light',
    
    -- Activity Tracking
    last_activity TIMESTAMP WITH TIME ZONE,
    login_count INTEGER DEFAULT 0,
    
    -- Status
    active BOOLEAN DEFAULT true,
    notes TEXT,
    created_by UUID,
    updated_by UUID,
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for admin users
CREATE INDEX idx_admin_users_email ON admin_users(email);
CREATE INDEX idx_admin_users_role ON admin_users(role);
CREATE INDEX idx_admin_users_active ON admin_users(active);
CREATE INDEX idx_admin_users_session ON admin_users(session_token);
CREATE INDEX idx_admin_users_reset ON admin_users(reset_token);
CREATE INDEX idx_admin_users_last_login ON admin_users(last_login);

-- ================================
-- 6. Analytics Events Table | جدول أحداث التحليلات
-- ================================

CREATE TABLE analytics_events (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    event_category VARCHAR(50),
    event_action VARCHAR(50),
    event_label TEXT,
    event_value DECIMAL(10,2),
    
    -- User Information
    user_id UUID,
    session_id VARCHAR(100),
    user_agent TEXT,
    ip_address INET,
    fingerprint TEXT,
    
    -- Location
    country VARCHAR(100),
    region VARCHAR(100),
    city VARCHAR(100),
    timezone VARCHAR(50),
    
    -- Device Information
    device_type VARCHAR(20), -- desktop, mobile, tablet
    device_brand VARCHAR(50),
    device_model VARCHAR(50),
    browser VARCHAR(50),
    browser_version VARCHAR(20),
    os VARCHAR(50),
    os_version VARCHAR(20),
    screen_resolution VARCHAR(20),
    
    -- Page Information
    page_url TEXT NOT NULL,
    page_title TEXT,
    page_path TEXT,
    referrer_url TEXT,
    referrer_domain TEXT,
    
    -- UTM Parameters
    utm_source VARCHAR(100),
    utm_medium VARCHAR(100),
    utm_campaign VARCHAR(100),
    utm_term VARCHAR(100),
    utm_content VARCHAR(100),
    
    -- E-commerce
    transaction_id VARCHAR(100),
    item_id VARCHAR(100),
    item_name TEXT,
    item_category VARCHAR(100),
    item_price DECIMAL(10,2),
    currency VARCHAR(3),
    
    -- Custom Properties
    metadata JSONB DEFAULT '{}',
    custom_properties JSONB DEFAULT '{}',
    
    -- Timing
    page_load_time INTEGER,
    interaction_time INTEGER,
    scroll_depth INTEGER,
    
    -- Timestamps
    event_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for analytics
CREATE INDEX idx_analytics_event_type ON analytics_events(event_type);
CREATE INDEX idx_analytics_event_category ON analytics_events(event_category);
CREATE INDEX idx_analytics_created_at ON analytics_events(created_at);
CREATE INDEX idx_analytics_event_timestamp ON analytics_events(event_timestamp);
CREATE INDEX idx_analytics_user_id ON analytics_events(user_id);
CREATE INDEX idx_analytics_session_id ON analytics_events(session_id);
CREATE INDEX idx_analytics_page_url ON analytics_events(page_url);
CREATE INDEX idx_analytics_country ON analytics_events(country);
CREATE INDEX idx_analytics_device_type ON analytics_events(device_type);

-- ================================
-- 7. Page Templates Table | جدول قوالب الصفحات
-- ================================

CREATE TABLE page_templates (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    description_en TEXT,
    type VARCHAR(50) DEFAULT 'landing', -- landing, service, about, contact, custom
    template_data JSONB NOT NULL DEFAULT '{}',
    sections JSONB DEFAULT '{}',
    styles JSONB DEFAULT '{}',
    scripts TEXT,
    preview_image TEXT,
    thumbnail TEXT,
    category VARCHAR(50),
    tags TEXT[] DEFAULT '{}',
    
    -- Status
    is_default BOOLEAN DEFAULT false,
    is_published BOOLEAN DEFAULT true,
    is_premium BOOLEAN DEFAULT false,
    
    -- Versioning
    version VARCHAR(10) DEFAULT '1.0.0',
    parent_template_id UUID REFERENCES page_templates(id),
    
    -- Author & Permissions
    author VARCHAR(100),
    author_id UUID REFERENCES admin_users(id),
    permissions JSONB DEFAULT '{}',
    
    -- Usage Stats
    usage_count INTEGER DEFAULT 0,
    download_count INTEGER DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0,
    reviews_count INTEGER DEFAULT 0,
    
    -- SEO
    seo_title TEXT,
    seo_description TEXT,
    seo_keywords TEXT,
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for page templates
CREATE INDEX idx_page_templates_type ON page_templates(type);
CREATE INDEX idx_page_templates_published ON page_templates(is_published);
CREATE INDEX idx_page_templates_category ON page_templates(category);
CREATE INDEX idx_page_templates_author_id ON page_templates(author_id);

-- ================================
-- 8. Themes Table | جدول الثيمات
-- ================================

CREATE TABLE themes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    description_en TEXT,
    
    -- Theme Configuration
    colors JSONB NOT NULL DEFAULT '{}',
    fonts JSONB DEFAULT '{}',
    spacing JSONB DEFAULT '{}',
    borders JSONB DEFAULT '{}',
    shadows JSONB DEFAULT '{}',
    animations JSONB DEFAULT '{}',
    
    -- Custom Styles
    custom_css TEXT,
    custom_js TEXT,
    
    -- Assets
    preview_image TEXT,
    thumbnail TEXT,
    demo_url TEXT,
    
    -- Status
    is_default BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT false,
    is_premium BOOLEAN DEFAULT false,
    is_dark BOOLEAN DEFAULT false,
    
    -- Compatibility
    supported_components TEXT[] DEFAULT '{}',
    min_version VARCHAR(10),
    max_version VARCHAR(10),
    
    -- Author & Versioning
    version VARCHAR(10) DEFAULT '1.0.0',
    author VARCHAR(100),
    author_id UUID REFERENCES admin_users(id),
    
    -- Categories & Tags
    category VARCHAR(50),
    tags TEXT[] DEFAULT '{}',
    
    -- Usage & Rating
    usage_count INTEGER DEFAULT 0,
    download_count INTEGER DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0,
    reviews_count INTEGER DEFAULT 0,
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ensure only one active theme at a time
CREATE UNIQUE INDEX idx_themes_active ON themes((is_active)) WHERE is_active = true;

-- Create indexes for themes
CREATE INDEX idx_themes_category ON themes(category);
CREATE INDEX idx_themes_is_premium ON themes(is_premium);
CREATE INDEX idx_themes_author_id ON themes(author_id);

-- ================================
-- Functions & Triggers | الدوال والمشغلات
-- ================================

-- Function to update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for all tables
CREATE TRIGGER update_services_updated_at 
    BEFORE UPDATE ON services 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_methods_updated_at 
    BEFORE UPDATE ON payment_methods 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at 
    BEFORE UPDATE ON orders 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_site_settings_updated_at 
    BEFORE UPDATE ON site_settings 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_admin_users_updated_at 
    BEFORE UPDATE ON admin_users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_page_templates_updated_at 
    BEFORE UPDATE ON page_templates 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_themes_updated_at 
    BEFORE UPDATE ON themes 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function for generating order numbers
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
DECLARE
    prefix TEXT;
    date_part TEXT;
    random_part TEXT;
    counter_part TEXT;
    new_number TEXT;
    counter_value INTEGER;
BEGIN
    -- Get prefix from site settings or use default
    SELECT COALESCE(order_prefix, 'KYC') INTO prefix FROM site_settings WHERE active = true LIMIT 1;
    
    -- Generate date part (YYYYMMDD)
    date_part := TO_CHAR(NOW(), 'YYYYMMDD');
    
    -- Generate random part (4 digits)
    random_part := LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0');
    
    -- Create the order number
    new_number := prefix || date_part || random_part;
    
    -- Ensure uniqueness
    WHILE EXISTS (SELECT 1 FROM orders WHERE order_number = new_number) LOOP
        random_part := LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0');
        new_number := prefix || date_part || random_part;
    END LOOP;
    
    NEW.order_number := new_number;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for order number generation
CREATE TRIGGER generate_order_number_trigger 
    BEFORE INSERT ON orders 
    FOR EACH ROW 
    WHEN (NEW.order_number IS NULL OR NEW.order_number = '')
    EXECUTE FUNCTION generate_order_number();

-- Function to update order status timestamps
CREATE OR REPLACE FUNCTION update_order_status_timestamps()
RETURNS TRIGGER AS $$
BEGIN
    -- Update timestamps based on status changes
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        CASE NEW.status
            WHEN 'processing' THEN
                NEW.started_at = COALESCE(NEW.started_at, NOW());
            WHEN 'completed' THEN
                NEW.completed_at = COALESCE(NEW.completed_at, NOW());
                NEW.actual_delivery = COALESCE(NEW.actual_delivery, CURRENT_DATE);
            ELSE
                -- Keep existing timestamps for other statuses
        END CASE;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for order status timestamps
CREATE TRIGGER update_order_status_timestamps_trigger 
    BEFORE UPDATE ON orders 
    FOR EACH ROW 
    EXECUTE FUNCTION update_order_status_timestamps();

-- ================================
-- Views | الإطلالات (Views)
-- ================================

-- View for order statistics
CREATE OR REPLACE VIEW order_stats AS
SELECT 
    status,
    COUNT(*) as count,
    AVG(amount) as avg_amount,
    SUM(amount) as total_amount,
    MIN(created_at) as earliest_order,
    MAX(created_at) as latest_order
FROM orders 
WHERE archived = false
GROUP BY status;

-- View for service performance
CREATE OR REPLACE VIEW service_performance AS
SELECT 
    s.id,
    s.name,
    s.category,
    COUNT(o.id) as total_orders,
    AVG(o.amount) as avg_order_value,
    SUM(o.amount) as total_revenue,
    COUNT(CASE WHEN o.status = 'completed' THEN 1 END) as completed_orders,
    ROUND(
        COUNT(CASE WHEN o.status = 'completed' THEN 1 END)::DECIMAL / 
        NULLIF(COUNT(o.id), 0) * 100, 2
    ) as completion_rate
FROM services s
LEFT JOIN orders o ON s.id = o.service_id
WHERE s.active = true
GROUP BY s.id, s.name, s.category
ORDER BY total_orders DESC;

-- View for daily analytics
CREATE OR REPLACE VIEW daily_analytics AS
SELECT 
    DATE(created_at) as date,
    COUNT(*) as total_events,
    COUNT(DISTINCT session_id) as unique_sessions,
    COUNT(DISTINCT ip_address) as unique_visitors,
    COUNT(CASE WHEN event_type = 'page_view' THEN 1 END) as page_views,
    COUNT(CASE WHEN event_type = 'order_created' THEN 1 END) as orders_created
FROM analytics_events
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- ================================
-- Success Message | رسالة النجاح
-- ================================

SELECT 
    '🎉 KYCtrust Database Setup Completed Successfully!' as message,
    '🎉 تم إعداد قاعدة بيانات KYCtrust بنجاح!' as message_ar,
    NOW() as completed_at;

-- Show table counts
SELECT 
    'Database Setup Summary' as summary,
    (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('services', 'payment_methods', 'orders', 'site_settings', 'admin_users', 'analytics_events', 'page_templates', 'themes')) as tables_created,
    (SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema = 'public') as triggers_created,
    (SELECT COUNT(*) FROM information_schema.views WHERE table_schema = 'public') as views_created;
