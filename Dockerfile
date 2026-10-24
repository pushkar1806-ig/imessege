# --- Stage 1: build the Frontend ---
FROM node:22-bookworm-slim AS Frontend-build
WORKDIR /app/Frontend

COPY Frontend/package.json Frontend/package-lock.json ./
RUN npm install --no-audit --no-fund --legacy-peer-deps

COPY Frontend/ ./
ENV VITE_API_URL=
ARG VITE_CLERK_PUBLISHABLE_KEY
ENV VITE_CLERK_PUBLISHABLE_KEY=$VITE_CLERK_PUBLISHABLE_KEY
RUN npm run build

# --- Stage 2: build the API bundle ---
FROM node:22-bookworm-slim AS bacFkend-build
WORKDIR /app/Backend

COPY Backend/package.json Backend/package-lock.json ./
RUN npm install --no-audit --no-fund

COPY Backend/./ ./
RUN npm run build

# --- Stage 3: runtime image ---
FROM node:22-bookworm-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3001

COPY Backend/package.json Backend/package-lock.json ./
RUN npm install --omit=dev --no-audit --no-fund && npm cache clean --force

COPY --from=Backend-build /app/Backend/dist ./dist
COPY --from=Frontend-build /app/Frontend/dist ./public

EXPOSE 3001
USER node

CMD ["node", "dist/index.js"]