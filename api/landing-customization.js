import { supabase } from './config/supabase.js';

export default async function handler(req, res) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  try {
    switch (req.method) {
      case 'GET':
        return await handleGet(req, res);
      case 'POST':
        return await handlePost(req, res);
      case 'PUT':
        return await handlePut(req, res);
      case 'DELETE':
        return await handleDelete(req, res);
      default:
        return res.status(405).json({ error: 'Method not allowed' });
    }
  } catch (error) {
    console.error('Landing customization API error:', error);
    return res.status(500).json({ 
      error: 'Internal server error',
      message: error.message 
    });
  }
}

async function handleGet(req, res) {
  const { section_name } = req.query;

  try {
    let query = supabase
      .from('landing_customization')
      .select('*')
      .eq('active', true);

    if (section_name) {
      query = query.eq('section_name', section_name);
    }

    const { data, error } = await query.order('created_at', { ascending: false });

    if (error) {
      console.error('Database error:', error);
      return res.status(500).json({ error: 'Failed to fetch customizations' });
    }

    return res.status(200).json({ customizations: data || [] });
  } catch (error) {
    console.error('Get customizations error:', error);
    return res.status(500).json({ error: 'Failed to fetch customizations' });
  }
}

async function handlePost(req, res) {
  const { section_name, content } = req.body;

  if (!section_name || !content) {
    return res.status(400).json({ error: 'Section name and content are required' });
  }

  try {
    // Check if customization already exists
    const { data: existing } = await supabase
      .from('landing_customization')
      .select('id')
      .eq('section_name', section_name)
      .eq('active', true)
      .single();

    if (existing) {
      // Update existing customization
      const { data, error } = await supabase
        .from('landing_customization')
        .update({
          content,
          updated_at: new Date().toISOString()
        })
        .eq('id', existing.id)
        .select()
        .single();

      if (error) {
        console.error('Database update error:', error);
        return res.status(500).json({ error: 'Failed to update customization' });
      }

      return res.status(200).json({ 
        message: 'Customization updated successfully',
        customization: data 
      });
    } else {
      // Create new customization
      const { data, error } = await supabase
        .from('landing_customization')
        .insert([{
          section_name,
          content,
          active: true
        }])
        .select()
        .single();

      if (error) {
        console.error('Database insert error:', error);
        return res.status(500).json({ error: 'Failed to create customization' });
      }

      return res.status(201).json({ 
        message: 'Customization created successfully',
        customization: data 
      });
    }
  } catch (error) {
    console.error('Post customization error:', error);
    return res.status(500).json({ error: 'Failed to save customization' });
  }
}

async function handlePut(req, res) {
  const { id } = req.query;
  const { section_name, content, active } = req.body;

  if (!id) {
    return res.status(400).json({ error: 'Customization ID is required' });
  }

  try {
    const updates = {
      updated_at: new Date().toISOString()
    };

    if (section_name !== undefined) updates.section_name = section_name;
    if (content !== undefined) updates.content = content;
    if (active !== undefined) updates.active = active;

    const { data, error } = await supabase
      .from('landing_customization')
      .update(updates)
      .eq('id', id)
      .select()
      .single();

    if (error) {
      console.error('Database update error:', error);
      return res.status(500).json({ error: 'Failed to update customization' });
    }

    if (!data) {
      return res.status(404).json({ error: 'Customization not found' });
    }

    return res.status(200).json({ 
      message: 'Customization updated successfully',
      customization: data 
    });
  } catch (error) {
    console.error('Put customization error:', error);
    return res.status(500).json({ error: 'Failed to update customization' });
  }
}

async function handleDelete(req, res) {
  const { id } = req.query;

  if (!id) {
    return res.status(400).json({ error: 'Customization ID is required' });
  }

  try {
    // Soft delete by setting active to false
    const { data, error } = await supabase
      .from('landing_customization')
      .update({ 
        active: false,
        updated_at: new Date().toISOString()
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      console.error('Database delete error:', error);
      return res.status(500).json({ error: 'Failed to delete customization' });
    }

    if (!data) {
      return res.status(404).json({ error: 'Customization not found' });
    }

    return res.status(200).json({ 
      message: 'Customization deleted successfully' 
    });
  } catch (error) {
    console.error('Delete customization error:', error);
    return res.status(500).json({ error: 'Failed to delete customization' });
  }
}
