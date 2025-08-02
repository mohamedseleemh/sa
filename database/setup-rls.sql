-- KYCtrust Platform - Row Level Security Setup
-- إعداد أمان مستوى الصفوف لمنصة KYCtrust

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

DROP POLICY IF EXISTS "Public read services" ON services;
DROP POLICY IF EXISTS "Admin manage services" ON services;
DROP POLICY IF EXISTS "Public read payment_methods" ON payment_methods;
DROP POLICY IF EXISTS "Admin manage payment_methods" ON payment_methods;
DROP POLICY IF EXISTS "Admin manage orders" ON orders;
DROP POLICY IF EXISTS "Public create orders" ON orders;
DROP POLICY IF EXISTS "Public read site_settings" ON site_settings;
DROP POLICY IF EXISTS "Admin manage site_settings" ON site_settings;
DROP POLICY IF EXISTS "Admin only admin_users" ON admin_users;
DROP POLICY IF EXISTS "Admin manage analytics" ON analytics_events;
DROP POLICY IF EXISTS "Public create analytics" ON analytics_events;
DROP POLICY IF EXISTS "Public read page_templates" ON page_templates;
DROP POLICY IF EXISTS "Admin manage page_templates" ON page_templates;
DROP POLICY IF EXISTS "Public read themes" ON themes;
DROP POLICY IF EXISTS "Admin manage themes" ON themes;

-- ================================
-- Services Table Policies
-- سياسات جدول الخدمات
-- ================================

-- Allow public to read active services
CREATE POLICY "Public read services" ON services
    FOR SELECT USING (active = true);

-- Allow admins to manage all services
CREATE POLICY "Admin manage services" ON services
    FOR ALL USING (
        auth.role() = 'service_role' OR
        EXISTS (
            SELECT 1 FROM admin_users 
            WHERE id = auth.uid() 
            AND active = true 
            AND 'manage_services' = ANY(permissions)
        )
    );

-- ================================
-- Payment Methods Table Policies
-- سياسات جدول طرق الدفع
-- ================================

-- Allow public to read active payment methods
CREATE POLICY "Public read payment_methods" ON payment_methods
    FOR SELECT USING (active = true);

-- Allow admins to manage payment methods
CREATE POLICY "Admin manage payment_methods" ON payment_methods
    FOR ALL USING (
        auth.role() = 'service_role' OR
        EXISTS (
            SELECT 1 FROM admin_users 
            WHERE id = auth.uid() 
            AND active = true 
            AND 'manage_payments' = ANY(permissions)
        )
    );

-- ================================
-- Orders Table Policies
-- سياسات جدول الطلبات
-- ================================

-- Allow public to create orders
CREATE POLICY "Public create orders" ON orders
    FOR INSERT WITH CHECK (true);

-- Allow admins to manage orders
CREATE POLICY "Admin manage orders" ON orders
    FOR ALL USING (
        auth.role() = 'service_role' OR
        EXISTS (
            SELECT 1 FROM admin_users 
            WHERE id = auth.uid() 
            AND active = true 
            AND 'manage_orders' = ANY(permissions)
        )
    );

-- ================================
-- Site Settings Table Policies
-- سياسات جدول إعدادات الموقع
-- ================================

-- Allow public to read site settings
CREATE POLICY "Public read site_settings" ON site_settings
    FOR SELECT USING (active = true);

-- Allow admins to manage site settings
CREATE POLICY "Admin manage site_settings" ON site_settings
    FOR ALL USING (
        auth.role() = 'service_role' OR
        EXISTS (
            SELECT 1 FROM admin_users 
            WHERE id = auth.uid() 
            AND active = true 
            AND 'manage_settings' = ANY(permissions)
        )
    );

-- ================================
-- Admin Users Table Policies
-- سياسات جدول المستخدمين الإداريين
-- ================================

-- Admins can only see their own data or manage others if they have permission
CREATE POLICY "Admin only admin_users" ON admin_users
    FOR ALL USING (
        auth.role() = 'service_role' OR
        id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM admin_users 
            WHERE id = auth.uid() 
            AND active = true 
            AND 'manage_admins' = ANY(permissions)
        )
    );

-- ================================
-- Analytics Events Table Policies
-- سياسات جدول أحداث التحليلات
-- ================================

-- Allow public to create analytics events
CREATE POLICY "Public create analytics" ON analytics_events
    FOR INSERT WITH CHECK (true);

-- Allow admins to read analytics
CREATE POLICY "Admin manage analytics" ON analytics_events
    FOR SELECT USING (
        auth.role() = 'service_role' OR
        EXISTS (
            SELECT 1 FROM admin_users 
            WHERE id = auth.uid() 
            AND active = true 
            AND 'view_analytics' = ANY(permissions)
        )
    );

-- ================================
-- Page Templates Table Policies
-- سياسات جدول قوالب الصفحات
-- ================================

-- Allow public to read published templates
CREATE POLICY "Public read page_templates" ON page_templates
    FOR SELECT USING (is_published = true);

-- Allow admins to manage templates
CREATE POLICY "Admin manage page_templates" ON page_templates
    FOR ALL USING (
        auth.role() = 'service_role' OR
        EXISTS (
            SELECT 1 FROM admin_users 
            WHERE id = auth.uid() 
            AND active = true 
            AND 'manage_templates' = ANY(permissions)
        )
    );

-- ================================
-- Themes Table Policies
-- سياسات جدول الثيمات
-- ================================

-- Allow public to read active themes
CREATE POLICY "Public read themes" ON themes
    FOR SELECT USING (is_active = true);

-- Allow admins to manage themes
CREATE POLICY "Admin manage themes" ON themes
    FOR ALL USING (
        auth.role() = 'service_role' OR
        EXISTS (
            SELECT 1 FROM admin_users 
            WHERE id = auth.uid() 
            AND active = true 
            AND 'manage_themes' = ANY(permissions)
        )
    );

-- ================================
-- Create helper function for checking admin permissions
-- إنشاء دالة مساعدة للتحقق من صلاحيات الإدارة
-- ================================

CREATE OR REPLACE FUNCTION check_admin_permission(required_permission TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM admin_users 
        WHERE id = auth.uid() 
        AND active = true 
        AND required_permission = ANY(permissions)
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ================================
-- Success message
-- رسالة نجاح الإعداد
-- ================================

SELECT 'Row Level Security configured successfully! 🔒' as status;
SELECT 'تم إعداد أمان مستوى الصفوف بنجاح! 🔒' as status_ar;
