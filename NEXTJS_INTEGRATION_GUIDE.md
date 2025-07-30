# 🔗 Next.js Integration Guide for walltouch.online

## 📋 Overview
Since your walltouch.online website is built with Next.js and deployed on Vercel, you'll integrate with n8n automation through API routes instead of WooCommerce webhooks.

## 🛠️ Integration Methods

### Method 1: API Routes (Recommended)
Create API routes in your Next.js project to send webhooks to n8n when orders are placed.

### Method 2: Client-Side Integration
Send webhooks directly from your frontend after successful orders.

### Method 3: Third-Party Integration
Use services like Stripe, PayPal, or other payment processors' webhooks.

## 🚀 Method 1: Next.js API Routes Integration

### Step 1: Create Webhook Utility
Create `lib/webhooks.js` in your Next.js project:

```javascript
// lib/webhooks.js
export class N8nWebhooks {
  constructor() {
    this.baseUrl = 'https://webhooks.walltouch.online/api/webhook';
  }

  async sendOrderWebhook(orderData, eventType = 'new-order') {
    try {
      const response = await fetch(`${this.baseUrl}/${eventType}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Webhook-Source': 'walltouch-nextjs',
          'X-Webhook-Event': eventType,
        },
        body: JSON.stringify({
          ...orderData,
          timestamp: new Date().toISOString(),
          source: 'walltouch.online',
          platform: 'nextjs'
        })
      });

      if (!response.ok) {
        throw new Error(`Webhook failed: ${response.status}`);
      }

      const result = await response.json();
      console.log('Webhook sent successfully:', result);
      return result;
    } catch (error) {
      console.error('Webhook error:', error);
      // Don't throw error to avoid breaking user experience
      return { success: false, error: error.message };
    }
  }

  async sendCustomerWebhook(customerData) {
    return this.sendOrderWebhook(customerData, 'new-customer');
  }

  async sendLeadWebhook(leadData) {
    return this.sendOrderWebhook(leadData, 'new-lead');
  }

  async sendOrderStatusUpdate(orderData) {
    return this.sendOrderWebhook(orderData, 'order-status-update');
  }
}

export const webhooks = new N8nWebhooks();
```

### Step 2: Create Order API Route
Create `pages/api/orders/create.js` (or `app/api/orders/create/route.js` for App Router):

```javascript
// pages/api/orders/create.js (Pages Router)
import { webhooks } from '../../../lib/webhooks';

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  try {
    const orderData = req.body;

    // Validate required fields
    if (!orderData.customer_email || !orderData.items || !orderData.total) {
      return res.status(400).json({ message: 'Missing required order data' });
    }

    // Generate order ID if not provided
    const orderId = orderData.order_id || `WT-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

    // Prepare order data for n8n
    const n8nOrderData = {
      order_id: orderId,
      customer_email: orderData.customer_email,
      customer_name: orderData.customer_name || 'Customer',
      total: parseFloat(orderData.total),
      currency: orderData.currency || 'USD',
      status: 'confirmed',
      items: orderData.items.map(item => ({
        name: item.name,
        quantity: item.quantity || 1,
        price: parseFloat(item.price),
        category: item.category || 'wallpapers',
        sku: item.sku || item.id
      })),
      shipping_address: orderData.shipping_address || {},
      billing_address: orderData.billing_address || {},
      payment_method: orderData.payment_method || 'online',
      order_date: new Date().toISOString(),
      website: 'walltouch.online'
    };

    // Send webhook to n8n
    const webhookResult = await webhooks.sendOrderWebhook(n8nOrderData);

    // Save order to your database here if needed
    // await saveOrderToDatabase(n8nOrderData);

    res.status(200).json({
      success: true,
      order_id: orderId,
      message: 'Order created successfully',
      webhook_sent: webhookResult.success !== false
    });

  } catch (error) {
    console.error('Order creation error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create order',
      error: error.message
    });
  }
}
```

### Step 3: App Router Version (if using App Router)
Create `app/api/orders/create/route.js`:

```javascript
// app/api/orders/create/route.js (App Router)
import { NextResponse } from 'next/server';
import { webhooks } from '../../../../lib/webhooks';

export async function POST(request) {
  try {
    const orderData = await request.json();

    // Validate required fields
    if (!orderData.customer_email || !orderData.items || !orderData.total) {
      return NextResponse.json(
        { message: 'Missing required order data' },
        { status: 400 }
      );
    }

    // Generate order ID
    const orderId = orderData.order_id || `WT-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

    // Prepare order data for n8n
    const n8nOrderData = {
      order_id: orderId,
      customer_email: orderData.customer_email,
      customer_name: orderData.customer_name || 'Customer',
      total: parseFloat(orderData.total),
      currency: orderData.currency || 'USD',
      status: 'confirmed',
      items: orderData.items.map(item => ({
        name: item.name,
        quantity: item.quantity || 1,
        price: parseFloat(item.price),
        category: item.category || 'wallpapers',
        sku: item.sku || item.id
      })),
      shipping_address: orderData.shipping_address || {},
      billing_address: orderData.billing_address || {},
      payment_method: orderData.payment_method || 'online',
      order_date: new Date().toISOString(),
      website: 'walltouch.online'
    };

    // Send webhook to n8n
    const webhookResult = await webhooks.sendOrderWebhook(n8nOrderData);

    return NextResponse.json({
      success: true,
      order_id: orderId,
      message: 'Order created successfully',
      webhook_sent: webhookResult.success !== false
    });

  } catch (error) {
    console.error('Order creation error:', error);
    return NextResponse.json(
      {
        success: false,
        message: 'Failed to create order',
        error: error.message
      },
      { status: 500 }
    );
  }
}
```

### Step 4: Frontend Integration
In your checkout/order completion component:

```javascript
// components/Checkout.js or pages/checkout.js
import { useState } from 'react';

export default function Checkout() {
  const [loading, setLoading] = useState(false);

  const handleOrderSubmit = async (orderData) => {
    setLoading(true);
    
    try {
      // Process payment first (Stripe, PayPal, etc.)
      const paymentResult = await processPayment(orderData);
      
      if (paymentResult.success) {
        // Send order to your API
        const response = await fetch('/api/orders/create', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            customer_email: orderData.email,
            customer_name: `${orderData.firstName} ${orderData.lastName}`,
            total: orderData.total,
            currency: 'USD',
            items: orderData.items,
            shipping_address: {
              street: orderData.address,
              city: orderData.city,
              state: orderData.state,
              zip: orderData.zip,
              country: orderData.country
            },
            billing_address: orderData.billingAddress,
            payment_method: paymentResult.payment_method,
            payment_id: paymentResult.payment_id
          })
        });

        const result = await response.json();
        
        if (result.success) {
          // Redirect to success page
          router.push(`/order-success?order_id=${result.order_id}`);
        } else {
          throw new Error(result.message);
        }
      }
    } catch (error) {
      console.error('Order submission error:', error);
      // Show error message to user
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      {/* Your checkout form */}
      <button 
        onClick={() => handleOrderSubmit(formData)}
        disabled={loading}
      >
        {loading ? 'Processing...' : 'Place Order'}
      </button>
    </div>
  );
}
```

## 🔗 Method 2: Client-Side Integration

For simpler integration, send webhooks directly from the frontend:

```javascript
// utils/orderWebhooks.js
export const sendOrderToN8n = async (orderData) => {
  try {
    const response = await fetch('https://webhooks.walltouch.online/api/webhook/new-order', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Webhook-Source': 'walltouch-frontend',
      },
      body: JSON.stringify({
        ...orderData,
        timestamp: new Date().toISOString(),
        source: 'walltouch.online'
      })
    });

    return await response.json();
  } catch (error) {
    console.error('Webhook error:', error);
    return { success: false, error: error.message };
  }
};

// In your checkout component
const handleOrderComplete = async (orderData) => {
  // Process payment first
  const paymentResult = await processPayment(orderData);
  
  if (paymentResult.success) {
    // Send to n8n automation
    await sendOrderToN8n({
      order_id: paymentResult.order_id,
      customer_email: orderData.email,
      customer_name: orderData.name,
      total: orderData.total,
      items: orderData.items,
      status: 'confirmed'
    });
    
    // Show success message
  }
};
```

## 💳 Method 3: Payment Processor Integration

### Stripe Integration
```javascript
// pages/api/stripe/webhook.js
import Stripe from 'stripe';
import { webhooks } from '../../../lib/webhooks';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).end();
  }

  const sig = req.headers['stripe-signature'];
  let event;

  try {
    event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET);
  } catch (err) {
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;
    
    // Extract order data from Stripe session
    const orderData = {
      order_id: session.metadata.order_id,
      customer_email: session.customer_details.email,
      customer_name: session.customer_details.name,
      total: session.amount_total / 100, // Convert from cents
      currency: session.currency,
      status: 'paid',
      payment_method: 'stripe',
      payment_id: session.payment_intent
    };

    // Send to n8n
    await webhooks.sendOrderWebhook(orderData);
  }

  res.json({ received: true });
}
```

## 🔧 Environment Variables

Update your Next.js environment variables:

```bash
# .env.local
NEXT_PUBLIC_N8N_WEBHOOK_URL=https://webhooks.walltouch.online/api/webhook
N8N_WEBHOOK_SECRET=your_webhook_secret

# Payment processors
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
PAYPAL_CLIENT_ID=...
PAYPAL_CLIENT_SECRET=...
```

## 🧪 Testing Your Integration

### Test Order Creation
```javascript
// Test in browser console or create a test page
const testOrder = {
  customer_email: 'test@walltouch.online',
  customer_name: 'Test Customer',
  total: 199.99,
  items: [
    {
      name: 'Premium Wallpaper Sample',
      quantity: 1,
      price: 199.99,
      category: 'wallpapers'
    }
  ],
  shipping_address: {
    street: '123 Test St',
    city: 'Test City',
    state: 'TS',
    zip: '12345'
  }
};

fetch('/api/orders/create', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(testOrder)
})
.then(res => res.json())
.then(data => console.log(data));
```

## 📊 Update Render Environment Variables

Since you're not using WooCommerce, update your Render environment variables:

```bash
# Remove WooCommerce variables:
# WOOCOMMERCE_URL
# WOOCOMMERCE_CONSUMER_KEY
# WOOCOMMERCE_CONSUMER_SECRET

# Add Next.js specific variables:
NEXTJS_SITE_URL=https://www.walltouch.online
WEBHOOK_SECRET=your_webhook_secret_key
ALLOWED_ORIGINS=https://www.walltouch.online,https://walltouch.online
```

## 🎯 Recommended Approach

For walltouch.online, I recommend:

1. **Use Method 1 (API Routes)** for better security and reliability
2. **Implement client-side fallback** for immediate user feedback
3. **Add payment processor webhooks** for payment confirmation
4. **Test thoroughly** with small orders first

This approach gives you full control over the order process while integrating seamlessly with your n8n automation system!

Would you like me to help you implement any specific part of this integration?
