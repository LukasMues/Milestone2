# Milestone 2: Complete Step-by-Step Implementation Guide

## 🎯 **For Complete Beginners**

This guide is designed for someone who has **never worked with containers, Kubernetes, or modern web development** before. It starts from absolute zero and walks you through every step, explaining what each tool does and why we use it.

### **What You'll Learn**
- How to install all required tools from scratch
- What containers and Kubernetes are
- How to build and deploy a complete web application
- Modern software development practices

### **Time Required**
- **Prerequisites Installation**: 30-60 minutes (first time only)
- **Application Deployment**: 15-30 minutes
- **Testing and Learning**: 30-60 minutes

### **What You'll End Up With**
A fully functional web application running on Kubernetes with:
- A web frontend that users can access
- A backend API that handles requests
- A database that stores information
- Load balancing across multiple instances
- Automatic health monitoring

---

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
12. [Complete Setup Walkthrough](#complete-setup-walkthrough)

## Project Overview

This project implements a complete web stack using modern containerization and orchestration technologies:

- **Frontend**: NGINX serving static HTML with JavaScript
- **Backend**: FastAPI Python application
- **Database**: PostgreSQL with persistent storage
- **Containerization**: Docker images for each component
- **Orchestration**: Kubernetes with kind (Kubernetes in Docker)
- **Automation**: PowerShell scripts for deployment

## Prerequisites Installation

This section guides you through installing all required tools from scratch. You'll need these tools to run the Kubernetes application.

### Step 1: System Requirements

Before starting, ensure your system meets these requirements:
- **Operating System**: Windows 10/11 (recommended), macOS, or Linux
- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: At least 10GB free disk space
- **Administrator Access**: Required for Docker installation

### Step 2: Install Docker Desktop

Docker Desktop is the container runtime that will run our application containers.

#### 2.1 Download Docker Desktop
1. **Go to**: https://www.docker.com/products/docker-desktop/
2. **Click**: "Download for Windows"
3. **Save**: The installer file (Docker Desktop Installer.exe)

#### 2.2 Install Docker Desktop
1. **Run**: The downloaded Docker Desktop Installer.exe
2. **Follow**: The installation wizard
3. **Restart**: Your computer when prompted
4. **Start**: Docker Desktop from the Start menu

#### 2.3 Verify Docker Installation
```powershell
# Open PowerShell and run:
docker --version
docker ps
```

**Expected Output**:
```
Docker version 24.0.7, build afdd53b
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

**What These Commands Do**:
- `docker --version`: Shows Docker version to confirm installation
- `docker ps`: Lists running containers (empty list is normal for fresh install)

### Step 3: Install kubectl

kubectl is the command-line tool for interacting with Kubernetes clusters.

#### 3.1 Download kubectl (Windows)
```powershell
# Download kubectl for Windows
Invoke-WebRequest -Uri "https://dl.k8s.io/release/v1.28.4/bin/windows/amd64/kubectl.exe" -OutFile "kubectl.exe"

# Move to a directory in your PATH (requires admin privileges)
Move-Item kubectl.exe "C:\Windows\System32\kubectl.exe"
```

#### 3.2 Alternative: Install via Chocolatey
If you have Chocolatey package manager:
```powershell
# Install Chocolatey first (if you don't have it)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install kubectl
choco install kubernetes-cli
```

#### 3.3 Verify kubectl Installation
```powershell
kubectl version --client
```

**Expected Output**:
```
Client Version: version.Info{Major:"1", Minor:"28", GitVersion:"v1.28.4", GitCommit:"a3a691b64ec7e2966cefc374d6e4f436fde9e3c3", GitTreeState:"clean", BuildDate:"2023-11-15T10:43:57Z", GoVersion:"go1.21.3", Compiler:"gc", Platform:"windows/amd64"}
```

### Step 4: Install kind (Kubernetes in Docker)

kind creates local Kubernetes clusters using Docker containers.

#### 4.1 Download kind
```powershell
# Create tools directory
New-Item -ItemType Directory -Path "$env:USERPROFILE\tools" -Force

# Download kind for Windows
$kindUrl = "https://kind.sigs.k8s.io/dl/v0.20.0/kind-windows-amd64"
$kindPath = "$env:USERPROFILE\tools\kind.exe"
Invoke-WebRequest -Uri $kindUrl -OutFile $kindPath

# Add to PATH (restart terminal after this)
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
[Environment]::SetEnvironmentVariable("PATH", "$currentPath;$env:USERPROFILE\tools", "User")
```

#### 4.2 Verify kind Installation
```powershell
# Restart PowerShell, then run:
& "$env:USERPROFILE\tools\kind.exe" version
```

**Expected Output**:
```
kind v0.20.0 go1.21.1 windows/amd64
```

### Step 5: Install Git (if not already installed)

Git is needed to clone the project repository.

#### 5.1 Download Git
1. **Go to**: https://git-scm.com/download/win
2. **Download**: Git for Windows
3. **Install**: Follow the installation wizard

#### 5.2 Verify Git Installation
```powershell
git --version
```

**Expected Output**:
```
git version 2.42.0.windows.2
```

### Step 6: Clone the Project Repository

Now you need to get the project files onto your computer.

#### 6.1 Clone the Repository
```powershell
# Navigate to where you want to store the project
cd C:\Users\$env:USERNAME\Desktop

# Clone the repository (replace with your actual repository URL)
git clone <your-repository-url>
cd Milestone2
```

**What This Does**:
- `cd`: Changes directory to Desktop
- `git clone`: Downloads the project files from the repository
- `cd Milestone2`: Enters the project directory

### Step 7: Verify All Prerequisites

Run this comprehensive check to ensure everything is installed correctly:

```powershell
# Check Docker
Write-Host "=== Docker ===" -ForegroundColor Green
docker --version
docker ps

# Check kubectl
Write-Host "`n=== kubectl ===" -ForegroundColor Green
kubectl version --client

# Check kind
Write-Host "`n=== kind ===" -ForegroundColor Green
& "$env:USERPROFILE\tools\kind.exe" version

# Check Git
Write-Host "`n=== Git ===" -ForegroundColor Green
git --version

# Check current directory
Write-Host "`n=== Current Directory ===" -ForegroundColor Green
pwd
```

**Expected Output**:
```
=== Docker ===
Docker version 24.0.7, build afdd53b
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

=== kubectl ===
Client Version: version.Info{Major:"1", Minor:"28", GitVersion:"v1.28.4", ...}

=== kind ===
kind v0.20.0 go1.21.1 windows/amd64

=== Git ===
git version 2.42.0.windows.2

=== Current Directory ===
Path
----
C:\Users\YourUsername\Desktop\Milestone2
```

### Step 8: Troubleshooting Common Installation Issues

#### 8.1 Docker Not Starting
**Problem**: Docker Desktop won't start or shows errors
**Solutions**:
1. **Enable WSL 2**: Docker Desktop requires WSL 2 on Windows
   ```powershell
   # Enable WSL feature
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```
2. **Restart Computer**: After enabling WSL 2
3. **Check System Requirements**: Ensure virtualization is enabled in BIOS

#### 8.2 kubectl Not Found
**Problem**: `kubectl: command not found`
**Solutions**:
1. **Check PATH**: Ensure kubectl is in your system PATH
2. **Restart Terminal**: Close and reopen PowerShell
3. **Manual Installation**: Use the download method above

#### 8.3 kind Not Found
**Problem**: `kind: command not found`
**Solutions**:
1. **Check Installation Path**: Verify kind.exe is in `%USERPROFILE%\tools\`
2. **Update PATH**: Ensure the tools directory is in your PATH
3. **Restart Terminal**: Close and reopen PowerShell

#### 8.4 Permission Errors
**Problem**: "Access denied" or permission errors
**Solutions**:
1. **Run as Administrator**: Right-click PowerShell and select "Run as Administrator"
2. **Check Antivirus**: Temporarily disable antivirus during installation
3. **Windows Defender**: Add exceptions for the tools directory

### Step 9: Final Verification

Before proceeding to the next section, run this final verification:

```powershell
# Test Docker functionality
Write-Host "Testing Docker..." -ForegroundColor Yellow
docker run hello-world

# Test kubectl functionality
Write-Host "`nTesting kubectl..." -ForegroundColor Yellow
kubectl version --client

# Test kind functionality
Write-Host "`nTesting kind..." -ForegroundColor Yellow
& "$env:USERPROFILE\tools\kind.exe" version

# Check project files
Write-Host "`nChecking project files..." -ForegroundColor Yellow
ls
```

**Expected Output**:
```
Testing Docker...
Hello from Docker!
This message shows that your installation appears to be working correctly.

Testing kubectl...
Client Version: version.Info{Major:"1", Minor:"28", GitVersion:"v1.28.4", ...}

Testing kind...
kind v0.20.0 go1.21.1 windows/amd64

Checking project files...
    Directory: C:\Users\YourUsername\Desktop\Milestone2

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----        8/24/2025   8:50 PM                api
d-----        8/24/2025   8:50 PM                db
d-----        8/24/2025   8:50 PM                frontend
d-----        8/24/2025   8:50 PM                k8s
d-----        8/24/2025   8:50 PM                scripts
-a----        8/24/2025   8:50 PM           1,234 README.md
-a----        8/24/2025   8:50 PM           5,678 run.ps1
```

**What This Verifies**:
- **Docker**: Can run containers successfully
- **kubectl**: Command-line tool is working
- **kind**: Can create Kubernetes clusters
- **Project Files**: All necessary files are present

If all these tests pass, you're ready to proceed to the next section!

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

## Multi-Node Cluster and Scaling

### Cluster Configuration (`kind-config.yaml`)

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
  labels:
    node-type: worker-1
- role: worker
  labels:
    node-type: worker-2
```

**Multi-Node Configuration Explained:**
- **Control Plane**: Single control plane node with ingress-ready labels
- **Worker Nodes**: Two worker nodes for distributing application load
- **Port Mappings**: Exposes ports 80 and 443 for external access
- **Node Labels**: Labels for node identification and scheduling

### API Scaling Configuration

The API deployment has been updated to run 3 replicas by default:

```yaml
spec:
  replicas: 3
```

**Scaling Benefits:**
- **Load Distribution**: Requests are distributed across multiple pods
- **High Availability**: If one pod fails, others continue serving
- **Performance**: Multiple instances handle concurrent requests
- **Node Distribution**: Pods can be scheduled on different nodes

### Enhanced Frontend with Load Balancing Display

The frontend now shows:
- **Container ID**: Which API instance is handling the request
- **Node Information**: Which node the pod is running on
- **Load Balancing Test**: Interactive test to verify load distribution

### Node Information Endpoint

New API endpoint `/api/node-info` provides:
- **Container ID**: Pod hostname
- **Pod Name**: Kubernetes pod name
- **Node Name**: Kubernetes node name

### Load Balancing Test

```powershell
# Check current status
.\run.ps1 status

# Test load balancing
.\scripts\test-load-balancing.ps1 50
```

## Summary

This implementation demonstrates a complete modern web application stack with:

1. **Microservices Architecture**: Separate containers for frontend, backend, and database
2. **Container Orchestration**: Kubernetes manages deployment, scaling, and networking
3. **Multi-Node Clustering**: Distributed across multiple worker nodes
4. **Horizontal Scaling**: API replicas for load balancing and high availability
5. **Service Discovery**: Automatic service-to-service communication
6. **Health Monitoring**: Probes ensure application availability
7. **Configuration Management**: Externalized configuration via ConfigMaps
8. **Load Balancing**: Automatic distribution of requests across replicas
9. **Automation**: Scripted deployment process for consistency
10. **Development Workflow**: Local development with kind cluster

The architecture is production-ready with proper separation of concerns, health checks, resource limits, automated deployment processes, and horizontal scaling capabilities.

## Complete Setup Walkthrough

This section provides a complete step-by-step walkthrough from zero to a fully running application, with detailed explanations of every command and its purpose.

### Step 1: Complete Prerequisites Installation

**IMPORTANT**: Before starting this walkthrough, you must complete the **Prerequisites Installation** section above. This includes installing Docker Desktop, kubectl, kind, and Git.

#### 1.1 Verify Prerequisites Installation
```powershell
# Check current working directory
pwd
# Expected output: C:\Users\YourUsername\Desktop\Milestone2 (or your project location)

# Verify all tools are installed
Write-Host "=== Verifying Prerequisites ===" -ForegroundColor Green
docker --version
kubectl version --client
& "$env:USERPROFILE\tools\kind.exe" version
git --version
```

**Explanation**: This command shows the current working directory and verifies all required tools are installed. We need to be in the project root directory to run all subsequent commands.

**Expected Output**:
```
=== Verifying Prerequisites ===
Docker version 24.0.7, build afdd53b
Client Version: version.Info{Major:"1", Minor:"28", GitVersion:"v1.28.4", ...}
kind v0.20.0 go1.21.1 windows/amd64
git version 2.42.0.windows.2
```

#### 1.2 Test Docker Functionality
```powershell
# Test Docker is working
Write-Host "`n=== Testing Docker ===" -ForegroundColor Green
docker run hello-world
```

**What This Does**: This tests that Docker can run containers successfully.

**Expected Output**:
```
=== Testing Docker ===
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### Step 2: Clean Environment (Optional)

#### 2.1 Stop Existing Cluster (if any)
```powershell
# Stop any existing kind cluster
kind delete cluster --name milestone2
```

**Explanation**: This removes any existing Kubernetes cluster with the name "milestone2" to ensure a clean start.

#### 2.2 Clean Docker Images (Optional)
```powershell
# Remove existing project images
docker rmi frontend-lm:latest api-lm:latest postgres-lm:latest --force
```

**Command Breakdown**:
- `docker rmi`: Remove Docker images
- `--force`: Force removal even if images are in use
- This ensures we build fresh images

### Step 3: Complete Deployment

#### 3.1 Run Complete Deployment Script
```powershell
# Execute the complete deployment script
powershell -ExecutionPolicy Bypass -File run.ps1 all
```

**Command Breakdown**:
- `powershell -ExecutionPolicy Bypass`: Runs PowerShell with execution policy bypassed
- `-File run.ps1`: Specifies the script file to execute
- `all`: Parameter passed to the script indicating complete deployment

**What This Command Does**:
1. **Starts Kubernetes Cluster**: Creates a multi-node kind cluster
2. **Builds Docker Images**: Creates containers for frontend, API, and database
3. **Loads Images**: Transfers images to the Kubernetes cluster
4. **Deploys Application**: Applies all Kubernetes manifests
5. **Shows Status**: Displays deployment status

**Expected Output**:
```
=== Starting complete deployment ===
Starting multi-node Kubernetes cluster...
Multi-node cluster created successfully!
Building Docker images...
Images built successfully!
Loading images to cluster...
Images loaded successfully!
Deploying to Kubernetes...
Application deployed successfully!

Waiting for pods to be ready...
=== Namespace ===
NAME          STATUS   AGE
lm-webstack   Active   1m

=== Nodes ===
NAME                       STATUS   ROLES           AGE   VERSION
milestone2-control-plane   Ready    control-plane   1m    v1.27.3
milestone2-worker          Ready    <none>          1m    v1.27.3
milestone2-worker2         Ready    <none>          1m    v1.27.3

=== Pods ===
NAME                           READY   STATUS    RESTARTS   AGE   IP           NODE                 NOMINATED NODE   READINESS GATES
api-lm-76f8598fcd-44q5k        1/1     Running   0          1m    10.244.2.6   milestone2-worker    <none>           <none>
api-lm-76f8598fcd-cll62        1/1     Running   0          1m    10.244.1.6   milestone2-worker2   <none>           <none>
api-lm-76f8598fcd-nbn7k        1/1     Running   0          1m    10.244.2.7   milestone2-worker    <none>           <none>
frontend-lm-6db4944f9f-p6sxp   1/1     Running   0          1m    10.244.2.5   milestone2-worker    <none>           <none>
postgres-lm-fb5478b6-5fd5r     1/1     Running   0          1m    10.244.1.3   milestone2-worker2   <none>           <none>

=== Services ===
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
api-lm        ClusterIP   10.96.31.111    <none>        8000/TCP       1m
frontend-lm   NodePort    10.96.154.94    <none>        80:30000/TCP   1m
postgres-lm   ClusterIP   10.96.201.201   <none>        5432/TCP       1m

=== Deployment completed! ===
To access the frontend, run: .\run.ps1 access-frontend
To access the API, run: .\run.ps1 access-api
```

### Step 4: Access the Application

#### 4.1 Set Up Port Forwarding for Frontend

**Open a new PowerShell window** and run:
```powershell
# Navigate to project directory
cd "C:\Users\lukas\OneDrive - Thomas More\Linux Webservices\Milestone2"

# Start frontend port forwarding
powershell -ExecutionPolicy Bypass -File run.ps1 access-frontend
```

**Command Breakdown**:
- `cd`: Changes directory to project root
- `powershell -ExecutionPolicy Bypass -File run.ps1 access-frontend`: Runs the access-frontend function

**What This Does**:
- Creates a tunnel from localhost:8080 to the frontend service
- Allows browser access to the web application

**Expected Output**:
```
Port forwarding to frontend service...
Access at: http://localhost:8080
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

#### 4.2 Set Up Port Forwarding for API

**Open another PowerShell window** and run:
```powershell
# Navigate to project directory
cd "C:\Users\lukas\OneDrive - Thomas More\Linux Webservices\Milestone2"

# Start API port forwarding
powershell -ExecutionPolicy Bypass -File run.ps1 access-api
```

**Expected Output**:
```
Port forwarding to API service...
Access at: http://localhost:8000
Forwarding from 127.0.0.1:8000 -> 8000
Forwarding from [::1]:8000 -> 8000
```

### Step 5: Test the Application

#### 5.1 Test Frontend
1. **Open your web browser**
2. **Navigate to**: `http://localhost:8080`
3. **Expected Result**: You should see "**[Default User]** has reached milestone 2!"

**What You're Seeing**:
- The HTML page loads from the NGINX frontend
- JavaScript fetches user data from the API
- The API retrieves data from the PostgreSQL database
- The name is displayed dynamically

#### 5.2 Test API Endpoints

**Open a third PowerShell window** and test the API:

```powershell
# Test health endpoint
Invoke-WebRequest -Uri "http://localhost:8000/health" -Method GET

# Test get current user
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method GET

# Test update user name
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method POST -Headers @{ "Content-Type" = "application/json" } -Body '{"name":"Your Name"}'

# Test container ID endpoint
Invoke-WebRequest -Uri "http://localhost:8000/container-id" -Method GET
```

**Command Breakdown**:
- `Invoke-WebRequest`: PowerShell cmdlet for making HTTP requests
- `-Uri`: Specifies the URL to request
- `-Method`: HTTP method (GET, POST, etc.)
- `-Headers`: Sets HTTP headers (Content-Type for JSON)
- `-Body`: Request body for POST requests

**Expected Outputs**:
```json
// Health check
{"status": "healthy"}

// Get user
{"name": "Default User"}

// Update user
{"message": "User name updated successfully", "name": "Your Name"}

// Container ID
{"container_id": "api-lm-76f8598fcd-44q5k"}
```

#### 5.3 Verify Integration
1. **Update the user name** using the API command above
2. **Refresh the browser** at `http://localhost:8080`
3. **Expected Result**: The page should now show "**[Your Name]** has reached milestone 2!"

### Step 6: Advanced Testing

#### 6.1 Test Load Balancing
```powershell
# Test load balancing by making multiple requests
for ($i = 1; $i -le 10; $i++) {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/container-id" -Method GET
    $data = $response.Content | ConvertFrom-Json
    Write-Host "Request $i`: $($data.container_id)"
}
```

**What This Tests**:
- **Load Balancing**: Requests are distributed across 3 API replicas
- **High Availability**: Multiple instances handle requests
- **Container Distribution**: Pods running on different nodes

#### 6.2 Check Cluster Status
```powershell
# Check all pods
kubectl get pods -n lm-webstack

# Check services
kubectl get services -n lm-webstack

# Check nodes
kubectl get nodes

# Check events
kubectl get events -n lm-webstack --sort-by='.lastTimestamp'
```

**Command Breakdown**:
- `kubectl get pods`: Lists all pods in the namespace
- `kubectl get services`: Lists all services
- `kubectl get nodes`: Lists all cluster nodes
- `kubectl get events`: Shows recent cluster events

### Step 7: Understanding the Architecture

#### 7.1 Container Distribution
```powershell
# Check which nodes pods are running on
kubectl get pods -n lm-webstack -o wide
```

**Expected Output**:
```
NAME                           READY   STATUS    RESTARTS   AGE   IP           NODE                 NOMINATED NODE   READINESS GATES
api-lm-76f8598fcd-44q5k        1/1     Running   0          1m    10.244.2.6   milestone2-worker    <none>           <none>
api-lm-76f8598fcd-cll62        1/1     Running   0          1m    10.244.1.6   milestone2-worker2   <none>           <none>
api-lm-76f8598fcd-nbn7k        1/1     Running   0          1m    10.244.2.7   milestone2-worker    <none>           <none>
frontend-lm-6db4944f9f-p6sxp   1/1     Running   0          1m    10.244.2.5   milestone2-worker    <none>           <none>
postgres-lm-fb5478b6-5fd5r     1/1     Running   0          1m    10.244.1.3   milestone2-worker2   <none>           <none>
```

**What This Shows**:
- **API Pods**: Distributed across worker nodes (2 on worker, 1 on worker2)
- **Frontend**: Running on worker node
- **Database**: Running on worker2 node
- **Load Distribution**: Kubernetes scheduler distributed pods for optimal performance

#### 7.2 Service Discovery
```powershell
# Check service endpoints
kubectl get endpoints -n lm-webstack
```

**Expected Output**:
```
NAME          ENDPOINTS                                           AGE
api-lm        10.244.1.6:8000,10.244.2.6:8000,10.244.2.7:8000   1m
frontend-lm   10.244.2.5:80                                      1m
postgres-lm   10.244.1.3:5432                                    1m
```

**What This Shows**:
- **API Service**: Routes to 3 API pods (load balancing)
- **Frontend Service**: Routes to 1 frontend pod
- **Database Service**: Routes to 1 database pod

### Step 8: Monitoring and Logs

#### 8.1 Check Application Logs
```powershell
# Check API logs
kubectl logs -n lm-webstack deployment/api-lm --tail=20

# Check frontend logs
kubectl logs -n lm-webstack deployment/frontend-lm --tail=20

# Check database logs
kubectl logs -n lm-webstack deployment/postgres-lm --tail=20
```

**Command Breakdown**:
- `kubectl logs`: Retrieves logs from pods
- `-n lm-webstack`: Specifies namespace
- `deployment/api-lm`: Gets logs from all pods in the deployment
- `--tail=20`: Shows last 20 lines of logs

#### 8.2 Check Resource Usage
```powershell
# Check pod resource usage
kubectl top pods -n lm-webstack

# Check node resource usage
kubectl top nodes
```

### Step 9: Cleanup (When Done)

#### 9.1 Stop Port Forwarding
- **Press Ctrl+C** in both PowerShell windows running port forwarding
- This stops the port forwarding tunnels

#### 9.2 Clean Up Resources
```powershell
# Remove all Kubernetes resources
powershell -ExecutionPolicy Bypass -File run.ps1 clean

# Stop the cluster
powershell -ExecutionPolicy Bypass -File run.ps1 stop-cluster
```

**What This Does**:
- `clean`: Removes all resources in the lm-webstack namespace
- `stop-cluster`: Deletes the entire kind cluster

### Step 10: Troubleshooting Common Issues

#### 10.1 Pod Not Starting
```powershell
# Check pod details
kubectl describe pod <pod-name> -n lm-webstack

# Check pod logs
kubectl logs <pod-name> -n lm-webstack
```

#### 10.2 Service Not Accessible
```powershell
# Check service endpoints
kubectl get endpoints -n lm-webstack

# Check service details
kubectl describe service <service-name> -n lm-webstack
```

#### 10.3 Database Connection Issues
```powershell
# Check database pod status
kubectl get pods -n lm-webstack -l app=postgres-lm

# Check database logs
kubectl logs -n lm-webstack deployment/postgres-lm
```

## Summary

This complete walkthrough demonstrates:

1. **Automated Deployment**: Single command deploys entire application stack
2. **Multi-Node Architecture**: Application distributed across multiple nodes
3. **Load Balancing**: API requests automatically distributed across replicas
4. **Service Discovery**: Automatic communication between services
5. **Health Monitoring**: Built-in health checks and monitoring
6. **Resource Management**: Proper resource limits and requests
7. **Scalability**: Easy horizontal scaling of components
8. **Observability**: Comprehensive logging and monitoring
9. **Cleanup**: Proper resource cleanup when done

The application is now fully functional and demonstrates modern containerized application deployment practices with Kubernetes.
