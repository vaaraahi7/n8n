# 🚀 Vercel Deployment Guide for n8n Ecommerce Automation

## 🎯 Deployment Strategy

**Important Note**: n8n is a complex application that requires persistent storage and long-running processes. Vercel is primarily designed for serverless functions, so we'll use a hybrid approach:

### Recommended Architecture:
1. **Vercel**: Webhook endpoints and API proxy (subdomain)
2. **External n8n**: Railway, Render, or DigitalOcean for n8n instance
3. **Main Domain**: Your ecommerce website

## 🏗️ Option 1: Vercel + External n8n (Recommended)

### Step 1: Deploy Webhook Proxy to Vercel

```bash
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login

# Deploy the project
vercel --prod
```

### Step 2: Setup External n8n Instance

#### Option A: Railway (Easiest)
```bash
# 1. Go to railway.app
# 2. Connect your GitHub repo
# 3. Deploy with these environment variables:

N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_password
WEBHOOK_URL=https://n8n-yourproject.railway.app/
N8N_HOST=n8n-yourproject.railway.app
N8N_PORT=5678
N8N_PROTOCOL=https
DB_TYPE=sqlite
```

#### Option B: Render
```bash
# 1. Go to render.com
# 2. Create new Web Service
# 3. Connect GitHub repo
# 4. Use Docker deployment
# 5. Set environment variables
```

#### Option C: DigitalOcean App Platform
```bash
# 1. Go to DigitalOcean
# 2. Create new App
# 3. Connect GitHub repo
# 4. Configure as Docker app
```

### Step 3: Configure Domain and Subdomain

#### DNS Configuration:
```bash
# Main domain (ecommerce): yourstore.com
A record: yourstore.com → your-ecommerce-server-ip

# Subdomain (n8n): n8n.yourstore.com
CNAME: n8n.yourstore.com → n8n-yourproject.railway.app

# Webhook proxy: webhooks.yourstore.com
CNAME: webhooks.yourstore.com → your-vercel-app.vercel.app
```

## 🏗️ Option 2: Full Vercel Deployment (Advanced)

### Custom n8n Serverless Setup

```bash
# Create custom n8n serverless function
mkdir api/n8n-custom
```

**File: `api/n8n-custom/index.js`**
```javascript
// Custom n8n serverless implementation
// Note: This is complex and may have limitations
const { WorkflowRunner } = require('n8n-core');

module.exports = async (req, res) => {
  try {
    // Initialize n8n workflow runner
    const runner = new WorkflowRunner();
    
    // Execute workflow based on webhook
    const result = await runner.run(req.body);
    
    res.json({ success: true, result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
```

## 🔧 Environment Configuration

### Vercel Environment Variables

```bash
# In Vercel dashboard, add these environment variables:

# Basic Configuration
NODE_ENV=production
N8N_USER=your_username
N8N_PASSWORD=your_secure_password

# External n8n Instance
N8N_INSTANCE_URL=https://n8n-yourproject.railway.app
N8N_API_KEY=your_n8n_api_key

# Webhook Configuration
WEBHOOK_BASE_URL=https://webhooks.yourstore.com
ALLOWED_ORIGINS=https://yourstore.com,https://n8n.yourstore.com

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# Social Media APIs
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
INSTAGRAM_ACCESS_TOKEN=your_instagram_token

# Blog Platforms
WORDPRESS_URL=https://yourblog.com
WORDPRESS_USERNAME=your_wp_username
WORDPRESS_PASSWORD=your_wp_app_password
```

## 🔗 Connecting to Your Ecommerce Website

### Webhook Integration

#### For Shopify:
```bash
# In Shopify Admin → Settings → Notifications
# Add webhook URLs:

Order created: https://webhooks.yourstore.com/api/webhook/new-order
Order updated: https://webhooks.yourstore.com/api/webhook/order-status-update
Order paid: https://webhooks.yourstore.com/api/webhook/order-paid
```

#### For WooCommerce:
```php
// Add to functions.php or custom plugin
add_action('woocommerce_new_order', 'send_order_webhook');
add_action('woocommerce_order_status_changed', 'send_status_webhook');

function send_order_webhook($order_id) {
    $order = wc_get_order($order_id);
    $webhook_url = 'https://webhooks.yourstore.com/api/webhook/new-order';
    
    $data = array(
        'order_id' => $order_id,
        'customer_email' => $order->get_billing_email(),
        'total' => $order->get_total(),
        'status' => $order->get_status(),
        'items' => array()
    );
    
    foreach ($order->get_items() as $item) {
        $data['items'][] = array(
            'name' => $item->get_name(),
            'quantity' => $item->get_quantity(),
            'price' => $item->get_total()
        );
    }
    
    wp_remote_post($webhook_url, array(
        'body' => json_encode($data),
        'headers' => array('Content-Type' => 'application/json')
    ));
}
```

#### For Custom Ecommerce:
```javascript
// Add webhook calls to your order processing
const sendOrderWebhook = async (orderData) => {
  try {
    const response = await fetch('https://webhooks.yourstore.com/api/webhook/new-order', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(orderData)
    });
    
    if (!response.ok) {
      throw new Error(`Webhook failed: ${response.status}`);
    }
    
    console.log('Webhook sent successfully');
  } catch (error) {
    console.error('Webhook error:', error);
  }
};

// Call when order is created
await sendOrderWebhook({
  order_id: 'ORD-123',
  customer_email: 'customer@example.com',
  total: 99.99,
  status: 'confirmed'
});
```

## 📊 Deployment Steps

### 1. Prepare for Deployment
```bash
# Test locally first
npm run local

# Test webhook endpoints
npm run test

# Build for production
npm run build
```

### 2. Deploy to Vercel
```bash
# Deploy with environment variables
vercel --prod

# Set custom domain
vercel domains add webhooks.yourstore.com
```

### 3. Deploy n8n Instance
```bash
# Using Railway
railway login
railway link
railway up

# Or using Docker on VPS
docker-compose -f docker-compose.prod.yml up -d
```

### 4. Configure DNS
```bash
# Update DNS records
# Point subdomain to n8n instance
# Point webhook subdomain to Vercel
```

### 5. Test Integration
```bash
# Test webhook endpoints
curl -X POST https://webhooks.yourstore.com/api/webhook/new-order \
  -H "Content-Type: application/json" \
  -d '{"order_id": "TEST-001", "total": 99.99}'

# Test n8n interface
curl https://n8n.yourstore.com/healthz
```

## 🔒 Security Configuration

### SSL/TLS Setup
```bash
# Vercel automatically provides SSL
# For external n8n, ensure HTTPS is enabled
# Use environment variables for sensitive data
```

### Webhook Security
```javascript
// Add webhook signature verification
const crypto = require('crypto');

const verifyWebhook = (req, res, next) => {
  const signature = req.headers['x-webhook-signature'];
  const payload = JSON.stringify(req.body);
  const secret = process.env.WEBHOOK_SECRET;
  
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');
  
  if (signature !== expectedSignature) {
    return res.status(401).json({ error: 'Invalid signature' });
  }
  
  next();
};
```

## 📈 Monitoring and Maintenance

### Health Checks
```bash
# Setup monitoring endpoints
GET https://webhooks.yourstore.com/api/health
GET https://n8n.yourstore.com/healthz
```

### Logging
```javascript
// Add structured logging
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'error.log', level: 'error' })
  ]
});
```

## 🚨 Troubleshooting

### Common Issues:

#### Webhook Not Receiving Data
```bash
# Check Vercel function logs
vercel logs

# Verify webhook URLs in ecommerce platform
# Test with curl commands
```

#### n8n Instance Not Accessible
```bash
# Check external service status
# Verify DNS configuration
# Check SSL certificates
```

#### Environment Variables Not Loading
```bash
# Verify variables in Vercel dashboard
# Check variable names match exactly
# Restart deployment after changes
```

## 💰 Cost Estimation

### Vercel (Webhook Proxy):
- **Free tier**: 100GB bandwidth, 100 serverless functions
- **Pro tier**: $20/month for higher limits

### External n8n Hosting:
- **Railway**: $5-20/month depending on usage
- **Render**: $7-25/month for web services
- **DigitalOcean**: $5-10/month for droplets

### Total Monthly Cost: $5-45/month

This deployment strategy gives you a robust, scalable n8n automation platform that integrates seamlessly with your ecommerce website!
