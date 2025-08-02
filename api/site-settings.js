import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.SUPABASE_URL || process.env.VITE_SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY || process.env.VITE_SUPABASE_ANON_KEY
);

export default async function handler(req, res) {
  const { method } = req;

  try {
    switch (method) {
      case 'GET':
        return await getSiteSettings(req, res);
      case 'POST':
        return await createSiteSettings(req, res);
      case 'PUT':
        return await updateSiteSettings(req, res);
      default:
        res.setHeader('Allow', ['GET', 'POST', 'PUT']);
        return res.status(405).json({ error: 'Method not allowed' });
    }
  } catch (error) {
    console.error('Site Settings API error:', error);
    return res.status(500).json({ error: 'Internal server error', details: error.message });
  }
}

async function getSiteSettings(req, res) {
  try {
    const { data, error } = await supabase
      .from('site_settings')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (error && error.code !== 'PGRST116') {
      throw error;
    }

    const defaultSettings = {
      title: 'KYCtrust - خدمات مالية رقمية موثوقة',
      description: 'نقدم خدمات مالية رقمية احترافية وآمنة لجميع المنصات العالمية مع ضمان الجودة والموثوقية',
      order_notice: 'سيتم التواصل معك يدويًا عبر واتساب بعد إرسال الطلب.'
    };

    return res.status(200).json({
      success: true,
      data: data || defaultSettings
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to fetch site settings', details: error.message });
  }
}

async function createSiteSettings(req, res) {
  try {
    const { title, description, order_notice } = req.body;

    if (!title || !description || !order_notice) {
      return res.status(400).json({ error: 'Title, description, and order notice are required' });
    }

    const settingsData = {
      title,
      description,
      order_notice
    };

    const { data, error } = await supabase
      .from('site_settings')
      .insert(settingsData)
      .select()
      .single();

    if (error) throw error;

    return res.status(201).json({
      success: true,
      message: 'Site settings created successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to create site settings', details: error.message });
  }
}

async function updateSiteSettings(req, res) {
  try {
    const { id } = req.query;
    const { title, description, order_notice } = req.body;

    if (!id) {
      return res.status(400).json({ error: 'Settings ID is required' });
    }

    const updateData = {};
    if (title !== undefined) updateData.title = title;
    if (description !== undefined) updateData.description = description;
    if (order_notice !== undefined) updateData.order_notice = order_notice;
    
    updateData.updated_at = new Date().toISOString();

    const { data, error } = await supabase
      .from('site_settings')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Site settings updated successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to update site settings', details: error.message });
  }
}
