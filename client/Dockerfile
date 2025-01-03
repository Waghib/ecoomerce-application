# Use official Node.js 16 as base image
FROM node:16.20.2-buster-slim as build

# Set working directory
WORKDIR /usr/src/app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y \
    python \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies and install cross-env globally to avoid permission issues
RUN npm install -g cross-env && npm install

# Copy the rest of the client code
COPY . .

# Move .env.example to .env
RUN mv .env.example .env

# Build the client for production
RUN npm run build

# Use official NGINX for serving the build
FROM nginx:alpine

# Copy the build artifacts from the build stage
COPY --from=build /usr/src/app/dist /usr/share/nginx/html

# Copy the NGINX config template
COPY nginx.conf.template /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
