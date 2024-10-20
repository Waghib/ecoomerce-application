# Use official Node.js 14 as base image
FROM node:16.20.2-buster-slim

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the server code
COPY . /usr/src/app/

# Expose port 3001 for the server
EXPOSE 3001

# Default command to start the application
CMD ["npm", "run", "dev"]
