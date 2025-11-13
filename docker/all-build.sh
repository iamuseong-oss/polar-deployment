#!/bin/bash

services=("catalog-service" "order-service" "dispatcher-service" "edge-service")

for service in "${services[@]}"; do
  echo "🔧 Building image for $service..."
  (
    cd "../../$service" || { echo "❌ Failed to enter $service"; exit 1; }
    ./gradlew bootBuildImage || { echo "❌ Build failed for $service"; exit 1; }
  )
  echo "✅ Finished building $service"
done

echo "🎉 All services built successfully!"