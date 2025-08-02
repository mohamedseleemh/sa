-- KYCtrust Database Schema
-- Version: 1.0.0
-- Created: 2024

-- ============================================
-- CORE TABLES
-- ============================================

-- Users Table (for admin and customer accounts)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'customer' CHECK (role IN ('admin', 'customer', 'operator')),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    avatar_url VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Services Table
CREATE TABLE IF NOT EXISTS services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),
    description TEXT,
    description_en TEXT,
    category VARCHAR(100),
    price DECIMAL(10,2) NOT NULL DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'SAR',
    estimated_duration VARCHAR(50),
    requirements TEXT,
    features JSONB,
    is_active BOOLEAN DEFAULT true,
    icon VARCHAR(100),
    image_url VARCHAR(500),
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    service_id UUID REFERENCES services(id) ON DELETE SET NULL,
    
    -- Customer Information
    customer_name VARCHAR(200) NOT NULL,
    customer_email VARCHAR(255),
    customer_phone VARCHAR(20),
    customer_address TEXT,
    
    -- Service Details
    service_name VARCHAR(200) NOT NULL,
    service_price DECIMAL(10,2) NOT NULL,
    
    -- Order Details
    quantity INTEGER DEFAULT 1,
    total_amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'SAR',
    
    -- Status and Timestamps
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'cancelled', 'refunded')),
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    
    -- Additional Information
    notes TEXT,
    requirements JSONB,
    attachments JSONB,
    estimated_completion DATE,
    completed_at TIMESTAMP WITH TIME ZONE,
    
    -- Payment Information
    payment_method VARCHAR(100),
    payment_status VARCHAR(50) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'partially_paid', 'refunded', 'failed')),
    payment_reference VARCHAR(100),
    payment_date TIMESTAMP WITH TIME ZONE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Payment Methods Table
CREATE TABLE IF NOT EXISTS payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(200) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('bank', 'wallet', 'crypto', 'card', 'cash')),
    
    -- Payment Details (stored as JSONB for flexibility)
    details JSONB NOT NULL DEFAULT '{}',
    
    -- Configuration
    is_active BOOLEAN DEFAULT true,
    fees JSONB DEFAULT '{}',
    limits JSONB DEFAULT '{}',
    
    -- Display Options
    icon VARCHAR(100),
    color VARCHAR(7),
    sort_order INTEGER DEFAULT 0,
    
    -- Instructions
    instructions TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- CONTENT MANAGEMENT TABLES
-- ============================================

-- Site Settings Table
CREATE TABLE IF NOT EXISTS site_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value JSONB,
    setting_type VARCHAR(50) DEFAULT 'string',
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Page Customizations Table
CREATE TABLE IF NOT EXISTS page_customizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    page_name VARCHAR(100) NOT NULL,
    section_name VARCHAR(100) NOT NULL,
    customization_data JSONB NOT NULL DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(page_name, section_name)
);

-- Media Library Table
CREATE TABLE IF NOT EXISTS media_library (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    filename VARCHAR(255) NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    file_type VARCHAR(50) CHECK (file_type IN ('image', 'video', 'document', 'audio')),
    alt_text VARCHAR(255),
    caption TEXT,
    uploaded_by UUID REFERENCES users(id) ON DELETE SET NULL,
    is_public BOOLEAN DEFAULT true,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- COMMUNICATION TABLES
-- ============================================

-- Messages/Tickets Table
CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    
    -- Message Details
    subject VARCHAR(300) NOT NULL,
    message TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    status VARCHAR(50) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'waiting_customer', 'resolved', 'closed')),
    
    -- Contact Information
    customer_name VARCHAR(200),
    customer_email VARCHAR(255),
    customer_phone VARCHAR(20),
    
    -- Categorization
    category VARCHAR(100),
    tags JSONB DEFAULT '[]',
    
    -- Assignment
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Timestamps
    last_reply_at TIMESTAMP WITH TIME ZONE,
    resolved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Message Replies Table
CREATE TABLE IF NOT EXISTS message_replies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID REFERENCES messages(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Reply Content
    reply_text TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT false,
    attachments JSONB DEFAULT '[]',
    
    -- Status
    is_solution BOOLEAN DEFAULT false,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- Notification Content
    title VARCHAR(300) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'info' CHECK (type IN ('info', 'success', 'warning', 'error')),
    
    -- Categorization
    category VARCHAR(100),
    
    -- Status
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,
    
    -- Actions
    action_url VARCHAR(500),
    action_text VARCHAR(100),
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- ANALYTICS AND LOGS TABLES
-- ============================================

-- Analytics Events Table
CREATE TABLE IF NOT EXISTS analytics_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    session_id VARCHAR(100),
    
    -- Event Details
    event_type VARCHAR(100) NOT NULL,
    event_name VARCHAR(200) NOT NULL,
    event_data JSONB DEFAULT '{}',
    
    -- Page/Location Information
    page_url VARCHAR(500),
    page_title VARCHAR(300),
    referrer VARCHAR(500),
    
    -- User Agent Information
    user_agent TEXT,
    ip_address INET,
    country VARCHAR(100),
    city VARCHAR(100),
    
    -- Device Information
    device_type VARCHAR(50),
    browser VARCHAR(100),
    os VARCHAR(100),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Activity Logs Table
CREATE TABLE IF NOT EXISTS activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Activity Details
    action VARCHAR(200) NOT NULL,
    resource_type VARCHAR(100),
    resource_id UUID,
    
    -- Changes
    old_values JSONB,
    new_values JSONB,
    
    -- Context
    ip_address INET,
    user_agent TEXT,
    additional_data JSONB DEFAULT '{}',
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System Logs Table
CREATE TABLE IF NOT EXISTS system_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    level VARCHAR(20) NOT NULL CHECK (level IN ('debug', 'info', 'warning', 'error', 'critical')),
    message TEXT NOT NULL,
    context JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- BACKUP AND MAINTENANCE TABLES
-- ============================================

-- Backups Table
CREATE TABLE IF NOT EXISTS backups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    backup_name VARCHAR(200) NOT NULL,
    backup_type VARCHAR(50) DEFAULT 'manual' CHECK (backup_type IN ('manual', 'automatic', 'scheduled')),
    file_path VARCHAR(500),
    file_size BIGINT,
    backup_data JSONB,
    
    -- Status
    status VARCHAR(50) DEFAULT 'completed' CHECK (status IN ('pending', 'running', 'completed', 'failed')),
    error_message TEXT,
    
    -- Metadata
    tables_included JSONB DEFAULT '[]',
    compression_type VARCHAR(50),
    checksum VARCHAR(128),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Users indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_active ON users(is_active);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Services indexes
CREATE INDEX IF NOT EXISTS idx_services_active ON services(is_active);
CREATE INDEX IF NOT EXISTS idx_services_category ON services(category);
CREATE INDEX IF NOT EXISTS idx_services_sort_order ON services(sort_order);

-- Orders indexes
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_priority ON orders(priority);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_service_id ON orders(service_id);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders(payment_status);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON orders(order_number);

-- Messages indexes
CREATE INDEX IF NOT EXISTS idx_messages_status ON messages(status);
CREATE INDEX IF NOT EXISTS idx_messages_user_id ON messages(user_id);
CREATE INDEX IF NOT EXISTS idx_messages_assigned_to ON messages(assigned_to);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at);

-- Analytics indexes
CREATE INDEX IF NOT EXISTS idx_analytics_events_type ON analytics_events(event_type);
CREATE INDEX IF NOT EXISTS idx_analytics_events_user_id ON analytics_events(user_id);
CREATE INDEX IF NOT EXISTS idx_analytics_events_created_at ON analytics_events(created_at);

-- Activity logs indexes
CREATE INDEX IF NOT EXISTS idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_logs_action ON activity_logs(action);
CREATE INDEX IF NOT EXISTS idx_activity_logs_created_at ON activity_logs(created_at);

-- ============================================
-- FUNCTIONS AND TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payment_methods_updated_at BEFORE UPDATE ON payment_methods FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_site_settings_updated_at BEFORE UPDATE ON site_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_page_customizations_updated_at BEFORE UPDATE ON page_customizations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_media_library_updated_at BEFORE UPDATE ON media_library FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_messages_updated_at BEFORE UPDATE ON messages FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_message_replies_updated_at BEFORE UPDATE ON message_replies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON notifications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate order numbers
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TEXT AS $$
DECLARE
    new_number TEXT;
    counter INTEGER;
BEGIN
    -- Get the current date in YYYYMMDD format
    new_number := 'KYC' || TO_CHAR(NOW(), 'YYYYMMDD');
    
    -- Get the count of orders created today
    SELECT COUNT(*) + 1 INTO counter
    FROM orders 
    WHERE DATE(created_at) = CURRENT_DATE;
    
    -- Append the counter with zero padding
    new_number := new_number || LPAD(counter::TEXT, 4, '0');
    
    RETURN new_number;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-generate order numbers
CREATE OR REPLACE FUNCTION set_order_number()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.order_number IS NULL OR NEW.order_number = '' THEN
        NEW.order_number := generate_order_number();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_order_number_trigger
    BEFORE INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION set_order_number();

-- ============================================
-- VIEWS FOR COMMON QUERIES
-- ============================================

-- Orders with customer and service details
CREATE OR REPLACE VIEW orders_detailed AS
SELECT 
    o.*,
    s.name as service_name_full,
    s.category as service_category,
    s.icon as service_icon,
    u.first_name || ' ' || u.last_name as user_full_name,
    u.email as user_email
FROM orders o
LEFT JOIN services s ON o.service_id = s.id
LEFT JOIN users u ON o.user_id = u.id;

-- Recent activity summary
CREATE OR REPLACE VIEW recent_activity AS
SELECT 
    'order' as activity_type,
    o.id,
    o.order_number as reference,
    o.customer_name as title,
    o.status as status,
    o.created_at
FROM orders o
WHERE o.created_at >= NOW() - INTERVAL '30 days'

UNION ALL

SELECT 
    'message' as activity_type,
    m.id,
    m.ticket_number as reference,
    m.subject as title,
    m.status as status,
    m.created_at
FROM messages m
WHERE m.created_at >= NOW() - INTERVAL '30 days'

ORDER BY created_at DESC;

-- ============================================
-- SECURITY POLICIES (Row Level Security)
-- ============================================

-- Enable RLS on sensitive tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Policy for users to see their own data
CREATE POLICY "Users can view own profile" ON users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

-- Policy for customers to see their own orders
CREATE POLICY "Customers can view own orders" ON orders
    FOR SELECT USING (auth.uid() = user_id);

-- Policy for customers to see their own messages
CREATE POLICY "Customers can view own messages" ON messages
    FOR SELECT USING (auth.uid() = user_id);

-- Policy for customers to see their own notifications
CREATE POLICY "Customers can view own notifications" ON notifications
    FOR SELECT USING (auth.uid() = user_id);

-- Admin policies (bypass RLS for admin role)
CREATE POLICY "Admins can view all users" ON users
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

CREATE POLICY "Admins can manage all orders" ON orders
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role IN ('admin', 'operator')
        )
    );

-- ============================================
-- INITIAL DATA
-- ============================================

-- Admin user will be created automatically through the secure setup process
-- No default admin credentials for security reasons
-- The application will prompt for secure password creation on first login

-- Note: Admin authentication is now handled by the frontend security system
-- with PBKDF2 password hashing and secure session management

-- Insert default services
INSERT INTO services (name, name_en, description, category, price, estimated_duration, features, is_active, icon)
VALUES 
    (
        'التحق�� من الهوية الأساسي',
        'Basic Identity Verification',
        'خدمة التحقق من الهوية الأساسية للأفراد',
        'KYC',
        199.00,
        '1-2 أيام عمل',
        '["التحقق من الوثائق", "التحقق من الهوية", "تقرير مفصل"]',
        true,
        'Shield'
    ),
    (
        'التحقق من الهوية المتقدم',
        'Advanced Identity Verification',
        'خدمة التحقق من الهوية المتقدمة مع فحص شامل',
        'KYC',
        399.00,
        '2-3 أيام عمل',
        '["التحقق الشامل", "فحص السجل الجنائي", "تقرير تفصيلي", "دعم 24/7"]',
        true,
        'ShieldCheck'
    ),
    (
        'التحقق من الشركات',
        'Business Verification',
        'خدمة التحقق من الشركات والكيانات التجارية',
        'Business',
        799.00,
        '3-5 أيام عمل',
        '["التحقق من السجل التجاري", "التحقق من المالكين", "تقرير مالي", "استشارة قانونية"]',
        true,
        'Building'
    )
ON CONFLICT DO NOTHING;

-- Insert default payment methods
INSERT INTO payment_methods (name, type, details, is_active, icon, color, sort_order)
VALUES 
    (
        'تحويل بنكي - الراجحي',
        'bank',
        '{"iban": "SA1234567890123456789012", "beneficiaryName": "KYCtrust للخدمات الرقمية", "bankName": "بنك الراجحي"}',
        true,
        'Building',
        '#10B981',
        1
    ),
    (
        'STC Pay',
        'wallet',
        '{"walletNumber": "0551234567", "instructions": "أرسل المبلغ إلى رقم المحفظة وأرسل لقطة الشاشة"}',
        true,
        'Smartphone',
        '#6366F1',
        2
    )
ON CONFLICT DO NOTHING;

-- Insert default site settings
INSERT INTO site_settings (setting_key, setting_value, setting_type, description, is_public)
VALUES 
    ('company_name', '"KYCtrust للخدمات الرقمية"', 'string', 'اسم الشركة', true),
    ('company_phone', '"+966501234567"', 'string', 'رقم هاتف الشركة', true),
    ('company_email', '"info@kyctrust.com"', 'string', 'البريد الإلكتروني للشركة', true),
    ('whatsapp_number', '"+966501234567"', 'string', 'رقم الواتساب', true),
    ('maintenance_mode', 'false', 'boolean', 'وضع الصيانة', false),
    ('enable_notifications', 'true', 'boolean', 'تفعيل الإشعارات', false),
    ('default_language', '"ar"', 'string', 'اللغة الافتراضية', true),
    ('theme_primary_color', '"#3B82F6"', 'string', 'اللون الأساسي للموضوع', true)
ON CONFLICT (setting_key) DO UPDATE SET 
    setting_value = EXCLUDED.setting_value,
    updated_at = NOW();

-- ============================================
-- DATABASE VERSION INFO
-- ============================================

CREATE TABLE IF NOT EXISTS schema_version (
    version VARCHAR(20) PRIMARY KEY,
    description TEXT,
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO schema_version (version, description)
VALUES ('1.0.0', 'Initial KYCtrust database schema')
ON CONFLICT (version) DO NOTHING;

-- End of Schema
