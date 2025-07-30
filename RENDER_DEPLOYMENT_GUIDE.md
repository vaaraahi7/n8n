# 🚀 Render Deployment Guide for walltouch.online

## 📋 Overview
- **Render**: Host n8n automation platform (n8n.walltouch.online)
- **Vercel**: Host webhook proxy (webhooks.walltouch.online)
- **Main Site**: Your ecommerce website (www.walltouch.online)

## 🎯 Render Free Plan Benefits
- ✅ **750 hours/month** free compute time
- ✅ **Automatic SSL** certificates
- ✅ **Custom domains** supported
- ✅ **GitHub integration** for auto-deploy
- ✅ **Environment variables** management
- ✅ **Persistent storage** for SQLite database

## 🔧 Part 1: Render Setup (n8n Platform)

### Step 1: Prepare Your Repository
```bash
# Ensure your repository has these files:
# ✅ Dockerfile (already created)
# ✅ .env.production (already configured)
# ✅ workflows/ directory
# ✅ package.json

# Commit and push to GitHub
git add .
git commit -m "Configure for Render deployment"
git push origin main
```

### Step 2: Create Render Web Service
1. **Go to [render.com](https://render.com)**
2. **Click "New +" → "Web Service"**
3. **Connect GitHub repository**
   - Select your n8n repository
   - Click "Connect"

### Step 3: Configure Render Service
```bash
# Service Configuration:
Name: n8n-walltouch-automation
Environment: Docker
Region: Oregon (US West) or Frankfurt (Europe)
Branch: main
Root Directory: . (leave empty)

# Build & Deploy:
Docker Command: (leave empty - uses Dockerfile)
```

### Step 4: Configure Environment Variables
In Render dashboard, add these environment variables:

```bash
# Basic n8n Configuration
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your_secure_password_here

# Domain Configuration  
N8N_HOST=n8n.walltouch.online
WEBHOOK_URL=https://n8n.walltouch.online/
N8N_PORT=5678
N8N_PROTOCOL=https

# Database Configuration
DB_TYPE=sqlite
DB_SQLITE_DATABASE=/opt/render/project/src/data/database.sqlite

# Security & Performance
N8N_SECURE_COOKIE=true
N8N_JWT_AUTH_ACTIVE=true
EXECUTIONS_PROCESS=main
EXECUTIONS_MODE=regular
N8N_METRICS=false
GENERIC_TIMEZONE=UTC

# Email Configuration (Gmail)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-gmail-app-password
SMTP_SENDER=your-email@gmail.com

# Social Media APIs (add your keys)
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
FACEBOOK_ACCESS_TOKEN=your_facebook_access_token
FACEBOOK_PAGE_ID=your_facebook_page_id

INSTAGRAM_ACCESS_TOKEN=your_instagram_access_token
INSTAGRAM_ACCOUNT_ID=your_instagram_account_id

# Google APIs
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
GOOGLE_API_KEY=your_google_api_key

# Blog Platforms
WORDPRESS_URL=https://yourblog.com
WORDPRESS_USERNAME=your_wp_username
WORDPRESS_PASSWORD=your_wp_app_password

# Ecommerce Integration
SHOPIFY_SHOP_NAME=your-shop-name
SHOPIFY_ACCESS_TOKEN=your_shopify_token
WOOCOMMERCE_URL=https://www.walltouch.online
WOOCOMMERCE_CONSUMER_KEY=your_woocommerce_key
WOOCOMMERCE_CONSUMER_SECRET=your_woocommerce_secret
```

### Step 5: Deploy on Render
```bash
# After configuring environment variables:
1. Click "Create Web Service"
2. Render will automatically start building
3. Wait for deployment (usually 5-10 minutes)
4. Check logs for any errors
```

### Step 6: Configure Custom Domain on Render
```bash
# In Render dashboard:
1. Go to your service → Settings
2. Scroll to "Custom Domains"
3. Click "Add Custom Domain"
4. Enter: n8n.walltouch.online
5. Render will provide CNAME record details
```

## ☁️ Part 2: Vercel Deployment (Webhook Proxy)

### Step 1: Deploy to Vercel
```bash
# Install Vercel CLI (if not already installed)
npm install -g vercel

# Login and deploy
vercel login
vercel --prod

# Follow prompts:
# Project name: n8n-walltouch-webhooks
# Directory: ./
```

### Step 2: Configure Vercel Environment Variables
```bash
# Set environment variables for Vercel
vercel env add N8N_INSTANCE_URL production
# Enter: https://n8n.walltouch.online

vercel env add WEBHOOK_BASE_URL production
# Enter: https://webhooks.walltouch.online

vercel env add NODE_ENV production
# Enter: production

vercel env add ALLOWED_ORIGINS production
# Enter: https://www.walltouch.online,https://n8n.walltouch.online

# Redeploy after setting variables
vercel --prod
```

### Step 3: Configure Custom Domain on Vercel
```bash
# In Vercel dashboard:
1. Go to your project → Settings → Domains
2. Add custom domain: webhooks.walltouch.online
3. Vercel will provide DNS configuration
```

## 🌐 Part 3: DNS Configuration

### Configure DNS Records in your domain provider:

```bash
# For walltouch.online domain, add these CNAME records:

# n8n subdomain (Render)
Type: CNAME
Name: n8n
Value: [your-render-service].onrender.com

# Webhooks subdomain (Vercel)
Type: CNAME
Name: webhooks  
Value: cname.vercel-dns.com
```

### DNS Configuration Steps:
1. **Login to your domain registrar** (GoDaddy, Namecheap, Cloudflare, etc.)
2. **Go to DNS Management**
3. **Add the CNAME records above**
4. **Wait 5-30 minutes** for DNS propagation
5. **Test with**: `nslookup n8n.walltouch.online`

## 🧪 Part 4: Testing Deployment

### Step 1: Test Render n8n Platform
```bash
# Test n8n health endpoint
curl https://n8n.walltouch.online/healthz

# Test n8n login page
curl -I https://n8n.walltouch.online

# Should return 200 OK with basic auth prompt
```

### Step 2: Test Vercel Webhook Proxy
```bash
# Test webhook health
curl https://webhooks.walltouch.online/api/health

# Test webhook endpoint
curl -X POST https://webhooks.walltouch.online/api/webhook/new-order \
  -H "Content-Type: application/json" \
  -d '{
    "order_id": "TEST-001",
    "customer_email": "test@walltouch.online",
    "total": 99.99,
    "status": "confirmed"
  }'
```

### Step 3: Test Full Integration
```bash
# Test complete order webhook
curl -X POST https://webhooks.walltouch.online/api/webhook/new-order \
  -H "Content-Type: application/json" \
  -d '{
    "order_id": "WALLTOUCH-001",
    "customer_email": "customer@example.com",
    "customer_name": "Test Customer",
    "total": 299.99,
    "currency": "USD",
    "status": "confirmed",
    "items": [
      {
        "name": "Premium Wallpaper Collection",
        "quantity": 3,
        "price": 89.99,
        "category": "wallpapers"
      },
      {
        "name": "Wall Touch Samples",
        "quantity": 1,
        "price": 29.99,
        "category": "samples"
      }
    ],
    "shipping_address": {
      "street": "123 Design Street",
      "city": "New York",
      "state": "NY",
      "zip": "10001",
      "country": "US"
    }
  }'
```

## 📊 Part 5: Import and Configure Workflows

### Step 1: Access n8n Interface
1. **Go to**: `https://n8n.walltouch.online`
2. **Login with**: admin / your_password
3. **You should see**: n8n dashboard

### Step 2: Import Workflows (Priority Order)
```bash
# Import these workflows in order:
1. workflows/invoice-communication.json (PRIORITY 1)
2. workflows/sales-automation.json (PRIORITY 2)

# For free plan, start with just these 2 workflows
# Add more later when you upgrade or optimize execution usage
```

### Step 3: Configure Workflow Credentials
```bash
# In each workflow, configure:
1. Gmail SMTP credentials
2. Social media API keys  
3. Ecommerce platform credentials
4. Blog platform credentials

# Test each workflow individually before activating
```

### Step 4: Activate Workflows
```bash
# Activate workflows by toggling the switch
# Start with:
1. Invoice & Communication (essential for orders)
2. Sales Automation (essential for reporting)

# Monitor execution count in n8n dashboard
```

## 🔗 Part 6: Connect to Your Ecommerce Website

### Update Webhook URLs in Your Platform:

#### For Shopify:
```bash
# Go to: Shopify Admin → Settings → Notifications → Webhooks
Order created: https://webhooks.walltouch.online/api/webhook/new-order
Order updated: https://webhooks.walltouch.online/api/webhook/order-status-update
Order paid: https://webhooks.walltouch.online/api/webhook/order-paid
Customer created: https://webhooks.walltouch.online/api/webhook/new-customer
```

#### For WooCommerce:
```php
// Update webhook URL in functions.php:
$webhook_url = 'https://webhooks.walltouch.online/api/webhook/new-order';
```

#### For Custom Platform:
```javascript
// Update webhook URLs in your code:
const webhookUrl = 'https://webhooks.walltouch.online/api/webhook/new-order';
```

## 🚨 Part 7: Troubleshooting

### Common Render Issues:

#### Build Failures:
```bash
# Check Render build logs:
1. Go to Render dashboard
2. Click on your service
3. Go to "Logs" tab
4. Look for build errors

# Common fixes:
- Verify Dockerfile syntax
- Check if all files are committed to GitHub
- Ensure environment variables are set correctly
```

#### Service Not Starting:
```bash
# Check Render service logs:
1. Look for startup errors in logs
2. Verify port 5678 is exposed
3. Check environment variables
4. Ensure database directory permissions

# Common fixes:
- Update Dockerfile USER permissions
- Verify N8N_PORT=5678
- Check database path in environment
```

#### Domain Not Working:
```bash
# Check DNS configuration:
nslookup n8n.walltouch.online

# Verify CNAME record:
dig n8n.walltouch.online CNAME

# Common fixes:
- Wait longer for DNS propagation (up to 24 hours)
- Verify CNAME record syntax
- Check domain registrar settings
```

### Render Free Plan Limitations:
```bash
# Free Plan Limits:
- 750 hours/month (about 25 days)
- Service sleeps after 15 minutes of inactivity
- 512 MB RAM
- Shared CPU

# Optimization Tips:
- Service will sleep when not used (normal behavior)
- First request after sleep takes 30-60 seconds
- Consider upgrading to paid plan for 24/7 uptime
```

## ✅ Part 8: Deployment Checklist

### Pre-Deployment:
- [ ] GitHub repository ready with all files
- [ ] Render account created and verified
- [ ] Domain DNS access available
- [ ] API keys and credentials ready

### Render Deployment:
- [ ] Web service created on Render
- [ ] Environment variables configured
- [ ] Service deployed successfully
- [ ] Custom domain configured
- [ ] n8n accessible via HTTPS

### Vercel Deployment:
- [ ] Vercel project deployed
- [ ] Environment variables set
- [ ] Custom domain configured
- [ ] Webhook endpoints responding

### DNS Configuration:
- [ ] CNAME records added to DNS
- [ ] DNS propagation complete
- [ ] Domains resolving correctly
- [ ] SSL certificates active

### n8n Configuration:
- [ ] Workflows imported successfully
- [ ] Credentials configured
- [ ] Workflows activated (start with 2)
- [ ] Test executions successful

### Integration Testing:
- [ ] Webhook endpoints tested
- [ ] Email delivery tested
- [ ] Order processing tested
- [ ] Ecommerce integration tested

## 🎉 Success!

Once complete, you'll have:
- ✅ **n8n running at**: https://n8n.walltouch.online
- ✅ **Webhooks at**: https://webhooks.walltouch.online  
- ✅ **Full automation** for walltouch.online

## 💡 Next Steps:
1. **Test with real order** from your website
2. **Monitor execution counts** in n8n dashboard
3. **Optimize workflows** based on performance
4. **Upgrade to paid plans** when ready to scale

## 🔄 Render vs Railway Comparison:
- **Render**: More reliable free tier, better for production
- **Railway**: Easier setup but limited free tier
- **Render**: 750 hours/month vs Railway's limited uploads
- **Render**: Better documentation and support

Your walltouch.online automation platform is ready to deploy on Render!
