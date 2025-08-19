#!/bin/bash

# Stop kind cluster for Milestone 2

set -e

echo "Stopping kind cluster..."

# Delete cluster
kind delete cluster --name milestone2

echo "Kind cluster 'milestone2' has been stopped." 