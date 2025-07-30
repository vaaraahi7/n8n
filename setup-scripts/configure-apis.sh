#!/bin/bash

# API Configuration Helper Script
# Helps set up free tier API keys for n8n integrations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}[STEP]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${RED}[IMPORTANT]${NC} $1"
}

# Gmail SMTP Setup
setup_gmail() {
    print_header "Gmail SMTP Configuration (FREE)"
    
    echo "To use Gmail for sending emails, you need to:"
    echo ""
    print_step "1. Enable 2-Factor Authentication on your Google account"
    echo "   • Go to: https://myaccount.google.com/security"
    echo "   • Enable 2-Step Verification"
    echo ""
    
    print_step "2. Generate an App Password"
    echo "   • Go to: https://myaccount.google.com/apppasswords"
    echo "   • Select 'Mail' and 'Other (custom name)'"
    echo "   • Name it 'n8n-automation'"
    echo "   • Copy the 16-character password"
    echo ""
    
    print_step "3. Update your .env file:"
    echo "   SMTP_HOST=smtp.gmail.com"
    echo "   SMTP_PORT=587"
    echo "   SMTP_USER=your-email@gmail.com"
    echo "   SMTP_PASS=your-16-char-app-password"
    echo "   SMTP_SENDER=your-email@gmail.com"
    echo ""
    
    print_warning "Gmail free tier limits: 500 emails/day"
    echo ""
}

# Facebook API Setup
setup_facebook() {
    print_header "Facebook API Configuration (FREE)"
    
    echo "To automate Facebook posts, you need to:"
    echo ""
    print_step "1. Create a Facebook App"
    echo "   • Go to: https://developers.facebook.com/"
    echo "   • Click 'Create App' → 'Business'"
    echo "   • Add 'Facebook Pages' product"
    echo ""
    
    print_step "2. Get Page Access Token"
    echo "   • Go to Graph API Explorer"
    echo "   • Select your app and page"
    echo "   • Generate token with 'pages_manage_posts' permission"
    echo ""
    
    print_step "3. Update your .env file:"
    echo "   FACEBOOK_APP_ID=your_app_id"
    echo "   FACEBOOK_APP_SECRET=your_app_secret"
    echo "   FACEBOOK_ACCESS_TOKEN=your_page_access_token"
    echo "   FACEBOOK_PAGE_ID=your_page_id"
    echo ""
    
    print_warning "Facebook free tier: No specific limits for basic posting"
    echo ""
}

# Instagram API Setup
setup_instagram() {
    print_header "Instagram API Configuration (FREE)"
    
    echo "To automate Instagram posts, you need to:"
    echo ""
    print_step "1. Convert to Instagram Business Account"
    echo "   • Link Instagram to Facebook Page"
    echo "   • Switch to Business Account in Instagram app"
    echo ""
    
    print_step "2. Use Facebook App (same as above)"
    echo "   • Instagram uses Facebook's Graph API"
    echo "   • Add 'Instagram Basic Display' product"
    echo ""
    
    print_step "3. Get Instagram Account ID"
    echo "   • Use Graph API Explorer"
    echo "   • Query: me/accounts → select page → instagram_business_account"
    echo ""
    
    print_step "4. Update your .env file:"
    echo "   INSTAGRAM_ACCESS_TOKEN=your_access_token"
    echo "   INSTAGRAM_ACCOUNT_ID=your_instagram_business_id"
    echo ""
    
    print_warning "Instagram API limits: 200 requests/hour per user"
    echo ""
}

# YouTube API Setup
setup_youtube() {
    print_header "YouTube API Configuration (FREE)"
    
    echo "To automate YouTube operations, you need to:"
    echo ""
    print_step "1. Create Google Cloud Project"
    echo "   • Go to: https://console.cloud.google.com/"
    echo "   • Create new project or select existing"
    echo "   • Enable YouTube Data API v3"
    echo ""
    
    print_step "2. Create Credentials"
    echo "   • Go to APIs & Services → Credentials"
    echo "   • Create OAuth 2.0 Client ID"
    echo "   • Add authorized redirect URIs"
    echo ""
    
    print_step "3. Update your .env file:"
    echo "   YOUTUBE_API_KEY=your_api_key"
    echo "   YOUTUBE_CLIENT_ID=your_client_id"
    echo "   YOUTUBE_CLIENT_SECRET=your_client_secret"
    echo ""
    
    print_warning "YouTube API free quota: 10,000 units/day"
    print_info "Video upload = 1,600 units, Search = 100 units"
    echo ""
}

# Google Search Console Setup
setup_search_console() {
    print_header "Google Search Console API (FREE)"
    
    echo "To monitor SEO performance, you need to:"
    echo ""
    print_step "1. Verify your website in Search Console"
    echo "   • Go to: https://search.google.com/search-console"
    echo "   • Add and verify your property"
    echo ""
    
    print_step "2. Enable Search Console API"
    echo "   • In Google Cloud Console"
    echo "   • Enable Google Search Console API"
    echo "   • Create service account credentials"
    echo ""
    
    print_step "3. Update your .env file:"
    echo "   GOOGLE_CLIENT_ID=your_client_id"
    echo "   GOOGLE_CLIENT_SECRET=your_client_secret"
    echo "   GOOGLE_SEARCH_CONSOLE_KEY=your_service_account_key"
    echo ""
    
    print_warning "Search Console API: 1,000 requests/day (free)"
    echo ""
}

# Shopify Setup
setup_shopify() {
    print_header "Shopify Integration (FREE with store)"
    
    echo "To connect your Shopify store, you need to:"
    echo ""
    print_step "1. Create Private App (for existing stores)"
    echo "   • Go to: Admin → Apps → Manage private apps"
    echo "   • Create private app with required permissions"
    echo ""
    
    print_step "2. Or use Shopify Partner Account (for development)"
    echo "   • Go to: https://partners.shopify.com/"
    echo "   • Create development store"
    echo ""
    
    print_step "3. Update your .env file:"
    echo "   SHOPIFY_SHOP_NAME=your-shop-name"
    echo "   SHOPIFY_ACCESS_TOKEN=your_access_token"
    echo ""
    
    print_warning "Shopify API limits: 2 requests/second (burst: 40)"
    echo ""
}

# WooCommerce Setup
setup_woocommerce() {
    print_header "WooCommerce Integration (FREE)"
    
    echo "To connect your WooCommerce store, you need to:"
    echo ""
    print_step "1. Enable REST API in WooCommerce"
    echo "   • Go to: WooCommerce → Settings → Advanced → REST API"
    echo "   • Create new API key"
    echo "   • Set permissions to Read/Write"
    echo ""
    
    print_step "2. Update your .env file:"
    echo "   WOOCOMMERCE_URL=https://yourstore.com"
    echo "   WOOCOMMERCE_CONSUMER_KEY=ck_your_consumer_key"
    echo "   WOOCOMMERCE_CONSUMER_SECRET=cs_your_consumer_secret"
    echo ""
    
    print_warning "WooCommerce API: No specific rate limits (depends on hosting)"
    echo ""
}

# Stripe Setup
setup_stripe() {
    print_header "Stripe Integration (FREE tier available)"
    
    echo "To handle payments and invoices, you need to:"
    echo ""
    print_step "1. Create Stripe Account"
    echo "   • Go to: https://stripe.com/"
    echo "   • Sign up for free account"
    echo "   • Complete account verification"
    echo ""
    
    print_step "2. Get API Keys"
    echo "   • Go to: Dashboard → Developers → API keys"
    echo "   • Copy Publishable and Secret keys"
    echo "   • Use test keys for development"
    echo ""
    
    print_step "3. Update your .env file:"
    echo "   STRIPE_SECRET_KEY=sk_test_your_secret_key"
    echo "   STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key"
    echo ""
    
    print_warning "Stripe free tier: No monthly fees, pay per transaction"
    print_info "Transaction fee: 2.9% + 30¢ per successful charge"
    echo ""
}

# Main menu
show_menu() {
    clear
    print_header "n8n API Configuration Helper"
    
    echo "Select the service you want to configure:"
    echo ""
    echo "1) Gmail SMTP (Email automation)"
    echo "2) Facebook API (Social media posting)"
    echo "3) Instagram API (Social media posting)"
    echo "4) YouTube API (Video automation)"
    echo "5) Google Search Console (SEO monitoring)"
    echo "6) Shopify (Ecommerce integration)"
    echo "7) WooCommerce (Ecommerce integration)"
    echo "8) Stripe (Payment processing)"
    echo "9) Show all configurations"
    echo "0) Exit"
    echo ""
    read -p "Enter your choice (0-9): " choice
    
    case $choice in
        1) setup_gmail ;;
        2) setup_facebook ;;
        3) setup_instagram ;;
        4) setup_youtube ;;
        5) setup_search_console ;;
        6) setup_shopify ;;
        7) setup_woocommerce ;;
        8) setup_stripe ;;
        9) show_all ;;
        0) exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_menu
}

# Show all configurations
show_all() {
    setup_gmail
    setup_facebook
    setup_instagram
    setup_youtube
    setup_search_console
    setup_shopify
    setup_woocommerce
    setup_stripe
}

# Make script executable and run
chmod +x "$0"
show_menu
