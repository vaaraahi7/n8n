#!/bin/bash

# n8n Ecommerce Automation Deployment Script
# Optimized for free plan usage

set -e

# Make script executable
chmod +x "$0"

echo "🚀 Starting n8n Ecommerce Automation Setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
check_docker() {
    print_status "Checking Docker installation..."
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Docker and Docker Compose are installed"
}

# Create necessary directories
create_directories() {
    print_status "Creating necessary directories..."
    
    mkdir -p nginx/ssl
    mkdir -p nginx/logs
    mkdir -p workflows
    mkdir -p credentials
    
    print_success "Directories created"
}

# Setup environment file
setup_environment() {
    print_status "Setting up environment configuration..."
    
    if [ ! -f .env ]; then
        cp .env.example .env
        print_warning "Please edit .env file with your actual credentials before starting n8n"
        print_warning "Important: Update the following in .env:"
        echo "  - N8N_PASSWORD (change from default)"
        echo "  - SMTP credentials for Gmail"
        echo "  - Domain name for your subdomain"
        echo "  - Social media API keys"
        echo "  - Ecommerce platform credentials"
    else
        print_success "Environment file already exists"
    fi
}

# Generate SSL certificates (self-signed for development)
generate_ssl() {
    print_status "Generating SSL certificates..."
    
    if [ ! -f nginx/ssl/cert.pem ]; then
        print_warning "Generating self-signed SSL certificate for development"
        print_warning "For production, replace with proper SSL certificates"
        
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout nginx/ssl/key.pem \
            -out nginx/ssl/cert.pem \
            -subj "/C=US/ST=State/L=City/O=Organization/CN=n8n.yourdomain.com"
        
        print_success "Self-signed SSL certificate generated"
    else
        print_success "SSL certificates already exist"
    fi
}

# Setup free plan optimized workflows
setup_workflows() {
    print_status "Setting up free plan optimized workflows..."
    
    # Create essential combined workflow for free plan
    cat > workflows/essential-ecommerce-free.json << 'EOF'
{
  "name": "Essential Ecommerce (Free Plan Optimized)",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "ecommerce-events",
        "options": {}
      },
      "name": "Ecommerce Events Webhook",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "position": [240, 300],
      "webhookId": "ecommerce-events"
    },
    {
      "parameters": {
        "functionCode": "// Event Router for Free Plan Optimization\nconst event = $json;\nconst eventType = event.type || event.event_type;\n\n// Route different events to appropriate handlers\nswitch(eventType) {\n  case 'order_created':\n  case 'order_confirmed':\n    return [{ json: { ...event, action: 'process_order' } }];\n  \n  case 'order_shipped':\n    return [{ json: { ...event, action: 'send_shipping_notification' } }];\n  \n  case 'order_delivered':\n    return [{ json: { ...event, action: 'send_delivery_confirmation' } }];\n  \n  case 'new_lead':\n    return [{ json: { ...event, action: 'process_lead' } }];\n  \n  case 'low_stock':\n    return [{ json: { ...event, action: 'stock_alert' } }];\n  \n  default:\n    return [{ json: { ...event, action: 'log_event' } }];\n}"
      },
      "name": "Event Router",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [460, 300]
    },
    {
      "parameters": {
        "rule": {
          "interval": [
            {
              "field": "cronExpression",
              "value": "0 18 * * *"
            }
          ]
        }
      },
      "name": "Daily Summary",
      "type": "n8n-nodes-base.cron",
      "typeVersion": 1,
      "position": [240, 600]
    }
  ],
  "connections": {
    "Ecommerce Events Webhook": {
      "main": [
        [
          {
            "node": "Event Router",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "active": false,
  "settings": {},
  "id": "essential-ecommerce-free"
}
EOF

    print_success "Essential workflow template created"
}

# Start services
start_services() {
    print_status "Starting n8n services..."
    
    # Pull latest images
    docker-compose pull
    
    # Start services
    docker-compose up -d
    
    print_success "Services started successfully"
    
    # Wait for services to be ready
    print_status "Waiting for services to be ready..."
    sleep 30
    
    # Check if n8n is responding
    if curl -f -s http://localhost:5678/healthz > /dev/null; then
        print_success "n8n is running and healthy"
    else
        print_warning "n8n might still be starting up. Please check logs if issues persist."
    fi
}

# Display access information
show_access_info() {
    echo ""
    echo "🎉 n8n Ecommerce Automation Setup Complete!"
    echo ""
    echo "📋 Access Information:"
    echo "  • Local URL: http://localhost:5678"
    echo "  • Production URL: https://n8n.yourdomain.com (after DNS setup)"
    echo "  • Default Login: admin / changeme123 (change in .env)"
    echo ""
    echo "📁 Important Files:"
    echo "  • Configuration: .env"
    echo "  • Workflows: workflows/"
    echo "  • SSL Certificates: nginx/ssl/"
    echo ""
    echo "🔧 Next Steps:"
    echo "  1. Edit .env with your actual credentials"
    echo "  2. Update domain name in nginx/nginx.conf"
    echo "  3. Set up DNS for your subdomain"
    echo "  4. Replace self-signed SSL with proper certificates"
    echo "  5. Import and activate workflows in n8n interface"
    echo ""
    echo "📖 Documentation:"
    echo "  • Setup Guide: README.md"
    echo "  • Free Plan Optimization: free-plan-optimization.md"
    echo "  • Workflow Templates: workflows/"
    echo ""
    echo "🆓 Free Plan Reminders:"
    echo "  • Maximum 2 active workflows"
    echo "  • 5,000 executions per month"
    echo "  • Start with essential workflows first"
    echo ""
    echo "🔍 Monitoring:"
    echo "  • Check logs: docker-compose logs -f"
    echo "  • Monitor usage in n8n dashboard"
    echo "  • Set up alerts at 80% execution usage"
    echo ""
}

# Main execution
main() {
    echo "🏪 n8n Ecommerce Automation Setup"
    echo "=================================="
    echo ""
    
    check_docker
    create_directories
    setup_environment
    generate_ssl
    setup_workflows
    start_services
    show_access_info
    
    echo ""
    print_success "Setup completed successfully! 🚀"
    echo ""
    print_warning "Remember to:"
    echo "  1. Update .env with real credentials"
    echo "  2. Configure your domain DNS"
    echo "  3. Import workflows in n8n interface"
    echo "  4. Test all integrations"
    echo ""
}

# Run main function
main "$@"
