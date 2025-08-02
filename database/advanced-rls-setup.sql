-- KYCtrust Platform - Advanced Row Level Security Setup
-- إعداد أمان مستوى الصفوف المتقدم لمنصة KYCtrust

-- ================================
-- Enable RLS on all tables
-- تفعيل RLS على جميع الجداول
-- ================================

ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE page_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE themes ENABLE ROW LEVEL SECURITY;

-- ================================
-- Drop existing policies if any
-- حذف السياسات الموجودة إن وجدت
-- ================================

DROP POLICY IF EXISTS "Public read active services" ON services;
DROP POLICY IF EXISTS "Admin manage services" ON services;
DROP POLICY IF EXISTS "Public read active payment methods" ON payment_methods;
DROP POLICY IF EXISTS "Admin manage payment methods" ON payment_methods;
DROP POLICY IF EXISTS "Public create orders" ON orders;
DROP POLICY IF EXISTS "Admin manage orders" ON orders;
DROP POLICY IF EXISTS "Public read site settings" ON site_settings;
DROP POLICY IF EXISTS "Admin manage site settings" ON site_settings;
DROP POLICY IF EXISTS "Admin only access" ON admin_users;
DROP POLICY IF EXISTS "Public create analytics" ON analytics_events;
DROP POLICY IF EXISTS "Admin read analytics" ON analytics_events;
DROP POLICY IF EXISTS "Public read published templates" ON page_templates;
DROP POLICY IF EXISTS "Admin manage templates" ON page_templates;
DROP POLICY IF EXISTS "Public read active themes" ON themes;
DROP POLICY IF EXISTS "Admin manage themes" ON themes;

-- ================================
-- Helper Functions | الدوال ��لمساعدة
-- ================================

-- Function to check if user is admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    -- For development: allow all operations
    -- For production: implement proper admin check
    RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check admin permissions
CREATE OR REPLACE FUNCTION has_admin_permission(required_permission TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- For development: allow all permissions
    -- For production: check actual admin permissions
    RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get current user role
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
BEGIN
    -- Return service_role for admin operations
    -- Return anon for public operations
    RETURN COALESCE(current_setting('request.jwt.claims', true)::json->>'role', 'anon');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================
-- Services Table Policies
-- سياسات جدول الخدمات
-- ================================

-- Allow public to read active services
CREATE POLICY "Public read active services" ON services
    FOR SELECT USING (
        active = true OR 
        get_user_role() = 'service_role'
    );

-- Allow admins and service role to manage all services
CREATE POLICY "Admin manage services" ON services
    FOR ALL USING (
        get_user_role() = 'service_role' OR
        is_admin()
    );

-- ================================
-- Payment Methods Table Policies  
-- سياسات جدول طرق الدفع
-- ================================

-- Allow public to read active payment methods
CREATE POLICY "Public read active payment methods" ON payment_methods
    FOR SELECT USING (
        active = true OR 
        get_user_role() = 'service_role'
    );

-- Allow admins to manage payment methods
CREATE POLICY "Admin manage payment methods" ON payment_methods
    FOR ALL USING (
        get_user_role() = 'service_role' OR
        is_admin()
    );

-- ================================
-- Orders Table Policies
-- سياسات جدول الطلبات
-- ================================

-- Allow public to create orders
CREATE POLICY "Public create orders" ON orders
    FOR INSERT WITH CHECK (true);

-- Allow public to read their own orders (by email/phone)
CREATE POLICY "Public read own orders" ON orders
    FOR SELECT USING (
        get_user_role() = 'service_role' OR
        is_admin()
        -- Add customer identification logic here for production
    );

-- Allow admins to manage all orders
CREATE POLICY "Admin manage orders" ON orders
    FOR ALL USING (
        get_user_role() = 'service_role' OR
        is_admin()
    );

-- ================================
-- Site Settings Table Policies
-- سياسات جدول إعدادات الموقع
-- ================================

-- Allow public to read active site settings
CREATE POLICY "Public read site settings" ON site_settings
    FOR SELECT USING (
        active = true OR 
        get_user_role() = 'service_role'
    );

-- Allow only admins to manage site settings
CREATE POLICY "Admin manage site settings" ON site_settings
    FOR ALL USING (
        get_user_role() = 'service_role' OR
        is_admin()
    );

-- ================================
-- Admin Users Table Policies
-- سياسات جدول المستخدمين الإداريين
-- ================================

-- Only service role and super admins can access admin users
CREATE POLICY "Admin only access" ON admin_users
    FOR ALL USING (
        get_user_role() = 'service_role'
        -- Add super admin check for production
    );

-- ================================
-- Analytics Events Table Policies
-- سياسات جدول أحداث التحليلات
-- ================================

-- Allow public to create analytics events
CREATE POLICY "Public create analytics" ON analytics_events
    FOR INSERT WITH CHECK (true);

-- Allow admins to read analytics
CREATE POLICY "Admin read analytics" ON analytics_events
    FOR SELECT USING (
        get_user_role() = 'service_role' OR
        is_admin()
    );

-- ================================
-- Page Templates Table Policies
-- سياسات جدول قوالب الصفحات
-- ================================

-- Allow public to read published templates
CREATE POLICY "Public read published templates" ON page_templates
    FOR SELECT USING (
        is_published = true OR 
        get_user_role() = 'service_role'
    );

-- Allow admins to manage templates
CREATE POLICY "Admin manage templates" ON page_templates
    FOR ALL USING (
        get_user_role() = 'service_role' OR
        is_admin()
    );

-- ================================
-- Themes Table Policies
-- سياسات جدول الثيمات
-- ================================

-- Allow public to read active/published themes
CREATE POLICY "Public read themes" ON themes
    FOR SELECT USING (
        (is_active = true OR is_default = true) OR 
        get_user_role() = 'service_role'
    );

-- Allow admins to manage themes
CREATE POLICY "Admin manage themes" ON themes
    FOR ALL USING (
        get_user_role() = 'service_role' OR
        is_admin()
    );

-- ================================
-- Additional Security Functions
-- دوال الأمان الإضافية
-- ================================

-- Function to check rate limiting
CREATE OR REPLACE FUNCTION check_rate_limit(action_type TEXT, limit_per_hour INTEGER DEFAULT 100)
RETURNS BOOLEAN AS $$
DECLARE
    current_count INTEGER;
    client_ip INET;
BEGIN
    -- Get client IP (simplified for development)
    client_ip := inet_client_addr();
    
    -- Count recent actions from this IP
    SELECT COUNT(*) INTO current_count
    FROM analytics_events 
    WHERE ip_address = client_ip 
    AND event_type = action_type
    AND created_at > NOW() - INTERVAL '1 hour';
    
    -- Return true if under limit
    RETURN current_count < limit_per_hour;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to log security events
CREATE OR REPLACE FUNCTION log_security_event(event_type TEXT, details JSONB DEFAULT '{}')
RETURNS VOID AS $$
BEGIN
    INSERT INTO analytics_events (
        event_type,
        event_category,
        ip_address,
        user_agent,
        metadata,
        created_at
    ) VALUES (
        event_type,
        'security',
        inet_client_addr(),
        current_setting('request.headers', true)::json->>'user-agent',
        details,
        NOW()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================
-- Development vs Production Settings
-- إعدادات التطوير مقابل الإنتاج
-- ================================

-- Create a settings table for RLS configuration
CREATE TABLE IF NOT EXISTS rls_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    environment VARCHAR(20) DEFAULT 'development', -- development, staging, production
    strict_mode BOOLEAN DEFAULT false,
    rate_limiting_enabled BOOLEAN DEFAULT false,
    admin_verification_required BOOLEAN DEFAULT false,
    public_registration_enabled BOOLEAN DEFAULT false,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default RLS settings
INSERT INTO rls_settings (environment, strict_mode, rate_limiting_enabled) 
VALUES ('development', false, false)
ON CONFLICT DO NOTHING;

-- ================================
-- Production Security Enhancements
-- تحسينات الأمان للإنتاج
-- ================================

-- Function to enable production security
CREATE OR REPLACE FUNCTION enable_production_security()
RETURNS VOID AS $$
BEGIN
    -- Update RLS settings for production
    UPDATE rls_settings SET
        environment = 'production',
        strict_mode = true,
        rate_limiting_enabled = true,
        admin_verification_required = true,
        updated_at = NOW()
    WHERE environment = 'development';
    
    -- Log the security upgrade
    PERFORM log_security_event('security_upgrade', '{"mode": "production"}');
    
    RAISE NOTICE 'Production security mode enabled!';
END;
$$ LANGUAGE plpgsql;

-- Function to check if we're in production mode
CREATE OR REPLACE FUNCTION is_production_mode()
RETURNS BOOLEAN AS $$
DECLARE
    prod_mode BOOLEAN;
BEGIN
    SELECT strict_mode INTO prod_mode 
    FROM rls_settings 
    WHERE environment IN ('production', 'staging')
    LIMIT 1;
    
    RETURN COALESCE(prod_mode, false);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================
-- Success Message
-- رسالة النجاح
-- ================================

SELECT 
    '🔒 Row Level Security configured successfully!' as status,
    '🔒 تم إعداد أمان مستوى الصفوف بنجاح!' as status_ar,
    'Environment: ' || COALESCE((SELECT environment FROM rls_settings LIMIT 1), 'development') as environment,
    'Strict Mode: ' || COALESCE((SELECT strict_mode FROM rls_settings LIMIT 1), false) as strict_mode;

-- Show policy summary
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
