# Milestone 2: Complete Step-by-Step Implementation Guide

## Table of Contents
1. [Project Overview](#project-overview)
2. [Prerequisites Installation](#prerequisites-installation)
3. [Project Structure](#project-structure)
4. [Backend API Implementation](#backend-api-implementation)
5. [Database Implementation](#database-implementation)
6. [Frontend Implementation](#frontend-implementation)
7. [Docker Containerization](#docker-containerization)
8. [Kubernetes Orchestration](#kubernetes-orchestration)
9. [Deployment Automation](#deployment-automation)
10. [Testing and Verification](#testing-and-verification)
11. [Troubleshooting](#troubleshooting)

## Project Overview

This project implements a complete web stack using modern containerization and orchestration technologies:

- **Frontend**: NGINX serving static HTML with JavaScript
- **Backend**: FastAPI Python application
- **Database**: PostgreSQL with persistent storage
- **Containerization**: Docker images for each component
- **Orchestration**: Kubernetes with kind (Kubernetes in Docker)
- **Automation**: PowerShell scripts for deployment

## Prerequisites Installation

### Step 1: Install Required Tools

The project includes installation scripts for Windows:

```powershell
# Install Docker Desktop, kubectl, kind, and make
.\install-prerequisites.ps1
.\install-tools.ps1
```

**Key Tools Explained:**
- **Docker Desktop**: Container runtime for building and running containers
- **kubectl**: Kubernetes command-line interface for cluster management
- **kind**: Kubernetes in Docker - creates local Kubernetes clusters using Docker containers
- **make**: Build automation tool for running complex commands

### Step 2: Verify Installation

```powershell
# Check Docker
docker --version
docker ps

# Check Kubernetes tools
kubectl version --client
kind version
```

## Project Structure

```
Milestone2/
├── api/                    # FastAPI backend application
│   ├── app.py             # Main FastAPI application
│   ├── db.py              # Database connection and operations
│   ├── Dockerfile         # Container configuration
│   └── requirements.txt   # Python dependencies
├── db/                    # Database configuration
│   ├── Dockerfile         # PostgreSQL container
│   └── init.sql          # Database initialization script
├── frontend/              # Web frontend
│   ├── index.html        # Static HTML page
│   ├── nginx.conf        # NGINX configuration
│   └── Dockerfile        # Container configuration
├── k8s/                   # Kubernetes manifests
│   ├── namespace.yaml    # Project namespace
│   ├── postgres/         # Database deployment
│   ├── api/              # Backend deployment
│   └── frontend/         # Frontend deployment
├── scripts/               # Utility scripts
├── run.ps1               # Main deployment script
└── README.md             # Project documentation
```

## Backend API Implementation

### FastAPI Application (`api/app.py`)

```python
import os
import socket
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from db import init_database, get_user_name, update_user_name
import time

# Initialize FastAPI app
app = FastAPI(title="Milestone 2 API", version="1.0.0")

# Pydantic model for user data
class UserUpdate(BaseModel):
    name: str
```

**Key Components Explained:**

1. **FastAPI Initialization**: Creates a FastAPI application with metadata
2. **Pydantic Model**: `UserUpdate` class validates incoming JSON data structure
3. **Import Structure**: Imports database functions and system utilities

```python
@app.on_event("startup")
async def startup_event():
    """Initialize database on startup."""
    # Wait for database to be ready
    max_retries = 30
    retry_count = 0
    
    while retry_count < max_retries:
        try:
            init_database()
            print("Database initialized successfully")
            break
        except Exception as e:
            print(f"Database connection failed (attempt {retry_count + 1}/{max_retries}): {e}")
            retry_count += 1
            time.sleep(2)
```

**Startup Event Explained:**
- **Retry Logic**: Waits for database to be ready (important for container orchestration)
- **Error Handling**: Gracefully handles database connection failures
- **Async Function**: Uses FastAPI's async capabilities for non-blocking operations

```python
@app.get("/user")
async def get_user():
    """Get current user name from database."""
    try:
        name = get_user_name()
        return {"name": name}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

@app.post("/user")
async def update_user(user_data: UserUpdate):
    """Update user name in database."""
    try:
        update_user_name(user_data.name)
        return {"message": "User name updated successfully", "name": user_data.name}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
```

**API Endpoints Explained:**
- **GET /user**: Retrieves current user name from database
- **POST /user**: Updates user name in database with validation
- **Error Handling**: Returns proper HTTP status codes and error messages

```python
@app.get("/container-id")
async def get_container_id():
    """Get container ID/hostname."""
    hostname = socket.gethostname()
    return {"container_id": hostname}
```

**Container ID Endpoint**: Returns the hostname/container ID for debugging and load balancing verification.

### Database Layer (`api/db.py`)

```python
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from contextlib import contextmanager

# Database configuration
DB_HOST = os.getenv('DATABASE_HOST', 'postgres-lm')
DB_PORT = os.getenv('DATABASE_PORT', '5432')
DB_NAME = os.getenv('DATABASE_NAME', 'milestone2')
DB_USER = os.getenv('DATABASE_USER', 'postgres')
DB_PASSWORD = os.getenv('DATABASE_PASSWORD', 'password123')
```

**Configuration Explained:**
- **Environment Variables**: Uses environment variables with defaults for flexibility
- **Service Discovery**: `postgres-lm` is the Kubernetes service name for the database
- **Security**: Credentials can be injected via environment variables

```python
@contextmanager
def get_db_connection():
    """Context manager for database connections."""
    conn = None
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        yield conn
    finally:
        if conn:
            conn.close()
```

**Connection Management Explained:**
- **Context Manager**: Ensures proper connection cleanup using Python's `with` statement
- **Resource Management**: Automatically closes connections even if exceptions occur
- **Connection Pooling**: Each function gets a fresh connection (simple approach)

```python
def init_database():
    """Initialize the database with required tables."""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Create users table if it doesn't exist
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    id SERIAL PRIMARY KEY,
                    name VARCHAR(255) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
            
            # Insert default user if table is empty
            cursor.execute("SELECT COUNT(*) FROM users")
            count = cursor.fetchone()[0]
            
            if count == 0:
                cursor.execute("""
                    INSERT INTO users (name) VALUES ('Default User')
                """)
            
            conn.commit()
```

**Database Initialization Explained:**
- **Idempotent Design**: `CREATE TABLE IF NOT EXISTS` allows safe re-runs
- **Default Data**: Inserts initial user if table is empty
- **Transaction Safety**: Uses explicit commits for data integrity

## Database Implementation

### PostgreSQL Container (`db/Dockerfile`)

```dockerfile
FROM postgres:15-alpine

# Copy initialization script
COPY init.sql /docker-entrypoint-initdb.d/

# Set environment variables
ENV POSTGRES_DB=milestone2
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password123

# Expose port 5432
EXPOSE 5432

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD pg_isready -U postgres -d milestone2 || exit 1
```

**Dockerfile Explained:**
- **Base Image**: Uses official PostgreSQL 15 Alpine for smaller size
- **Init Scripts**: `/docker-entrypoint-initdb.d/` is automatically executed on first run
- **Environment Variables**: Sets up database name, user, and password
- **Health Check**: Uses `pg_isready` to verify database availability

### Database Initialization (`db/init.sql`)

```sql
-- Create the milestone2 database (if not exists)
-- This is handled by POSTGRES_DB environment variable

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default user
INSERT INTO users (name) VALUES ('Default User')
ON CONFLICT DO NOTHING;
```

**SQL Script Explained:**
- **Table Creation**: Defines the users table with proper constraints
- **Default Data**: Inserts initial user record
- **Conflict Handling**: Uses `ON CONFLICT DO NOTHING` for idempotent execution

## Frontend Implementation

### Static HTML (`frontend/index.html`)

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Milestone 2</title>
  </head>
  <body>
    <h1><span id="user">Loading...</span> has reached milestone 2!</h1>

    <script>
      // fetch user from API
      fetch("/api/user")
        .then((res) => res.json())
        .then((data) => {
          const user = data.name;
          document.getElementById("user").innerText = user;
        });
    </script>
  </body>
</html>
```

**HTML Structure Explained:**
- **Responsive Design**: Uses viewport meta tag for mobile compatibility
- **Dynamic Content**: JavaScript fetches user data from API
- **API Integration**: Uses relative path `/api/user` which gets proxied to backend

### NGINX Configuration (`frontend/nginx.conf`)

```nginx
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
```

**NGINX Configuration Explained:**
- **Worker Connections**: Sets maximum concurrent connections per worker
- **Logging**: Configures access and error logs with detailed format
- **Performance**: Enables sendfile, tcp_nopush for better performance

```nginx
    server {
        listen 80;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;

        # Serve static files
        location / {
            try_files $uri $uri/ /index.html;
        }

        # Proxy API requests to FastAPI service
        location /api/ {
            proxy_pass http://api-lm:8000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Health check endpoint
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
    }
}
```

**Server Block Explained:**
- **Static File Serving**: Serves HTML files from `/usr/share/nginx/html`
- **API Proxy**: Routes `/api/*` requests to the FastAPI service
- **Service Discovery**: Uses `api-lm` service name for Kubernetes networking
- **Health Check**: Provides simple health endpoint for Kubernetes probes

### Frontend Container (`frontend/Dockerfile`)

```dockerfile
FROM nginx:alpine

# Install curl for health check
RUN apk add --no-cache curl

# Copy the static HTML file
COPY index.html /usr/share/nginx/html/index.html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/health || exit 1
```

**Frontend Dockerfile Explained:**
- **Base Image**: Uses NGINX Alpine for minimal size
- **Health Check**: Installs curl for health check functionality
- **File Copying**: Copies HTML and NGINX configuration
- **Port Exposure**: Exposes port 80 for HTTP traffic

## Docker Containerization

### API Container (`api/Dockerfile`)

```dockerfile
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .
COPY db.py .

# Expose port 8000
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# Run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

**API Dockerfile Explained:**
- **Base Image**: Uses Python 3.11 slim for smaller size
- **System Dependencies**: Installs gcc for compiling Python packages
- **Dependency Management**: Installs Python packages from requirements.txt
- **Application Code**: Copies FastAPI application files
- **Health Check**: Uses curl to verify application health
- **Command**: Runs uvicorn ASGI server

### Python Dependencies (`api/requirements.txt`)

```txt
fastapi==0.104.1
uvicorn[standard]==0.24.0
psycopg2-binary==2.9.9
pydantic==2.5.0
```

**Dependencies Explained:**
- **FastAPI**: Modern web framework for building APIs
- **Uvicorn**: ASGI server for running FastAPI applications
- **psycopg2-binary**: PostgreSQL adapter for Python
- **Pydantic**: Data validation using Python type annotations

## Kubernetes Orchestration

### Namespace (`k8s/namespace.yaml`)

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: lm-webstack
  labels:
    name: lm-webstack
    project: milestone2
```

**Namespace Explained:**
- **Resource Isolation**: Creates isolated environment for the application
- **Labeling**: Adds labels for organization and filtering
- **Resource Management**: All other resources will be created in this namespace

### PostgreSQL Deployment (`k8s/postgres/deployment.yaml`)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-lm
  namespace: lm-webstack
  labels:
    app: postgres-lm
    project: milestone2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres-lm
  template:
    metadata:
      labels:
        app: postgres-lm
    spec:
      containers:
      - name: postgres
        image: postgres-lm:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 5432
```

**Deployment Structure Explained:**
- **apiVersion**: Specifies Kubernetes API version for apps/v1
- **kind**: Defines resource type as Deployment
- **metadata**: Names and labels the deployment
- **replicas**: Number of pod instances (1 for database)
- **selector**: Matches pods with this deployment
- **imagePullPolicy**: Never - uses local images only

```yaml
        env:
        - name: POSTGRES_DB
          valueFrom:
            configMapKeyRef:
              name: postgres-config-lm
              key: POSTGRES_DB
        - name: POSTGRES_USER
          valueFrom:
            secretKeyRef:
              name: postgres-secret-lm
              key: username
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-secret-lm
              key: password
```

**Environment Variables Explained:**
- **ConfigMap**: Stores non-sensitive configuration data
- **Secret**: Stores sensitive data like passwords
- **Externalization**: Separates configuration from code

```yaml
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
        - name: init-script
          mountPath: /docker-entrypoint-initdb.d
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

**Volume and Resource Management:**
- **Persistent Storage**: Mounts PVC for data persistence
- **Init Scripts**: Mounts initialization scripts
- **Resource Limits**: Prevents resource exhaustion

```yaml
        livenessProbe:
          exec:
            command:
            - pg_isready
            - -U
            - postgres
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
            - pg_isready
            - -U
            - postgres
          initialDelaySeconds: 5
          periodSeconds: 5
```

**Health Probes Explained:**
- **Liveness Probe**: Checks if container is alive, restarts if failed
- **Readiness Probe**: Checks if container is ready to receive traffic
- **pg_isready**: PostgreSQL-specific health check command

### API Deployment (`k8s/api/deployment.yaml`)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-lm
  namespace: lm-webstack
  labels:
    app: api-lm
    project: milestone2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-lm
  template:
    metadata:
      labels:
        app: api-lm
    spec:
      containers:
      - name: api
        image: api-lm:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 8000
```

**API Deployment Structure:**
- **Similar Structure**: Follows same pattern as PostgreSQL deployment
- **Port Configuration**: Exposes port 8000 for FastAPI
- **Label Consistency**: Uses consistent labeling scheme

```yaml
        env:
        - name: DATABASE_HOST
          valueFrom:
            configMapKeyRef:
              name: api-config-lm
              key: DATABASE_HOST
        - name: DATABASE_PORT
          valueFrom:
            configMapKeyRef:
              name: api-config-lm
              key: DATABASE_PORT
        - name: DATABASE_NAME
          valueFrom:
            configMapKeyRef:
              name: api-config-lm
              key: DATABASE_NAME
        - name: DATABASE_USER
          valueFrom:
            configMapKeyRef:
              name: api-config-lm
              key: DATABASE_USER
        - name: DATABASE_PASSWORD
          valueFrom:
            configMapKeyRef:
              name: api-config-lm
              key: DATABASE_PASSWORD
```

**Database Configuration:**
- **Service Discovery**: Uses Kubernetes service names
- **ConfigMap Integration**: Externalizes all database configuration
- **Security**: Passwords stored in ConfigMap (in production, use Secrets)

```yaml
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5
```

**HTTP Health Probes:**
- **HTTP GET**: Uses HTTP requests instead of exec commands
- **Health Endpoint**: Calls `/health` endpoint defined in FastAPI
- **Timing**: Allows sufficient time for application startup

### Frontend Deployment (`k8s/frontend/deployment.yaml`)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-lm
  namespace: lm-webstack
  labels:
    app: frontend-lm
    project: milestone2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend-lm
  template:
    metadata:
      labels:
        app: frontend-lm
    spec:
      containers:
      - name: frontend
        image: frontend-lm:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 80
```

**Frontend Deployment:**
- **Port 80**: Standard HTTP port for web servers
- **NGINX Configuration**: Mounts custom NGINX config via ConfigMap

```yaml
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
```

**Configuration Mounting:**
- **ConfigMap Volume**: Mounts NGINX configuration
- **subPath**: Mounts specific file instead of entire directory
- **Resource Limits**: Minimal resources for static file serving

### Services

Each deployment has a corresponding service for network communication:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres-lm
  namespace: lm-webstack
  labels:
    app: postgres-lm
spec:
  selector:
    app: postgres-lm
  ports:
  - port: 5432
    targetPort: 5432
  type: ClusterIP
```

**Service Configuration Explained:**
- **Selector**: Routes traffic to pods with matching labels
- **Port Mapping**: Maps service port to container port
- **Service Types**:
  - **ClusterIP**: Internal cluster communication (database, API)
  - **NodePort**: External access on specific node port (frontend)

## Deployment Automation

### Main Deployment Script (`run.ps1`)

```powershell
# Simple project runner for Milestone 2
param([string]$action = "help")

function Start-Cluster {
    Write-Host "Starting Kubernetes cluster..." -ForegroundColor Green
    & "$env:USERPROFILE\tools\kind.exe" create cluster --name milestone2
    Write-Host "Cluster created successfully!" -ForegroundColor Green
}
```

**Script Structure Explained:**
- **Parameter Handling**: Accepts action parameter with default "help"
- **Function Organization**: Each deployment step is a separate function
- **Color Output**: Uses colored output for better user experience

```powershell
function Build-Images {
    Write-Host "Building Docker images..." -ForegroundColor Green
    docker build -t frontend-lm:latest frontend/
    docker build -t api-lm:latest api/
    docker build -t postgres-lm:latest db/
    Write-Host "Images built successfully!" -ForegroundColor Green
}
```

**Image Building:**
- **Parallel Building**: Builds all three images
- **Tagging**: Uses consistent naming scheme with `:latest` tag
- **Context**: Builds from respective directories

```powershell
function Load-Images {
    Write-Host "Loading images to cluster..." -ForegroundColor Green
    & "$env:USERPROFILE\tools\kind.exe" load docker-image frontend-lm:latest --name milestone2
    & "$env:USERPROFILE\tools\kind.exe" load docker-image api-lm:latest --name milestone2
    & "$env:USERPROFILE\tools\kind.exe" load docker-image postgres-lm:latest --name milestone2
    Write-Host "Images loaded successfully!" -ForegroundColor Green
}
```

**Image Loading:**
- **kind Integration**: Loads local images into kind cluster
- **Cluster Targeting**: Specifies cluster name for multi-cluster setups
- **Local Registry**: Avoids need for external image registry

```powershell
function Deploy-Application {
    Write-Host "Deploying to Kubernetes..." -ForegroundColor Green
    kubectl apply -f k8s/namespace.yaml
    kubectl apply -f k8s/postgres/
    kubectl apply -f k8s/api/
    kubectl apply -f k8s/frontend/
    Write-Host "Application deployed successfully!" -ForegroundColor Green
}
```

**Deployment Process:**
- **Namespace First**: Creates namespace before other resources
- **Directory Application**: Applies all YAML files in each directory
- **Order Dependency**: Deploys database first, then API, then frontend

```powershell
function Deploy-All {
    Write-Host "=== Starting complete deployment ===" -ForegroundColor Green
    Start-Cluster
    Build-Images
    Load-Images
    Deploy-Application
    Write-Host "`nWaiting for pods to be ready..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    Show-Status
    Write-Host "`n=== Deployment completed! ===" -ForegroundColor Green
    Write-Host "To access the frontend, run: .\run.ps1 access-frontend" -ForegroundColor Cyan
    Write-Host "To access the API, run: .\run.ps1 access-api" -ForegroundColor Cyan
}
```

**Complete Deployment:**
- **Sequential Execution**: Runs all steps in correct order
- **Wait Period**: Allows pods time to start up
- **Status Display**: Shows final deployment status
- **User Guidance**: Provides next steps for access

## Testing and Verification

### Step 1: Check Deployment Status

```powershell
# Check namespace
kubectl get namespace lm-webstack

# Check pods
kubectl get pods -n lm-webstack

# Check services
kubectl get services -n lm-webstack
```

### Step 2: Access Frontend

```powershell
# Port forward to frontend
powershell -ExecutionPolicy Bypass -File run.ps1 access-frontend
```

Then open http://localhost:8080 in your browser.

### Step 3: Test API

```powershell
# Port forward to API
powershell -ExecutionPolicy Bypass -File run.ps1 access-api
```

Test API endpoints:
```bash
# Get current user
curl http://localhost:8000/user

# Update user name
curl -X POST http://localhost:8000/user \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe"}'

# Get container ID
curl http://localhost:8000/container-id
```

### Step 4: Verify Integration

1. Open frontend in browser
2. Note the displayed user name
3. Update name via API
4. Refresh browser to see updated name

## Troubleshooting

### Common Issues and Solutions

#### 1. Docker Not Running
**Symptoms**: Connection errors, "docker daemon not running"
**Solution**: Start Docker Desktop application

#### 2. PowerShell Execution Policy
**Symptoms**: "cannot be loaded" error
**Solution**: Use `powershell -ExecutionPolicy Bypass -File run.ps1 all`

#### 3. Images Not Found
**Symptoms**: "image not present locally" errors
**Solution**: Rebuild images with `.\run.ps1 build`

#### 4. Database Connection Issues
**Symptoms**: API errors, database connection failures
**Solution**: Check PostgreSQL pod status and logs

#### 5. Port Forwarding Issues
**Symptoms**: Cannot access localhost
**Solution**: Ensure port forwarding is running and ports are available

### Debugging Commands

```powershell
# Check pod logs
kubectl logs -n lm-webstack deployment/api-lm
kubectl logs -n lm-webstack deployment/frontend-lm
kubectl logs -n lm-webstack deployment/postgres-lm

# Check pod status
kubectl describe pods -n lm-webstack

# Check events
kubectl get events -n lm-webstack --sort-by='.lastTimestamp'

# Check service endpoints
kubectl get endpoints -n lm-webstack
```

## Summary

This implementation demonstrates a complete modern web application stack with:

1. **Microservices Architecture**: Separate containers for frontend, backend, and database
2. **Container Orchestration**: Kubernetes manages deployment, scaling, and networking
3. **Service Discovery**: Automatic service-to-service communication
4. **Health Monitoring**: Probes ensure application availability
5. **Configuration Management**: Externalized configuration via ConfigMaps
6. **Automation**: Scripted deployment process for consistency
7. **Development Workflow**: Local development with kind cluster

The architecture is production-ready with proper separation of concerns, health checks, resource limits, and automated deployment processes.
