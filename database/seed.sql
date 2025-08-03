-- KYCtrust Database Seed Data
-- This file contains sample data for development and testing

-- Clear existing data (be careful in production!)
-- DELETE FROM analytics_events;
-- DELETE FROM activity_logs;
-- DELETE FROM message_replies;
-- DELETE FROM messages;
-- DELETE FROM notifications;
-- DELETE FROM orders;
-- DELETE FROM page_customizations;
-- DELETE FROM media_library;
-- DELETE FROM site_settings;
-- DELETE FROM payment_methods;
-- DELETE FROM services;
-- DELETE FROM users WHERE email != 'admin@kyctrust.com';

-- ============================================
-- SAMPLE USERS
-- ============================================

INSERT INTO users (id, email, password_hash, role, first_name, last_name, phone, is_active, is_verified) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'customer1@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LfWppDaGq0MpbKOFK', 'customer', 'أحمد', 'المحمد', '+966501111111', true, true),
('550e8400-e29b-41d4-a716-446655440002', 'customer2@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LfWppDaGq0MpbKOFK', 'customer', 'فاطمة', 'الأحمد', '+966502222222', true, true),
('550e8400-e29b-41d4-a716-446655440003', 'operator@kyctrust.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LfWppDaGq0MpbKOFK', 'operator', 'سارة', 'العتيبي', '+966503333333', true, true),
('550e8400-e29b-41d4-a716-446655440004', 'customer3@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LfWppDaGq0MpbKOFK', 'customer', 'محمد', 'السالم', '+966504444444', true, false),
('550e8400-e29b-41d4-a716-446655440005', 'customer4@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LfWppDaGq0MpbKOFK', 'customer', 'نورا', 'الخالد', '+966505555555', true, true)
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- SAMPLE SERVICES
-- ============================================

INSERT INTO services (id, name, name_en, description, description_en, category, price, estimated_duration, requirements, features, is_active, icon, sort_order) VALUES
('650e8400-e29b-41d4-a716-446655440001', 'التحقق السريع من الهوية', 'Quick Identity Check', 'خدمة التحقق السريع من الهوية للاستخدامات الأساسية', 'Quick identity verification for basic use cases', 'KYC', 99.00, '24 ساعة', 'صورة الهوية الوطنية، صورة شخصية', '["التحقق الأساسي", "تقرير فوري", "دعم عبر الواتساب"]', true, 'Zap', 1),
('650e8400-e29b-41d4-a716-446655440002', 'التحقق المتقدم من الهوية', 'Advanced Identity Verification', 'خدمة شاملة للتحقق من الهوية مع فحص دقيق', 'Comprehensive identity verification with thorough checks', 'KYC', 299.00, '2-3 أيام عمل', 'الهوية الوطنية، كشف حساب بنكي، إثبات عنوان', '["فحص شامل", "تحقق من السجلات", "تقرير مفصل", "ضمان الجودة"]', true, 'Shield', 2),
('650e8400-e29b-41d4-a716-446655440003', 'التحقق المؤسسي', 'Corporate Verification', 'خدمة التحقق من الشركات والمؤسسات', 'Business and corporate entity verification', 'Business', 599.00, '5-7 أيام عمل', 'السجل التجاري، عقد التأسيس، بيانات المالكين', '["تحقق مؤسسي", "فحص المالكين", "تقرير مالي", "استشارة قانونية"]', true, 'Building', 3),
('650e8400-e29b-41d4-a716-446655440004', 'فحص السجل الجنائي', 'Criminal Background Check', 'خدمة فحص السجل الجنائي والأمني', 'Criminal and security background verification', 'Background', 399.00, '3-5 أيام عمل', 'الهوية الوطنية، تصريح من الشخص', '["فحص السجل الجنائي", "التحقق الأمني", "تقرير معتمد"]', true, 'FileSearch', 4),
('650e8400-e29b-41d4-a716-446655440005', 'التحقق الدولي', 'International Verification', 'خدمة التحقق من الهوية للمقيمين والأجانب', 'Identity verification for residents and foreigners', 'International', 449.00, '7-10 أيام عمل', 'جواز السفر، الإقامة، وثائق إضافية', '["تحقق دولي", "فحص الوثائق ا��أجنبية", "تقرير معتمد دولياً"]', true, 'Globe', 5),
('650e8400-e29b-41d4-a716-446655440006', 'التحقق المصرفي', 'Banking Verification', 'خدمة التحقق للمؤسسات المصرفية والمالية', 'Specialized verification for banking and financial institutions', 'Financial', 799.00, '3-7 أيام عمل', 'وثائق شاملة، تفويض مصرفي', '["فحص مصرفي شامل", "تحقق AML", "تقرير معتمد", "امتثال لـ SAMA"]', true, 'Banknote', 6)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- SAMPLE ORDERS
-- ============================================

INSERT INTO orders (id, order_number, user_id, service_id, customer_name, customer_email, customer_phone, service_name, service_price, total_amount, status, priority, notes, payment_method, payment_status, created_at, updated_at) VALUES
('750e8400-e29b-41d4-a716-446655440001', 'KYC202412010001', '550e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440002', 'أحمد المحمد', 'customer1@example.com', '+966501111111', 'التحقق المتقدم من الهوية', 299.00, 299.00, 'completed', 'medium', 'تم التحقق بنجاح', 'تحويل بنكي - الراجحي', 'paid', NOW() - INTERVAL '5 days', NOW() - INTERVAL '2 days'),
('750e8400-e29b-41d4-a716-446655440002', 'KYC202412010002', '550e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440001', 'فاطمة الأحمد', 'customer2@example.com', '+966502222222', 'التحقق السريع من الهوي��', 99.00, 99.00, 'processing', 'high', 'طلب عاجل للعمل', 'STC Pay', 'paid', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 hour'),
('750e8400-e29b-41d4-a716-446655440003', 'KYC202412010003', '550e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440003', 'محمد السالم', 'customer3@example.com', '+966504444444', 'التحقق المؤسسي', 599.00, 599.00, 'pending', 'medium', 'في انتظار استكمال الوثائق', 'تحويل بنكي - الراجحي', 'pending', NOW() - INTERVAL '1 day', NOW() - INTERVAL '6 hours'),
('750e8400-e29b-41d4-a716-446655440004', 'KYC202412010004', '550e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440004', 'نورا الخالد', 'customer4@example.com', '+966505555555', 'فحص السجل الجنائي', 399.00, 399.00, 'processing', 'low', 'فحص للتوظيف', 'STC Pay', 'paid', NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day'),
('750e8400-e29b-41d4-a716-446655440005', 'KYC202412010005', NULL, '650e8400-e29b-41d4-a716-446655440001', 'خالد العبدالله', 'khalid@example.com', '+966506666666', 'التحقق السريع من الهوية', 99.00, 99.00, 'cancelled', 'low', 'تم الإلغاء بناء على طلب العميل', NULL, 'refunded', NOW() - INTERVAL '7 days', NOW() - INTERVAL '6 days'),
('750e8400-e29b-41d4-a716-446655440006', 'KYC202412010006', NULL, '650e8400-e29b-41d4-a716-446655440005', 'ليلى الحارثي', 'laila@example.com', '+966507777777', 'التحقق الدولي', 449.00, 449.00, 'processing', 'high', 'عميل مقيم يحتاج تحقق عاجل', 'تحويل بنكي - الراجحي', 'paid', NOW() - INTERVAL '4 days', NOW() - INTERVAL '2 hours')
ON CONFLICT (order_number) DO NOTHING;

-- ============================================
-- SAMPLE PAYMENT METHODS
-- ============================================

INSERT INTO payment_methods (id, name, type, details, is_active, fees, limits, icon, color, sort_order, instructions) VALUES
('850e8400-e29b-41d4-a716-446655440001', 'بنك الراجحي', 'bank', '{"iban": "SA0380000000608012345678", "beneficiaryName": "KYCtrust للخدمات الرقمية", "bankName": "بنك الراجحي", "accountNumber": "608012345678"}', true, '{"fixed": 0, "percentage": 0}', '{"min": 50, "max": 50000}', 'Building', '#00A651', 1, 'يرجى إرسال إيصال التحويل عبر الواتساب بعد الدفع مع رقم الطلب'),
('850e8400-e29b-41d4-a716-446655440002', 'بنك الأهلي', 'bank', '{"iban": "SA4410000000123456789012", "beneficiaryName": "KYCtrust للخدمات الرقمية", "bankName": "البنك الأهلي السعودي"}', true, '{"fixed": 0, "percentage": 0}', '{"min": 50, "max": 50000}', 'Building', '#E31837', 2, 'يرجى إرسال إيصال التحويل عبر الواتساب بعد الدفع'),
('850e8400-e29b-41d4-a716-446655440003', 'STC Pay', 'wallet', '{"walletNumber": "+966501234567", "displayName": "KYCtrust"}', true, '{"fixed": 0, "percentage": 2}', '{"min": 10, "max": 10000}', 'Smartphone', '#6C2E8C', 3, 'أرسل المبلغ إلى رقم المحفظة وأرسل لقطة الشاشة مع رقم الطلب'),
('850e8400-e29b-41d4-a716-446655440004', 'Apple Pay', 'wallet', '{"merchantId": "merchant.com.kyctrust", "displayName": "KYCtrust"}', false, '{"fixed": 0, "percentage": 2.5}', '{"min": 10, "max": 5000}', 'Smartphone', '#000000', 4, 'استخدم Apple Pay للدفع الآمن والسريع'),
('850e8400-e29b-41d4-a716-446655440005', 'مدى', 'card', '{"gateway": "mada", "merchantId": "KYC12345"}', false, '{"fixed": 0, "percentage": 2.5}', '{"min": 10, "max": 5000}', 'CreditCard', '#0066CC', 5, 'سيتم توجيهك لصفحة الدفع الآمنة لإتمام المعاملة'),
('850e8400-e29b-41d4-a716-446655440006', 'فيزا/ماستركارد', 'card', '{"gateway": "visa_mastercard", "merchantId": "KYC12345"}', false, '{"fixed": 0, "percentage": 3}', '{"min": 10, "max": 10000}', 'CreditCard', '#1A1F71', 6, 'ادفع بأمان باستخدام بطاقة فيزا أو ماستركارد'),
('850e8400-e29b-41d4-a716-446655440007', 'فودافون كاش', 'wallet', '{"walletNumber": "01062453344", "displayName": "KYCtrust"}', true, '{"fixed": 0, "percentage": 1}', '{"min": 5, "max": 20000}', 'Smartphone', '#E60000', 7, 'يرجى إرسال لقطة شاشة بعد التحويل'),
('850e8400-e29b-41d4-a716-446655440008', 'USDT (TRC20)', 'crypto', '{"cryptoAddress": "TFUt8GRpk2R8Wv3FvoCiSUghRBQo4HrmQK", "network": "TRC20"}', true, '{"fixed": 1, "percentage": 0}', '{"min": 10, "max": 100000}', 'Globe', '#26A17B', 8, 'تأكد من إرسال المبلغ على شبكة TRC20 فقط')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- SAMPLE MESSAGES/TICKETS
-- ============================================

INSERT INTO messages (id, ticket_number, user_id, order_id, subject, message, priority, status, customer_name, customer_email, customer_phone, category, assigned_to, created_at, updated_at) VALUES
('950e8400-e29b-41d4-a716-446655440001', 'TKT202412010001', '550e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440001', 'استفسار عن حالة الطلب', 'أريد معرفة متى سيكون طلبي جاهز؟', 'medium', 'resolved', 'أحمد المحمد', 'customer1@example.com', '+966501111111', 'طلب', '550e8400-e29b-41d4-a716-446655440003', NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day'),
('950e8400-e29b-41d4-a716-446655440002', 'TKT202412010002', '550e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440002', 'مشكلة في رفع الوثائق', 'لا أستطيع رفع صورة الهوية، تظهر رسالة خطأ', 'high', 'in_progress', 'فاطمة الأحمد', 'customer2@example.com', '+966502222222', 'تقني', '550e8400-e29b-41d4-a716-446655440003', NOW() - INTERVAL '1 day', NOW() - INTERVAL '2 hours'),
('950e8400-e29b-41d4-a716-446655440003', 'TKT202412010003', NULL, NULL, 'استفسار عن الخدمات', 'أريد معرفة الفرق بين خدمة التحقق الأساسي والمتقدم', 'low', 'open', 'سعد الغامدي', 'saad@example.com', '+966508888888', 'استفسار', NULL, NOW() - INTERVAL '6 hours', NOW() - INTERVAL '6 hours'),
('950e8400-e29b-41d4-a716-446655440004', 'TKT202412010004', '550e8400-e29b-41d4-a716-446655440004', '750e8400-e29b-41d4-a716-446655440003', 'طلب تعديل البيانات', 'أريد تعديل رقم الهاتف في طلبي', 'medium', 'waiting_customer', 'محمد السالم', 'customer3@example.com', '+966504444444', 'طلب', '550e8400-e29b-41d4-a716-446655440003', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day')
ON CONFLICT (ticket_number) DO NOTHING;

-- ============================================
-- SAMPLE MESSAGE REPLIES
-- ============================================

INSERT INTO message_replies (id, message_id, user_id, reply_text, is_internal, is_solution, created_at) VALUES
('a50e8400-e29b-41d4-a716-446655440001', '950e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', 'شكراً لتواصلك معنا. طلبك قيد المعالجة وسيكون جاهز خلال 24 ساعة.', false, true, NOW() - INTERVAL '2 days'),
('a50e8400-e29b-41d4-a716-446655440002', '950e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'شكراً لكم، في انتظار النتيجة', false, false, NOW() - INTERVAL '2 days'),
('a50e8400-e29b-41d4-a716-446655440003', '950e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', 'يرجى المحاولة مرة أخرى وإرسال الصورة بصيغة PNG أو JPG، وأن يكون الحجم أقل من 5 ميجا', false, false, NOW() - INTERVAL '1 hour'),
('a50e8400-e29b-41d4-a716-446655440004', '950e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', 'يمكنك تعديل البيانات من خلال تسجيل الدخول لحسابك أو إرسال البيانات الجديدة عبر الواتساب', false, true, NOW() - INTERVAL '1 day')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- SAMPLE NOTIFICATIONS
-- ============================================

INSERT INTO notifications (id, user_id, title, message, type, category, is_read, action_url, created_at) VALUES
('b50e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'تم إكمال طلبك', 'تم إكمال طلب التحقق من الهوية رقم KYC202412010001 بنجاح', 'success', 'order', true, '/orders/750e8400-e29b-41d4-a716-446655440001', NOW() - INTERVAL '2 days'),
('b50e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'طلبك قيد المعالجة', 'طلبك رقم KYC202412010002 قيد المعالجة حالياً', 'info', 'order', false, '/orders/750e8400-e29b-41d4-a716-446655440002', NOW() - INTERVAL '1 day'),
('b50e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440004', 'مطلوب وثائق إضافية', 'يرجى رفع وثائق إضافية لإكمال طلبك KYC202412010003', 'warning', 'order', false, '/orders/750e8400-e29b-41d4-a716-446655440003', NOW() - INTERVAL '6 hours'),
('b50e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440005', 'رد على استفسارك', 'تم الرد على تذكرة الدعم رقم TKT202412010004', 'info', 'support', false, '/messages/950e8400-e29b-41d4-a716-446655440004', NOW() - INTERVAL '1 day')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- SAMPLE SITE SETTINGS
-- ============================================

INSERT INTO site_settings (setting_key, setting_value, setting_type, description, is_public) VALUES
('welcome_message', '"مرحباً بك في KYCtrust - منصتك الموثوقة للتحقق من الهوية"', 'string', 'رسالة الترحيب', true),
('support_hours', '"الأحد - الخميس: 9:00 صباحاً - 6:00 مساءً"', 'string', 'ساعات الدعم', true),
('emergency_contact', '"+966501234567"', 'string', 'رقم الطوارئ', true),
('social_twitter', '"@kyctrust"', 'string', 'حساب تويتر', true),
('social_linkedin', '"company/kyctrust"', 'string', 'حساب لينكد إن', true),
('enable_live_chat', 'true', 'boolean', 'تفعيل الدردشة المباشرة', false),
('max_file_size_mb', '10', 'number', 'الحد الأقصى لحجم الملف بالميجابايت', false),
('allowed_file_types', '["jpg", "jpeg", "png", "pdf", "doc", "docx"]', 'json', 'أنواع الملفات المسموحة', false),
('email_verification_required', 'true', 'boolean', 'تفعيل التحقق من البريد الإلكتروني', false),
('auto_approve_orders', 'false', 'boolean', 'الموافقة التلقائية على الطلبات', false)
ON CONFLICT (setting_key) DO UPDATE SET 
    setting_value = EXCLUDED.setting_value,
    updated_at = NOW();

-- ============================================
-- SAMPLE PAGE CUSTOMIZATIONS
-- ============================================

INSERT INTO page_customizations (page_name, section_name, customization_data, is_active) VALUES
('landing', 'hero', '{"title": "KYCtrust للخدمات الرقمية", "subtitle": "منصتك الموثوقة للتحقق من الهوية", "buttonText": "ابدأ الآن", "backgroundImage": "/images/hero-bg.jpg"}', true),
('landing', 'services', '{"title": "خدماتنا", "subtitle": "حلول شاملة للتحقق من الهوية", "showPrices": true}', true),
('landing', 'features', '{"title": "لماذا تختار KYCtrust؟", "features": [{"title": "سرعة في التنفيذ", "description": "نتائج سريعة ودقيقة", "icon": "Zap"}, {"title": "أمان عالي", "description": "حماية متقدمة للبيانات", "icon": "Shield"}, {"title": "دعم 24/7", "description": "فريق دعم متاح دائماً", "icon": "Clock"}]}', true),
('landing', 'testimonials', '{"title": "آراء عملائنا", "testimonials": [{"name": "أحمد السعيد", "company": "شركة التقنية المتقدمة", "text": "خدمة ممتازة وسريعة، أنصح بها بشدة", "rating": 5}, {"name": "فاطمة الع��ي", "company": "مؤسسة النور", "text": "فريق محترف ونتائج دقيقة", "rating": 5}]}', true)
ON CONFLICT (page_name, section_name) DO UPDATE SET 
    customization_data = EXCLUDED.customization_data,
    updated_at = NOW();

-- ============================================
-- SAMPLE ANALYTICS EVENTS
-- ============================================

INSERT INTO analytics_events (event_type, event_name, event_data, page_url, page_title, user_agent, ip_address, device_type, browser, created_at) VALUES
('page_view', 'Landing Page View', '{"source": "direct"}', '/', 'KYCtrust - الصفحة الرئيسية', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '192.168.1.100', 'desktop', 'Chrome', NOW() - INTERVAL '1 hour'),
('page_view', 'Services Page View', '{"source": "navigation"}', '/services', 'الخدمات - KYCtrust', 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X)', '192.168.1.101', 'mobile', 'Safari', NOW() - INTERVAL '2 hours'),
('form_submission', 'Contact Form', '{"form_type": "contact", "source": "landing"}', '/contact', 'اتصل بنا - KYCtrust', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '192.168.1.102', 'desktop', 'Safari', NOW() - INTERVAL '3 hours'),
('order_created', 'New Order', '{"order_id": "750e8400-e29b-41d4-a716-446655440002", "service_type": "basic"}', '/order/new', 'طلب جديد - KYCtrust', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '192.168.1.103', 'desktop', 'Edge', NOW() - INTERVAL '1 day'),
('button_click', 'WhatsApp Contact', '{"location": "header", "action": "whatsapp_click"}', '/', 'KYCtrust - الصفحة الرئيسية', 'Mozilla/5.0 (Android 11; Mobile; rv:85.0)', '192.168.1.104', 'mobile', 'Firefox', NOW() - INTERVAL '5 hours')
ON CONFLICT DO NOTHING;

-- ============================================
-- SAMPLE ACTIVITY LOGS
-- ============================================

INSERT INTO activity_logs (user_id, action, resource_type, resource_id, old_values, new_values, ip_address, additional_data, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440003', 'order_status_updated', 'order', '750e8400-e29b-41d4-a716-446655440001', '{"status": "processing"}', '{"status": "completed"}', '192.168.1.200', '{"reason": "verification_completed"}', NOW() - INTERVAL '2 days'),
('550e8400-e29b-41d4-a716-446655440003', 'user_login', 'user', '550e8400-e29b-41d4-a716-446655440003', NULL, NULL, '192.168.1.201', '{"login_method": "email_password"}', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440001', 'profile_updated', 'user', '550e8400-e29b-41d4-a716-446655440001', '{"phone": "+966501111110"}', '{"phone": "+966501111111"}', '192.168.1.105', NULL, NOW() - INTERVAL '3 days'),
('550e8400-e29b-41d4-a716-446655440003', 'payment_method_added', 'payment_method', '850e8400-e29b-41d4-a716-446655440006', NULL, '{"name": "فيزا/ماستركارد", "type": "card"}', '192.168.1.200', NULL, NOW() - INTERVAL '1 week')
ON CONFLICT DO NOTHING;

-- ============================================
-- UPDATE STATISTICS
-- ============================================

-- Update order counts in services (this would normally be done by triggers)
UPDATE services SET 
    description = description || ' (' || (
        SELECT COUNT(*) FROM orders WHERE service_id = services.id
    ) || ' طلب مكتمل)'
WHERE id IN (
    SELECT DISTINCT service_id FROM orders WHERE service_id IS NOT NULL
);

-- ============================================
-- SAMPLE BACKUPS RECORD
-- ============================================

INSERT INTO backups (backup_name, backup_type, file_path, file_size, status, tables_included, created_at, completed_at) VALUES
('النسخة الاحتياطية الأولية', 'manual', '/backups/initial_backup_2024.sql', 2048000, 'completed', '["users", "services", "orders", "payment_methods", "site_settings"]', NOW() - INTERVAL '1 week', NOW() - INTERVAL '1 week'),
('نسخة احتياطية يومية', 'automatic', '/backups/daily_backup_2024.sql', 1536000, 'completed', '["orders", "messages", "notifications", "analytics_events"]', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day')
ON CONFLICT DO NOTHING;

-- ============================================
-- FINAL NOTES
-- ============================================

-- This seed file provides:
-- 1. Sample users with different roles
-- 2. Variety of services with different categories and prices
-- 3. Orders in different statuses
-- 4. Payment methods covering different types
-- 5. Support tickets and responses
-- 6. Notifications for users
-- 7. Site settings and customizations
-- 8. Analytics events for testing
-- 9. Activity logs for audit trail
-- 10. Sample backups

-- To use this file:
-- 1. Ensure the schema.sql has been executed first
-- 2. Run this file: psql -d your_database -f seed.sql
-- 3. The data is designed to not conflict with existing data
-- 4. You can run this multiple times safely

-- Default login credentials:
-- Admin: admin@kyctrust.com / admin123
-- Operator: operator@kyctrust.com / admin123
-- Customers: customer1@example.com / admin123 (and customer2, etc.)

ANALYZE; -- Update table statistics for better query performance
