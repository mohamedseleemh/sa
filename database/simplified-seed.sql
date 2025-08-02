-- KYCtrust Simplified Database Seed Data
-- Insert default data for the simplified application (NO USER REGISTRATION)

-- Insert default site settings
INSERT INTO site_settings (
    title, 
    description, 
    order_notice, 
    whatsapp_number,
    primary_color,
    secondary_color,
    accent_color,
    language,
    meta_keywords,
    meta_description
) VALUES (
    'KYCtrust - خدمات مالية رقمية موثوقة',
    'نقدم خدمات مالية رقمية احترافية وآمنة لجميع المنصات العالمية مع ضمان الجودة والموثوقية',
    'سيتم التواصل معك يدوياً عبر واتساب بعد إرسال الطلب.',
    '+201062453344',
    '#3B82F6',
    '#1E40AF', 
    '#F59E0B',
    'ar',
    'خدمات مالية, محافظ رقمية, تحويلات دولية, KYC Trust, PayPal, Payoneer, Wise',
    'منصة KYCtrust الرائدة في تقديم الخدمات المالية الرقمية الآمنة والموثوقة'
);

-- Insert default services
INSERT INTO services (name, description, price, category, order_index, active, popular, processing_time) VALUES
('Payoneer', 'إنشاء وتفعيل حساب Payoneer للتحويلات الدولية', '30$', 'wallets', 1, true, true, '5 ��قائق'),
('Wise (TransferWise)', 'فتح حساب Wise للتحويلات المالية الدولية', '30$', 'wallets', 2, true, true, '5 دقائق'),
('Skrill', 'إنشاء وتفعيل محفظة Skrill الرقمية', '20$', 'wallets', 3, true, false, '3 دقائق'),
('Neteller', 'فتح حساب Neteller للمدفوعات الإلكترونية', '20$', 'wallets', 4, true, false, '3 دقائق'),
('Kast', 'إنشاء حساب Kast للخدمات المالية', '20$', 'banking', 5, true, false, '5 دقائق'),
('Redotpay', 'فتح حساب Redotpay للمدفوعات', '20$', 'wallets', 6, true, false, '3 دقائق'),
('OKX', 'إنشاء حساب OKX لتداول العملات الرقمية', '20$', 'crypto', 7, true, false, '5 دقائق'),
('World First', 'فتح حساب World First للخدمات المصرفية', '20$', 'banking', 8, true, false, '10 د��ائق'),
('Bybit', 'إنشاء حساب Bybit للتداول', '20$', 'crypto', 9, true, false, '5 دقائق'),
('Bitget', 'فتح حساب Bitget للعملات الرقمية', '20$', 'crypto', 10, true, false, '5 دقائق'),
('KuCoin', 'إنشاء حساب KuCoin للتداول', '20$', 'crypto', 11, true, false, '5 دقائق'),
('PayPal', 'إنشاء وتفعيل حساب PayPal', '15$', 'wallets', 12, true, true, '3 دقا��ق'),
('Mexc', 'فتح حساب Mexc للتداول', '20$', 'crypto', 13, true, false, '5 دقائق'),
('Exness', 'إنشاء حساب Exness للتداول', '20$', 'trading', 14, true, false, '10 دقائق'),
('شحن رصيد فودافون', 'خدمة شحن رصيد فودافون كاش', '100 جنيه = 120 جنيه (متاح أي مبلغ)', 'local', 15, true, false, '1 دقيقة'),
('سحب من TikTok', 'خدمة سحب الأرباح من TikTok', 'حسب الاتفاق', 'social', 16, true, false, '24 ساعة'),
('سحب من PayPal', 'خدمة سحب الأموال من PayPal', 'حسب الاتفاق', 'wallets', 17, true, false, '2-6 ساعات');

-- Insert default payment methods (Manual Only)
INSERT INTO payment_methods (name, details, type, active, order_index, instructions) VALUES
('Vodafone Cash', '+201062453344', 'manual', true, 1, 'قم بإرسال المبلغ إلى رقم فودافون كاش (نفس رقم الواتس اب) وأرفق صورة من عملية التحويل'),
('USDT (TRC20)', 'TFUt8GRpk2R8Wv3FvoCiSUghRBQo4HrmQK', 'manual', true, 2, 'أرسل USDT إلى العنوان المذكور على شبكة TRC20 وأرفق hash المعاملة'),
('Orange Cash', '01234567890', 'manual', true, 3, 'قم بإرسال المبلغ إلى رقم Orange Cash وأرفق إثبات التحويل'),
('حوالة بنكية', 'البنك الأهلي المصري - حساب رقم: 1234567890', 'manual', true, 4, 'قم بتحويل المبلغ إلى الحساب البنكي المذكور وأرفق صورة من الإيصال');

-- Insert default testimonials
INSERT INTO testimonials (customer_name, customer_role, rating, comment, is_featured, display_order, active) VALUES
('أحمد محمد', 'رائد أعمال', 5, 'خدمة ممتازة وسريعة، تم تفعيل حساب Payoneer في دقائق معدودة والدعم الفني رائع', true, 1, true),
('فاطمة علي', 'مطورة ويب', 5, 'أفضل موقع للخدمات المالية الرقمية، التعامل احترافي والأسعار مناسبة جداً', true, 2, true),
('محمد سعد', 'متداول', 4, 'تم إنشاء حساب OKX بنجاح، الخدمة سريعة والفريق متعاون', false, 3, true),
('نور الدين', 'مصمم جرافيك', 5, 'خدمة PayPal كانت سريعة ومضمونة، أنصح بالتعامل معهم', false, 4, true),
('سارة أحمد', 'كاتبة محتوى', 5, 'تجربة رائعة مع خدمة Wise، كل شيء تم بسلاسة ودقة عالية', true, 5, true);

-- Insert default FAQs
INSERT INTO faqs (question, answer, category, display_order, active, language) VALUES
('ما هي مدة تنفيذ الطلب؟', 'يتم تنفيذ معظم الطلبات خلال 5-30 دقيقة حسب نوع الخدمة المطلوبة', 'general', 1, true, 'ar'),
('هل الخدمات آمنة ومضمونة؟', 'نعم، جميع خدماتنا آمنة ومضمونة 100% مع ضمان استرداد الأموال في حالة عدم نجاح الخدمة', 'security', 2, true, 'ar'),
('كيف يتم الدفع؟', 'يمكنك الدفع عبر فودافون كاش، USDT، أو حوالة بنكية حسب طريقة الدفع المناسبة لك', 'payment', 3, true, 'ar'),
('هل يمكنني إلغاء الطلب؟', 'يمكن إلغاء الطلب قبل البدء في تنفيذه، أما بعد البدء فلا يمكن الإلغاء', 'general', 4, true, 'ar'),
('كيف يتم التواصل معكم؟', 'يتم التواصل عبر واتساب على الرقم المذكور في الموقع، وسنقوم بالرد خلال دقائق', 'support', 5, true, 'ar'),
('هل تقدمون دعم فني؟', 'نعم، نقدم دعم فني على مدار الساعة لجميع العملاء لضمان تنفيذ الخدمات بأفضل شكل', 'support', 6, true, 'ar');

-- Insert default themes for page builder
INSERT INTO themes (name, theme_config, is_default, active) VALUES
('الثيم الافتراضي', '{"colors":{"primary":"#3B82F6","secondary":"#1E40AF","accent":"#F59E0B","background":"#FFFFFF","text":"#1F2937"},"fonts":{"heading":"Inter","body":"Inter"},"spacing":{"small":8,"medium":16,"large":32}}', true, true),
('ثيم أزرق داكن', '{"colors":{"primary":"#1E3A8A","secondary":"#3730A3","accent":"#DC2626","background":"#F8FAFC","text":"#1E293B"},"fonts":{"heading":"Inter","body":"Inter"},"spacing":{"small":8,"medium":16,"large":32}}', false, true),
('ثيم أخضر طبيعي', '{"colors":{"primary":"#059669","secondary":"#047857","accent":"#F59E0B","background":"#F0FDF4","text":"#1F2937"},"fonts":{"heading":"Inter","body":"Inter"},"spacing":{"small":8,"medium":16,"large":32}}', false, true);

-- Insert default page template
INSERT INTO page_templates (name, page_type, template_data, theme_config, is_default, active) VALUES
('الصفحة الرئيسية الافتراضية', 'landing', '[{"id":"hero-1","type":"hero","position":{"x":0,"y":0},"size":{"width":"100%","height":"600px"},"content":{"title":"KYCtrust - خدمات مالية رقمية موثوقة","subtitle":"نقدم خدمات مالية رقمية احترافية وآمنة","buttonText":"اطلب الخدمة الآن","backgroundImage":""},"styles":{},"visible":true}]', '{"colors":{"primary":"#3B82F6","secondary":"#1E40AF","accent":"#F59E0B"}}', true, true);
