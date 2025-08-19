#!/bin/bash

# Print Kubernetes cluster configuration

echo "=== Kubernetes Cluster Configuration ==="
echo ""

echo "Cluster Info:"
kubectl cluster-info
echo ""

echo "Nodes:"
kubectl get nodes -o wide
echo ""

echo "Context:"
kubectl config current-context
echo ""

echo "Namespaces:"
kubectl get namespaces
echo ""

echo "Storage Classes:"
kubectl get storageclass
echo ""

echo "=== End Configuration ===" 