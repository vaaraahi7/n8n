# ⚡ Quick Deploy Commands for walltouch.online

## 🚂 Railway Deployment Commands

### 1. Install Railway CLI (if needed)
```bash
# Install Railway CLI
npm install -g @railway/cli

# Or using curl
curl -fsSL https://railway.app/install.sh | sh
```

### 2. Login and Deploy to Railway
```bash
# Login to Railway
railway login

# Initialize Railway project
railway init

# Link to existing project (if you created one in web interface)
railway link

# Deploy to Railway
railway up

# Check deployment status
railway status

# View logs
railway logs
```

### 3. Set Environment Variables on Railway
```bash
# Set environment variables via CLI
railway variables set N8N_BASIC_AUTH_ACTIVE=true
railway variables set N8N_BASIC_AUTH_USER=admin
railway variables set N8N_BASIC_AUTH_PASSWORD=your_secure_password
railway variables set N8N_HOST=n8n.walltouch.online
railway variables set WEBHOOK_URL=https://n8n.walltouch.online/
railway variables set N8N_PORT=5678
railway variables set N8N_PROTOCOL=https
railway variables set DB_TYPE=sqlite
railway variables set DB_SQLITE_DATABASE=/app/data/database.sqlite

# Or set all at once using environment file
railway variables set --from-file .env.production
```

### 4. Configure Custom Domain on Railway
```bash
# Add custom domain via CLI
railway domain add n8n.walltouch.online

# Or do it via web interface:
# 1. Go to railway.app dashboard
# 2. Select your project
# 3. Go to Settings → Domains
# 4. Add custom domain: n8n.walltouch.online
```

## ☁️ Vercel Deployment Commands

### 1. Install Vercel CLI (if needed)
```bash
# Install Vercel CLI
npm install -g vercel
```

### 2. Login and Deploy to Vercel
```bash
# Login to Vercel
vercel login

# Deploy to Vercel (from project root)
vercel

# Follow prompts:
# ? Set up and deploy? Y
# ? Which scope? [Your Account]
# ? Link to existing project? N
# ? Project name? n8n-walltouch-webhooks
# ? Directory? ./

# Deploy to production
vercel --prod
```

### 3. Set Environment Variables on Vercel
```bash
# Set environment variables
vercel env add N8N_INSTANCE_URL production
# Enter: https://n8n.walltouch.online

vercel env add WEBHOOK_BASE_URL production
# Enter: https://webhooks.walltouch.online

vercel env add NODE_ENV production
# Enter: production

vercel env add ALLOWED_ORIGINS production
# Enter: https://www.walltouch.online,https://n8n.walltouch.online

# Redeploy after setting environment variables
vercel --prod
```

### 4. Configure Custom Domain on Vercel
```bash
# Add custom domain via CLI
vercel domains add webhooks.walltouch.online

# Or via web interface:
# 1. Go to vercel.com dashboard
# 2. Select your project
# 3. Go to Settings → Domains
# 4. Add: webhooks.walltouch.online
```

## 🌐 DNS Configuration Commands

### Check Current DNS
```bash
# Check current DNS records
nslookup www.walltouch.online
nslookup n8n.walltouch.online
nslookup webhooks.walltouch.online

# Check DNS propagation
dig n8n.walltouch.online
dig webhooks.walltouch.online
```

### DNS Records to Add
```bash
# Add these records in your DNS provider:

# For n8n subdomain (Railway)
Type: CNAME
Name: n8n
Value: [your-railway-domain].railway.app

# For webhooks subdomain (Vercel)  
Type: CNAME
Name: webhooks
Value: cname.vercel-dns.com
```

## 🧪 Testing Commands

### Test Railway Deployment
```bash
# Test n8n health
curl https://n8n.walltouch.online/healthz

# Test n8n login page
curl -I https://n8n.walltouch.online

# Check if basic auth is working
curl -u admin:your_password https://n8n.walltouch.online/rest/active-workflows
```

### Test Vercel Deployment
```bash
# Test webhook proxy health
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

### Test Full Integration
```bash
# Test order webhook (should trigger n8n workflow)
curl -X POST https://webhooks.walltouch.online/api/webhook/new-order \
  -H "Content-Type: application/json" \
  -d '{
    "order_id": "REAL-TEST-001",
    "customer_email": "customer@example.com",
    "customer_name": "Test Customer",
    "total": 199.99,
    "currency": "USD",
    "status": "confirmed",
    "items": [
      {
        "name": "Premium Wallpaper Roll",
        "quantity": 2,
        "price": 89.99,
        "category": "wallpapers"
      }
    ],
    "shipping_address": {
      "street": "123 Main St",
      "city": "New York",
      "state": "NY",
      "zip": "10001"
    }
  }'
```

## 🔧 Troubleshooting Commands

### Railway Troubleshooting
```bash
# Check Railway logs
railway logs

# Check Railway status
railway status

# Restart Railway service
railway restart

# Check Railway environment variables
railway variables

# Connect to Railway shell (if needed)
railway shell
```

### Vercel Troubleshooting
```bash
# Check Vercel logs
vercel logs

# Check Vercel deployment status
vercel ls

# Redeploy Vercel project
vercel --prod

# Check Vercel environment variables
vercel env ls

# Remove and redeploy if needed
vercel remove
vercel --prod
```

### DNS Troubleshooting
```bash
# Check DNS propagation globally
curl "https://dns.google/resolve?name=n8n.walltouch.online&type=CNAME"
curl "https://dns.google/resolve?name=webhooks.walltouch.online&type=CNAME"

# Check from different DNS servers
nslookup n8n.walltouch.online 8.8.8.8
nslookup webhooks.walltouch.online 1.1.1.1

# Flush local DNS cache (if testing locally)
# Windows:
ipconfig /flushdns

# macOS:
sudo dscacheutil -flushcache

# Linux:
sudo systemctl restart systemd-resolved
```

## 📊 Monitoring Commands

### Check Deployment Health
```bash
# Create a simple monitoring script
cat > check_health.sh << 'EOF'
#!/bin/bash
echo "Checking walltouch.online automation health..."

echo "1. Testing n8n platform..."
if curl -s https://n8n.walltouch.online/healthz | grep -q "ok"; then
    echo "✅ n8n platform: HEALTHY"
else
    echo "❌ n8n platform: UNHEALTHY"
fi

echo "2. Testing webhook proxy..."
if curl -s https://webhooks.walltouch.online/api/health | grep -q "healthy"; then
    echo "✅ Webhook proxy: HEALTHY"
else
    echo "❌ Webhook proxy: UNHEALTHY"
fi

echo "3. Testing main website..."
if curl -s -I https://www.walltouch.online | grep -q "200 OK"; then
    echo "✅ Main website: HEALTHY"
else
    echo "❌ Main website: CHECK NEEDED"
fi

echo "Health check complete!"
EOF

chmod +x check_health.sh
./check_health.sh
```

### Monitor Logs
```bash
# Monitor Railway logs in real-time
railway logs --follow

# Monitor Vercel logs
vercel logs --follow

# Check specific time range
railway logs --since 1h
vercel logs --since 1h
```

## 🚀 Complete Deployment Script

### All-in-One Deployment
```bash
#!/bin/bash
echo "🚀 Deploying walltouch.online automation platform..."

# 1. Deploy to Railway
echo "📡 Deploying n8n to Railway..."
railway login
railway up
railway variables set --from-file .env.production
railway domain add n8n.walltouch.online

# 2. Deploy to Vercel
echo "☁️ Deploying webhooks to Vercel..."
vercel login
vercel --prod
vercel env add N8N_INSTANCE_URL production
vercel env add WEBHOOK_BASE_URL production
vercel env add NODE_ENV production
vercel domains add webhooks.walltouch.online

# 3. Test deployments
echo "🧪 Testing deployments..."
sleep 30  # Wait for deployments to be ready

if curl -s https://n8n.walltouch.online/healthz | grep -q "ok"; then
    echo "✅ Railway deployment successful!"
else
    echo "❌ Railway deployment failed!"
fi

if curl -s https://webhooks.walltouch.online/api/health | grep -q "healthy"; then
    echo "✅ Vercel deployment successful!"
else
    echo "❌ Vercel deployment failed!"
fi

echo "🎉 Deployment complete!"
echo "📋 Next steps:"
echo "1. Configure DNS records for your domain"
echo "2. Import workflows in n8n interface"
echo "3. Configure webhook URLs in your ecommerce platform"
echo "4. Test with a real order"
```

## 📝 Quick Reference

### Important URLs:
- **n8n Interface**: https://n8n.walltouch.online
- **Webhook Endpoint**: https://webhooks.walltouch.online/api/webhook/
- **Health Checks**: 
  - https://n8n.walltouch.online/healthz
  - https://webhooks.walltouch.online/api/health

### Default Credentials:
- **Username**: admin
- **Password**: [set in environment variables]

### Key Environment Variables:
- `N8N_BASIC_AUTH_USER` and `N8N_BASIC_AUTH_PASSWORD`
- `N8N_HOST=n8n.walltouch.online`
- `WEBHOOK_BASE_URL=https://webhooks.walltouch.online`

This guide provides all the commands you need to deploy your n8n automation platform for walltouch.online!
