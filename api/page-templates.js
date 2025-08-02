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
        return await getPageTemplates(req, res);
      case 'POST':
        return await savePageTemplate(req, res);
      case 'PUT':
        return await updatePageTemplate(req, res);
      case 'DELETE':
        return await deletePageTemplate(req, res);
      default:
        res.setHeader('Allow', ['GET', 'POST', 'PUT', 'DELETE']);
        return res.status(405).json({ error: 'Method not allowed' });
    }
  } catch (error) {
    console.error('Page Templates API error:', error);
    return res.status(500).json({ error: 'Internal server error', details: error.message });
  }
}

async function getPageTemplates(req, res) {
  try {
    const { page_type, active } = req.query;
    
    let query = supabase.from('page_templates').select('*');

    if (page_type) {
      query = query.eq('page_type', page_type);
    }

    if (active !== undefined) {
      query = query.eq('active', active === 'true');
    }

    query = query.order('updated_at', { ascending: false });

    const { data, error } = await query;

    if (error) throw error;

    return res.status(200).json({
      success: true,
      data,
      count: data?.length || 0
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to fetch page templates', details: error.message });
  }
}

async function savePageTemplate(req, res) {
  try {
    const { name, page_type, template_data, theme_config, custom_css, is_default } = req.body;

    if (!name || !page_type || !template_data) {
      return res.status(400).json({ error: 'Name, page type, and template data are required' });
    }

    const templateData = {
      name,
      page_type,
      template_data: JSON.stringify(template_data),
      theme_config: JSON.stringify(theme_config || {}),
      custom_css: custom_css || '',
      is_default: is_default || false,
      active: true
    };

    if (is_default) {
      await supabase
        .from('page_templates')
        .update({ is_default: false })
        .eq('page_type', page_type);
    }

    const { data, error } = await supabase
      .from('page_templates')
      .insert(templateData)
      .select()
      .single();

    if (error) throw error;

    return res.status(201).json({
      success: true,
      message: 'Page template saved successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to save page template', details: error.message });
  }
}

async function updatePageTemplate(req, res) {
  try {
    const { id } = req.query;
    const { name, template_data, theme_config, custom_css, is_default, active } = req.body;

    if (!id) {
      return res.status(400).json({ error: 'Template ID is required' });
    }

    const { data: existingTemplate } = await supabase
      .from('page_templates')
      .select('page_type')
      .eq('id', id)
      .single();

    if (!existingTemplate) {
      return res.status(404).json({ error: 'Template not found' });
    }

    const updateData = {};
    if (name !== undefined) updateData.name = name;
    if (template_data !== undefined) updateData.template_data = JSON.stringify(template_data);
    if (theme_config !== undefined) updateData.theme_config = JSON.stringify(theme_config);
    if (custom_css !== undefined) updateData.custom_css = custom_css;
    if (is_default !== undefined) updateData.is_default = is_default;
    if (active !== undefined) updateData.active = active;
    
    updateData.updated_at = new Date().toISOString();

    if (is_default) {
      await supabase
        .from('page_templates')
        .update({ is_default: false })
        .eq('page_type', existingTemplate.page_type)
        .neq('id', id);
    }

    const { data, error } = await supabase
      .from('page_templates')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Page template updated successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to update page template', details: error.message });
  }
}

async function deletePageTemplate(req, res) {
  try {
    const { id } = req.query;

    if (!id) {
      return res.status(400).json({ error: 'Template ID is required' });
    }

    const { error } = await supabase
      .from('page_templates')
      .delete()
      .eq('id', id);

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Page template deleted successfully'
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to delete page template', details: error.message });
  }
}
