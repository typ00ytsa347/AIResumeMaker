# Stage 1: Build the frontend
FROM node:18 AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install
COPY frontend .

# Set an ARG for the backend API URL (this won't modify the .env file)
ARG VITE_BACKEND_API_URL
ENV VITE_BACKEND_API_URL=$VITE_BACKEND_API_URL

# Create a modified .env file and copy it into the container
RUN echo "VITE_BACKEND_API_URL=$VITE_BACKEND_API_URL" > .env

RUN npm run build

# Stage 2: Create a lightweight production image for the frontend
FROM nginx:alpine

# Copy the build files from the previous stage
COPY --from=frontend-builder /app/frontend/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

## Start Nginx with the CMD
#CMD ["nginx", "-g", "daemon off;"]
