# Milestone 2 - Kubernetes Web Stack Makefile

# Variables
NAMESPACE = lm-webstack
REGISTRY = localhost:5000
TAG = latest

# Image names with LM prefix
FRONTEND_IMAGE = frontend-lm:$(TAG)
API_IMAGE = api-lm:$(TAG)
POSTGRES_IMAGE = postgres-lm:$(TAG)

# Default target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  cluster-up     - Start Kubernetes cluster (kind or minikube)"
	@echo "  cluster-down   - Stop Kubernetes cluster"
	@echo "  build          - Build all Docker images"
	@echo "  load-images    - Load images to cluster"
	@echo "  deploy         - Deploy application to Kubernetes"
	@echo "  status         - Show deployment status"
	@echo "  logs           - Show logs from all pods"
	@echo "  access-frontend - Port forward to frontend service"
	@echo "  access-api     - Port forward to API service"
	@echo "  test           - Run basic tests"
	@echo "  clean          - Remove all Kubernetes resources"
	@echo "  all            - Build, load, and deploy everything"

# Cluster management
.PHONY: cluster-up
cluster-up:
	@echo "Starting Kubernetes cluster..."
	@if command -v kind >/dev/null 2>&1; then \
		if [ "$(OS)" = "Windows_NT" ]; then \
			powershell -ExecutionPolicy Bypass -File ./scripts/kind-up.ps1; \
		else \
			./scripts/kind-up.sh; \
		fi \
	elif command -v minikube >/dev/null 2>&1; then \
		minikube start; \
	else \
		echo "Error: Neither kind nor minikube found. Please install one of them."; \
		exit 1; \
	fi

.PHONY: cluster-down
cluster-down:
	@echo "Stopping Kubernetes cluster..."
	@if command -v kind >/dev/null 2>&1; then \
		if [ "$(OS)" = "Windows_NT" ]; then \
			powershell -ExecutionPolicy Bypass -File ./scripts/kind-down.ps1; \
		else \
			./scripts/kind-down.sh; \
		fi \
	elif command -v minikube >/dev/null 2>&1; then \
		minikube stop; \
	fi

# Build Docker images
.PHONY: build
build:
	@echo "Building Docker images..."
	docker build -t $(FRONTEND_IMAGE) frontend/
	docker build -t $(API_IMAGE) api/
	docker build -t $(POSTGRES_IMAGE) db/

# Load images to cluster
.PHONY: load-images
load-images:
	@echo "Loading images to cluster..."
	@if command -v kind >/dev/null 2>&1; then \
		kind load docker-image $(FRONTEND_IMAGE); \
		kind load docker-image $(API_IMAGE); \
		kind load docker-image $(POSTGRES_IMAGE); \
	elif command -v minikube >/dev/null 2>&1; then \
		eval $$(minikube docker-env); \
		docker build -t $(FRONTEND_IMAGE) frontend/; \
		docker build -t $(API_IMAGE) api/; \
		docker build -t $(POSTGRES_IMAGE) db/; \
	fi

# Deploy to Kubernetes
.PHONY: deploy
deploy:
	@echo "Deploying to Kubernetes..."
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/postgres/
	kubectl apply -f k8s/api/
	kubectl apply -f k8s/frontend/
	@echo "Waiting for pods to be ready..."
	kubectl wait --for=condition=ready pod -l app=postgres-lm -n $(NAMESPACE) --timeout=120s
	kubectl wait --for=condition=ready pod -l app=api-lm -n $(NAMESPACE) --timeout=120s
	kubectl wait --for=condition=ready pod -l app=frontend-lm -n $(NAMESPACE) --timeout=120s

# Show status
.PHONY: status
status:
	@echo "=== Namespace ==="
	kubectl get namespace $(NAMESPACE)
	@echo ""
	@echo "=== Pods ==="
	kubectl get pods -n $(NAMESPACE)
	@echo ""
	@echo "=== Services ==="
	kubectl get services -n $(NAMESPACE)
	@echo ""
	@echo "=== PVC ==="
	kubectl get pvc -n $(NAMESPACE)

# Show logs
.PHONY: logs
logs:
	@echo "=== Frontend Logs ==="
	kubectl logs -n $(NAMESPACE) deployment/frontend-lm --tail=20
	@echo ""
	@echo "=== API Logs ==="
	kubectl logs -n $(NAMESPACE) deployment/api-lm --tail=20
	@echo ""
	@echo "=== PostgreSQL Logs ==="
	kubectl logs -n $(NAMESPACE) deployment/postgres-lm --tail=20

# Access services
.PHONY: access-frontend
access-frontend:
	@echo "Port forwarding to frontend service..."
	@echo "Access at: http://localhost:8080"
	kubectl port-forward -n $(NAMESPACE) svc/frontend-lm 8080:80

.PHONY: access-api
access-api:
	@echo "Port forwarding to API service..."
	@echo "Access at: http://localhost:8000"
	kubectl port-forward -n $(NAMESPACE) svc/api-lm 8000:8000

# Run tests
.PHONY: test
test:
	@echo "Running basic tests..."
	@echo "1. Testing API endpoints..."
	@kubectl port-forward -n $(NAMESPACE) svc/api-lm 8000:8000 &
	@sleep 5
	@curl -s http://localhost:8000/user || echo "API not ready yet"
	@curl -s -X POST http://localhost:8000/user -H "Content-Type: application/json" -d '{"name": "Test User"}' || echo "API not ready yet"
	@curl -s http://localhost:8000/container-id || echo "API not ready yet"
	@pkill -f "kubectl port-forward"

# Clean up
.PHONY: clean
clean:
	@echo "Cleaning up Kubernetes resources..."
	kubectl delete namespace $(NAMESPACE) --ignore-not-found=true
	@echo "Cleaning up Docker images..."
	docker rmi $(FRONTEND_IMAGE) $(API_IMAGE) $(POSTGRES_IMAGE) --force 2>/dev/null || true

# Complete deployment
.PHONY: all
all: build load-images deploy status

# Development helpers
.PHONY: restart-api
restart-api:
	kubectl rollout restart deployment/api-lm -n $(NAMESPACE)

.PHONY: restart-frontend
restart-frontend:
	kubectl rollout restart deployment/frontend-lm -n $(NAMESPACE)

.PHONY: describe-pods
describe-pods:
	kubectl describe pods -n $(NAMESPACE)

.PHONY: exec-api
exec-api:
	kubectl exec -it -n $(NAMESPACE) deployment/api-lm -- /bin/bash

.PHONY: exec-postgres
exec-postgres:
	kubectl exec -it -n $(NAMESPACE) deployment/postgres-lm -- psql -U postgres -d milestone2 