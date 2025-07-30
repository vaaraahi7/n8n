# 🚀 Step-by-Step Deployment Guide: Railway + Vercel

## 📋 Overview
- **Railway**: Host n8n automation platform (n8n.walltouch.online)
- **Vercel**: Host webhook proxy (webhooks.walltouch.online)
- **Main Site**: Your ecommerce website (www.walltouch.online)

## 🚂 Part 1: Railway Deployment (n8n Platform)

### Step 1: Prepare Railway Account
```bash
# 1. Go to railway.app
# 2. Sign up with GitHub account
# 3. Connect your GitHub repository
```

### Step 2: Create Railway Project
```bash
# 1. Click "New Project"
# 2. Select "Deploy from GitHub repo"
# 3. Choose your n8n repository
# 4. Select "Deploy Now"
```

### Step 3: Configure Railway Environment Variables
In Railway dashboard → Variables tab, add these:

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

# Database
DB_TYPE=sqlite
DB_SQLITE_DATABASE=/app/data/database.sqlite

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-gmail-app-password
SMTP_SENDER=your-email@gmail.com

# Security
N8N_SECURE_COOKIE=true
N8N_JWT_AUTH_ACTIVE=true
EXECUTIONS_PROCESS=main
EXECUTIONS_MODE=regular
GENERIC_TIMEZONE=UTC

# Performance
N8N_METRICS=false
```

### Step 4: Create Railway Dockerfile
Create `Dockerfile` in your project root:

```dockerfile
FROM n8nio/n8n:latest

# Set working directory
WORKDIR /home/node

# Copy workflows and configurations
COPY workflows/ /home/node/.n8n/workflows/
COPY credentials/ /home/node/.n8n/credentials/

# Create data directory
RUN mkdir -p /app/data

# Set permissions
USER root
RUN chown -R node:node /home/node/.n8n /app/data
USER node

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
```

### Step 5: Deploy to Railway
```bash
# Railway will automatically deploy when you push to main branch
git add .
git commit -m "Configure for Railway deployment"
git push origin main

# Monitor deployment in Railway dashboard
# Wait for "Deployed" status (usually 2-5 minutes)
```

### Step 6: Configure Railway Custom Domain
```bash
# 1. In Railway dashboard → Settings → Domains
# 2. Click "Custom Domain"
# 3. Enter: n8n.walltouch.online
# 4. Railway will provide CNAME record
# 5. Add CNAME record to your DNS (see DNS section below)
```

## ☁️ Part 2: Vercel Deployment (Webhook Proxy)

### Step 1: Prepare Vercel Account
```bash
# 1. Go to vercel.com
# 2. Sign up with GitHub account
# 3. Install Vercel CLI
npm install -g vercel
```

### Step 2: Login to Vercel CLI
```bash
# Login to Vercel
vercel login

# Navigate to your project
cd /path/to/your/n8n-project
```

### Step 3: Configure Vercel Project
```bash
# Initialize Vercel project
vercel

# Answer the prompts:
# ? Set up and deploy "n8n"? [Y/n] y
# ? Which scope do you want to deploy to? [Your Account]
# ? Link to existing project? [y/N] n
# ? What's your project's name? n8n-walltouch-webhooks
# ? In which directory is your code located? ./
```

### Step 4: Configure Vercel Environment Variables
```bash
# Add environment variables via Vercel dashboard or CLI
vercel env add N8N_INSTANCE_URL
# Enter: https://n8n.walltouch.online

vercel env add WEBHOOK_BASE_URL
# Enter: https://webhooks.walltouch.online

vercel env add NODE_ENV
# Enter: production

vercel env add ALLOWED_ORIGINS
# Enter: https://www.walltouch.online,https://n8n.walltouch.online
```

### Step 5: Deploy to Vercel
```bash
# Deploy to production
vercel --prod

# Vercel will provide a URL like: n8n-walltouch-webhooks.vercel.app
```

### Step 6: Configure Vercel Custom Domain
```bash
# 1. In Vercel dashboard → Project → Settings → Domains
# 2. Add custom domain: webhooks.walltouch.online
# 3. Vercel will provide DNS configuration
```

## 🌐 Part 3: DNS Configuration

### Configure DNS Records in your domain provider:

```bash
# For walltouch.online domain, add these records:

# Main website (if not already configured)
Type: A
Name: www
Value: [your-ecommerce-server-ip]

# n8n subdomain (Railway)
Type: CNAME
Name: n8n
Value: [railway-provided-domain].railway.app

# Webhooks subdomain (Vercel)
Type: CNAME
Name: webhooks
Value: cname.vercel-dns.com
```

### DNS Configuration Steps:
```bash
# 1. Login to your domain registrar (GoDaddy, Namecheap, etc.)
# 2. Go to DNS Management
# 3. Add the CNAME records above
# 4. Wait 5-30 minutes for DNS propagation
# 5. Test with: nslookup n8n.walltouch.online
```

## 🔧 Part 4: Testing Deployment

### Step 1: Test n8n Platform
```bash
# Test n8n accessibility
curl https://n8n.walltouch.online/healthz

# Or visit in browser:
# https://n8n.walltouch.online
# Login with your configured credentials
```

### Step 2: Test Webhook Proxy
```bash
# Test webhook endpoint
curl -X POST https://webhooks.walltouch.online/api/webhook/new-order \
  -H "Content-Type: application/json" \
  -d '{
    "order_id": "TEST-001",
    "customer_email": "test@example.com",
    "total": 99.99,
    "status": "confirmed"
  }'

# Should return success response
```

### Step 3: Test Health Endpoints
```bash
# Test health endpoints
curl https://webhooks.walltouch.online/api/health
curl https://n8n.walltouch.online/healthz
```

## 📊 Part 5: Import and Configure Workflows

### Step 1: Access n8n Interface
```bash
# 1. Go to https://n8n.walltouch.online
# 2. Login with your credentials
# 3. You should see the n8n interface
```

### Step 2: Import Workflows
```bash
# In n8n interface:
# 1. Go to Workflows → Import from File
# 2. Import these files in order:
#    - workflows/invoice-communication.json
#    - workflows/sales-automation.json
#    - workflows/blog-automation.json
#    - workflows/marketing-automation.json
#    - workflows/social-media-automation.json
```

### Step 3: Configure Workflow Credentials
```bash
# For each workflow, configure credentials:
# 1. Gmail SMTP credentials
# 2. Social media API keys
# 3. Blog platform credentials
# 4. Ecommerce platform credentials
```

### Step 4: Activate Workflows
```bash
# Start with these 2 workflows (free plan limit):
# 1. Invoice & Communication (Priority 1)
# 2. Sales Automation (Priority 2)

# Activate by clicking the toggle switch in each workflow
```

## 🔗 Part 6: Connect to Your Ecommerce Website

### Update Webhook URLs in Your Ecommerce Platform:

#### For Shopify:
```bash
# Go to: Shopify Admin → Settings → Notifications → Webhooks
# Add these webhook URLs:

Order created: https://webhooks.walltouch.online/api/webhook/new-order
Order updated: https://webhooks.walltouch.online/api/webhook/order-status-update
Order paid: https://webhooks.walltouch.online/api/webhook/order-paid
Customer created: https://webhooks.walltouch.online/api/webhook/new-customer
```

#### For WooCommerce:
```php
// Update webhook URLs in your functions.php:
$webhook_url = 'https://webhooks.walltouch.online/api/webhook/new-order';
```

#### For Custom Platform:
```javascript
// Update webhook URLs in your code:
const webhookUrl = 'https://webhooks.walltouch.online/api/webhook/new-order';
```

## 🚨 Part 7: Troubleshooting

### Common Issues and Solutions:

#### Railway Deployment Issues:
```bash
# Check Railway logs
# Go to Railway dashboard → Deployments → View Logs

# Common fixes:
# 1. Verify Dockerfile syntax
# 2. Check environment variables
# 3. Ensure port 5678 is exposed
```

#### Vercel Deployment Issues:
```bash
# Check Vercel logs
vercel logs

# Common fixes:
# 1. Verify vercel.json configuration
# 2. Check API routes in api/ directory
# 3. Verify environment variables
```

#### DNS Issues:
```bash
# Check DNS propagation
nslookup n8n.walltouch.online
nslookup webhooks.walltouch.online

# If not working:
# 1. Wait longer (up to 24 hours)
# 2. Check DNS record syntax
# 3. Contact domain provider support
```

#### SSL Certificate Issues:
```bash
# Both Railway and Vercel provide automatic SSL
# If SSL issues:
# 1. Wait for automatic certificate generation
# 2. Check domain verification
# 3. Contact platform support
```

## ✅ Part 8: Deployment Checklist

### Pre-Deployment:
- [ ] GitHub repository ready
- [ ] Environment variables configured
- [ ] Domain DNS access available
- [ ] API keys and credentials ready

### Railway Deployment:
- [ ] Railway account created
- [ ] Project deployed successfully
- [ ] Environment variables configured
- [ ] Custom domain configured
- [ ] n8n accessible via HTTPS

### Vercel Deployment:
- [ ] Vercel account created
- [ ] Project deployed successfully
- [ ] Environment variables configured
- [ ] Custom domain configured
- [ ] Webhook endpoints responding

### DNS Configuration:
- [ ] CNAME records added
- [ ] DNS propagation complete
- [ ] Domains resolving correctly
- [ ] SSL certificates active

### n8n Configuration:
- [ ] Workflows imported
- [ ] Credentials configured
- [ ] Workflows activated
- [ ] Test executions successful

### Integration Testing:
- [ ] Webhook endpoints tested
- [ ] Email delivery tested
- [ ] Social media posting tested
- [ ] Ecommerce integration tested

## 🎉 Success!

Once all steps are complete, you'll have:
- ✅ **n8n running at**: https://n8n.walltouch.online
- ✅ **Webhooks at**: https://webhooks.walltouch.online
- ✅ **Full automation** for your walltouch.online ecommerce site

Your automation system will now handle:
- 📧 Order confirmations and status emails
- 📱 Social media posting
- 📝 Blog content generation
- 📊 Sales reporting
- 🎯 Marketing automation

## 💡 Next Steps:
1. Test with a real order from your website
2. Monitor execution counts in n8n dashboard
3. Optimize workflows based on performance
4. Scale up when ready (upgrade to paid plans)

Need help with any step? Check the troubleshooting section or refer to the detailed guides!
