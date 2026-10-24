# --- Stage 1: build the frontend ---
FROM node:22-bookworm-slim AS frontend-build
WORKDIR /app/frontend

COPY frontend/package.json frontend/package-lock.json ./
RUN npm install --no-audit --no-fund --legacy-peer-deps

COPY frontend/ ./
ENV VITE_API_URL=
ARG VITE_CLERK_PUBLISHABLE_KEY
ENV VITE_CLERK_PUBLISHABLE_KEY=$VITE_CLERK_PUBLISHABLE_KEY
RUN npm run build

# --- Stage 2: build the API bundle (if applicable) ---
FROM node:22-bookworm-slim AS backend-build
WORKDIR /app/backend

COPY backend/package.json backend/package-lock.json ./
RUN npm install --no-audit --no-fund

COPY backend/ ./
RUN npm run build

# --- Stage 3: runtime image ---
FROM node:22-bookworm-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3001

# Copy backend dependencies setup
COPY backend/package.json backend/package-lock.json ./
RUN npm install --omit=dev --no-audit --no-fund && npm cache clean --force

# Copy compiled backend output (adjust 'dir' if your build outputs to 'dist' or 'build')
COPY --from=backend-build /app/backend/dir ./dir

# Copy built frontend assets into the backend or static serving path 
# (Assuming your backend serves the frontend from a 'public' or static folder)
COPY --from=frontend-build /app/frontend/dist ./public

EXPOSE 3001
USER node

CMD ["node", "dir/index.js"]