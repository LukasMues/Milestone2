#!/bin/bash

# Start kind cluster for Milestone 2

set -e

echo "Starting kind cluster..."

# Create kind cluster configuration
cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30000
    hostPort: 30000
    protocol: TCP
- role: worker
EOF

# Create cluster
kind create cluster --name milestone2 --config kind-config.yaml

# Wait for cluster to be ready
echo "Waiting for cluster to be ready..."
kubectl wait --for=condition=ready node --all --timeout=120s

# Show cluster info
echo "Cluster is ready!"
kubectl cluster-info
kubectl get nodes

# Clean up config file
rm -f kind-config.yaml

echo "Kind cluster 'milestone2' is running."
echo "To stop the cluster, run: ./scripts/kind-down.sh" 