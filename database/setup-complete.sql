-- KYCtrust Platform - Complete Database Setup
-- إعداد قاعدة البيانات الكاملة لمنصة KYCtrust

-- ================================
-- Drop existing tables if needed
-- حذف الجداول الموجودة إذا لزم الأمر
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
-- Enable necessary extensions
-- تفعيل الامتدادات المطلوبة
-- ================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ================================
-- Create Services Table
-- إنشاء جدول الخدمات
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
    color VARCHAR(50),
    order_index INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    featured BOOLEAN DEFAULT false,
    tags TEXT[],
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for better performance
CREATE INDEX idx_services_active ON services(active);
CREATE INDEX idx_services_category ON services(category);
CREATE INDEX idx_services_order ON services(order_index);

-- ================================
-- Create Payment Methods Table
-- إنشاء جدول طرق الدفع
-- ================================

CREATE TABLE payment_methods (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    description_en TEXT,
    details TEXT,
    details_en TEXT,
    type VARCHAR(50), -- bank, wallet, card, crypto
    icon VARCHAR(50),
    color VARCHAR(50),
    account_info JSONB DEFAULT '{}',
    instructions TEXT,
    instructions_en TEXT,
    order_index INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    fees JSONB DEFAULT '{}',
    limits JSONB DEFAULT '{}',
    processing_time VARCHAR(50),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for better performance
CREATE INDEX idx_payment_methods_active ON payment_methods(active);
CREATE INDEX idx_payment_methods_type ON payment_methods(type);

-- ================================
-- Create Orders Table
-- إنشاء جدول الطلبات
-- ================================

CREATE TABLE orders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    customer_name TEXT NOT NULL,
    customer_email VARCHAR(255),
    customer_phone VARCHAR(20),
    customer_country VARCHAR(100),
    service_id UUID REFERENCES services(id),
    service_name TEXT NOT NULL,
    service_price TEXT,
    payment_method_id UUID REFERENCES payment_methods(id),
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
    attachments TEXT[],
    tags TEXT[],
    estimated_delivery DATE,
    completed_at TIMESTAMP WITH TIME ZONE,
    archived BOOLEAN DEFAULT false,
    archived_at TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_orders_customer_email ON orders(customer_email);
CREATE INDEX idx_orders_service_id ON orders(service_id);
CREATE INDEX idx_orders_archived ON orders(archived);

-- ================================
-- Create Site Settings Table
-- إنشاء جدول إعدادات الموقع
-- ================================

CREATE TABLE site_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    site_title TEXT NOT NULL DEFAULT 'KYCtrust',
    site_title_en TEXT DEFAULT 'KYCtrust',
    site_description TEXT DEFAULT 'منصة موثوقة للخدمات المالية ا��رقمية',
    site_description_en TEXT DEFAULT 'Trusted Digital Financial Services Platform',
    site_logo TEXT,
    site_favicon TEXT,
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
    contact_address TEXT,
    contact_address_en TEXT,
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
    version VARCHAR(10) DEFAULT '1.0.0',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ensure only one settings record
CREATE UNIQUE INDEX idx_site_settings_single ON site_settings((active)) WHERE active = true;

-- ================================
-- Create Admin Users Table
-- إنشاء جدول المستخدمين الإداريين
-- ================================

CREATE TABLE admin_users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name TEXT NOT NULL,
    role VARCHAR(20) DEFAULT 'admin' CHECK (role IN ('admin', 'manager', 'operator')),
    permissions TEXT[] DEFAULT ARRAY['read'],
    avatar TEXT,
    phone VARCHAR(20),
    last_login TIMESTAMP WITH TIME ZONE,
    login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP WITH TIME ZONE,
    email_verified BOOLEAN DEFAULT false,
    two_factor_enabled BOOLEAN DEFAULT false,
    two_factor_secret TEXT,
    recovery_codes TEXT[],
    session_token TEXT,
    reset_token TEXT,
    reset_token_expires TIMESTAMP WITH TIME ZONE,
    active BOOLEAN DEFAULT true,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for security
CREATE INDEX idx_admin_users_email ON admin_users(email);
CREATE INDEX idx_admin_users_session ON admin_users(session_token);
CREATE INDEX idx_admin_users_reset ON admin_users(reset_token);

-- ================================
-- Create Analytics Events Table
-- إنشاء جدول أحداث التحليلات
-- ================================

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
    referrer_url TEXT,
    page_url TEXT NOT NULL,
    page_title TEXT,
    utm_source VARCHAR(100),
    utm_medium VARCHAR(100),
    utm_campaign VARCHAR(100),
    utm_term VARCHAR(100),
    utm_content VARCHAR(100),
    metadata JSONB DEFAULT '{}',
    custom_properties JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for analytics queries
CREATE INDEX idx_analytics_event_type ON analytics_events(event_type);
CREATE INDEX idx_analytics_created_at ON analytics_events(created_at);
CREATE INDEX idx_analytics_user_id ON analytics_events(user_id);
CREATE INDEX idx_analytics_session_id ON analytics_events(session_id);

-- ================================
-- Create Page Templates Table
-- إنشاء جدول قوالب الصفحات
-- ================================

CREATE TABLE page_templates (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    description_en TEXT,
    type VARCHAR(50) DEFAULT 'landing', -- landing, service, about, contact
    template_data JSONB NOT NULL DEFAULT '{}',
    preview_image TEXT,
    category VARCHAR(50),
    tags TEXT[],
    is_default BOOLEAN DEFAULT false,
    is_published BOOLEAN DEFAULT true,
    version VARCHAR(10) DEFAULT '1.0.0',
    author VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for templates
CREATE INDEX idx_page_templates_type ON page_templates(type);
CREATE INDEX idx_page_templates_published ON page_templates(is_published);

-- ================================
-- Create Themes Table
-- إنشاء جدول الثيمات
-- ================================

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
    tags TEXT[],
    version VARCHAR(10) DEFAULT '1.0.0',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ensure only one active theme
CREATE UNIQUE INDEX idx_themes_active ON themes((is_active)) WHERE is_active = true;

-- ================================
-- Create Functions for auto-updating timestamps
-- إنشاء دوال للتحديث التلقائي للوقت
-- ================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for all tables
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payment_methods_updated_at BEFORE UPDATE ON payment_methods FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_site_settings_updated_at BEFORE UPDATE ON site_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_admin_users_updated_at BEFORE UPDATE ON admin_users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_page_templates_updated_at BEFORE UPDATE ON page_templates FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_themes_updated_at BEFORE UPDATE ON themes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================
-- Create Function for generating order numbers
-- إنشاء دالة لتوليد أرقام الطلبات
-- ================================

CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.order_number IS NULL THEN
        NEW.order_number := 'KYC' || TO_CHAR(NOW(), 'YYYYMMDD') || LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0');
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER generate_order_number_trigger BEFORE INSERT ON orders FOR EACH ROW EXECUTE FUNCTION generate_order_number();

-- ================================
-- Success message
-- رسالة نجاح الإعداد
-- ================================

SELECT 'KYCtrust Database Setup Completed Successfully! ✅' as status;
SELECT 'تم إعداد قاعدة بيانات KYCtrust بنجاح! ✅' as status_ar;
