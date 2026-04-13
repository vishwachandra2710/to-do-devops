# ---------- 1️⃣ Build Stage ----------
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only package files first (for caching)
COPY package.json package-lock.json* ./

# Install dependencies (stable + avoids conflicts)
RUN npm ci --legacy-peer-deps

# Copy rest of the code
COPY . .

# Build the Vite app
RUN npm run build

# ---------- 2️⃣ Production Stage ----------
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]