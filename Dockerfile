FROM n8nio/n8n:latest

# Set working directory
WORKDIR /home/node

# Create necessary directories for Render deployment
USER root
RUN mkdir -p /home/node/.n8n/workflows /home/node/.n8n/credentials /opt/render/project/src/data

# Install curl for health checks (Alpine Linux uses apk)
RUN apk add --no-cache curl

# Copy workflows and configurations (only if they exist)
COPY workflows/ /home/node/.n8n/workflows/

# Create credentials directory (will be populated via n8n interface)
RUN mkdir -p /home/node/.n8n/credentials

# Set permissions for Render
RUN chown -R node:node /home/node/.n8n /opt/render/project/src/data

# Switch back to node user
USER node

# Expose port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5678/healthz || exit 1

# Start n8n
CMD ["n8n", "start"]
