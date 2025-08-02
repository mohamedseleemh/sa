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
        return await getThemes(req, res);
      case 'POST':
        return await saveTheme(req, res);
      case 'PUT':
        return await updateTheme(req, res);
      case 'DELETE':
        return await deleteTheme(req, res);
      default:
        res.setHeader('Allow', ['GET', 'POST', 'PUT', 'DELETE']);
        return res.status(405).json({ error: 'Method not allowed' });
    }
  } catch (error) {
    console.error('Themes API error:', error);
    return res.status(500).json({ error: 'Internal server error', details: error.message });
  }
}

async function getThemes(req, res) {
  try {
    const { active, is_default } = req.query;
    
    let query = supabase.from('themes').select('*');

    if (active !== undefined) {
      query = query.eq('active', active === 'true');
    }

    if (is_default !== undefined) {
      query = query.eq('is_default', is_default === 'true');
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
    return res.status(500).json({ error: 'Failed to fetch themes', details: error.message });
  }
}

async function saveTheme(req, res) {
  try {
    const { name, theme_config, preview_image, is_default } = req.body;

    if (!name || !theme_config) {
      return res.status(400).json({ error: 'Name and theme config are required' });
    }

    const themeData = {
      name,
      theme_config: JSON.stringify(theme_config),
      preview_image: preview_image || '',
      is_default: is_default || false,
      active: true
    };

    if (is_default) {
      await supabase
        .from('themes')
        .update({ is_default: false });
    }

    const { data, error } = await supabase
      .from('themes')
      .insert(themeData)
      .select()
      .single();

    if (error) throw error;

    return res.status(201).json({
      success: true,
      message: 'Theme saved successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to save theme', details: error.message });
  }
}

async function updateTheme(req, res) {
  try {
    const { id } = req.query;
    const { name, theme_config, preview_image, is_default, active } = req.body;

    if (!id) {
      return res.status(400).json({ error: 'Theme ID is required' });
    }

    const updateData = {};
    if (name !== undefined) updateData.name = name;
    if (theme_config !== undefined) updateData.theme_config = JSON.stringify(theme_config);
    if (preview_image !== undefined) updateData.preview_image = preview_image;
    if (is_default !== undefined) updateData.is_default = is_default;
    if (active !== undefined) updateData.active = active;
    
    updateData.updated_at = new Date().toISOString();

    if (is_default) {
      await supabase
        .from('themes')
        .update({ is_default: false })
        .neq('id', id);
    }

    const { data, error } = await supabase
      .from('themes')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Theme updated successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to update theme', details: error.message });
  }
}

async function deleteTheme(req, res) {
  try {
    const { id } = req.query;

    if (!id) {
      return res.status(400).json({ error: 'Theme ID is required' });
    }

    const { data: theme } = await supabase
      .from('themes')
      .select('is_default')
      .eq('id', id)
      .single();

    if (theme?.is_default) {
      return res.status(400).json({ error: 'Cannot delete the default theme' });
    }

    const { error } = await supabase
      .from('themes')
      .delete()
      .eq('id', id);

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Theme deleted successfully'
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to delete theme', details: error.message });
  }
}
