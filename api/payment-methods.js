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
        return await getPaymentMethods(req, res);
      case 'POST':
        return await createPaymentMethod(req, res);
      case 'PUT':
        return await updatePaymentMethod(req, res);
      case 'DELETE':
        return await deletePaymentMethod(req, res);
      default:
        res.setHeader('Allow', ['GET', 'POST', 'PUT', 'DELETE']);
        return res.status(405).json({ error: 'Method not allowed' });
    }
  } catch (error) {
    console.error('Payment Methods API error:', error);
    return res.status(500).json({ error: 'Internal server error', details: error.message });
  }
}

async function getPaymentMethods(req, res) {
  try {
    const { active } = req.query;
    
    let query = supabase.from('payment_methods').select('*');

    if (active !== undefined) {
      query = query.eq('active', active === 'true');
    }

    query = query.order('created_at', { ascending: true });

    const { data, error } = await query;

    if (error) throw error;

    return res.status(200).json({
      success: true,
      data,
      count: data?.length || 0
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to fetch payment methods', details: error.message });
  }
}

async function createPaymentMethod(req, res) {
  try {
    const { name, details } = req.body;

    if (!name || !details) {
      return res.status(400).json({ error: 'Name and details are required' });
    }

    const paymentMethodData = {
      name,
      details,
      active: true
    };

    const { data, error } = await supabase
      .from('payment_methods')
      .insert(paymentMethodData)
      .select()
      .single();

    if (error) throw error;

    return res.status(201).json({
      success: true,
      message: 'Payment method created successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to create payment method', details: error.message });
  }
}

async function updatePaymentMethod(req, res) {
  try {
    const { id } = req.query;
    const { name, details, active } = req.body;

    if (!id) {
      return res.status(400).json({ error: 'Payment method ID is required' });
    }

    const updateData = {};
    if (name !== undefined) updateData.name = name;
    if (details !== undefined) updateData.details = details;
    if (active !== undefined) updateData.active = active;
    
    updateData.updated_at = new Date().toISOString();

    const { data, error } = await supabase
      .from('payment_methods')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Payment method updated successfully',
      data
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to update payment method', details: error.message });
  }
}

async function deletePaymentMethod(req, res) {
  try {
    const { id } = req.query;

    if (!id) {
      return res.status(400).json({ error: 'Payment method ID is required' });
    }

    const { error } = await supabase
      .from('payment_methods')
      .delete()
      .eq('id', id);

    if (error) throw error;

    return res.status(200).json({
      success: true,
      message: 'Payment method deleted successfully'
    });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to delete payment method', details: error.message });
  }
}
