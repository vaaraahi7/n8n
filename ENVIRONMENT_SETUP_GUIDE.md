# 🌍 Environment Setup Guide

## 📋 Overview

This guide explains how to set up different environments for your n8n ecommerce automation system:
- **Local Development** - For testing and development
- **Staging** - For pre-production testing
- **Production** - For live deployment

## 🏗️ Environment Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  LOCAL DEV      │    │    STAGING      │    │   PRODUCTION    │
│                 │    │                 │    │                 │
│ localhost:5678  │    │ staging.domain  │    │ n8n.domain.com  │
│ ngrok tunnel    │    │ test APIs       │    │ live APIs       │
│ mailtrap email  │    │ staging data    │    │ real customers  │
│ test webhooks   │    │ full testing    │    │ live webhooks   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🔧 Environment Configuration

### 1. Local Development Setup

#### Prerequisites:
```bash
# Install required tools
npm install -g ngrok
docker --version
docker-compose --version
```

#### Setup Steps:
```bash
# 1. Clone repository
git clone <your-repo>
cd n8n

# 2. Copy local environment file
cp .env.local .env

# 3. Edit environment variables
nano .env

# 4. Start local development
docker-compose up -d

# 5. Setup ngrok for webhook testing
ngrok http 5678
# Update WEBHOOK_BASE_URL in .env with ngrok URL
```

#### Local Environment Features:
- ✅ **SQLite database** - No external DB required
- ✅ **Mailtrap email** - Safe email testing
- ✅ **ngrok tunneling** - External webhook access
- ✅ **Debug logging** - Detailed error information
- ✅ **Mock data support** - Test without real APIs
- ✅ **Hot reloading** - Instant changes

#### Local Testing Checklist:
- [ ] n8n accessible at http://localhost:5678
- [ ] ngrok tunnel active and webhook URL updated
- [ ] Mailtrap receiving test emails
- [ ] Workflows import successfully
- [ ] Test webhooks respond correctly
- [ ] Social media APIs authenticated (test accounts)

### 2. Staging Environment Setup

#### Purpose:
- **Pre-production testing** with real-like data
- **Integration testing** with staging ecommerce site
- **Performance testing** under load
- **User acceptance testing** by stakeholders

#### Setup Steps:
```bash
# 1. Copy staging environment file
cp .env.staging .env

# 2. Update staging-specific values
nano .env

# 3. Deploy to staging platform (Railway/Render/etc.)
# Follow platform-specific deployment guide

# 4. Configure staging domain DNS
# Point staging.yourstore.com to staging server

# 5. Setup SSL certificates
# Use Let's Encrypt or platform SSL
```

#### Staging Environment Features:
- ✅ **Staging domain** - staging.yourstore.com
- ✅ **Test APIs** - Sandbox/test API keys
- ✅ **Staging database** - Separate from production
- ✅ **Email testing** - Mailtrap or test email service
- ✅ **Performance monitoring** - Metrics and logging
- ✅ **Backup testing** - Test backup/restore procedures

#### Staging Testing Checklist:
- [ ] Staging site accessible via HTTPS
- [ ] All workflows function correctly
- [ ] Integration with staging ecommerce site
- [ ] Email delivery working
- [ ] Social media posting to test accounts
- [ ] Performance metrics within acceptable ranges
- [ ] Error handling working correctly

### 3. Production Environment Setup

#### Prerequisites:
- **Domain configured** - yourstore.com with DNS access
- **SSL certificates** - Valid SSL for all subdomains
- **Production APIs** - Live API keys and credentials
- **Monitoring setup** - Error tracking and alerts
- **Backup strategy** - Regular automated backups

#### Setup Steps:
```bash
# 1. Copy production environment file
cp .env.production .env

# 2. Update all production values
nano .env
# IMPORTANT: Use strong passwords and real API keys

# 3. Deploy to production platform
# Use reliable hosting (Railway Pro, DigitalOcean, AWS)

# 4. Configure production DNS
# Point n8n.yourstore.com to production server
# Point webhooks.yourstore.com to webhook proxy

# 5. Setup SSL certificates
certbot certonly --standalone -d n8n.yourstore.com
certbot certonly --standalone -d webhooks.yourstore.com

# 6. Configure monitoring and alerts
# Setup Sentry, monitoring dashboards, etc.
```

#### Production Environment Features:
- ✅ **Production domain** - n8n.yourstore.com
- ✅ **Live APIs** - Real social media, email, payment APIs
- ✅ **Production database** - Reliable, backed up storage
- ✅ **Real email delivery** - Gmail/SendGrid for customer emails
- ✅ **Performance optimization** - Caching, CDN, optimization
- ✅ **Security hardening** - Rate limiting, IP filtering, SSL
- ✅ **Monitoring & alerts** - 24/7 monitoring and notifications
- ✅ **Automated backups** - Daily backups with retention

#### Production Deployment Checklist:
- [ ] All environment variables configured with production values
- [ ] SSL certificates installed and valid
- [ ] DNS records pointing to correct servers
- [ ] All integrations tested with live data
- [ ] Monitoring and alerting configured
- [ ] Backup strategy implemented and tested
- [ ] Security measures in place
- [ ] Performance optimized
- [ ] Documentation updated
- [ ] Team trained on production procedures

## 🔄 Environment Management

### Switching Between Environments:
```bash
# Switch to local development
cp .env.local .env
docker-compose restart

# Switch to staging
cp .env.staging .env
# Redeploy to staging platform

# Switch to production
cp .env.production .env
# Deploy to production platform
```

### Environment Variable Management:
```bash
# Validate environment variables
node scripts/validate-env.js

# Compare environments
diff .env.local .env.staging
diff .env.staging .env.production

# Backup environment files
cp .env .env.backup.$(date +%Y%m%d)
```

### Database Management:
```bash
# Local database backup
cp data/local-database.sqlite backups/local-$(date +%Y%m%d).sqlite

# Staging database backup
# Use platform-specific backup tools

# Production database backup
# Automated daily backups configured
```

## 🔒 Security Considerations

### Environment-Specific Security:

#### Local Development:
- ✅ Use test API keys only
- ✅ Never commit real credentials
- ✅ Use .env files (not tracked in git)
- ✅ Disable authentication for easier testing

#### Staging:
- ✅ Use staging/sandbox API keys
- ✅ Enable basic authentication
- ✅ Restrict access to team members
- ✅ Use test payment processors

#### Production:
- ✅ Use live API keys with minimal permissions
- ✅ Enable all security features
- ✅ Implement rate limiting
- ✅ Use strong passwords and secrets
- ✅ Enable HTTPS everywhere
- ✅ Regular security audits

### Secret Management:
```bash
# Use environment-specific secret management
# Local: .env files
# Staging: Platform environment variables
# Production: Secure secret management (AWS Secrets Manager, etc.)

# Never commit secrets to git
echo ".env*" >> .gitignore
echo "*.key" >> .gitignore
echo "secrets/" >> .gitignore
```

## 📊 Monitoring and Maintenance

### Environment Health Checks:
```bash
# Health check endpoints
GET /api/health
GET /healthz

# Monitor key metrics
- Response time < 2 seconds
- Error rate < 1%
- Uptime > 99.9%
- Memory usage < 80%
- Disk usage < 80%
```

### Log Management:
```bash
# Local logs
docker-compose logs -f n8n

# Staging/Production logs
# Use centralized logging (ELK stack, Datadog, etc.)

# Log levels by environment
# Local: debug
# Staging: info
# Production: warn/error
```

### Backup Strategy:
```bash
# Local: Manual backups
# Staging: Daily backups, 7-day retention
# Production: Daily backups, 30-day retention + monthly archives

# Backup verification
# Test restore procedures monthly
# Document recovery procedures
```

## 🚀 Deployment Workflow

### Recommended Deployment Flow:
```
Local Development → Staging → Production

1. Develop and test locally
2. Deploy to staging for integration testing
3. User acceptance testing on staging
4. Deploy to production with monitoring
5. Post-deployment verification
```

### Deployment Commands:
```bash
# Local to Staging
git push origin staging
# Triggers staging deployment

# Staging to Production
git push origin main
# Triggers production deployment

# Rollback if needed
git revert <commit-hash>
git push origin main
```

## 🔧 Troubleshooting

### Common Environment Issues:

#### Local Development:
```bash
# n8n not starting
docker-compose down && docker-compose up -d

# Webhooks not working
# Check ngrok is running and URL is updated in .env

# Database issues
rm data/local-database.sqlite
# Restart n8n to recreate database
```

#### Staging/Production:
```bash
# Check application logs
# Platform-specific log viewing commands

# Verify environment variables
# Check platform environment variable settings

# Test connectivity
curl https://n8n.yourstore.com/healthz
curl https://webhooks.yourstore.com/api/health
```

### Performance Issues:
```bash
# Monitor resource usage
# Check memory, CPU, disk usage

# Optimize workflows
# Review execution times and optimize slow workflows

# Scale resources
# Increase server resources if needed
```

This environment setup ensures smooth development, testing, and production deployment of your n8n ecommerce automation system!
