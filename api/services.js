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
        return await getServices(req, res);
      case 'POST':
        return await createService(req, res);
      case 'PUT':
        return await updateService(req, res);
      case 'DELETE':
        return await deleteService(req, res);
      default:
        res.setHeader('Allow', ['GET', 'POST', 'PUT', 'DELETE']);
        return res.status(405).json({ error: 'Method not allowed' });
    }
  } catch (error) {
    console.error('Services API error:', error);
    return res.status(500).json({ error: 'Internal server error', details: error.message });
  }
}

async function getServices(req, res) {
  try {
    const { data, error } = await supabase
      .from('services')
      .select('*')
      .eq('active', true)
      .order('order_index', { ascending: true });

    if (error) throw error;

    return res.status(200).json({
      success: true,
      data,
      count: data?.length || 0
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to fetch services', details: error.message });
  }
}

async function createService(req, res) {
  try {
    const { name, price, description, order_index } = req.body;

    if (!name || !price) {
      return res.status(400).json({ error: 'Name and price are required' });
    }

    const serviceData = {
      name,
      price,
      description: description || '',
      order_index: order_index || 0,
      active: true
    };

    const { data, error } = await supabase
      .from('services')
      .insert(serviceData)
      .select()
      .single();

    if (error) throw error;

    return res.status(201).json({
      success: true,
      message: 'Service created successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to create service', details: error.message });
  }
}

async function updateService(req, res) {
  try {
    const { id } = req.query;
    const { name, price, description, order_index, active } = req.body;

    if (!id) {
      return res.status(400).json({ error: 'Service ID is required' });
    }

    const updateData = {};
    if (name !== undefined) updateData.name = name;
    if (price !== undefined) updateData.price = price;
    if (description !== undefined) updateData.description = description;
    if (order_index !== undefined) updateData.order_index = order_index;
    if (active !== undefined) updateData.active = active;
    
    updateData.updated_at = new Date().toISOString();

    const { data, error } = await supabase
      .from('services')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Service updated successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to update service', details: error.message });
  }
}

async function deleteService(req, res) {
  try {
    const { id } = req.query;

    if (!id) {
      return res.status(400).json({ error: 'Service ID is required' });
    }

    const { error } = await supabase
      .from('services')
      .delete()
      .eq('id', id);

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Service deleted successfully'
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to delete service', details: error.message });
  }
}
