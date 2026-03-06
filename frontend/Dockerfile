

# Multi-stage production Dockerfile for a Vite + React frontend

# -------------------------
# Stage 1: Build the app
# -------------------------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency files first for better layer caching
COPY package*.json ./

# Install dependencies reproducibly
RUN npm ci

# Copy application source
COPY . .

# Build production assets
RUN npm run build

# -------------------------
# Stage 2: Serve with Nginx
# -------------------------
FROM nginx:1.27-alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy built frontend assets
COPY --from=builder /app/dist /usr/share/nginx/html

# SPA routing support
RUN printf 'server {\n  listen 80;\n  server_name _;\n\n  root /usr/share/nginx/html;\n  index index.html;\n\n  location / {\n    try_files $uri $uri/ /index.html;\n  }\n\n  location /assets/ {\n    expires 1y;\n    add_header Cache-Control "public, immutable";\n  }\n}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


