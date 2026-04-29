# STAGE 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
RUN apk add --no-cache curl
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]

# STAGE 2: Runtime 
FROM builder 

# Set environment to production 
ENV NODE_ENV=production 

WORKDIR /app 

# Copy only the necessary production files from the builder stage 
COPY --from=builder /app/package*.json ./ 
COPY --from=builder /app/node_modules ./node_modules 
COPY --from=builder /app/public ./public 
COPY --from=builder /app/views ./views 
COPY --from=builder /app/routes ./routes 
COPY --from=builder /app/models ./models 
COPY --from=builder /app/config ./config 
COPY --from=builder /app/server.js ./server.js 

# Expose the port the app runs on (usually 3000 or 8080) 
EXPOSE 3000 
CMD ["node", "server.js"]
