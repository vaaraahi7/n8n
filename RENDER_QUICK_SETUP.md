# ⚡ Render Quick Setup for walltouch.online

## 🚀 Step-by-Step Render Deployment

### Step 1: Prepare Repository
```bash
# Ensure all files are committed
git add .
git commit -m "Configure for Render deployment"
git push origin main
```

### Step 2: Create Render Web Service
1. **Go to [render.com](https://render.com/dashboard)**
2. **Click "New +" → "Web Service"**
3. **Connect GitHub repository**
4. **Configure service:**

```bash
# Service Settings:
Name: n8n-walltouch-automation
Environment: Docker
Region: Oregon (US West)
Branch: main
Root Directory: (leave empty)
Build Command: (leave empty)
Start Command: (leave empty)
```

### Step 3: Add Environment Variables
**In Render dashboard → Environment tab, add these variables:**

#### Essential Variables (Required):
```bash
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=WallTouch2024!Secure
N8N_HOST=n8n.walltouch.online
WEBHOOK_URL=https://n8n.walltouch.online/
N8N_PORT=5678
N8N_PROTOCOL=https
DB_TYPE=sqlite
DB_SQLITE_DATABASE=/opt/render/project/src/data/database.sqlite
N8N_SECURE_COOKIE=true
N8N_JWT_AUTH_ACTIVE=true
EXECUTIONS_PROCESS=main
EXECUTIONS_MODE=regular
N8N_METRICS=false
GENERIC_TIMEZONE=UTC
```

#### Email Configuration (Gmail):
```bash
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=vaaraahicreations@gmail.com
SMTP_PASS=Vedic@1212
SMTP_SENDER=vaaraahicreations@gmail.com
```

#### Ecommerce Integration:
```bash
# Add these to Render:
NEXTJS_SITE_URL=https://www.walltouch.online
WEBHOOK_SECRET=your_webhook_secret_key
ALLOWED_ORIGINS=https://www.walltouch.online,https://walltouch.online
```

#### Social Media (Optional - Add Later):
```bash
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
FACEBOOK_ACCESS_TOKEN=your_facebook_access_token
FACEBOOK_PAGE_ID=your_facebook_page_id
INSTAGRAM_ACCESS_TOKEN=your_instagram_access_token
INSTAGRAM_ACCOUNT_ID=your_instagram_account_id
```

### Step 4: Deploy Service
```bash
# After adding environment variables:
1. Click "Create Web Service"
2. Render starts building automatically
3. Wait 5-10 minutes for deployment
4. Check "Logs" tab for any errors
```

### Step 5: Configure Custom Domain
```bash
# In Render dashboard:
1. Go to Settings → Custom Domains
2. Click "Add Custom Domain"
3. Enter: n8n.walltouch.online
4. Note the CNAME record provided
```

## ☁️ Vercel Deployment (Webhook Proxy)

### Step 1: Deploy to Vercel
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel login
vercel --prod
```

### Step 2: Configure Vercel Environment Variables
```bash
vercel env add N8N_INSTANCE_URL production
# Enter: https://n8n.walltouch.online

vercel env add WEBHOOK_BASE_URL production
# Enter: https://webhooks.walltouch.online

vercel env add NODE_ENV production
# Enter: production

vercel env add ALLOWED_ORIGINS production
# Enter: https://www.walltouch.online,https://n8n.walltouch.online

# Redeploy
vercel --prod
```

### Step 3: Add Custom Domain to Vercel
```bash
# In Vercel dashboard:
1. Go to Project → Settings → Domains
2. Add: webhooks.walltouch.online
3. Note the DNS configuration
```

## 🌐 DNS Configuration

### Add These DNS Records:
```bash
# In your domain provider (GoDaddy, Namecheap, etc.):

# For n8n (Render)
Type: CNAME
Name: n8n
Value: [your-render-service].onrender.com

# For webhooks (Vercel)
Type: CNAME
Name: webhooks
Value: cname.vercel-dns.com
```

## 🧪 Testing Your Deployment

### Test 1: Check n8n Platform
```bash
# Test health endpoint
curl https://n8n.walltouch.online/healthz

# Expected response: {"status":"ok"}
```

### Test 2: Check Webhook Proxy
```bash
# Test webhook endpoint
curl https://webhooks.walltouch.online/api/health

# Expected response: {"status":"healthy"}
```

### Test 3: Test Order Webhook
```bash
curl -X POST https://webhooks.walltouch.online/api/webhook/new-order \
  -H "Content-Type: application/json" \
  -d '{
    "order_id": "WALLTOUCH-TEST-001",
    "customer_email": "test@walltouch.online",
    "customer_name": "Test Customer",
    "total": 199.99,
    "status": "confirmed",
    "items": [
      {
        "name": "Premium Wallpaper Sample Pack",
        "quantity": 1,
        "price": 199.99,
        "category": "wallpapers"
      }
    ]
  }'

# Expected response: {"success":true}
```

## 📊 Import Workflows

### Step 1: Access n8n
1. **Go to**: https://n8n.walltouch.online
2. **Login**: admin / WallTouch2024!Secure
3. **Should see**: n8n dashboard

### Step 2: Import Essential Workflows
```bash
# Import in this order (free plan - max 2 active):
1. workflows/invoice-communication.json
2. workflows/sales-automation.json

# Save others for later when you upgrade
```

### Step 3: Configure Credentials
```bash
# In each workflow, set up:
1. Gmail SMTP credentials
2. WooCommerce API credentials
3. Any social media credentials you have

# Test each workflow before activating
```

## 🔗 Connect Your Ecommerce Site

### For WooCommerce:
Add this to your `functions.php`:

```php
// Webhook for new orders
add_action('woocommerce_new_order', 'send_walltouch_order_webhook');

function send_walltouch_order_webhook($order_id) {
    $order = wc_get_order($order_id);
    $webhook_url = 'https://webhooks.walltouch.online/api/webhook/new-order';
    
    $data = array(
        'order_id' => $order_id,
        'customer_email' => $order->get_billing_email(),
        'customer_name' => $order->get_billing_first_name() . ' ' . $order->get_billing_last_name(),
        'total' => floatval($order->get_total()),
        'status' => $order->get_status(),
        'items' => array()
    );
    
    foreach ($order->get_items() as $item) {
        $data['items'][] = array(
            'name' => $item->get_name(),
            'quantity' => $item->get_quantity(),
            'price' => floatval($item->get_total()),
            'category' => 'wallpapers'
        );
    }
    
    wp_remote_post($webhook_url, array(
        'body' => json_encode($data),
        'headers' => array('Content-Type' => 'application/json')
    ));
}
```

## 🚨 Troubleshooting

### Render Service Not Starting:
```bash
# Check Render logs:
1. Go to Render dashboard
2. Click your service
3. Check "Logs" tab

# Common issues:
- Environment variables missing
- Database path incorrect
- Port not exposed correctly
```

### Domain Not Working:
```bash
# Check DNS propagation:
nslookup n8n.walltouch.online

# Wait up to 24 hours for DNS propagation
# Verify CNAME records are correct
```

### n8n Not Accessible:
```bash
# Check if service is running:
curl https://[your-render-url].onrender.com/healthz

# If working, issue is with custom domain
# If not working, check environment variables
```

## ✅ Quick Checklist

### Render Setup:
- [ ] Web service created
- [ ] Environment variables added
- [ ] Service deployed successfully
- [ ] Custom domain configured
- [ ] Health check passing

### Vercel Setup:
- [ ] Project deployed
- [ ] Environment variables set
- [ ] Custom domain added
- [ ] Webhook endpoints working

### DNS Setup:
- [ ] CNAME records added
- [ ] DNS propagation complete
- [ ] Both domains resolving

### n8n Setup:
- [ ] Can access n8n interface
- [ ] Workflows imported
- [ ] Credentials configured
- [ ] Workflows activated

### Integration:
- [ ] Webhook code added to ecommerce site
- [ ] Test order processed successfully
- [ ] Email notifications working

## 🎉 Success!

Your walltouch.online automation platform is now live at:
- **n8n Interface**: https://n8n.walltouch.online
- **Webhook Endpoint**: https://webhooks.walltouch.online

## 💡 Next Steps:
1. **Test with real order** from walltouch.online
2. **Monitor execution usage** in n8n dashboard
3. **Add more workflows** as needed
4. **Upgrade plans** when ready to scale

## 🔄 Render Free Plan Notes:
- **750 hours/month** (about 25 days)
- **Service sleeps** after 15 minutes of inactivity
- **30-60 second** wake-up time for first request
- **Perfect for testing** and low-volume production

Your automation system is ready to handle orders, send emails, and manage your walltouch.online business!
