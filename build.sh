#!/bin/bash
# build.sh - Build script for Render deployment
# Compiles TypeScript, Tailwind CSS, and Go binary
set -e

echo "🔨 Building assets..."

# Install npm dependencies
npm install --ci --no-audit --no-fund

# Build Tailwind CSS
echo "🎨 Building Tailwind CSS..."
npm run css:build

# Build TypeScript
echo "📘 Building TypeScript..."
npm run ts:build

echo "🐹 Building Go binary..."
CGO_ENABLED=0 go build -o bin/server -ldflags="-s -w" ./cmd/web

echo "✅ Build complete!"
