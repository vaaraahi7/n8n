const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
require('dotenv').config();

const app = express();

// Security and performance middleware
app.use(helmet({
  contentSecurityPolicy: false, // n8n needs this disabled
  crossOriginEmbedderPolicy: false
}));
app.use(compression());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
  credentials: true
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0',
    environment: process.env.NODE_ENV || 'development'
  });
});

// Webhook proxy endpoints
app.all('/api/webhook/*', (req, res) => {
  const webhookPath = req.params[0];
  
  // Log webhook calls for debugging
  console.log(`Webhook called: ${webhookPath}`, {
    method: req.method,
    headers: req.headers,
    body: req.body,
    query: req.query
  });
  
  // In production, this would proxy to n8n
  // For now, return success response
  res.json({
    success: true,
    webhook: webhookPath,
    timestamp: new Date().toISOString(),
    data: req.body
  });
});

// Main n8n interface proxy
app.all('/api/n8n', (req, res) => {
  // This would proxy to n8n instance
  // For Vercel deployment, you might need to use n8n cloud or custom setup
  res.json({
    message: 'n8n interface would be proxied here',
    redirect: process.env.N8N_CLOUD_URL || 'https://app.n8n.cloud'
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not found',
    path: req.path,
    method: req.method
  });
});

const port = process.env.PORT || 3000;

if (process.env.NODE_ENV !== 'production') {
  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
    console.log(`Health check: http://localhost:${port}/api/health`);
  });
}

module.exports = app;
