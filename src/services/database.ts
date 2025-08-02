import { supabase } from '../lib/supabase';
import type { Service, PaymentMethod, SiteSettings, Order } from '../context/DataContext';
import { appState } from './stateManager';
import { PERFORMANCE_CONFIG } from '../config/performance';
import { errorHandlers } from '../utils/errorHandler';
import { errorRateLimiter } from '../utils/errorRateLimiter';
import { safeTrackEvent, trackEventCircuitBreaker } from '../utils/trackEventCircuitBreaker';

export interface DatabaseService {
  // Services
  getServices(): Promise<Service[]>;
  createService(service: Omit<Service, 'id'>): Promise<Service>;
  updateService(id: string, updates: Partial<Service>): Promise<Service>;
  deleteService(id: string): Promise<void>;

  // Payment Methods
  getPaymentMethods(): Promise<PaymentMethod[]>;
  createPaymentMethod(method: Omit<PaymentMethod, 'id'>): Promise<PaymentMethod>;
  updatePaymentMethod(id: string, updates: Partial<PaymentMethod>): Promise<PaymentMethod>;
  deletePaymentMethod(id: string): Promise<void>;

  // Site Settings
  getSiteSettings(): Promise<SiteSettings>;
  updateSiteSettings(settings: Partial<SiteSettings>): Promise<SiteSettings>;

  // Orders
  getOrders(): Promise<Order[]>;
  createOrder(order: Omit<Order, 'id' | 'timestamp'>): Promise<Order>;
  updateOrder(id: string, updates: Partial<Order>): Promise<Order>;
  deleteOrder(id: string): Promise<void>;
  archiveOrder(id: string): Promise<Order>;

  // Analytics
  trackEvent(eventType: string, metadata?: any): Promise<void>;
  getAnalytics(startDate?: Date, endDate?: Date): Promise<any>;
}

// Supabase Database Service Implementation
export class SupabaseDatabaseService implements DatabaseService {
  // Services Methods
  async getServices(): Promise<Service[]> {
    const { data, error } = await supabase
      .from('services')
      .select('*')
      .order('order_index');

    if (error) throw new Error(`Failed to fetch services: ${error.message}`);
    
    return data.map(this.mapServiceFromDB);
  }

  async createService(service: Omit<Service, 'id'>): Promise<Service> {
    const { data, error } = await supabase
      .from('services')
      .insert({
        name: service.name,
        price: service.price,
        order_index: service.order,
        active: service.active,
        description: `${service.name} service`,
        category: 'general'
      })
      .select()
      .single();

    if (error) throw new Error(`Failed to create service: ${error.message}`);
    
    return this.mapServiceFromDB(data);
  }

  async updateService(id: string, updates: Partial<Service>): Promise<Service> {
    const updateData: any = {};
    if (updates.name) updateData.name = updates.name;
    if (updates.price) updateData.price = updates.price;
    if (updates.order !== undefined) updateData.order_index = updates.order;
    if (updates.active !== undefined) updateData.active = updates.active;

    const { data, error } = await supabase
      .from('services')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw new Error(`Failed to update service: ${error.message}`);
    
    return this.mapServiceFromDB(data);
  }

  async deleteService(id: string): Promise<void> {
    const { error } = await supabase
      .from('services')
      .delete()
      .eq('id', id);

    if (error) throw new Error(`Failed to delete service: ${error.message}`);
  }

  // Payment Methods
  async getPaymentMethods(): Promise<PaymentMethod[]> {
    const { data, error } = await supabase
      .from('payment_methods')
      .select('*')
      .order('order_index');

    if (error) throw new Error(`Failed to fetch payment methods: ${error.message}`);
    
    return data.map(this.mapPaymentMethodFromDB);
  }

  async createPaymentMethod(method: Omit<PaymentMethod, 'id'>): Promise<PaymentMethod> {
    const { data, error } = await supabase
      .from('payment_methods')
      .insert({
        name: method.name,
        details: method.details,
        active: method.active,
        type: 'manual'
      })
      .select()
      .single();

    if (error) throw new Error(`Failed to create payment method: ${error.message}`);
    
    return this.mapPaymentMethodFromDB(data);
  }

  async updatePaymentMethod(id: string, updates: Partial<PaymentMethod>): Promise<PaymentMethod> {
    const { data, error } = await supabase
      .from('payment_methods')
      .update(updates)
      .eq('id', id)
      .select()
      .single();

    if (error) throw new Error(`Failed to update payment method: ${error.message}`);
    
    return this.mapPaymentMethodFromDB(data);
  }

  async deletePaymentMethod(id: string): Promise<void> {
    const { error } = await supabase
      .from('payment_methods')
      .delete()
      .eq('id', id);

    if (error) throw new Error(`Failed to delete payment method: ${error.message}`);
  }

  // Site Settings
  async getSiteSettings(): Promise<SiteSettings> {
    const { data, error } = await supabase
      .from('site_settings')
      .select('*')
      .single();

    if (error) throw new Error(`Failed to fetch site settings: ${error.message}`);
    
    return {
      title: data.title,
      description: data.description,
      orderNotice: data.order_notice,
      whatsappNumber: data.whatsapp_number
    };
  }

  async updateSiteSettings(settings: Partial<SiteSettings>): Promise<SiteSettings> {
    const updateData: any = {};
    if (settings.title) updateData.title = settings.title;
    if (settings.description) updateData.description = settings.description;
    if (settings.orderNotice) updateData.order_notice = settings.orderNotice;
    if (settings.whatsappNumber) updateData.whatsapp_number = settings.whatsappNumber;

    const { data, error } = await supabase
      .from('site_settings')
      .update(updateData)
      .select()
      .single();

    if (error) throw new Error(`Failed to update site settings: ${error.message}`);
    
    return {
      title: data.title,
      description: data.description,
      orderNotice: data.order_notice,
      whatsappNumber: data.whatsapp_number
    };
  }

  // Orders
  async getOrders(): Promise<Order[]> {
    const { data, error } = await supabase
      .from('orders')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw new Error(`Failed to fetch orders: ${error.message}`);
    
    return data.map(this.mapOrderFromDB);
  }

  async createOrder(order: Omit<Order, 'id' | 'timestamp'>): Promise<Order> {
    const { data, error } = await supabase
      .from('orders')
      .insert({
        customer_name: order.customerName,
        service_name: order.serviceName,
        notes: order.notes,
        archived: order.archived
      })
      .select()
      .single();

    if (error) throw new Error(`Failed to create order: ${error.message}`);
    
    return this.mapOrderFromDB(data);
  }

  async updateOrder(id: string, updates: Partial<Order>): Promise<Order> {
    const updateData: any = {};
    if (updates.customerName) updateData.customer_name = updates.customerName;
    if (updates.serviceName) updateData.service_name = updates.serviceName;
    if (updates.notes) updateData.notes = updates.notes;
    if (updates.archived !== undefined) updateData.archived = updates.archived;

    const { data, error } = await supabase
      .from('orders')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw new Error(`Failed to update order: ${error.message}`);
    
    return this.mapOrderFromDB(data);
  }

  async deleteOrder(id: string): Promise<void> {
    const { error } = await supabase
      .from('orders')
      .delete()
      .eq('id', id);

    if (error) throw new Error(`Failed to delete order: ${error.message}`);
  }

  async archiveOrder(id: string): Promise<Order> {
    return this.updateOrder(id, { archived: true });
  }

  // Analytics
  async trackEvent(eventType: string, metadata: any = {}): Promise<void> {
    try {
      // Validate inputs to prevent errors
      if (!eventType || typeof eventType !== 'string') {
        // Silent validation
        return;
      }

      // Ensure supabase is available and properly configured
      if (!supabase) {
        // Silent fallback
        return this.offlineTrackEvent(eventType, metadata);
      }

      // Check if Supabase is properly configured
      if (!supabase.supabaseUrl || !supabase.supabaseKey) {
        // Silent configuration check
        return this.offlineTrackEvent(eventType, metadata);
      }

      const { error } = await supabase
        .from('analytics_events')
        .insert({
          event_type: eventType,
          metadata: metadata || {},
          page_url: window.location.href,
          referrer_url: document.referrer
        });

      if (error) {
        // Add more context about the error source
        const errorContext = this.analyzeErrorContext(error);

        // Silent error handling

        // Check if it's a network error
        if (this.isNetworkError(error)) {
          return this.offlineTrackEvent(eventType, metadata);
        }

        // Check for specific database errors that should be handled gracefully
        const errorCode = this.safeGetProperty(error, 'code');
        if (errorCode === 'PGRST301' || errorCode === '42P01' || errorCode === '42703') {
          return this.offlineTrackEvent(eventType, metadata);
        }

        // Silent error handling
        this.offlineTrackEvent(eventType, metadata);
      }
    } catch (error) {
      // Check if it's a network error
      if (this.isNetworkError(error)) {
        return this.offlineTrackEvent(eventType, metadata);
      }
      // Silent error handling
      this.offlineTrackEvent(eventType, metadata);
    }
  }

  // Safely get property from object
  private safeGetProperty(obj: any, property: string): any {
    try {
      if (!obj || typeof obj !== 'object') {
        return undefined;
      }
      return obj[property];
    } catch (e) {
      return undefined;
    }
  }

  // Analyze error context to provide better insights
  private analyzeErrorContext(error: unknown): string {
    try {
      // Check if it's a network-related error
      if (this.isNetworkError(error)) {
        return 'network_error';
      }

      // Check if it's a Supabase configuration issue
      if (!supabase || !supabase.supabaseUrl) {
        return 'supabase_not_configured';
      }

      // Check if it's an empty object (common with connection issues)
      if (error && typeof error === 'object') {
        const keys = this.safeGetKeys(error);
        if (keys.length === 0) {
          return 'empty_error_object_connection_issue';
        }

        // Check for specific Supabase error patterns
        const errorCode = this.safeGetProperty(error, 'code');
        if (errorCode) {
          if (errorCode.startsWith('PGRST')) {
            return 'postgrest_api_error';
          }
          if (errorCode === '42P01') {
            return 'table_does_not_exist';
          }
          if (errorCode === '42703') {
            return 'column_does_not_exist';
          }
        }

        return 'supabase_database_error';
      }

      return 'unknown_error_type';
    } catch (e) {
      return 'error_analysis_failed';
    }
  }

  // Check if error is network-related
  private isNetworkError(error: any): boolean {
    if (!error) return false;

    try {
      const errorMessage = this.extractErrorMessage(error).toLowerCase();
      const networkErrorPatterns = [
        'failed to fetch',
        'network request failed',
        'typeerror: fetch',
        'err_network',
        'err_internet_disconnected',
        'connection refused',
        'timeout',
        'enotfound',
        'econnrefused',
        'network error',
        'fetch error'
      ];

      return networkErrorPatterns.some(pattern =>
        errorMessage.includes(pattern)
      );
    } catch (e) {
      return false;
    }
  }

  // Specific error handler for trackEvent
  private handleTrackEventError(error: unknown, eventType: string, metadata: any): void {
    try {
      // Add debugging to understand the error object better
      if (import.meta.env.DEV) {
        console.debug('🔍 trackEvent error debug:', {
          error,
          type: typeof error,
          constructor: error?.constructor?.name,
          keys: error && typeof error === 'object' ? this.safeGetKeys(error) : [],
          isError: error instanceof Error,
          isNetworkError: this.isNetworkError(error)
        });
      }

      // For network errors, use less noisy logging
      if (this.isNetworkError(error)) {
        const networkMessage = this.extractErrorMessage(error);
        console.warn('🌐 trackEvent network issue:', {
          message: networkMessage,
          eventType,
          fallback: 'stored offline'
        });
        return;
      }

      // For other errors, use full error handling with rate limiting
      const errorMessage = this.extractErrorMessage(error);
      const errorKey = errorRateLimiter.createErrorKey('track_event', errorMessage);

      if (errorRateLimiter.shouldLogError(errorKey)) {
        // Build safe error details to avoid circular references
        const errorDetails = this.buildSafeErrorDetails(error);

        console.error('🚨 trackEvent database error:', JSON.stringify({
          message: errorMessage,
          eventType,
          metadataKeys: metadata ? this.safeGetKeys(metadata) : [],
          timestamp: new Date().toISOString(),
          errorDetails
        }, null, 2));

        // Use the improved error handler
        errorHandlers.database(error, 'track_event', 'analytics_events');
      } else {
        console.debug('🔄 trackEvent error (rate limited):', errorMessage);
      }
    } catch (handlerError) {
      // If the error handler itself fails, use minimal safe logging
      const safeErrorMessage = this.extractErrorMessage(error);
      const safeHandlerMessage = this.extractErrorMessage(handlerError);

      console.error('🔧 trackEvent error (backup handler):', {
        originalError: safeErrorMessage,
        handlerError: safeHandlerMessage,
        eventType,
        timestamp: new Date().toISOString()
      });
    }
  }

  // Safely get object keys without throwing on circular references
  private safeGetKeys(obj: any): string[] {
    try {
      if (!obj || typeof obj !== 'object') {
        return [];
      }
      return Object.keys(obj);
    } catch (e) {
      return ['<enumeration-failed>'];
    }
  }

  // Build safe error details object
  private buildSafeErrorDetails(error: unknown): any {
    try {
      const details: any = {
        type: typeof error,
        constructor: 'Unknown'
      };

      if (error && typeof error === 'object') {
        const obj = error as any;

        // Safely get constructor name
        try {
          details.constructor = obj.constructor?.name || 'Object';
        } catch (e) {
          details.constructor = 'Unknown';
        }

        // Safely get keys
        details.keys = this.safeGetKeys(error);

        // Safely extract specific properties
        const safeProperties = ['name', 'code', 'status', 'statusCode'];
        safeProperties.forEach(prop => {
          try {
            const value = obj[prop];
            if (value !== undefined && value !== null) {
              details[prop] = String(value);
            }
          } catch (e) {
            // Skip this property
          }
        });

        // Extract raw message safely
        try {
          if (error instanceof Error) {
            details.rawMessage = error.message;
          } else if (obj.message) {
            details.rawMessage = String(obj.message);
          } else {
            details.rawMessage = this.extractErrorMessage(error);
          }
        } catch (e) {
          details.rawMessage = 'Message extraction failed';
        }
      } else {
        details.rawMessage = String(error);
      }

      return details;
    } catch (e) {
      return {
        type: typeof error,
        constructor: 'Unknown',
        rawMessage: 'Details extraction completely failed',
        extractionError: e instanceof Error ? e.message : String(e)
      };
    }
  }

  // Helper method to extract meaningful error messages
  private extractErrorMessage(error: unknown): string {
    try {
      // Handle standard Error objects
      if (error instanceof Error) {
        return error.message || 'Error occurred (no message)';
      }

      // Handle null/undefined
      if (error === null || error === undefined) {
        return 'Database operation failed (null/undefined error)';
      }

      // Handle string errors
      if (typeof error === 'string') {
        return error.trim() || 'Database operation failed (empty string error)';
      }

      // Handle object errors (including Supabase errors)
      if (error && typeof error === 'object') {
        const obj = error as any;

        // First, try to safely extract properties
        let message = '';
        let details = '';
        let code = '';
        let hint = '';

        // Safe property extraction to avoid circular references
        try {
          message = obj.message || '';
          details = obj.details || obj.detail || '';
          code = obj.code || obj.status || obj.statusCode || '';
          hint = obj.hint || obj.info || '';
        } catch (e) {
          // Property access failed, probably circular reference
          return 'Database error (circular reference detected)';
        }

        // Try to build meaningful message from extracted properties
        const messageParts: string[] = [];

        if (message && typeof message === 'string' && message.trim()) {
          messageParts.push(message.trim());
        }

        if (details && typeof details === 'string' && details.trim()) {
          messageParts.push(`Details: ${details.trim()}`);
        }

        if (hint && typeof hint === 'string' && hint.trim()) {
          messageParts.push(`Hint: ${hint.trim()}`);
        }

        if (code && typeof code === 'string' && code.trim()) {
          messageParts.push(`Code: ${code.trim()}`);
        }

        if (messageParts.length > 0) {
          return messageParts.join(' | ');
        }

        // Try other common error properties
        const candidates = [
          'description', 'error', 'statusText', 'reason', 'title', 'type'
        ];

        for (const candidate of candidates) {
          try {
            const value = obj[candidate];
            if (value && typeof value === 'string' && value.trim() && value !== '[object Object]') {
              return value.trim();
            }
          } catch (e) {
            // Continue to next candidate
            continue;
          }
        }

        // Try toString if it exists and is safe
        try {
          if (obj.toString && typeof obj.toString === 'function') {
            const stringified = obj.toString();
            if (stringified &&
                stringified !== '[object Object]' &&
                stringified !== 'undefined' &&
                stringified !== 'null' &&
                stringified.trim()) {
              return stringified.trim();
            }
          }
        } catch (e) {
          // toString failed
        }

        // Try to enumerate and describe the object safely
        try {
          const keys = Object.keys(obj);
          const constructorName = obj.constructor?.name || 'Unknown';

          if (keys.length > 0) {
            // Limit to first few keys to avoid huge messages
            const limitedKeys = keys.slice(0, 5);
            const keysStr = limitedKeys.join(', ') + (keys.length > 5 ? '...' : '');
            return `Database error (type: ${constructorName}, properties: [${keysStr}])`;
          } else {
            // Handle completely empty objects with more specific messages
            if (constructorName === 'Object') {
              // Try to provide context-aware error messages
              if (!supabase || !supabase.supabaseUrl) {
                return 'Supabase client not properly configured - check environment variables';
              }
              return 'Database connection failed - server returned empty response (check network and Supabase status)';
            } else {
              return `Database operation failed (empty ${constructorName} response - possible API timeout)`;
            }
          }
        } catch (e) {
          return 'Database operation failed (object enumeration error)';
        }
      }

      // Handle other primitive types
      if (typeof error === 'number') {
        return `Database error code: ${error}`;
      }

      if (typeof error === 'boolean') {
        return `Database operation failed (boolean: ${error})`;
      }

      // Final fallback for any other type
      try {
        const errorString = String(error);
        if (errorString &&
            errorString !== '[object Object]' &&
            errorString !== 'undefined' &&
            errorString !== 'null' &&
            errorString.trim()) {
          return errorString.trim();
        }
      } catch (e) {
        // String conversion failed
      }

      // Ultimate fallback
      return `Database operation failed (unknown error type: ${typeof error})`;

    } catch (extractionError) {
      // Error in error extraction itself
      return `Database operation failed (error extraction failed: ${extractionError instanceof Error ? extractionError.message : 'unknown'})`;
    }
  }

  // Offline trackEvent fallback
  private offlineTrackEvent(eventType: string, metadata: any): void {
    try {
      const events = JSON.parse(localStorage.getItem('pending_analytics') || '[]');
      events.push({
        id: Date.now().toString(),
        event_type: eventType,
        metadata: metadata || {},
        page_url: window.location.href,
        referrer_url: document.referrer,
        created_at: new Date().toISOString(),
        offline: true,
        retry_count: 0
      });

      // Keep only last 100 offline events to prevent storage bloat
      if (events.length > 100) {
        events.splice(0, events.length - 100);
      }

      localStorage.setItem('pending_analytics', JSON.stringify(events));
      console.log(`📱 Stored trackEvent offline: ${eventType}`);
    } catch (error) {
      console.warn('🔧 Failed to store analytics offline:', error);
    }
  }

  async getAnalytics(startDate?: Date, endDate?: Date): Promise<any> {
    let query = supabase
      .from('analytics_events')
      .select('*');

    if (startDate) {
      query = query.gte('created_at', startDate.toISOString());
    }
    if (endDate) {
      query = query.lte('created_at', endDate.toISOString());
    }

    const { data, error } = await query.order('created_at', { ascending: false });

    if (error) throw new Error(`Failed to fetch analytics: ${error.message}`);
    
    return data;
  }

  // Helper mapping functions
  private mapServiceFromDB(data: any): Service {
    return {
      id: data.id,
      name: data.name,
      price: data.price,
      order: data.order_index || 0,
      active: data.active ?? true
    };
  }

  private mapPaymentMethodFromDB(data: any): PaymentMethod {
    return {
      id: data.id,
      name: data.name,
      details: data.details,
      active: data.active ?? true
    };
  }

  private mapOrderFromDB(data: any): Order {
    return {
      id: data.id,
      customerName: data.customer_name,
      serviceName: data.service_name,
      notes: data.notes || '',
      timestamp: new Date(data.created_at),
      archived: data.archived ?? false
    };
  }
}

// Fallback LocalStorage Service
export class LocalStorageDatabaseService implements DatabaseService {
  private getStorageKey(key: string): string {
    return `kyctrust_${key}`;
  }

  private getFromStorage<T>(key: string, defaultValue: T): T {
    try {
      const item = localStorage.getItem(this.getStorageKey(key));
      return item ? JSON.parse(item) : defaultValue;
    } catch {
      return defaultValue;
    }
  }

  private setToStorage<T>(key: string, value: T): void {
    localStorage.setItem(this.getStorageKey(key), JSON.stringify(value));
  }

  async getServices(): Promise<Service[]> {
    return this.getFromStorage('services', []);
  }

  async createService(service: Omit<Service, 'id'>): Promise<Service> {
    const services = await this.getServices();
    const newService: Service = { ...service, id: Date.now().toString() };
    services.push(newService);
    this.setToStorage('services', services);
    return newService;
  }

  async updateService(id: string, updates: Partial<Service>): Promise<Service> {
    const services = await this.getServices();
    const index = services.findIndex(s => s.id === id);
    if (index === -1) throw new Error('Service not found');
    
    services[index] = { ...services[index], ...updates };
    this.setToStorage('services', services);
    return services[index];
  }

  async deleteService(id: string): Promise<void> {
    const services = await this.getServices();
    const filtered = services.filter(s => s.id !== id);
    this.setToStorage('services', filtered);
  }

  async getPaymentMethods(): Promise<PaymentMethod[]> {
    return this.getFromStorage('paymentMethods', []);
  }

  async createPaymentMethod(method: Omit<PaymentMethod, 'id'>): Promise<PaymentMethod> {
    const methods = await this.getPaymentMethods();
    const newMethod: PaymentMethod = { ...method, id: Date.now().toString() };
    methods.push(newMethod);
    this.setToStorage('paymentMethods', methods);
    return newMethod;
  }

  async updatePaymentMethod(id: string, updates: Partial<PaymentMethod>): Promise<PaymentMethod> {
    const methods = await this.getPaymentMethods();
    const index = methods.findIndex(m => m.id === id);
    if (index === -1) throw new Error('Payment method not found');
    
    methods[index] = { ...methods[index], ...updates };
    this.setToStorage('paymentMethods', methods);
    return methods[index];
  }

  async deletePaymentMethod(id: string): Promise<void> {
    const methods = await this.getPaymentMethods();
    const filtered = methods.filter(m => m.id !== id);
    this.setToStorage('paymentMethods', filtered);
  }

  async getSiteSettings(): Promise<SiteSettings> {
    return this.getFromStorage('siteSettings', {
      title: 'KYCtrust',
      description: 'Digital Financial Services',
      orderNotice: 'We will contact you via WhatsApp',
      whatsappNumber: '+201062453344'
    });
  }

  async updateSiteSettings(settings: Partial<SiteSettings>): Promise<SiteSettings> {
    const current = await this.getSiteSettings();
    const updated = { ...current, ...settings };
    this.setToStorage('siteSettings', updated);
    return updated;
  }

  async getOrders(): Promise<Order[]> {
    const orders = this.getFromStorage('orders', []);
    return orders.map((order: any) => ({
      ...order,
      timestamp: new Date(order.timestamp)
    }));
  }

  async createOrder(order: Omit<Order, 'id' | 'timestamp'>): Promise<Order> {
    const orders = await this.getOrders();
    const newOrder: Order = {
      ...order,
      id: Date.now().toString(),
      timestamp: new Date()
    };
    orders.push(newOrder);
    this.setToStorage('orders', orders);
    return newOrder;
  }

  async updateOrder(id: string, updates: Partial<Order>): Promise<Order> {
    const orders = await this.getOrders();
    const index = orders.findIndex(o => o.id === id);
    if (index === -1) throw new Error('Order not found');
    
    orders[index] = { ...orders[index], ...updates };
    this.setToStorage('orders', orders);
    return orders[index];
  }

  async deleteOrder(id: string): Promise<void> {
    const orders = await this.getOrders();
    const filtered = orders.filter(o => o.id !== id);
    this.setToStorage('orders', filtered);
  }

  async archiveOrder(id: string): Promise<Order> {
    return this.updateOrder(id, { archived: true });
  }

  async trackEvent(eventType: string, metadata: any = {}): Promise<void> {
    try {
      // Validate inputs
      if (!eventType || typeof eventType !== 'string') {
        console.warn('🔧 Offline trackEvent: Invalid eventType provided:', eventType);
        return;
      }

      // Store events locally for potential sync later
      const events = this.getFromStorage('analytics_events', []);
      events.push({
        id: Date.now().toString(),
        event_type: eventType,
        metadata: metadata || {},
        created_at: new Date().toISOString(),
        offline: true
      });
      this.setToStorage('analytics_events', events);
    } catch (error) {
      // Use safe error logging for offline mode
      console.error('🔧 Offline trackEvent error:', {
        message: error instanceof Error ? error.message : String(error),
        eventType,
        timestamp: new Date().toISOString()
      });
    }
  }

  async getAnalytics(startDate?: Date, endDate?: Date): Promise<any> {
    const events = this.getFromStorage('analytics_events', []);
    return events.filter((event: any) => {
      const eventDate = new Date(event.created_at);
      if (startDate && eventDate < startDate) return false;
      if (endDate && eventDate > endDate) return false;
      return true;
    });
  }
}

// Database Factory
export function createDatabaseService(): DatabaseService {
  // Check if Supabase is configured
  if (supabase && supabase.supabaseUrl && supabase.supabaseKey) {
    return new SupabaseDatabaseService();
  } else {
    console.warn('Supabase not configured, falling back to localStorage');
    return new LocalStorageDatabaseService();
  }
}

// Default export
export const databaseService = createDatabaseService();
