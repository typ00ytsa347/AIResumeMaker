# Stage 1: Build the backend
FROM node:18 AS backend-builder

WORKDIR /app/backend

COPY backend/package*.json ./
RUN npm install
COPY backend .

# Stage 2: Create a production image for the backend
FROM node:18-slim

WORKDIR /app/backend

COPY --from=backend-builder /app/backend .

EXPOSE 3000

CMD ["npm", "start"]
