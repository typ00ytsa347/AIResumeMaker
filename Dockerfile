# Stage 1: Build the frontend
FROM node:18 AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install
COPY frontend .

RUN npm run build

# Stage 2: Build the backend
FROM node:18 AS backend-builder

WORKDIR /app/backend

COPY backend/package*.json ./
RUN npm install
COPY backend .

# Stage 3: Create the final image
FROM node:18-slim

WORKDIR /app

# Copy only the necessary files from the frontend build
COPY --from=frontend-builder /app/frontend/public ./frontend/build

# Copy the backend code and other necessary files
COPY --from=backend-builder /app/backend .

# Expose the port your backend is running on
EXPOSE 3000

# Start your backend application
CMD ["npm", "start"]
