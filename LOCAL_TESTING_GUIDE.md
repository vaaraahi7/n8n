# 🧪 Local Testing Guide for n8n Ecommerce Automation

## 🎯 Testing Strategy

**Recommended Approach**: Test locally first, then deploy to Vercel

### Why Test Locally First?
- ✅ **Free testing** - No hosting costs during development
- ✅ **Quick iterations** - Instant changes and testing
- ✅ **Debug easily** - Full access to logs and debugging
- ✅ **Safe environment** - No risk to production data
- ✅ **Webhook testing** - Use ngrok for external webhook access

## 🚀 Local Setup Instructions

### 1. Prerequisites
```bash
# Install required tools
npm install -g ngrok
# or
brew install ngrok  # macOS
```

### 2. Start n8n Locally
```bash
# Clone your project
git clone <your-repo>
cd n8n

# Start with Docker Compose
docker-compose up -d

# Or start n8n directly (if installed locally)
npx n8n start --tunnel
```

### 3. Setup ngrok for Webhooks
```bash
# In a new terminal, expose n8n to internet
ngrok http 5678

# You'll get a URL like: https://abc123.ngrok.io
# Use this as your webhook base URL
```

### 4. Configure Local Environment
```bash
# Copy and edit environment file
cp .env.example .env.local

# Edit .env.local with local settings
nano .env.local
```

**Local Environment Variables:**
```bash
# Local n8n Configuration
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
WEBHOOK_URL=https://abc123.ngrok.io/

# Use ngrok URL for webhooks
WEBHOOK_BASE_URL=https://abc123.ngrok.io/webhook

# Local database
DB_TYPE=sqlite
DB_SQLITE_DATABASE=./data/database.sqlite

# Test email (use Mailtrap or similar)
SMTP_HOST=smtp.mailtrap.io
SMTP_PORT=2525
SMTP_USER=your_mailtrap_user
SMTP_PASS=your_mailtrap_pass

# Test mode flags
NODE_ENV=development
DEBUG_MODE=true
```

## 🔗 Connecting to Your Ecommerce Website

### Option 1: Test with Mock Data
```bash
# Create test webhook endpoint
curl -X POST https://abc123.ngrok.io/webhook/new-order \
  -H "Content-Type: application/json" \
  -d '{
    "order_id": "TEST-001",
    "customer_email": "test@example.com",
    "customer_name": "Test Customer",
    "total": 99.99,
    "status": "confirmed",
    "items": [
      {
        "name": "Test Wallpaper",
        "quantity": 2,
        "price": 49.99
      }
    ]
  }'
```

### Option 2: Connect to Local Ecommerce Site
If your ecommerce site runs locally:
```bash
# Your ecommerce site: http://localhost:3000
# n8n webhooks: https://abc123.ngrok.io/webhook/

# Configure your ecommerce platform to send webhooks to:
# Order events: https://abc123.ngrok.io/webhook/new-order
# Status updates: https://abc123.ngrok.io/webhook/order-status-update
# New leads: https://abc123.ngrok.io/webhook/new-lead
```

### Option 3: Connect to Live Ecommerce Site
```bash
# Use ngrok URL in your live site's webhook settings
# This allows testing with real data safely
```

## 🛠️ Testing Workflows

### 1. Test Order Processing
```javascript
// Test data for order webhook
{
  "order_id": "ORD-12345",
  "customer_email": "customer@example.com",
  "customer_name": "John Doe",
  "total": 299.99,
  "status": "confirmed",
  "items": [
    {
      "name": "Floral Wallpaper Roll",
      "quantity": 3,
      "price": 89.99,
      "category": "wallpapers"
    },
    {
      "name": "Modern Table Lamp",
      "quantity": 1,
      "price": 129.99,
      "category": "furniture"
    }
  ],
  "shipping_address": {
    "street": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zip": "10001"
  }
}
```

### 2. Test Lead Generation
```javascript
// Test data for lead webhook
{
  "email": "lead@example.com",
  "name": "Jane Smith",
  "source": "organic",
  "pages_visited": 8,
  "time_on_site": 420,
  "viewed_pricing": true,
  "company_size": "small",
  "budget": "medium"
}
```

### 3. Test Blog Publishing
```javascript
// Test data for blog webhook
{
  "title": "Test: Best Wallpapers for Small Rooms",
  "category": "wallpapers",
  "content": "This is test blog content...",
  "keywords": ["wallpaper", "small rooms", "interior design"],
  "meta_description": "Discover the best wallpapers for small rooms...",
  "featured_image": "https://example.com/image.jpg"
}
```

## 📧 Email Testing

### Using Mailtrap (Recommended for Testing)
```bash
# Sign up at mailtrap.io (free tier available)
# Get SMTP credentials and add to .env.local

SMTP_HOST=smtp.mailtrap.io
SMTP_PORT=2525
SMTP_USER=your_mailtrap_username
SMTP_PASS=your_mailtrap_password
```

### Using Gmail (for Production-like Testing)
```bash
# Use a test Gmail account
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-test-email@gmail.com
SMTP_PASS=your-app-password
```

## 🔍 Debugging and Monitoring

### 1. Check n8n Logs
```bash
# View Docker logs
docker-compose logs -f n8n

# Or if running directly
# Logs appear in terminal
```

### 2. Monitor Webhook Calls
```bash
# ngrok provides a web interface at:
http://localhost:4040

# Shows all incoming webhook requests
# Useful for debugging webhook data
```

### 3. Test Individual Nodes
- Use n8n's **"Execute Node"** feature
- Test each workflow step individually
- Check data transformation at each stage

## 🚦 Testing Checklist

### ✅ Basic Setup
- [ ] n8n running locally (http://localhost:5678)
- [ ] ngrok tunnel active
- [ ] Environment variables configured
- [ ] Workflows imported and activated

### ✅ Webhook Testing
- [ ] Order processing webhook responds
- [ ] Lead generation webhook responds
- [ ] Blog publishing webhook responds
- [ ] Social media webhooks respond

### ✅ Email Testing
- [ ] Order confirmation emails sent
- [ ] Invoice emails generated
- [ ] Marketing emails delivered
- [ ] Notification emails working

### ✅ Integration Testing
- [ ] Ecommerce platform connects successfully
- [ ] Social media APIs authenticated
- [ ] Blog platforms accessible
- [ ] SEO tools integrated

### ✅ Performance Testing
- [ ] Workflows execute within time limits
- [ ] No memory leaks or crashes
- [ ] Error handling works correctly
- [ ] Execution counts tracked

## 🔧 Common Issues and Solutions

### Issue: Webhooks Not Receiving Data
```bash
# Check ngrok is running
ngrok http 5678

# Verify webhook URLs in ecommerce platform
# Check firewall settings
# Test with curl commands
```

### Issue: Email Not Sending
```bash
# Verify SMTP credentials
# Check spam folders
# Test with simple email workflow
# Use Mailtrap for debugging
```

### Issue: API Rate Limits
```bash
# Check API quotas and limits
# Implement retry logic
# Use webhook triggers instead of polling
# Monitor execution frequency
```

### Issue: Workflow Execution Errors
```bash
# Check n8n logs for error details
# Verify all required environment variables
# Test with simplified data
# Use try-catch nodes for error handling
```

## 📊 Local Testing Metrics

Track these metrics during local testing:
- **Webhook Response Time**: < 5 seconds
- **Email Delivery Time**: < 30 seconds
- **Workflow Success Rate**: > 95%
- **API Call Success Rate**: > 98%
- **Memory Usage**: Monitor for leaks

## 🎯 Next Steps After Local Testing

Once local testing is successful:

1. **Deploy to Vercel** (see Vercel deployment guide)
2. **Update webhook URLs** to production URLs
3. **Configure production environment variables**
4. **Test with live ecommerce data**
5. **Monitor performance and optimize**

## 💡 Pro Tips for Local Testing

1. **Use test data consistently** - Create standard test datasets
2. **Test error scenarios** - Simulate failures and edge cases
3. **Monitor execution counts** - Stay within free plan limits
4. **Document issues** - Keep track of bugs and solutions
5. **Test incrementally** - Add one workflow at a time
6. **Backup configurations** - Export working workflows

This local testing approach ensures your n8n automation works perfectly before deploying to production!
