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
        return await getOrders(req, res);
      case 'POST':
        return await createOrder(req, res);
      case 'PUT':
        return await updateOrder(req, res);
      case 'DELETE':
        return await deleteOrder(req, res);
      default:
        res.setHeader('Allow', ['GET', 'POST', 'PUT', 'DELETE']);
        return res.status(405).json({ error: 'Method not allowed' });
    }
  } catch (error) {
    console.error('Orders API error:', error);
    return res.status(500).json({ error: 'Internal server error', details: error.message });
  }
}

async function getOrders(req, res) {
  try {
    const { archived, status, limit, offset } = req.query;
    
    let query = supabase.from('orders').select('*');

    if (archived !== undefined) {
      query = query.eq('archived', archived === 'true');
    }

    if (status) {
      query = query.eq('status', status);
    }

    query = query.order('created_at', { ascending: false });

    if (limit) {
      query = query.limit(parseInt(limit));
    }

    if (offset) {
      query = query.range(parseInt(offset), parseInt(offset) + parseInt(limit || 50) - 1);
    }

    const { data, error } = await query;

    if (error) throw error;

    return res.status(200).json({
      success: true,
      data,
      count: data?.length || 0
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to fetch orders', details: error.message });
  }
}

async function createOrder(req, res) {
  try {
    const { customer_name, service_name, notes } = req.body;

    if (!customer_name || !service_name) {
      return res.status(400).json({ error: 'Customer name and service name are required' });
    }

    const orderData = {
      customer_name,
      service_name,
      notes: notes || '',
      status: 'pending',
      archived: false
    };

    const { data, error } = await supabase
      .from('orders')
      .insert(orderData)
      .select()
      .single();

    if (error) throw error;

    return res.status(201).json({
      success: true,
      message: 'Order created successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to create order', details: error.message });
  }
}

async function updateOrder(req, res) {
  try {
    const { id } = req.query;
    const { customer_name, service_name, notes, status, archived } = req.body;

    if (!id) {
      return res.status(400).json({ error: 'Order ID is required' });
    }

    const updateData = {};
    if (customer_name !== undefined) updateData.customer_name = customer_name;
    if (service_name !== undefined) updateData.service_name = service_name;
    if (notes !== undefined) updateData.notes = notes;
    if (status !== undefined) updateData.status = status;
    if (archived !== undefined) updateData.archived = archived;
    
    updateData.updated_at = new Date().toISOString();

    const { data, error } = await supabase
      .from('orders')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Order updated successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to update order', details: error.message });
  }
}

async function deleteOrder(req, res) {
  try {
    const { id } = req.query;

    if (!id) {
      return res.status(400).json({ error: 'Order ID is required' });
    }

    const { error } = await supabase
      .from('orders')
      .delete()
      .eq('id', id);

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Order deleted successfully'
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to delete order', details: error.message });
  }
}
