# Deployment Guide - Milestone 2

## Prerequisites

Before starting, ensure you have the following tools installed:

1. **Docker Desktop** - For building and running containers
2. **kubectl** - Kubernetes command-line tool
3. **kind** or **minikube** - Local Kubernetes cluster
4. **make** - Build automation tool

### Installation Commands

#### Windows (PowerShell)
```powershell
# Install Chocolatey (if not already installed)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools
choco install docker-desktop
choco install kubernetes-cli
choco install kind
choco install make
```

#### macOS
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install tools
brew install docker
brew install kubectl
brew install kind
brew install make
```

#### Linux (Ubuntu/Debian)
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Install make
sudo apt-get install make
```

## Step-by-Step Deployment

### 1. Start Kubernetes Cluster

#### Using kind (Recommended)
```bash
# Start cluster
make cluster-up

# Verify cluster is running
kubectl cluster-info
kubectl get nodes
```

#### Using minikube (Alternative)
```bash
# Start minikube
minikube start

# Verify cluster is running
kubectl cluster-info
kubectl get nodes
```

### 2. Build Docker Images

```bash
# Build all images
make build
```

This will build:
- `frontend-lm:latest` - NGINX with static HTML
- `api-lm:latest` - FastAPI application
- `postgres-lm:latest` - PostgreSQL database

### 3. Load Images to Cluster

```bash
# Load images to cluster
make load-images
```

### 4. Deploy Application

```bash
# Deploy all components
make deploy
```

This creates:
- Namespace: `lm-webstack`
- PostgreSQL: Secret, ConfigMap, PVC, Deployment, Service
- API: ConfigMap, Deployment, Service
- Frontend: ConfigMap, Deployment, Service

### 5. Verify Deployment

```bash
# Check deployment status
make status
```

Expected output:
```
=== Namespace ===
NAME          STATUS   AGE
lm-webstack   Active   1m

=== Pods ===
NAME                          READY   STATUS    RESTARTS   AGE
api-lm-xxxxx                  1/1     Running   0          1m
frontend-lm-xxxxx             1/1     Running   0          1m
postgres-lm-xxxxx             1/1     Running   0          1m

=== Services ===
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
api-lm        ClusterIP   10.96.x.x       <none>        8000/TCP       1m
frontend-lm   NodePort    10.96.x.x       <none>        80:30000/TCP   1m
postgres-lm   ClusterIP   10.96.x.x       <none>        5432/TCP       1m

=== PVC ===
NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
postgres-pvc-lm   Bound    pvc-xxxxx                                 1Gi        RWO            standard       1m
```

## Testing the Application

### 1. Test API Endpoints

```bash
# Port forward to API service
kubectl port-forward -n lm-webstack svc/api-lm 8000:8000 &
```

In another terminal:
```bash
# Test GET /user
curl http://localhost:8000/user

# Test POST /user
curl -X POST http://localhost:8000/user \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe"}'

# Test GET /container-id
curl http://localhost:8000/container-id
```

### 2. Access Frontend

```bash
# Port forward to frontend service
kubectl port-forward -n lm-webstack svc/frontend-lm 8080:80
```

Open http://localhost:8080 in your browser.

### 3. Test Name Update Flow

1. Open the frontend in your browser
2. Note the current name displayed
3. Update the name via API:
   ```bash
   curl -X POST http://localhost:8000/user \
     -H "Content-Type: application/json" \
     -d '{"name": "New Name"}'
   ```
4. Refresh the browser page to see the updated name

## Troubleshooting

### Check Pod Logs
```bash
# API logs
kubectl logs -n lm-webstack deployment/api-lm

# Frontend logs
kubectl logs -n lm-webstack deployment/frontend-lm

# PostgreSQL logs
kubectl logs -n lm-webstack deployment/postgres-lm
```

### Check Pod Status
```bash
# Describe pods for detailed information
kubectl describe pods -n lm-webstack

# Check events
kubectl get events -n lm-webstack --sort-by='.lastTimestamp'
```

### Common Issues

#### 1. Images Not Found
```bash
# Rebuild and reload images
make build
make load-images
```

#### 2. Database Connection Issues
```bash
# Check if PostgreSQL is ready
kubectl get pods -n lm-webstack -l app=postgres-lm

# Check PostgreSQL logs
kubectl logs -n lm-webstack deployment/postgres-lm
```

#### 3. API Not Responding
```bash
# Check API pod status
kubectl get pods -n lm-webstack -l app=api-lm

# Check API logs
kubectl logs -n lm-webstack deployment/api-lm
```

#### 4. Frontend Not Loading
```bash
# Check frontend pod status
kubectl get pods -n lm-webstack -l app=frontend-lm

# Check frontend logs
kubectl logs -n lm-webstack deployment/frontend-lm
```

## Cleanup

```bash
# Remove all resources
make clean

# Stop cluster
make cluster-down
```

## Architecture Overview

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Frontend  │    │     API     │    │  Database   │
│   (NGINX)   │◄──►│  (FastAPI)  │◄──►│ (PostgreSQL)│
│  NodePort   │    │ ClusterIP   │    │ ClusterIP   │
│   Port 80   │    │  Port 8000  │    │  Port 5432  │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       │                   │                   │
       ▼                   ▼                   ▼
   Static HTML      REST API Endpoints    Persistent Data
   + API Proxy      + Database Ops        + User Table
```

## API Endpoints

| Method | Endpoint | Description | Request Body | Response |
|--------|----------|-------------|--------------|----------|
| GET | `/user` | Get current user name | - | `{"name": "..."}` |
| POST | `/user` | Update user name | `{"name": "..."}` | `{"message": "...", "name": "..."}` |
| GET | `/container-id` | Get container ID | - | `{"container_id": "..."}` |
| GET | `/health` | Health check | - | `{"status": "healthy"}` |

## Kubernetes Resources

### Namespace
- `lm-webstack`: Isolates all project resources

### PostgreSQL
- **Secret**: Database credentials
- **ConfigMap**: Database configuration
- **PVC**: 1Gi persistent storage
- **Deployment**: PostgreSQL 15 with health checks
- **Service**: ClusterIP on port 5432

### API (FastAPI)
- **ConfigMap**: Database connection settings
- **Deployment**: FastAPI with liveness/readiness probes
- **Service**: ClusterIP on port 8000

### Frontend (NGINX)
- **ConfigMap**: NGINX configuration with API proxy
- **Deployment**: NGINX serving static files
- **Service**: NodePort on port 30000 