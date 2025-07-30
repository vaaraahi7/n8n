# 🛒 Ecommerce Integration Guide

## 🎯 Overview

This guide shows how to connect your n8n automation workflows with various ecommerce platforms. The integration enables automatic order processing, customer communication, inventory management, and marketing automation.

## 🏗️ Architecture Overview

```
Your Ecommerce Website (yourstore.com)
           ↓ (webhooks)
Webhook Proxy (webhooks.yourstore.com) 
           ↓ (triggers)
n8n Automation (n8n.yourstore.com)
           ↓ (actions)
Email, Social Media, Blog, Analytics
```

## 🛍️ Platform-Specific Integrations

### 1. Shopify Integration

#### Setup Webhooks in Shopify Admin:
```bash
# Go to: Settings → Notifications → Webhooks
# Add these webhook endpoints:

Order created: https://webhooks.yourstore.com/api/webhook/new-order
Order updated: https://webhooks.yourstore.com/api/webhook/order-status-update
Order paid: https://webhooks.yourstore.com/api/webhook/order-paid
Order cancelled: https://webhooks.yourstore.com/api/webhook/order-cancelled
Customer created: https://webhooks.yourstore.com/api/webhook/new-customer
```

#### Shopify Webhook Data Format:
```javascript
// Order Created Webhook
{
  "id": 450789469,
  "email": "customer@example.com",
  "created_at": "2024-01-15T10:30:00-05:00",
  "updated_at": "2024-01-15T10:30:00-05:00",
  "number": 1001,
  "note": null,
  "token": "b1946ac92492d2347c6235b4d2611184",
  "gateway": "shopify_payments",
  "test": false,
  "total_price": "199.99",
  "subtotal_price": "179.99",
  "total_weight": 0,
  "total_tax": "20.00",
  "taxes_included": false,
  "currency": "USD",
  "financial_status": "paid",
  "confirmed": true,
  "total_discounts": "0.00",
  "buyer_accepts_marketing": true,
  "name": "#1001",
  "referring_site": "",
  "landing_site": "/",
  "cancelled_at": null,
  "cancel_reason": null,
  "reference": null,
  "user_id": null,
  "location_id": null,
  "source_identifier": null,
  "source_url": null,
  "processed_at": "2024-01-15T10:30:00-05:00",
  "device_id": null,
  "phone": "+1234567890",
  "customer_locale": "en",
  "app_id": 580111,
  "browser_ip": "192.168.1.1",
  "landing_site_ref": null,
  "order_number": 1001,
  "discount_applications": [],
  "discount_codes": [],
  "note_attributes": [],
  "payment_gateway_names": ["shopify_payments"],
  "processing_method": "direct",
  "checkout_id": 901414060,
  "source_name": "web",
  "fulfillment_status": null,
  "tax_lines": [
    {
      "price": "20.00",
      "rate": 0.1,
      "title": "Tax"
    }
  ],
  "tags": "",
  "contact_email": "customer@example.com",
  "order_status_url": "https://yourstore.myshopify.com/orders/token",
  "presentment_currency": "USD",
  "total_line_items_price": "179.99",
  "total_discounts_set": {
    "shop_money": {
      "amount": "0.00",
      "currency_code": "USD"
    }
  },
  "total_shipping_price_set": {
    "shop_money": {
      "amount": "0.00",
      "currency_code": "USD"
    }
  },
  "subtotal_price_set": {
    "shop_money": {
      "amount": "179.99",
      "currency_code": "USD"
    }
  },
  "total_price_set": {
    "shop_money": {
      "amount": "199.99",
      "currency_code": "USD"
    }
  },
  "total_tax_set": {
    "shop_money": {
      "amount": "20.00",
      "currency_code": "USD"
    }
  },
  "line_items": [
    {
      "id": 866550311766439020,
      "variant_id": 808950810,
      "title": "Premium Wallpaper Roll",
      "quantity": 2,
      "sku": "WP-001",
      "variant_title": "Floral Pattern",
      "vendor": "Your Store",
      "fulfillment_service": "manual",
      "product_id": 632910392,
      "requires_shipping": true,
      "taxable": true,
      "gift_card": false,
      "name": "Premium Wallpaper Roll - Floral Pattern",
      "variant_inventory_management": "shopify",
      "properties": [],
      "product_exists": true,
      "fulfillable_quantity": 2,
      "grams": 500,
      "price": "89.99",
      "total_discount": "0.00",
      "fulfillment_status": null,
      "price_set": {
        "shop_money": {
          "amount": "89.99",
          "currency_code": "USD"
        }
      },
      "total_discount_set": {
        "shop_money": {
          "amount": "0.00",
          "currency_code": "USD"
        }
      },
      "discount_allocations": [],
      "duties": [],
      "admin_graphql_api_id": "gid://shopify/LineItem/866550311766439020",
      "tax_lines": [
        {
          "title": "Tax",
          "price": "18.00",
          "rate": 0.1,
          "price_set": {
            "shop_money": {
              "amount": "18.00",
              "currency_code": "USD"
            }
          }
        }
      ]
    }
  ],
  "shipping_lines": [],
  "billing_address": {
    "first_name": "John",
    "address1": "123 Main St",
    "phone": "+1234567890",
    "city": "New York",
    "zip": "10001",
    "province": "New York",
    "country": "United States",
    "last_name": "Doe",
    "address2": "",
    "company": null,
    "latitude": 40.7128,
    "longitude": -74.0060,
    "name": "John Doe",
    "country_code": "US",
    "province_code": "NY"
  },
  "shipping_address": {
    "first_name": "John",
    "address1": "123 Main St",
    "phone": "+1234567890",
    "city": "New York",
    "zip": "10001",
    "province": "New York",
    "country": "United States",
    "last_name": "Doe",
    "address2": "",
    "company": null,
    "latitude": 40.7128,
    "longitude": -74.0060,
    "name": "John Doe",
    "country_code": "US",
    "province_code": "NY"
  },
  "fulfillments": [],
  "client_details": {
    "browser_ip": "192.168.1.1",
    "accept_language": "en-US,en;q=0.9",
    "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    "session_hash": null,
    "browser_width": 1920,
    "browser_height": 1080
  },
  "refunds": [],
  "customer": {
    "id": 207119551,
    "email": "customer@example.com",
    "accepts_marketing": true,
    "created_at": "2024-01-01T00:00:00-05:00",
    "updated_at": "2024-01-15T10:30:00-05:00",
    "first_name": "John",
    "last_name": "Doe",
    "orders_count": 1,
    "state": "enabled",
    "total_spent": "199.99",
    "last_order_id": 450789469,
    "note": null,
    "verified_email": true,
    "multipass_identifier": null,
    "tax_exempt": false,
    "phone": "+1234567890",
    "tags": "",
    "last_order_name": "#1001",
    "currency": "USD",
    "addresses": [
      {
        "id": 207119551,
        "customer_id": 207119551,
        "first_name": "John",
        "last_name": "Doe",
        "company": null,
        "address1": "123 Main St",
        "address2": "",
        "city": "New York",
        "province": "New York",
        "country": "United States",
        "zip": "10001",
        "phone": "+1234567890",
        "name": "John Doe",
        "province_code": "NY",
        "country_code": "US",
        "country_name": "United States",
        "default": true
      }
    ],
    "accepts_marketing_updated_at": "2024-01-01T00:00:00-05:00",
    "marketing_opt_in_level": "single_opt_in",
    "tax_exemptions": [],
    "admin_graphql_api_id": "gid://shopify/Customer/207119551",
    "default_address": {
      "id": 207119551,
      "customer_id": 207119551,
      "first_name": "John",
      "last_name": "Doe",
      "company": null,
      "address1": "123 Main St",
      "address2": "",
      "city": "New York",
      "province": "New York",
      "country": "United States",
      "zip": "10001",
      "phone": "+1234567890",
      "name": "John Doe",
      "province_code": "NY",
      "country_code": "US",
      "country_name": "United States",
      "default": true
    }
  }
}
```

### 2. WooCommerce Integration

#### Add Webhook Code to functions.php:
```php
<?php
// Add to your theme's functions.php or create a custom plugin

// Hook into WooCommerce order events
add_action('woocommerce_new_order', 'send_new_order_webhook', 10, 1);
add_action('woocommerce_order_status_changed', 'send_order_status_webhook', 10, 4);
add_action('woocommerce_payment_complete', 'send_payment_complete_webhook', 10, 1);

function send_new_order_webhook($order_id) {
    $order = wc_get_order($order_id);
    if (!$order) return;
    
    $webhook_url = 'https://webhooks.yourstore.com/api/webhook/new-order';
    
    $order_data = array(
        'order_id' => $order_id,
        'order_number' => $order->get_order_number(),
        'status' => $order->get_status(),
        'created_date' => $order->get_date_created()->format('c'),
        'total' => floatval($order->get_total()),
        'subtotal' => floatval($order->get_subtotal()),
        'tax_total' => floatval($order->get_total_tax()),
        'shipping_total' => floatval($order->get_shipping_total()),
        'currency' => $order->get_currency(),
        'payment_method' => $order->get_payment_method(),
        'payment_method_title' => $order->get_payment_method_title(),
        'customer' => array(
            'id' => $order->get_customer_id(),
            'email' => $order->get_billing_email(),
            'first_name' => $order->get_billing_first_name(),
            'last_name' => $order->get_billing_last_name(),
            'phone' => $order->get_billing_phone(),
        ),
        'billing_address' => array(
            'first_name' => $order->get_billing_first_name(),
            'last_name' => $order->get_billing_last_name(),
            'company' => $order->get_billing_company(),
            'address_1' => $order->get_billing_address_1(),
            'address_2' => $order->get_billing_address_2(),
            'city' => $order->get_billing_city(),
            'state' => $order->get_billing_state(),
            'postcode' => $order->get_billing_postcode(),
            'country' => $order->get_billing_country(),
            'email' => $order->get_billing_email(),
            'phone' => $order->get_billing_phone(),
        ),
        'shipping_address' => array(
            'first_name' => $order->get_shipping_first_name(),
            'last_name' => $order->get_shipping_last_name(),
            'company' => $order->get_shipping_company(),
            'address_1' => $order->get_shipping_address_1(),
            'address_2' => $order->get_shipping_address_2(),
            'city' => $order->get_shipping_city(),
            'state' => $order->get_shipping_state(),
            'postcode' => $order->get_shipping_postcode(),
            'country' => $order->get_shipping_country(),
        ),
        'line_items' => array(),
        'shipping_lines' => array(),
        'tax_lines' => array(),
        'coupon_lines' => array()
    );
    
    // Add line items
    foreach ($order->get_items() as $item_id => $item) {
        $product = $item->get_product();
        $order_data['line_items'][] = array(
            'id' => $item_id,
            'name' => $item->get_name(),
            'product_id' => $item->get_product_id(),
            'variation_id' => $item->get_variation_id(),
            'quantity' => $item->get_quantity(),
            'tax_class' => $item->get_tax_class(),
            'subtotal' => $item->get_subtotal(),
            'subtotal_tax' => $item->get_subtotal_tax(),
            'total' => $item->get_total(),
            'total_tax' => $item->get_total_tax(),
            'price' => floatval($product ? $product->get_price() : 0),
            'sku' => $product ? $product->get_sku() : '',
            'meta_data' => $item->get_meta_data()
        );
    }
    
    // Add shipping lines
    foreach ($order->get_items('shipping') as $item_id => $item) {
        $order_data['shipping_lines'][] = array(
            'id' => $item_id,
            'method_title' => $item->get_method_title(),
            'method_id' => $item->get_method_id(),
            'total' => $item->get_total(),
            'total_tax' => $item->get_total_tax(),
            'meta_data' => $item->get_meta_data()
        );
    }
    
    // Send webhook
    wp_remote_post($webhook_url, array(
        'method' => 'POST',
        'timeout' => 30,
        'headers' => array(
            'Content-Type' => 'application/json',
            'X-WC-Webhook-Source' => get_bloginfo('url'),
            'X-WC-Webhook-Topic' => 'order.created',
            'X-WC-Webhook-Resource' => 'order',
            'X-WC-Webhook-Event' => 'created',
            'X-WC-Webhook-Signature' => base64_encode(hash_hmac('sha256', json_encode($order_data), 'your-webhook-secret', true)),
            'X-WC-Webhook-ID' => $order_id,
            'X-WC-Webhook-Delivery-ID' => wp_generate_uuid4()
        ),
        'body' => json_encode($order_data),
        'data_format' => 'body'
    ));
}

function send_order_status_webhook($order_id, $old_status, $new_status, $order) {
    $webhook_url = 'https://webhooks.yourstore.com/api/webhook/order-status-update';
    
    $status_data = array(
        'order_id' => $order_id,
        'order_number' => $order->get_order_number(),
        'old_status' => $old_status,
        'new_status' => $new_status,
        'status_changed_date' => current_time('c'),
        'customer_email' => $order->get_billing_email(),
        'customer_name' => $order->get_billing_first_name() . ' ' . $order->get_billing_last_name(),
        'total' => floatval($order->get_total()),
        'currency' => $order->get_currency()
    );
    
    wp_remote_post($webhook_url, array(
        'method' => 'POST',
        'timeout' => 30,
        'headers' => array(
            'Content-Type' => 'application/json',
            'X-WC-Webhook-Source' => get_bloginfo('url'),
            'X-WC-Webhook-Topic' => 'order.updated'
        ),
        'body' => json_encode($status_data)
    ));
}

function send_payment_complete_webhook($order_id) {
    $order = wc_get_order($order_id);
    if (!$order) return;
    
    $webhook_url = 'https://webhooks.yourstore.com/api/webhook/order-paid';
    
    $payment_data = array(
        'order_id' => $order_id,
        'order_number' => $order->get_order_number(),
        'payment_complete_date' => current_time('c'),
        'payment_method' => $order->get_payment_method(),
        'payment_method_title' => $order->get_payment_method_title(),
        'transaction_id' => $order->get_transaction_id(),
        'total' => floatval($order->get_total()),
        'currency' => $order->get_currency(),
        'customer_email' => $order->get_billing_email(),
        'customer_name' => $order->get_billing_first_name() . ' ' . $order->get_billing_last_name()
    );
    
    wp_remote_post($webhook_url, array(
        'method' => 'POST',
        'timeout' => 30,
        'headers' => array(
            'Content-Type' => 'application/json',
            'X-WC-Webhook-Source' => get_bloginfo('url'),
            'X-WC-Webhook-Topic' => 'order.payment_complete'
        ),
        'body' => json_encode($payment_data)
    ));
}

// Add webhook for new customer registration
add_action('user_register', 'send_new_customer_webhook', 10, 1);

function send_new_customer_webhook($user_id) {
    $user = get_userdata($user_id);
    if (!$user) return;
    
    $webhook_url = 'https://webhooks.yourstore.com/api/webhook/new-customer';
    
    $customer_data = array(
        'customer_id' => $user_id,
        'email' => $user->user_email,
        'first_name' => get_user_meta($user_id, 'first_name', true),
        'last_name' => get_user_meta($user_id, 'last_name', true),
        'username' => $user->user_login,
        'date_created' => $user->user_registered,
        'billing_address' => array(
            'first_name' => get_user_meta($user_id, 'billing_first_name', true),
            'last_name' => get_user_meta($user_id, 'billing_last_name', true),
            'company' => get_user_meta($user_id, 'billing_company', true),
            'address_1' => get_user_meta($user_id, 'billing_address_1', true),
            'address_2' => get_user_meta($user_id, 'billing_address_2', true),
            'city' => get_user_meta($user_id, 'billing_city', true),
            'state' => get_user_meta($user_id, 'billing_state', true),
            'postcode' => get_user_meta($user_id, 'billing_postcode', true),
            'country' => get_user_meta($user_id, 'billing_country', true),
            'email' => get_user_meta($user_id, 'billing_email', true),
            'phone' => get_user_meta($user_id, 'billing_phone', true)
        )
    );
    
    wp_remote_post($webhook_url, array(
        'method' => 'POST',
        'timeout' => 30,
        'headers' => array(
            'Content-Type' => 'application/json',
            'X-WC-Webhook-Source' => get_bloginfo('url'),
            'X-WC-Webhook-Topic' => 'customer.created'
        ),
        'body' => json_encode($customer_data)
    ));
}
?>
```

### 3. Magento Integration

#### Create Custom Module for Webhooks:
```php
<?php
// app/code/YourStore/WebhookIntegration/Observer/OrderSaveAfter.php

namespace YourStore\WebhookIntegration\Observer;

use Magento\Framework\Event\ObserverInterface;
use Magento\Framework\Event\Observer;
use Magento\Framework\HTTP\Client\Curl;
use Magento\Framework\Serialize\Serializer\Json;

class OrderSaveAfter implements ObserverInterface
{
    protected $curl;
    protected $json;
    
    public function __construct(
        Curl $curl,
        Json $json
    ) {
        $this->curl = $curl;
        $this->json = $json;
    }
    
    public function execute(Observer $observer)
    {
        $order = $observer->getEvent()->getOrder();
        
        if ($order->getState() === 'new') {
            $this->sendNewOrderWebhook($order);
        }
        
        if ($order->getOrigData('state') !== $order->getState()) {
            $this->sendStatusUpdateWebhook($order);
        }
    }
    
    private function sendNewOrderWebhook($order)
    {
        $webhookUrl = 'https://webhooks.yourstore.com/api/webhook/new-order';
        
        $orderData = [
            'order_id' => $order->getId(),
            'increment_id' => $order->getIncrementId(),
            'status' => $order->getStatus(),
            'state' => $order->getState(),
            'created_at' => $order->getCreatedAt(),
            'total' => $order->getGrandTotal(),
            'subtotal' => $order->getSubtotal(),
            'tax_amount' => $order->getTaxAmount(),
            'shipping_amount' => $order->getShippingAmount(),
            'currency' => $order->getOrderCurrencyCode(),
            'customer' => [
                'id' => $order->getCustomerId(),
                'email' => $order->getCustomerEmail(),
                'first_name' => $order->getCustomerFirstname(),
                'last_name' => $order->getCustomerLastname()
            ],
            'billing_address' => $this->getAddressData($order->getBillingAddress()),
            'shipping_address' => $this->getAddressData($order->getShippingAddress()),
            'items' => $this->getOrderItems($order)
        ];
        
        $this->sendWebhook($webhookUrl, $orderData);
    }
    
    private function sendStatusUpdateWebhook($order)
    {
        $webhookUrl = 'https://webhooks.yourstore.com/api/webhook/order-status-update';
        
        $statusData = [
            'order_id' => $order->getId(),
            'increment_id' => $order->getIncrementId(),
            'old_status' => $order->getOrigData('status'),
            'new_status' => $order->getStatus(),
            'old_state' => $order->getOrigData('state'),
            'new_state' => $order->getState(),
            'updated_at' => $order->getUpdatedAt(),
            'customer_email' => $order->getCustomerEmail(),
            'total' => $order->getGrandTotal()
        ];
        
        $this->sendWebhook($webhookUrl, $statusData);
    }
    
    private function getAddressData($address)
    {
        if (!$address) return null;
        
        return [
            'first_name' => $address->getFirstname(),
            'last_name' => $address->getLastname(),
            'company' => $address->getCompany(),
            'street' => $address->getStreet(),
            'city' => $address->getCity(),
            'region' => $address->getRegion(),
            'postcode' => $address->getPostcode(),
            'country_id' => $address->getCountryId(),
            'telephone' => $address->getTelephone()
        ];
    }
    
    private function getOrderItems($order)
    {
        $items = [];
        foreach ($order->getAllVisibleItems() as $item) {
            $items[] = [
                'item_id' => $item->getId(),
                'product_id' => $item->getProductId(),
                'sku' => $item->getSku(),
                'name' => $item->getName(),
                'quantity' => $item->getQtyOrdered(),
                'price' => $item->getPrice(),
                'total' => $item->getRowTotal()
            ];
        }
        return $items;
    }
    
    private function sendWebhook($url, $data)
    {
        try {
            $this->curl->setOption(CURLOPT_TIMEOUT, 30);
            $this->curl->addHeader('Content-Type', 'application/json');
            $this->curl->post($url, $this->json->serialize($data));
        } catch (\Exception $e) {
            // Log error
            error_log('Webhook error: ' . $e->getMessage());
        }
    }
}
```

### 4. Custom Ecommerce Platform Integration

#### JavaScript/Node.js Example:
```javascript
// webhook-sender.js
const axios = require('axios');

class WebhookSender {
    constructor(baseUrl, secret = null) {
        this.baseUrl = baseUrl;
        this.secret = secret;
    }
    
    async sendOrderWebhook(orderData, event = 'created') {
        const webhookUrl = `${this.baseUrl}/api/webhook/new-order`;
        
        const payload = {
            ...orderData,
            event: event,
            timestamp: new Date().toISOString(),
            source: 'custom-ecommerce'
        };
        
        try {
            const response = await axios.post(webhookUrl, payload, {
                headers: {
                    'Content-Type': 'application/json',
                    'X-Webhook-Event': event,
                    'X-Webhook-Source': 'custom-ecommerce',
                    ...(this.secret && {
                        'X-Webhook-Signature': this.generateSignature(payload)
                    })
                },
                timeout: 30000
            });
            
            console.log('Webhook sent successfully:', response.status);
            return response.data;
        } catch (error) {
            console.error('Webhook error:', error.message);
            throw error;
        }
    }
    
    async sendCustomerWebhook(customerData, event = 'created') {
        const webhookUrl = `${this.baseUrl}/api/webhook/new-customer`;
        
        const payload = {
            ...customerData,
            event: event,
            timestamp: new Date().toISOString(),
            source: 'custom-ecommerce'
        };
        
        return this.sendWebhook(webhookUrl, payload, event);
    }
    
    async sendLeadWebhook(leadData) {
        const webhookUrl = `${this.baseUrl}/api/webhook/new-lead`;
        
        const payload = {
            ...leadData,
            timestamp: new Date().toISOString(),
            source: 'website'
        };
        
        return this.sendWebhook(webhookUrl, payload, 'lead_generated');
    }
    
    async sendWebhook(url, payload, event) {
        try {
            const response = await axios.post(url, payload, {
                headers: {
                    'Content-Type': 'application/json',
                    'X-Webhook-Event': event,
                    'X-Webhook-Source': 'custom-ecommerce',
                    ...(this.secret && {
                        'X-Webhook-Signature': this.generateSignature(payload)
                    })
                },
                timeout: 30000
            });
            
            console.log(`Webhook sent successfully (${event}):`, response.status);
            return response.data;
        } catch (error) {
            console.error(`Webhook error (${event}):`, error.message);
            throw error;
        }
    }
    
    generateSignature(payload) {
        const crypto = require('crypto');
        const payloadString = JSON.stringify(payload);
        return crypto.createHmac('sha256', this.secret).update(payloadString).digest('hex');
    }
}

// Usage example
const webhookSender = new WebhookSender('https://webhooks.yourstore.com', 'your-webhook-secret');

// Send order webhook
const orderData = {
    order_id: 'ORD-12345',
    customer_email: 'customer@example.com',
    customer_name: 'John Doe',
    total: 199.99,
    currency: 'USD',
    status: 'confirmed',
    items: [
        {
            name: 'Premium Wallpaper',
            quantity: 2,
            price: 89.99,
            category: 'wallpapers'
        },
        {
            name: 'Modern Lamp',
            quantity: 1,
            price: 109.99,
            category: 'furniture'
        }
    ],
    shipping_address: {
        street: '123 Main St',
        city: 'New York',
        state: 'NY',
        zip: '10001',
        country: 'US'
    }
};

webhookSender.sendOrderWebhook(orderData, 'created');

// Send customer webhook
const customerData = {
    customer_id: 'CUST-67890',
    email: 'newcustomer@example.com',
    first_name: 'Jane',
    last_name: 'Smith',
    phone: '+1234567890',
    accepts_marketing: true,
    registration_source: 'website'
};

webhookSender.sendCustomerWebhook(customerData, 'created');

// Send lead webhook
const leadData = {
    email: 'lead@example.com',
    name: 'Potential Customer',
    source: 'organic',
    pages_visited: 5,
    time_on_site: 300,
    viewed_pricing: true,
    interests: ['wallpapers', 'home-decor']
};

webhookSender.sendLeadWebhook(leadData);

module.exports = WebhookSender;
```

## 🔧 Testing Your Integration

### 1. Test Webhook Endpoints
```bash
# Test order webhook
curl -X POST https://webhooks.yourstore.com/api/webhook/new-order \
  -H "Content-Type: application/json" \
  -d '{
    "order_id": "TEST-001",
    "customer_email": "test@example.com",
    "total": 99.99,
    "status": "confirmed"
  }'

# Test customer webhook
curl -X POST https://webhooks.yourstore.com/api/webhook/new-customer \
  -H "Content-Type: application/json" \
  -d '{
    "customer_id": "CUST-001",
    "email": "newcustomer@example.com",
    "first_name": "Test",
    "last_name": "Customer"
  }'

# Test lead webhook
curl -X POST https://webhooks.yourstore.com/api/webhook/new-lead \
  -H "Content-Type: application/json" \
  -d '{
    "email": "lead@example.com",
    "source": "organic",
    "pages_visited": 3
  }'
```

### 2. Monitor Webhook Delivery
```javascript
// Add webhook logging to your ecommerce platform
const logWebhookDelivery = (url, payload, response) => {
    console.log('Webhook Delivery Log:', {
        timestamp: new Date().toISOString(),
        url: url,
        payload_size: JSON.stringify(payload).length,
        response_status: response.status,
        response_time: response.responseTime,
        success: response.status >= 200 && response.status < 300
    });
};
```

## 🔒 Security Best Practices

### 1. Webhook Signature Verification
```javascript
// Verify webhook signatures
const crypto = require('crypto');

const verifyWebhookSignature = (payload, signature, secret) => {
    const expectedSignature = crypto
        .createHmac('sha256', secret)
        .update(JSON.stringify(payload))
        .digest('hex');
    
    return crypto.timingSafeEqual(
        Buffer.from(signature, 'hex'),
        Buffer.from(expectedSignature, 'hex')
    );
};
```

### 2. Rate Limiting
```javascript
// Implement rate limiting for webhook endpoints
const rateLimit = require('express-rate-limit');

const webhookLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // limit each IP to 100 requests per windowMs
    message: 'Too many webhook requests from this IP'
});

app.use('/api/webhook', webhookLimiter);
```

### 3. IP Whitelisting
```javascript
// Whitelist known ecommerce platform IPs
const allowedIPs = [
    '127.0.0.1', // localhost for testing
    // Add your ecommerce platform IPs
];

const ipWhitelist = (req, res, next) => {
    const clientIP = req.ip || req.connection.remoteAddress;
    
    if (allowedIPs.includes(clientIP)) {
        next();
    } else {
        res.status(403).json({ error: 'IP not allowed' });
    }
};

app.use('/api/webhook', ipWhitelist);
```

This integration guide provides everything you need to connect your ecommerce platform with the n8n automation system, enabling powerful automated workflows for order processing, customer communication, and marketing automation!
