-- KYCtrust Platform - Complete Initial Data Seeding
-- إدراج البيانات الأولية الكاملة لمنصة KYCtrust

-- ================================
-- 1. Insert Site Settings | إدراج إعدادات الموقع
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
    success_color,
    warning_color,
    error_color,
    contact_email,
    contact_phone,
    contact_whatsapp,
    contact_hours,
    contact_hours_en,
    social_links,
    business_hours,
    features,
    stats,
    testimonials,
    faqs,
    seo_settings,
    analytics_settings,
    notification_settings,
    security_settings
) VALUES (
    'KYCtrust - منصة موثوقة للخدمات المالية الرقمية',
    'KYCtrust - Trusted Digital Financial Services Platform',
    'منصة موثوقة تقدم أفضل الخدمات المالية الرقمية مع ضمان الأمان والجودة والسرعة في التنفيذ',
    'Trusted platform providing the best digital financial services with guaranteed security, quality, and fast execution',
    'مستقبل الخدمات المالية الرقمية',
    'The Future of Digital Financial Services',
    'نحن نعيد تعريف الخدمات المالية الرقمية من خلال تقديم حلول مبتكرة وآمنة ومتطورة تلبي احتياجات العصر الحديث وتضمن أفضل تجربة للعملاء',
    'We are redefining digital financial services through innovative, secure, and advanced solutions that meet modern era needs and ensure the best customer experience',
    'سيتم التواصل معك خلال 24 ساعة لتأكيد الطلب وبدء العمل. نضمن لك أفضل خدمة وأسرع تنفيذ.',
    'We will contact you within 24 hours to confirm your order and start working. We guarantee the best service and fastest execution.',
    '#3B82F6',
    '#6366F1', 
    '#8B5CF6',
    '#10B981',
    '#F59E0B',
    '#EF4444',
    'info@kyctrust.com',
    '+966501234567',
    '+966501234567',
    'السبت - الخميس: 9:00 ص - 6:00 م (بتوقيت الرياض)',
    'Saturday - Thursday: 9:00 AM - 6:00 PM (Riyadh Time)',
    '{"twitter": "https://twitter.com/kyctrust", "linkedin": "https://linkedin.com/company/kyctrust", "telegram": "https://t.me/kyctrust", "instagram": "https://instagram.com/kyctrust", "youtube": "https://youtube.com/@kyctrust", "tiktok": "https://tiktok.com/@kyctrust"}',
    '{"saturday": {"open": "09:00", "close": "18:00", "closed": false}, "sunday": {"open": "09:00", "close": "18:00", "closed": false}, "monday": {"open": "09:00", "close": "18:00", "closed": false}, "tuesday": {"open": "09:00", "close": "18:00", "closed": false}, "wednesday": {"open": "09:00", "close": "18:00", "closed": false}, "thursday": {"open": "09:00", "close": "18:00", "closed": false}, "friday": {"open": "14:00", "close": "18:00", "closed": false}}',
    '{"security": {"title": "أمان متقدم", "title_en": "Advanced Security", "description": "حماية بمستوى البنوك مع تشفير عالي الجودة وأنظمة أمان متطورة", "description_en": "Bank-level protection with high-quality encryption and advanced security systems", "icon": "shield-check"}, "speed": {"title": "سرعة في التنفيذ", "title_en": "Fast Execution", "description": "إنجاز جميع الطلبات في أقل من 5 دقائق مع ضمان الجودة", "description_en": "Complete all orders in less than 5 minutes with quality guarantee", "icon": "zap"}, "support": {"title": "دعم على مدار الساعة", "title_en": "24/7 Support", "description": "فريق دعم متخصص متاح 24/7 لمساعدتك في أي وقت", "description_en": "Professional support team available 24/7 to help you anytime", "icon": "headphones"}, "trust": {"title": "موثوقية عالية", "title_en": "High Reliability", "description": "معدل نجاح 99.9% في جميع الخدمات مع ضمان استرداد الأموال", "description_en": "99.9% success rate in all services with money-back guarantee", "icon": "award"}, "global": {"title": "تغطية عالمية", "title_en": "Global Coverage", "description": "نخدم أكثر من 50 دولة حول العالم بأعلى معايير الجودة", "description_en": "We serve over 50 countries worldwide with the highest quality standards", "icon": "globe"}, "innovation": {"title": "تقنيات مبتكرة", "title_en": "Innovative Technology", "description": "نستخدم أحدث التقنيات والذكاء الاصطناعي لضمان أفضل النتائج", "description_en": "We use the latest technologies and AI to ensure the best results", "icon": "cpu"}}',
    '{"total_clients": 15000, "completed_orders": 35000, "success_rate": 99.9, "countries_served": 50, "years_experience": 5, "team_members": 25, "average_response_time": "< 5 minutes", "customer_satisfaction": 98.5}',
    '{"testimonial_1": {"name": "أحمد محمد", "name_en": "Ahmed Mohammed", "role": "رئيس تنفيذي", "role_en": "CEO", "company": "شركة التقنية المتقدمة", "company_en": "Advanced Technology Company", "rating": 5, "text": "خدمة ممتازة وسرعة في التنفيذ. فريق محترف وموثوق.", "text_en": "Excellent service and fast execution. Professional and reliable team.", "image": ""}, "testimonial_2": {"name": "فاطمة العلي", "name_en": "Fatima Al-Ali", "role": "مديرة مالية", "role_en": "Finance Manager", "company": "مجموعة الاستثمار الخليجي", "company_en": "Gulf Investment Group", "rating": 5, "text": "أفضل منصة للخدمات المالية الرقمية. أنصح بها بشدة.", "text_en": "Best platform for digital financial services. Highly recommended.", "image": ""}, "testimonial_3": {"name": "خالد السعد", "name_en": "Khalid Al-Saad", "role": "مطور أعمال", "role_en": "Business Developer", "company": "شركة الرقمنة الذكية", "company_en": "Smart Digitization Company", "rating": 5, "text": "خدمة عملاء ممتازة ودعم فني على أعلى مستوى.", "text_en": "Excellent customer service and top-level technical support.", "image": ""}}',
    '{"faq_1": {"question": "كم يستغرق تنفيذ الطلب؟", "question_en": "How long does order execution take?", "answer": "معظم الطلبات تتم في أقل من 5 دقائق، والطلبات المعقدة خلال 24 ساعة.", "answer_en": "Most orders are completed in less than 5 minutes, complex orders within 24 hours.", "category": "general"}, "faq_2": {"question": "هل الخدمات آمنة؟", "question_en": "Are the services secure?", "answer": "نعم، نستخدم أحدث تقنيات التشفير وأمان البيانات المعتمدة دولياً.", "answer_en": "Yes, we use the latest encryption and internationally certified data security technologies.", "category": "security"}, "faq_3": {"question": "ما هي طرق الدفع المقبولة؟", "question_en": "What payment methods are accepted?", "answer": "نقبل التحويل البنكي، المحافظ الرقمية، والعملات المشفرة.", "answer_en": "We accept bank transfers, digital wallets, and cryptocurrencies.", "category": "payment"}, "faq_4": {"question": "هل يمكنني إلغاء الطلب؟", "question_en": "Can I cancel my order?", "answer": "يمكنك إلغاء الطلب قبل البدء في التنفيذ مع استرداد كامل للمبلغ.", "answer_en": "You can cancel the order before execution starts with full refund.", "category": "general"}}',
    '{"title": "KYCtrust - منصة موثوقة للخدمات المالية الرقمية | Trusted Digital Financial Services", "description": "احصل على أفضل الخدمات المالية الرقمية من منصة KYCtrust الموثوقة. خدمات KYC وAML وتحليل المخاطر المالية. سرعة وأمان وموثوقية.", "keywords": "خدمات مالية رقمية، KYC، AML، تحليل مخاطر، خدمات مصرفية، محافظ رقمية، KYCtrust، موثوقة، آمنة، سريعة", "author": "KYCtrust", "robots": "index, follow", "canonical": "https://kyctrust.com", "og_title": "KYCtrust - مستقبل الخدمات المالية الرقمية", "og_description": "منصة موثوقة تقدم أفضل الخدمات المالية الرقمية مع ضمان الأمان والجودة", "og_image": "https://kyctrust.com/images/og-image.jpg"}',
    '{"google_analytics_id": "", "facebook_pixel_id": "", "hotjar_site_id": "", "google_tag_manager_id": "", "enabled": false, "conversion_tracking": true, "ecommerce_tracking": true, "custom_events": true}',
    '{"email_notifications": {"enabled": true, "order_confirmation": true, "status_updates": true, "promotions": false}, "sms_notifications": {"enabled": false, "order_confirmation": false, "status_updates": false}, "push_notifications": {"enabled": true, "order_updates": true, "news": false}, "admin_notifications": {"new_orders": true, "failed_payments": true, "system_alerts": true}}',
    '{"allowed_countries": ["SA", "AE", "QA", "KW", "BH", "OM", "US", "GB", "CA", "AU"], "blocked_countries": [], "max_orders_per_ip": 10, "max_orders_per_email": 5, "require_email_verification": false, "enable_captcha": true, "session_timeout": 3600, "password_policy": {"min_length": 8, "require_uppercase": true, "require_lowercase": true, "require_numbers": true, "require_symbols": false}}'
) ON CONFLICT DO NOTHING;

-- ================================
-- 2. Insert Services | إدراج الخدمات
-- ================================

INSERT INTO services (name, name_en, description, description_en, price, price_numeric, currency, category, icon, color, order_index, active, featured, tags, requirements, delivery_time) VALUES

-- KYC Services
('خدمات KYC المتقدمة للأفراد', 'Advanced KYC Services for Individuals', 'خدمات تحقق الهوية الشاملة للأفراد وفقاً للمعايير الدولية مع ضمان الأمان والسرعة', 'Comprehensive identity verification services for individuals according to international standards with guaranteed security and speed', '$299', 299.00, 'USD', 'kyc', 'shield-check', '#3B82F6', 1, true, true, '{"kyc", "identity", "verification", "individuals"}', 'صورة الهوية، صورة شخصية، إثبات العنوان', '2-4 hours'),

('خدمات KYC للشركات والمؤسسات', 'KYC Services for Companies & Institutions', 'خدمات تحقق متقدمة للشركات والمؤسسات مع فحص شامل للوثائق القانونية والمالية', 'Advanced verification services for companies and institutions with comprehensive legal and financial document review', '$799', 799.00, 'USD', 'kyc', 'building', '#2563EB', 2, true, true, '{"kyc", "business", "corporate", "institutions"}', 'السجل التجاري، عقد التأسيس، البيانات المالية', '24-48 hours'),

('خدمات KYB (Know Your Business)', 'KYB (Know Your Business) Services', 'تحقق شامل من هوية الأعمال والشركاء التجاريين لضمان الامتثال والأمان', 'Comprehensive business identity and commercial partners verification for compliance and security assurance', '$599', 599.00, 'USD', 'kyc', 'handshake', '#1D4ED8', 3, true, false, '{"kyb", "business", "partners", "compliance"}', 'وثائق الشركة، قائمة الشركاء، البيانات المالية', '24-72 hours'),

-- AML Services
('خدمات AML المتخصصة', 'Specialized AML Services', 'خدمات مكافحة غسيل الأموال وتمويل الإرهاب وفقاً للمعايير الدولية والمحلية', 'Anti-money laundering and terrorism financing services according to international and local standards', '$399', 399.00, 'USD', 'aml', 'shield', '#EF4444', 4, true, true, '{"aml", "compliance", "anti-money-laundering"}', 'تفاصيل المعام��ات، مصادر الأموال، الوثائق المطلوبة', '24-48 hours'),

('فحص القوائم السوداء العالمية', 'Global Sanctions & Watchlist Screening', 'فحص شامل للأفراد والشركات مقابل القوائم السوداء العالمية ومعاقب OFAC', 'Comprehensive screening for individuals and companies against global blacklists and OFAC sanctions', '$199', 199.00, 'USD', 'aml', 'search', '#DC2626', 5, true, false, '{"sanctions", "screening", "ofac", "blacklist"}', 'الاسم الكامل، تاريخ الميلاد، الجنسية', '1-4 hours'),

-- Risk Analysis
('تحليل المخاطر المالية الشامل', 'Comprehensive Financial Risk Analysis', 'تقييم متقدم للمخاطر المالية باستخدام أحدث التقنيات والذكاء الاصطناعي', 'Advanced financial risk assessment using latest technologies and artificial intelligence', '$499', 499.00, 'USD', 'risk', 'trending-up', '#10B981', 6, true, true, '{"risk", "analysis", "financial", "ai"}', 'البيانات المالية، تاريخ المعاملات، التقارير المالية', '12-24 hours'),

('تقييم مخاطر الائتمان', 'Credit Risk Assessment', 'تحليل متخصص لمخاطر الائتمان وال��درة على السداد للأفراد والشركات', 'Specialized credit risk analysis and repayment capability for individuals and companies', '$349', 349.00, 'USD', 'risk', 'credit-card', '#059669', 7, true, false, '{"credit", "risk", "assessment", "lending"}', 'التاريخ الائتماني، الدخل، الأصول، الالتزامات', '24-48 hours'),

-- Compliance Services
('استشارات الامتثال المالي', 'Financial Compliance Consulting', 'استشارات متخصصة في الامتثال للوائح المالية المحلية والدولية', 'Specialized consulting in compliance with local and international financial regulations', '$699', 699.00, 'USD', 'compliance', 'book-open', '#8B5CF6', 8, true, false, '{"compliance", "consulting", "regulations"}', 'تفاصيل النشاط، اللوائح المطبقة، الهيكل التنظيمي', '48-72 hours'),

('إعداد سياسات AML/CFT', 'AML/CFT Policy Development', 'تطوير وإعداد سياسات مكافحة غسيل الأموال وتمويل الإرهاب حسب المتطلبات التنظيمية', 'Development of anti-money laundering and counter-terrorism financing policies according to regulatory requirements', '$999', 999.00, 'USD', 'compliance', 'file-text', '#7C3AED', 9, true, false, '{"policy", "aml", "cft", "development"}', 'هيكل الشركة، طبيعة النشاط، اللوائح المطبقة', '5-7 days'),

-- Audit Services
('تدقيق الحسابات الرقمية', 'Digital Account Auditing', 'خدمات تدقيق شاملة للحسابات والمحافظ الرقمية مع تقرير مفصل', 'Comprehensive auditing services for digital accounts and wallets with detailed reporting', '$449', 449.00, 'USD', 'audit', 'search', '#F59E0B', 10, true, false, '{"audit", "digital", "accounts", "wallets"}', 'تفاصيل الحسابات، سجل المعاملات، كلمات المرور', '48-72 hours'),

('مراجعة الامتثال الداخلي', 'Internal Compliance Review', 'مراجعة شاملة لأنظمة الامتثال الداخلية وتقديم التوصيات للتحسين', 'Comprehensive review of internal compliance systems with improvement recommendations', '$799', 799.00, 'USD', 'audit', 'clipboard-check', '#D97706', 11, true, false, '{"compliance", "review", "internal", "audit"}', 'السياسات الحالية، الإجراءات، التقارير', '5-7 days'),

-- Payment Solutions
('حلول الدفع الآمنة للتجارة الإلكترونية', 'Secure Payment Solutions for E-commerce', 'تطوير وتنفيذ حلول دفع آمنة ومتطورة للمتاجر الإلكترونية والشركات', 'Development and implementation of secure and advanced payment solutions for e-commerce and companies', '$1299', 1299.00, 'USD', 'payment', 'credit-card', '#06B6D4', 12, true, true, '{"payment", "ecommerce", "solutions", "integration"}', 'متطلبات النظام، نوع التجارة، حجم المعاملات', '7-14 days'),

('إعداد محافظ رقمية متقدمة', 'Advanced Digital Wallet Setup', 'إنشاء وإعداد محافظ رقمية متقدمة مع أعلى معايير الأمان والتشفير', 'Creation and setup of advanced digital wallets with highest security and encryption standards', '$899', 899.00, 'USD', 'payment', 'wallet', '#0891B2', 13, true, false, '{"wallet", "digital", "setup", "security"}', 'نوع المحفظة المطلوبة، العملات المدعومة، متطلبات الأمان', '3-5 days'),

-- Training & Education
('تدريب فرق الامتثال', 'Compliance Teams Training', 'برامج تدريبية متخصصة لفرق الامتثال في الشركات والمؤسسات المالية', 'Specialized training programs for compliance teams in companies and financial institutions', '$1499', 1499.00, 'USD', 'training', 'graduation-cap', '#7C2D12', 14, true, false, '{"training", "compliance", "teams", "education"}', 'عدد المتدربين، مستوى الخبرة، التخصص المطلوب', '2-3 weeks'),

('ورش عمل AML/KYC', 'AML/KYC Workshops', 'ورش عمل تفاعلية لفهم متطلبات AML/KYC وأفضل الممارسات في التطبيق', 'Interactive workshops to understand AML/KYC requirements and best practices in implementation', '$999', 999.00, 'USD', 'training', 'users', '#92400E', 15, true, false, '{"workshop", "aml", "kyc", "interactive"}', 'عدد المشاركين، المستوى المطلوب، المدة المفضلة', '1-2 weeks');

-- ================================
-- 3. Insert Payment Methods | إدراج طرق الدفع
-- ================================

INSERT INTO payment_methods (name, name_en, description, description_en, details, details_en, type, icon, color, order_index, active, account_info, instructions, instructions_en, processing_time, supported_currencies, min_amount, max_amount) VALUES

-- Bank Transfers
('التحويل البنكي المحلي - الراجحي', 'Local Bank Transfer - Al Rajhi', 'تحويل مصرفي آمن وسريع عبر بنك الراجحي داخل المملكة العربية السعودية', 'Safe and fast bank transfer via Al Rajhi Bank within Saudi Arabia', 'بنك الراجحي - الفرع الرئيسي بالرياض - حساب تجاري', 'Al Rajhi Bank - Main Branch Riyadh - Business Account', 'bank', 'building-2', '#22C55E', 1, true,
'{"bank_name": "بنك الراجحي", "bank_name_en": "Al Rajhi Bank", "account_name": "KYCtrust Financial Services", "account_number": "123456789012", "iban": "SA1234567890123456789012", "swift_code": "RJHISARI", "branch": "فرع الرياض الرئيسي", "branch_en": "Main Riyadh Branch", "branch_code": "001"}',
'قم بتحويل المبلغ المطلوب إلى الحساب المذكور أعلاه، ثم أرسل صورة من إيصال التحويل عبر واتساب أو البريد الإلكتروني لتأكيد العملية.',
'Transfer the required amount to the account mentioned above, then send a copy of the transfer receipt via WhatsApp or email to confirm the transaction.',
'1-3 ساعات في أوقات العمل', '{"SAR", "USD"}', 100.00, 50000.00),

('التحويل البنكي الدولي - SWIFT', 'International Bank Transfer - SWIFT', 'تحويل مصرفي دولي آمن عبر نظام SWIFT للعملاء من خارج السعودية', 'Secure international bank transfer via SWIFT system for customers outside Saudi Arabia', 'حساب مصرفي دولي معتمد لاستقبال التحويلات من جميع أنحاء العالم', 'Certified international bank account to receive transfers from around the world', 'bank', 'globe', '#1E40AF', 2, true,
'{"bank_name": "Bank of America", "account_name": "KYCtrust International Ltd", "account_number": "987654321098", "swift_code": "BOFAUS3N", "routing_number": "026009593", "address": "100 Federal Street, Boston, MA 02110", "intermediary_bank": "Citibank N.A.", "intermediary_swift": "CITIUS33"}',
'استخدم معلومات الحساب أعلاه للتحويل الدولي، وتأكد من إضافة رقم الطلب في خانة المرجع. مدة التحويل 1-3 أيام عمل.',
'Use the account information above for international transfer, and make sure to add the order number in the reference field. Transfer time is 1-3 business days.',
'1-3 أيام عمل', '{"USD", "EUR", "GBP"}', 200.00, 100000.00),

-- Digital Wallets
('محفظة STC Pay', 'STC Pay Wallet', 'دفع سريع وآمن عبر محفظة STC Pay - الحل الأمثل للدفعات المحلية', 'Fast and secure payment via STC Pay wallet - optimal solution for local payments', 'محفظة تجارية معتمدة لاستقبال المدفوعات من جميع أنحاء المملكة', 'Certified business wallet to receive payments from all over the Kingdom', 'wallet', 'wallet', '#E11D48', 3, true,
'{"wallet_number": "+966501234567", "account_name": "KYCtrust Services", "account_type": "business", "merchant_id": "STC123456789", "qr_code": "data:image/png;base64,..."}',
'ادفع المبلغ المطلوب عبر تطبيق STC Pay باستخدام رقم المحفظة أو مسح رمز QR، ثم أرسل لقطة شاشة تؤكد العملية.',
'Pay the required amount via STC Pay app using wallet number or QR code scan, then send a screenshot confirming the transaction.',
'فوري - أقل من دقيقة', '{"SAR"}', 50.00, 10000.00),

('محفظة Apple Pay', 'Apple Pay Wallet', 'دفع سريع وآمن باستخدام Apple Pay للمستخدمين على أجهزة iOS', 'Fast and secure payment using Apple Pay for iOS device users', 'خدمة دفع رقمية متقدمة مع حماية بيومترية وتشفير متقدم', 'Advanced digital payment service with biometric protection and advanced encryption', 'wallet', 'smartphone', '#000000', 4, true,
'{"merchant_id": "merchant.com.kyctrust.pay", "supported_cards": ["Visa", "Mastercard", "mada"], "supported_countries": ["SA", "AE", "US", "GB"], "business_identifier": "APPLE-PAY-KYCTRUST"}',
'استخدم Apple Pay للدفع السريع والآمن. سيتم توجيهك لإتمام العملية عبر محفظة آبل الخ��صة بك.',
'Use Apple Pay for fast and secure payment. You will be directed to complete the transaction through your Apple Wallet.',
'فوري', '{"SAR", "USD", "EUR"}', 100.00, 5000.00),

-- Wise Transfer
('تحويل Wise (TransferWise)', 'Wise Transfer (TransferWise)', 'تحويل دولي سريع وبأسعار تنافسية عبر منصة Wise المعتمدة عالمياً', 'Fast international transfer with competitive rates via globally certified Wise platform', 'حساب Wise تجاري معتمد لاستقبال التحويلات بأقل الرسوم', 'Certified Wise business account to receive transfers with minimal fees', 'international', 'globe', '#6366F1', 5, true,
'{"wise_email": "payments@kyctrust.com", "account_type": "business", "supported_currencies": ["USD", "EUR", "GBP", "SAR", "AED"], "account_details": {"USD": "Account: 8310006428", "EUR": "IBAN: BE47967897613635", "GBP": "Account: 23538294"}}',
'أرسل المبلغ المطلوب إلى حساب Wise باستخدام البريد الإلكتروني payments@kyctrust.com أو تفاصيل الحساب المناسبة للعملة.',
'Send the required amount to Wise account using email payments@kyctrust.com or appropriate account details for the currency.',
'دقائق إلى ساعات ��سب العملة', '{"USD", "EUR", "GBP", "SAR", "AED", "CAD", "AUD"}', 50.00, 50000.00),

-- Cryptocurrencies
('بيتكوين (Bitcoin)', 'Bitcoin (BTC)', 'دفع آمن ومشفر بعملة البيتكوين مع تأكيد سريع للمعاملات', 'Secure and encrypted payment with Bitcoin with fast transaction confirmation', 'محفظة بيتكوين آمنة ومعتمدة لاستقبال المدفوعات المشفرة', 'Secure and certified Bitcoin wallet to receive encrypted payments', 'crypto', 'bitcoin', '#F7931A', 6, true,
'{"wallet_address": "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh", "network": "Bitcoin", "confirmations_required": 3, "qr_code": "bitcoin:bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh", "explorer_url": "https://blockstream.info/address/"}',
'أرسل المبلغ المطلوب بعملة البيتكوين إلى العنوان المحدد أعلاه. سيتم تأكيد العملية بعد 3 تأكيدات على الشبكة.',
'Send the required amount in Bitcoin to the address specified above. The transaction will be confirmed after 3 network confirmations.',
'30-60 دقيقة للتأكيد الكامل', '{"BTC"}', 0.001, 10.0),

('تيثر USDT', 'Tether USDT', 'دفع مستقر بعملة USDT المربوطة بالدولار الأمريكي عبر شبكات متعددة', 'Stable payment with USDT pegged to US Dollar via multiple networks', 'محافظ USDT متعددة الشبكات لضمان أسرع المعاملات وأقل الرسوم', 'Multi-network USDT wallets to ensure fastest transactions and lowest fees', 'crypto', 'dollar-sign', '#26A17B', 7, true,
'{"wallets": {"TRC20": "TQn9Y2khEsLJW3Jse6F8J8J8J8J8J8J8J8", "ERC20": "0x742d35Cc6661C0532E6c1d7d6c8a8d9F8A8F8D2E", "BEP20": "0x742d35Cc6661C0532E6c1d7d6c8a8d9F8A8F8D2E"}, "preferred_network": "TRC20", "min_confirmations": {"TRC20": 20, "ERC20": 12, "BEP20": 15}}',
'اختر الشبكة المناسبة (نوصي بـ TRC20 للرسوم الأقل) وأرسل المبلغ بعملة USDT إلى العنوان المحدد.',
'Choose the appropriate network (we recommend TRC20 for lower fees) and send the amount in USDT to the specified address.',
'5-15 دقيقة حسب الشبكة', '{"USDT"}', 10.00, 100000.00),

('إيثريوم (Ethereum)', 'Ethereum (ETH)', 'دفع بعملة الإيثريوم مع دعم العقود الذكية والمعاملات السريعة', 'Payment with Ethereum supporting smart contracts and fast transactions', 'محفظة إيثريوم متقدمة مع دعم للرموز المميزة والعقود الذكية', 'Advanced Ethereum wallet with support for tokens and smart contracts', 'crypto', 'hexagon', '#627EEA', 8, true,
'{"wallet_address": "0x742d35Cc6661C0532E6c1d7d6c8a8d9F8A8F8D2E", "network": "Ethereum", "gas_limit": 21000, "supported_tokens": ["ETH", "USDT", "USDC", "DAI"], "confirmations_required": 12}',
'أرسل المبلغ بعملة الإيثريوم أو الرموز المدعومة إلى العنوان المحدد. تأكد من استخدام شبكة Ethereum الرئيسية.',
'Send the amount in Ethereum or supported tokens to the specified address. Make sure to use the main Ethereum network.',
'15-30 دقيقة للتأكيد', '{"ETH", "USDT", "USDC"}', 0.01, 1000.0),

-- Buy Now Pay Later
('تابي (Tabby) - اشتري الآن وادفع لاحقاً', 'Tabby - Buy Now Pay Later', 'حلول دفع مرنة مع إمكانية تقسيط المشتريات على 4 دفعات بدون فوائد', 'Flexible payment solutions with ability to split purchases into 4 interest-free installments', 'خدمة دفع آجل معتمدة في منطقة الخليج مع موافقة فورية', 'Certified deferred payment service in Gulf region with instant approval', 'bnpl', 'calendar', '#7C3AED', 9, true,
'{"merchant_id": "TABBY-KYCTRUST-001", "supported_countries": ["SA", "AE", "KW", "BH"], "installment_options": [4], "max_amount": 5000, "approval_rate": "95%", "processing_fee": 0}',
'اختر خيار الدفع عبر تابي عند إتمام الطلب، وستتم الموافقة الفورية لتقسيم المبلغ على 4 دفعات.',
'Choose Tabby payment option when completing the order, and you will get instant approval to split the amount into 4 payments.',
'موافقة فورية', '{"SAR", "AED"}', 100.00, 5000.00),

('تمارا (Tamara) - تقسيط ذكي', 'Tamara - Smart Installments', 'تقسيط ذكي للمشتريات مع خيارات دفع مرنة وبدون رسوم إضافية', 'Smart installments for purchases with flexible payment options and no additional fees', 'منصة تقسيط رائدة في المنطقة مع تجربة دفع سلسة ومريحة', 'Leading installment platform in the region with smooth and comfortable payment experience', 'bnpl', 'credit-card', '#00D4B4', 10, true,
'{"merchant_code": "TAMARA-KYC-789", "installment_plans": ["3_months", "6_months", "12_months"], "countries": ["SA", "AE"], "instant_decision": true, "down_payment": "25%", "fees": "0%"}',
'ادفع 25% من قيمة الطلب الآن وقسط الباقي على 3، 6، أو 12 شهر بدون فوائد عبر تمارا.',
'Pay 25% of the order value now and installment the rest over 3, 6, or 12 months without interest through Tamara.',
'قرار فوري خلال ثواني', '{"SAR", "AED"}', 200.00, 10000.00);

-- ================================
-- 4. Insert Default Admin User | إدراج المستخدم الإداري الافتراضي
-- ================================

INSERT INTO admin_users (
    email,
    password_hash,
    name,
    role,
    permissions,
    active,
    email_verified,
    preferences,
    timezone,
    language,
    theme
) VALUES (
    'admin@kyctrust.com',
    crypt('KYCtrust2024!Admin', gen_salt('bf')),
    'مدير النظام الرئيسي',
    'super_admin',
    ARRAY[
        'manage_services',
        'manage_orders', 
        'manage_payments',
        'manage_settings',
        'manage_admins',
        'view_analytics',
        'manage_templates',
        'manage_themes',
        'system_admin',
        'financial_reports',
        'security_settings'
    ],
    true,
    true,
    '{"dashboard_layout": "modern", "notifications": {"email": true, "push": true, "sms": false}, "auto_refresh": true, "items_per_page": 25}',
    'Asia/Riyadh',
    'ar',
    'light'
) ON CONFLICT (email) DO NOTHING;

-- ================================
-- 5. Insert Default Theme | إدراج الثيم الافتراضي
-- ================================

INSERT INTO themes (
    name,
    name_en,
    description,
    description_en,
    colors,
    fonts,
    spacing,
    borders,
    shadows,
    animations,
    is_default,
    is_active,
    category,
    version
) VALUES (
    'الثيم الافتراضي المتقدم',
    'Advanced Default Theme',
    'الثيم الافتراضي للمنصة مع تصميم حديث وألوان متناسقة ومتجاوبة',
    'Default platform theme with modern design, harmonious and responsive colors',
    '{"primary": "#3B82F6", "secondary": "#6366F1", "accent": "#8B5CF6", "success": "#10B981", "warning": "#F59E0B", "error": "#EF4444", "info": "#06B6D4", "background": "#FFFFFF", "surface": "#F8FAFC", "text": {"primary": "#1F2937", "secondary": "#6B7280", "disabled": "#9CA3AF"}, "border": "#E5E7EB", "divider": "#F3F4F6"}',
    '{"primary": "Cairo", "secondary": "system-ui", "mono": "Courier New", "sizes": {"xs": "0.75rem", "sm": "0.875rem", "base": "1rem", "lg": "1.125rem", "xl": "1.25rem", "2xl": "1.5rem", "3xl": "1.875rem", "4xl": "2.25rem"}, "weights": {"light": 300, "normal": 400, "medium": 500, "semibold": 600, "bold": 700, "extrabold": 800}}',
    '{"xs": "0.25rem", "sm": "0.5rem", "md": "1rem", "lg": "1.5rem", "xl": "3rem", "2xl": "6rem", "section": "4rem", "container": "1.25rem"}',
    '{"radius": {"none": "0", "sm": "0.25rem", "md": "0.375rem", "lg": "0.5rem", "xl": "0.75rem", "2xl": "1rem", "full": "9999px"}, "width": {"thin": "1px", "medium": "2px", "thick": "4px"}}',
    '{"sm": "0 1px 2px 0 rgba(0, 0, 0, 0.05)", "md": "0 4px 6px -1px rgba(0, 0, 0, 0.1)", "lg": "0 10px 15px -3px rgba(0, 0, 0, 0.1)", "xl": "0 20px 25px -5px rgba(0, 0, 0, 0.1)", "glow": "0 0 20px rgba(59, 130, 246, 0.3)", "inner": "inset 0 2px 4px 0 rgba(0, 0, 0, 0.06)"}',
    '{"duration": {"fast": "150ms", "normal": "300ms", "slow": "500ms"}, "timing": {"ease": "cubic-bezier(0.25, 0.8, 0.25, 1)", "bounce": "cubic-bezier(0.68, -0.55, 0.265, 1.55)"}, "transforms": {"hover_scale": "1.05", "hover_translate": "-2px", "click_scale": "0.95"}}',
    true,
    true,
    'default',
    '2.0.0'
) ON CONFLICT DO NOTHING;

-- ================================
-- 6. Insert Sample Analytics Events | إدراج أحداث تحليلات تجريبية
-- ================================

INSERT INTO analytics_events (event_type, event_category, event_action, page_url, page_title, device_type, browser, country, metadata) VALUES
('page_view', 'navigation', 'view', 'https://kyctrust.com/', 'الصفحة الرئيسية - KYCtrust', 'desktop', 'Chrome', 'Saudi Arabia', '{"section": "hero", "language": "ar", "utm_source": "google"}'),
('page_view', 'navigation', 'view', 'https://kyctrust.com/services', 'خدماتنا - KYCtrust', 'mobile', 'Safari', 'United Arab Emirates', '{"section": "services", "language": "ar"}'),
('service_view', 'services', 'view', 'https://kyctrust.com/', 'الصفحة الرئيسية', 'desktop', 'Firefox', 'Saudi Arabia', '{"service_name": "خدمات KYC المتقدمة", "service_id": "1", "price": 299}'),
('user_interaction', 'engagement', 'click', 'https://kyctrust.com/', 'الصفحة الرئيسية', 'mobile', 'Chrome', 'Kuwait', '{"element": "cta_button", "text": "ابدأ الآن", "section": "hero"}'),
('order_started', 'conversion', 'start', 'https://kyctrust.com/', 'الصفحة الرئيسية', 'desktop', 'Edge', 'Bahrain', '{"service": "خدمات KYC المتقدمة", "step": "selection", "amount": 299}'),
('scroll_depth', 'engagement', 'scroll', 'https://kyctrust.com/', 'الصفحة الرئيسية', 'mobile', 'Chrome', 'Saudi Arabia', '{"depth": 75, "section": "testimonials"}'),
('modal_opened', 'interaction', 'open', 'https://kyctrust.com/', 'الصفحة الرئيسية', 'desktop', 'Chrome', 'Qatar', '{"modal_type": "order_modal", "service": "تحليل المخاطر المالية"}');

-- ================================
-- Success Messages & Summary
-- رسائل النجاح والملخص
-- ================================

-- Show completion message
SELECT 
    '🎉 KYCtrust Complete Database Seeded Successfully!' as message,
    '🎉 تم إدراج البيانات الكاملة لمنصة KYCtrust بنجاح!' as message_ar,
    NOW() as completed_at;

-- Show data summary
SELECT 
    'Complete Data Summary | ملخص البيانات الكاملة' as summary,
    (SELECT COUNT(*) FROM services) as total_services,
    (SELECT COUNT(*) FROM payment_methods) as total_payment_methods,
    (SELECT COUNT(*) FROM admin_users) as total_admin_users,
    (SELECT COUNT(*) FROM site_settings) as total_site_settings,
    (SELECT COUNT(*) FROM themes) as total_themes,
    (SELECT COUNT(*) FROM analytics_events) as sample_analytics_events;

-- Show services by category
SELECT 
    'Services by Category | الخدمات حسب الفئة' as title,
    category,
    COUNT(*) as count,
    AVG(price_numeric) as avg_price
FROM services 
GROUP BY category 
ORDER BY count DESC;

-- Show active payment methods by type
SELECT 
    'Payment Methods by Type | طرق الدفع حسب النوع' as title,
    type,
    COUNT(*) as count,
    MIN(min_amount) as min_amount,
    MAX(max_amount) as max_amount
FROM payment_methods 
WHERE active = true
GROUP BY type 
ORDER BY count DESC;
