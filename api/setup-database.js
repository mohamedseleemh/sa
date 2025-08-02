import { createClient } from '@supabase/supabase-js';

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { supabaseUrl, supabaseKey, setupKey } = req.body;

    // التحقق من مفتاح الإعداد
    if (setupKey !== process.env.SETUP_KEY) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    if (!supabaseUrl || !supabaseKey) {
      return res.status(400).json({ error: 'Missing Supabase credentials' });
    }

    const supabase = createClient(supabaseUrl, supabaseKey);

    // إنشاء الجداول
    const tables = [
      // جدول الخدمات
      `CREATE TABLE IF NOT EXISTS services (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        name TEXT NOT NULL,
        price TEXT NOT NULL,
        order_index INTEGER NOT NULL DEFAULT 0,
        active BOOLEAN DEFAULT true,
        description TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );`,

      // جدول طرق الدفع
      `CREATE TABLE IF NOT EXISTS payment_methods (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        name TEXT NOT NULL,
        details TEXT NOT NULL,
        active BOOLEAN DEFAULT true,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );`,

      // جدول الطلبات
      `CREATE TABLE IF NOT EXISTS orders (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        customer_name TEXT NOT NULL,
        service_name TEXT NOT NULL,
        notes TEXT,
        status TEXT DEFAULT 'pending',
        archived BOOLEAN DEFAULT false,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );`,

      // جدول إعدادات الموقع
      `CREATE TABLE IF NOT EXISTS site_settings (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        order_notice TEXT NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );`,

      // جدول المستخدمين الإداريين
      `CREATE TABLE IF NOT EXISTS admin_users (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        role TEXT DEFAULT 'admin',
        active BOOLEAN DEFAULT true,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );`
    ];

    // تنفيذ إنشاء الجداول
    for (const sql of tables) {
      const { error } = await supabase.rpc('exec_sql', { sql });
      if (error) {
        console.error('Error creating table:', error);
      }
    }

    // إدراج البيانات الافتراضية
    const defaultServices = [
      { name: 'Payoneer', price: '30$', order_index: 1, active: true },
      { name: 'Wise', price: '30$', order_index: 2, active: true },
      { name: 'Skrill', price: '20$', order_index: 3, active: true },
      { name: 'Neteller', price: '20$', order_index: 4, active: true },
      { name: 'Kast', price: '20$', order_index: 5, active: true },
      { name: 'Redotpay', price: '20$', order_index: 6, active: true },
      { name: 'Okx', price: '20$', order_index: 7, active: true },
      { name: 'World First', price: '20$', order_index: 8, active: true },
      { name: 'Bybit', price: '20$', order_index: 9, active: true },
      { name: 'Bitget', price: '20$', order_index: 10, active: true },
      { name: 'Kucoin', price: '20$', order_index: 11, active: true },
      { name: 'PayPal', price: '15$', order_index: 12, active: true },
      { name: 'Mexc', price: '20$', order_index: 13, active: true },
      { name: 'Exness', price: '20$', order_index: 14, active: true },
      { name: 'شحن رصيد فودافون', price: '100 جنيه = 120 جنيه (متاح أي مبلغ)', order_index: 15, active: true },
      { name: 'سحب من TikTok', price: 'حسب الاتفاق', order_index: 16, active: true },
      { name: 'سحب من PayPal', price: 'حسب الاتفاق', order_index: 17, active: true }
    ];

    const defaultPaymentMethods = [
      { name: 'Vodafone Cash', details: '01062453344', active: true },
      { name: 'USDT (TRC20)', details: 'TFUt8GRpk2R8Wv3FvoCiSUghRBQo4HrmQK', active: true }
    ];

    const defaultSiteSettings = {
      title: 'KYCtrust - خدمات مالية رقمية موثوقة',
      description: 'نقدم خدمات مالية رقمية احترافية وآمنة لجميع المنصات العالمية مع ضمان الجودة والموثوقية',
      order_notice: 'سيتم التواصل معك يدويًا عبر واتساب بعد إرسال الطلب.'
    };

    // التحقق من وجود البيانات قبل الإدراج
    const { data: existingServices } = await supabase.from('services').select('id').limit(1);
    if (!existingServices || existingServices.length === 0) {
      await supabase.from('services').insert(defaultServices);
    }

    const { data: existingPaymentMethods } = await supabase.from('payment_methods').select('id').limit(1);
    if (!existingPaymentMethods || existingPaymentMethods.length === 0) {
      await supabase.from('payment_methods').insert(defaultPaymentMethods);
    }

    const { data: existingSettings } = await supabase.from('site_settings').select('id').limit(1);
    if (!existingSettings || existingSettings.length === 0) {
      await supabase.from('site_settings').insert(defaultSiteSettings);
    }

    // إنشاء Row Level Security policies
    const rlsPolicies = [
      `ALTER TABLE services ENABLE ROW LEVEL SECURITY;`,
      `CREATE POLICY "Enable read access for all users" ON services FOR SELECT USING (true);`,
      `CREATE POLICY "Enable insert for authenticated users only" ON services FOR INSERT WITH CHECK (auth.role() = 'authenticated');`,
      
      `ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;`,
      `CREATE POLICY "Enable read access for all users" ON payment_methods FOR SELECT USING (true);`,
      
      `ALTER TABLE orders ENABLE ROW LEVEL SECURITY;`,
      `CREATE POLICY "Enable insert for all users" ON orders FOR INSERT WITH CHECK (true);`,
      `CREATE POLICY "Enable read for authenticated users only" ON orders FOR SELECT USING (auth.role() = 'authenticated');`,
      
      `ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;`,
      `CREATE POLICY "Enable read access for all users" ON site_settings FOR SELECT USING (true);`
    ];

    for (const policy of rlsPolicies) {
      const { error } = await supabase.rpc('exec_sql', { sql: policy });
      if (error && !error.message.includes('already exists')) {
        console.error('Error creating policy:', error);
      }
    }

    res.status(200).json({ 
      success: true, 
      message: 'Database setup completed successfully',
      tables_created: tables.length,
      services_added: defaultServices.length,
      payment_methods_added: defaultPaymentMethods.length
    });

  } catch (error) {
    console.error('Database setup error:', error);
    res.status(500).json({ 
      error: 'Database setup failed', 
      details: error.message 
    });
  }
}
