# 🚀 Quick Start Guide - n8n Ecommerce Automation

## 📋 What You Get

✅ **Complete n8n setup** with subdomain configuration  
✅ **SEO automation** - Google Search Console, sitemap monitoring  
✅ **Marketing automation** - Lead scoring, email campaigns, newsletters  
✅ **Social media automation** - Facebook, Instagram, YouTube posting  
✅ **Sales automation** - Order processing, inventory management, reporting  
✅ **Invoice & communication** - Auto invoices, status emails via Gmail
✅ **Blog automation** - Auto-generated interior design content (NEW!)
✅ **Free plan optimized** - Maximum efficiency within 5,000 executions/month

## 🏃‍♂️ 5-Minute Setup

### 1. Deploy n8n
```bash
# Make deployment script executable and run
chmod +x setup-scripts/deploy.sh
./setup-scripts/deploy.sh
```

### 2. Configure APIs
```bash
# Interactive API configuration helper
chmod +x setup-scripts/configure-apis.sh
./setup-scripts/configure-apis.sh
```

### 3. Access n8n
- **Local**: http://localhost:5678
- **Production**: https://n8n.yourdomain.com
- **Login**: admin / changeme123 (change in .env)

## 🔧 Essential Configuration

### Update .env file:
```bash
# Copy example and edit
cp .env.example .env
nano .env
```

**Required settings:**
- `N8N_PASSWORD` - Change from default
- `SMTP_USER` & `SMTP_PASS` - Gmail credentials
- `DOMAIN` - Your domain name
- Social media API keys (optional)

### Import Workflows:
1. Open n8n interface
2. Go to Workflows → Import
3. Import these files (in order):
   - `workflows/invoice-communication.json` (Priority 1)
   - `workflows/sales-automation.json` (Priority 2)
   - `workflows/blog-automation.json` (Priority 3 - NEW!)
   - `workflows/marketing-automation.json` (Priority 4)

## 🆓 Free Plan Strategy

### Active Workflows (Max 2):
1. **Invoice & Communication** - Critical for customer experience
2. **Sales Automation** - Essential for order processing

### Execution Budget (5,000/month):
- Order processing: ~400 executions
- Customer emails: ~600 executions  
- Daily reports: ~30 executions
- **Buffer**: ~4,000 executions for growth

### When to Upgrade:
- **Starter ($20/month)**: When you need >2 workflows or >4,000 executions
- **Pro ($50/month)**: When processing >200 orders/month

## 📊 Workflow Features

### 🧾 Invoice & Communication
- **Auto invoice generation** with HTML templates
- **Order status emails** (confirmed, shipped, delivered)
- **Customer follow-up** with review requests
- **Gmail integration** for reliable delivery

### 💰 Sales Automation  
- **Order processing** with priority scoring
- **Inventory management** with low stock alerts
- **Daily sales reports** with key metrics
- **High-value order** manual review alerts

### 📧 Marketing Automation
- **Lead scoring** based on behavior and source
- **Automated email sequences** (hot/warm/cold leads)
- **Weekly newsletters** with dynamic content
- **Customer segmentation** for targeted campaigns

### 📱 Social Media Automation
- **Multi-platform posting** (Facebook, Instagram)
- **Content generation** with templates
- **Engagement monitoring** with auto-responses
- **Scheduled posting** 3x daily

### 🔍 SEO Automation
- **Google Search Console** monitoring
- **Sitemap health checks** with alerts
- **Weekly SEO reports** with actionable insights
- **Competitor analysis** tracking

## 🔗 Integration Webhooks

### Order Events:
```
POST https://n8n.yourdomain.com/webhook/order-status-update
{
  "order_id": "12345",
  "status": "confirmed|shipped|delivered",
  "customer_email": "customer@email.com",
  "total": 99.99,
  "items": [...]
}
```

### New Leads:
```
POST https://n8n.yourdomain.com/webhook/new-lead
{
  "email": "lead@email.com",
  "name": "John Doe",
  "source": "organic|paid|social|referral",
  "pages_visited": 5,
  "time_on_site": 300
}
```

### Social Engagement:
```
POST https://n8n.yourdomain.com/webhook/social-engagement
{
  "type": "comment|mention",
  "platform": "facebook|instagram",
  "user_name": "username",
  "text": "Great product!",
  "link": "https://..."
}
```

## 🛠️ Customization

### Email Templates:
Edit email content in workflow nodes:
- Welcome emails
- Order confirmations  
- Shipping notifications
- Review requests

### Social Media Content:
Modify content templates in `Generate Content` node:
- Product highlights
- Tips and advice
- Customer testimonials
- Promotional posts

### Lead Scoring:
Adjust scoring algorithm in `Score Lead` node:
- Email domain scoring
- Traffic source weights
- Behavior scoring
- Company size factors

## 📈 Monitoring & Optimization

### Track Usage:
- Monitor execution count in n8n dashboard
- Set alerts at 80% usage (4,000 executions)
- Review workflow efficiency monthly

### Performance Tips:
- Use webhooks instead of polling
- Batch process multiple items
- Implement conditional logic
- Optimize cron schedules

### Scaling Indicators:
- Consistently hitting execution limits
- Need for more than 2 active workflows
- Processing >100 orders/month
- Requiring advanced error handling

## 🆘 Troubleshooting

### Common Issues:

**n8n won't start:**
```bash
# Check logs
docker-compose logs -f n8n

# Restart services
docker-compose restart
```

**Webhook not working:**
- Check firewall settings
- Verify webhook URLs
- Test with curl/Postman

**Email not sending:**
- Verify Gmail app password
- Check SMTP settings in .env
- Test with simple workflow

**API rate limits:**
- Monitor API usage
- Implement retry logic
- Use webhook triggers instead of polling

## 📞 Support Resources

- **n8n Community**: https://community.n8n.io/
- **Documentation**: https://docs.n8n.io/
- **Workflow Examples**: https://n8n.io/workflows/
- **API Docs**: Platform-specific documentation

## 🎯 Next Steps

1. **Week 1**: Deploy and test basic order processing
2. **Week 2**: Configure social media integrations  
3. **Week 3**: Set up marketing automation
4. **Week 4**: Optimize and monitor performance

## 💡 Pro Tips

- Start with essential workflows only
- Test thoroughly before going live
- Monitor execution usage closely
- Plan upgrade path as you grow
- Keep workflows simple and efficient
- Use error handling to prevent failed executions

---

**🎉 You're all set!** Your ecommerce automation platform is ready to handle orders, engage customers, and grow your business automatically.

Need help? Check the documentation or reach out to the n8n community!
