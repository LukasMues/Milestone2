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

## 📋 **Step-by-Step Guide Overview**

### **Phase 1: Setup and Installation (Steps 1-3)**
- **Step 1**: Install Prerequisites (Docker, kubectl, kind, Git)
- **Step 2**: Clone and Explore Project Structure
- **Step 3**: Verify Installation and Environment

### **Phase 2: Understanding the Code (Steps 4-7)**
- **Step 4**: Backend API Implementation
- **Step 5**: Database Implementation
- **Step 6**: Frontend Implementation
- **Step 7**: Docker Containerization

### **Phase 3: Deployment and Orchestration (Steps 8-10)**
- **Step 8**: Kubernetes Orchestration
- **Step 9**: Deployment Automation
- **Step 10**: Testing and Verification

### **Phase 4: Advanced Features (Steps 11-13)**
- **Step 11**: Monitoring and Metrics
- **Step 12**: Load Balancing and Scaling
- **Step 13**: Troubleshooting and Cleanup

---

## Table of Contents
1. [Step 1: Install Prerequisites](#step-1-install-prerequisites)
2. [Step 2: Clone and Explore Project Structure](#step-2-clone-and-explore-project-structure)
3. [Step 3: Verify Installation and Environment](#step-3-verify-installation-and-environment)
4. [Step 4: Backend API Implementation](#step-4-backend-api-implementation)
5. [Step 5: Database Implementation](#step-5-database-implementation)
6. [Step 6: Frontend Implementation](#step-6-frontend-implementation)
7. [Step 7: Docker Containerization](#step-7-docker-containerization)
8. [Step 8: Kubernetes Orchestration](#step-8-kubernetes-orchestration)
9. [Step 9: Deployment Automation](#step-9-deployment-automation)
10. [Step 10: Testing and Verification](#step-10-testing-and-verification)
11. [Step 11: Monitoring and Metrics](#step-11-monitoring-and-metrics)
12. [Step 12: Load Balancing and Scaling](#step-12-load-balancing-and-scaling)
13. [Step 13: Troubleshooting and Cleanup](#step-13-troubleshooting-and-cleanup)

## Project Overview

This project implements a complete web stack using modern containerization and orchestration technologies:

- **Frontend**: NGINX serving static HTML with JavaScript
- **Backend**: FastAPI Python application
- **Database**: PostgreSQL with persistent storage
- **Containerization**: Docker images for each component
- **Orchestration**: Kubernetes with kind (Kubernetes in Docker)
- **Automation**: PowerShell scripts for deployment

---

## Step 1: Install Prerequisites

**Objective**: Install all required tools to run the Kubernetes application.

**Estimated Time**: 30-60 minutes (first time only)

**What You'll Install**:
- Docker Desktop (container runtime)
- kubectl (Kubernetes command-line tool)
- kind (local Kubernetes cluster)
- Git (version control)

### 1.1 System Requirements Check

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

---

## Step 2: Clone and Explore Project Structure

**Objective**: Get the project files and understand the project organization.

**Estimated Time**: 5-10 minutes

### 2.1 Clone the Project Repository

Now you need to get the project files onto your computer.

#### Clone the Repository
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

---

## Step 3: Verify Installation and Environment

**Objective**: Ensure all tools are properly installed and working.

**Estimated Time**: 5-10 minutes

### 3.1 Final Verification

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

---

## Step 4: Backend API Implementation

**Objective**: Understand how the FastAPI backend works.

**Estimated Time**: 15-20 minutes

### 4.1 Understanding the API Structure

The backend is built using FastAPI, a modern Python web framework. Let's examine every line of the main FastAPI application:

### FastAPI Application (`api/app.py`)

Let's examine every line of the main FastAPI application:

```python
# Standard library imports for system operations
import os                    # Operating system interface (environment variables, file paths)
import socket               # Low-level networking interface (get hostname/container ID)
import time                 # Time-related functions (sleep for retry logic)

# Third-party library imports
from fastapi import FastAPI, HTTPException    # FastAPI web framework and exception handling
from pydantic import BaseModel               # Data validation and settings management

# Local module imports
from db import init_database, get_user_name, update_user_name  # Database operations

# Create FastAPI application instance with metadata
app = FastAPI(
    title="Milestone 2 API",      # API title for documentation
    version="1.0.0"               # API version for tracking
)

# Pydantic model for request validation
class UserUpdate(BaseModel):
    name: str    # Required string field for user name updates
```

**Line-by-Line Explanation:**

1. **`import os`**: Provides access to operating system functionality like environment variables
2. **`import socket`**: Enables network operations, specifically `gethostname()` to get container ID
3. **`import time`**: Provides time utilities, used for `sleep()` in retry logic
4. **`from fastapi import FastAPI, HTTPException`**: 
   - `FastAPI`: Main web framework class
   - `HTTPException`: For returning proper HTTP error responses
5. **`from pydantic import BaseModel`**: Base class for data validation models
6. **`from db import ...`**: Imports our custom database functions
7. **`app = FastAPI(...)`**: Creates the main application instance with metadata
8. **`class UserUpdate(BaseModel)`**: Defines data structure for incoming JSON requests
9. **`name: str`**: Declares that the 'name' field must be a string

```python
# FastAPI startup event - runs when application starts
@app.on_event("startup")
async def startup_event():
    """Initialize database on startup."""
    # Configuration for retry logic
    max_retries = 30        # Maximum number of connection attempts
    retry_count = 0         # Current attempt counter
    
    # Retry loop for database connection
    while retry_count < max_retries:
        try:
            # Attempt to initialize database
            init_database()  # Call our database initialization function
            print("Database initialized successfully")  # Success message
            break           # Exit loop on success
        except Exception as e:
            # Handle any database connection errors
            print(f"Database connection failed (attempt {retry_count + 1}/{max_retries}): {e}")
            retry_count += 1    # Increment retry counter
            time.sleep(2)       # Wait 2 seconds before next attempt
```

**Line-by-Line Explanation:**

1. **`@app.on_event("startup")`**: FastAPI decorator that runs this function when the application starts
2. **`async def startup_event():`**: Defines an asynchronous function (non-blocking)
3. **`max_retries = 30`**: Sets maximum number of database connection attempts
4. **`retry_count = 0`**: Initializes counter for tracking attempts
5. **`while retry_count < max_retries:`**: Loop until max retries reached
6. **`try:`**: Start of error handling block
7. **`init_database()`**: Call our database initialization function
8. **`print("Database initialized successfully")`**: Log success message
9. **`break`**: Exit the retry loop on success
10. **`except Exception as e:`**: Catch any database connection errors
11. **`print(f"...")`**: Log error with attempt number and error details
12. **`retry_count += 1`**: Increment retry counter
13. **`time.sleep(2)`**: Wait 2 seconds before next attempt (prevents overwhelming database)

```python
# GET endpoint to retrieve current user name
@app.get("/user")                    # HTTP GET request to /user path
async def get_user():                # Asynchronous function handler
    """Get current user name from database."""
    try:
        # Call database function to get user name
        name = get_user_name()       # Retrieve name from database
        return {"name": name}        # Return JSON response with name
    except Exception as e:
        # Handle any database errors
        raise HTTPException(
            status_code=500,         # HTTP 500 Internal Server Error
            detail=f"Database error: {str(e)}"  # Error message with details
        )

# POST endpoint to update user name
@app.post("/user")                   # HTTP POST request to /user path
async def update_user(user_data: UserUpdate):  # Parameter validated by Pydantic
    """Update user name in database."""
    try:
        # Call database function to update user name
        update_user_name(user_data.name)  # Update name in database
        return {                           # Return success response
            "message": "User name updated successfully", 
            "name": user_data.name
        }
    except Exception as e:
        # Handle any database errors
        raise HTTPException(
            status_code=500,         # HTTP 500 Internal Server Error
            detail=f"Database error: {str(e)}"  # Error message with details
        )
```

**Line-by-Line Explanation:**

**GET /user Endpoint:**
1. **`@app.get("/user")`**: FastAPI decorator for HTTP GET requests to /user path
2. **`async def get_user():`**: Asynchronous function handler (non-blocking)
3. **`try:`**: Start error handling block
4. **`name = get_user_name()`**: Call database function to retrieve user name
5. **`return {"name": name}`**: Return JSON response with user name
6. **`except Exception as e:`**: Catch any database errors
7. **`raise HTTPException(...)`**: Return HTTP 500 error with details

**POST /user Endpoint:**
8. **`@app.post("/user")`**: FastAPI decorator for HTTP POST requests to /user path
9. **`async def update_user(user_data: UserUpdate):`**: Function with Pydantic validation
10. **`try:`**: Start error handling block
11. **`update_user_name(user_data.name)`**: Call database function to update name
12. **`return {...}`**: Return success response with message and updated name
13. **`except Exception as e:`**: Catch any database errors
14. **`raise HTTPException(...)`**: Return HTTP 500 error with details

```python
# GET endpoint to retrieve container ID/hostname
@app.get("/container-id")            # HTTP GET request to /container-id path
async def get_container_id():        # Asynchronous function handler
    """Get container ID/hostname."""
    hostname = socket.gethostname()  # Get system hostname (container ID in Kubernetes)
    return {"container_id": hostname} # Return JSON response with container ID
```

**Line-by-Line Explanation:**

1. **`@app.get("/container-id")`**: FastAPI decorator for HTTP GET requests to /container-id path
2. **`async def get_container_id():`**: Asynchronous function handler (non-blocking)
3. **`hostname = socket.gethostname()`**: Get the system hostname (in Kubernetes, this is the pod name)
4. **`return {"container_id": hostname}`**: Return JSON response with container ID

**Purpose**: This endpoint helps verify load balancing by showing which API instance is handling each request.

```python
# GET endpoint for health check (used by Kubernetes probes)
@app.get("/health")                  # HTTP GET request to /health path
async def health_check():            # Asynchronous function handler
    """Health check endpoint."""
    return {"status": "healthy"}     # Return simple health status
```

**Line-by-Line Explanation:**

1. **`@app.get("/health")`**: FastAPI decorator for HTTP GET requests to /health path
2. **`async def health_check():`**: Asynchronous function handler (non-blocking)
3. **`return {"status": "healthy"}`**: Return JSON response indicating healthy status

**Purpose**: This endpoint is used by Kubernetes health probes to verify the application is running.

```python
# GET endpoint for root path
@app.get("/")                        # HTTP GET request to root path
async def root():                    # Asynchronous function handler
    """Root endpoint."""
    return {"message": "Milestone 2 API is running"}  # Return API status message
```

**Line-by-Line Explanation:**

1. **`@app.get("/")`**: FastAPI decorator for HTTP GET requests to root path
2. **`async def root():`**: Asynchronous function handler (non-blocking)
3. **`return {"message": "Milestone 2 API is running"}`**: Return JSON response with API status

```python
# GET endpoint for node information (enhanced container info)
@app.get("/node-info")               # HTTP GET request to /node-info path
async def get_node_info():           # Asynchronous function handler
    """Get node and pod information."""
    hostname = socket.gethostname()  # Get system hostname (container ID)
    pod_name = os.getenv('HOSTNAME', hostname)  # Get pod name from environment or use hostname
    node_name = os.getenv('NODE_NAME', 'unknown')  # Get node name from environment or default
    
    return {                         # Return comprehensive node information
        "container_id": hostname,
        "pod_name": pod_name,
        "node_name": node_name
    }
```

**Line-by-Line Explanation:**

1. **`@app.get("/node-info")`**: FastAPI decorator for HTTP GET requests to /node-info path
2. **`async def get_node_info():`**: Asynchronous function handler (non-blocking)
3. **`hostname = socket.gethostname()`**: Get the system hostname (container ID)
4. **`pod_name = os.getenv('HOSTNAME', hostname)`**: Get pod name from environment variable
5. **`node_name = os.getenv('NODE_NAME', 'unknown')`**: Get node name from environment variable
6. **`return {...}`**: Return JSON response with container, pod, and node information

**Purpose**: This endpoint provides detailed information about the Kubernetes pod and node for debugging and monitoring.

### Monitoring and Metrics

The API also includes Prometheus monitoring capabilities:

```python
# Import monitoring libraries
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import Response
from starlette.middleware.base import BaseHTTPMiddleware

# Define Prometheus metrics
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint', 'status'])
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'HTTP request latency', ['method', 'endpoint'])
USER_OPERATIONS = Counter('user_operations_total', 'Total user operations', ['operation'])

# Middleware for automatic metrics collection
class MetricsMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        start_time = time.time()     # Record start time
        
        response = await call_next(request)  # Process the request
        
        duration = time.time() - start_time  # Calculate request duration
        # Record metrics
        REQUEST_LATENCY.labels(method=request.method, endpoint=request.url.path).observe(duration)
        REQUEST_COUNT.labels(method=request.method, endpoint=request.url.path, status=response.status_code).inc()
        
        return response

# Add middleware to app
app.add_middleware(MetricsMiddleware)
```

**Line-by-Line Explanation:**

1. **`from prometheus_client import ...`**: Import Prometheus monitoring libraries
2. **`REQUEST_COUNT = Counter(...)`**: Define counter for total HTTP requests
3. **`REQUEST_LATENCY = Histogram(...)`**: Define histogram for request duration
4. **`USER_OPERATIONS = Counter(...)`**: Define counter for user operations
5. **`class MetricsMiddleware(BaseHTTPMiddleware):`**: Define middleware for automatic metrics
6. **`async def dispatch(self, request, call_next):`**: Middleware function that processes every request
7. **`start_time = time.time()`**: Record when request processing starts
8. **`response = await call_next(request)`**: Process the actual request
9. **`duration = time.time() - start_time`**: Calculate how long the request took
10. **`REQUEST_LATENCY.labels(...).observe(duration)`**: Record request duration metric
11. **`REQUEST_COUNT.labels(...).inc()`**: Increment request count metric
12. **`app.add_middleware(MetricsMiddleware)`**: Add middleware to FastAPI app

```python
# GET endpoint for Prometheus metrics
@app.get("/metrics")                 # HTTP GET request to /metrics path
async def get_metrics():             # Asynchronous function handler
    """Get Prometheus metrics."""
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)  # Return metrics in Prometheus format
```

**Line-by-Line Explanation:**

1. **`@app.get("/metrics")`**: FastAPI decorator for HTTP GET requests to /metrics path
2. **`async def get_metrics():`**: Asynchronous function handler (non-blocking)
3. **`return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)`**: Return Prometheus metrics

**Purpose**: This endpoint exposes metrics for Prometheus to scrape and monitor application performance.

---

## Step 5: Database Implementation

**Objective**: Understand how the PostgreSQL database is configured and managed.

**Estimated Time**: 10-15 minutes

### 5.1 Database Connection Layer

The database layer handles all database operations. Let's examine every line of the database connection module:

```python
# Standard library imports
import os                    # Operating system interface (environment variables)
from contextlib import contextmanager  # Context manager utilities

# Third-party library imports
import psycopg2              # PostgreSQL adapter for Python
from psycopg2.extras import RealDictCursor  # Dictionary-like cursor for easier data access

# Database configuration using environment variables with defaults
DB_HOST = os.getenv('DATABASE_HOST', 'postgres-lm')      # Database host (Kubernetes service name)
DB_PORT = os.getenv('DATABASE_PORT', '5432')             # Database port (PostgreSQL default)
DB_NAME = os.getenv('DATABASE_NAME', 'milestone2')       # Database name
DB_USER = os.getenv('DATABASE_USER', 'postgres')         # Database username
DB_PASSWORD = os.getenv('DATABASE_PASSWORD', 'password123')  # Database password
```

**Line-by-Line Explanation:**

1. **`import os`**: Provides access to environment variables via `os.getenv()`
2. **`from contextlib import contextmanager`**: Provides decorator for creating context managers
3. **`import psycopg2`**: PostgreSQL database adapter for Python
4. **`from psycopg2.extras import RealDictCursor`**: Cursor that returns results as dictionaries
5. **`DB_HOST = os.getenv('DATABASE_HOST', 'postgres-lm')`**: 
   - Gets DATABASE_HOST from environment variables
   - Defaults to 'postgres-lm' (Kubernetes service name) if not set
6. **`DB_PORT = os.getenv('DATABASE_PORT', '5432')`**: 
   - Gets DATABASE_PORT from environment variables
   - Defaults to '5432' (PostgreSQL default port) if not set
7. **`DB_NAME = os.getenv('DATABASE_NAME', 'milestone2')`**: 
   - Gets DATABASE_NAME from environment variables
   - Defaults to 'milestone2' if not set
8. **`DB_USER = os.getenv('DATABASE_USER', 'postgres')`**: 
   - Gets DATABASE_USER from environment variables
   - Defaults to 'postgres' if not set
9. **`DB_PASSWORD = os.getenv('DATABASE_PASSWORD', 'password123')`**: 
   - Gets DATABASE_PASSWORD from environment variables
   - Defaults to 'password123' if not set

**Why Environment Variables?**
- **Flexibility**: Different environments can use different database settings
- **Security**: Sensitive data can be injected at runtime
- **Kubernetes Integration**: ConfigMaps and Secrets can provide these values

```python
# Context manager for database connections - ensures proper cleanup
@contextmanager                    # Decorator that creates a context manager
def get_db_connection():           # Function that manages database connections
    """Context manager for database connections."""
    conn = None                    # Initialize connection variable to None
    try:
        # Create database connection using configuration variables
        conn = psycopg2.connect(
            host=DB_HOST,          # Database host from environment variable
            port=DB_PORT,          # Database port from environment variable
            database=DB_NAME,      # Database name from environment variable
            user=DB_USER,          # Database user from environment variable
            password=DB_PASSWORD   # Database password from environment variable
        )
        yield conn                 # Yield connection to the calling code
    finally:
        # Always execute this block, even if an exception occurs
        if conn:                   # Check if connection exists
            conn.close()           # Close the database connection
```

**Line-by-Line Explanation:**

1. **`@contextmanager`**: Decorator that converts this function into a context manager
2. **`def get_db_connection():`**: Function definition for database connection management
3. **`conn = None`**: Initialize connection variable to None (will be set in try block)
4. **`try:`**: Start of error handling block
5. **`conn = psycopg2.connect(...)`**: Create PostgreSQL connection with our configuration
6. **`host=DB_HOST`**: Use database host from environment variable
7. **`port=DB_PORT`**: Use database port from environment variable
8. **`database=DB_NAME`**: Use database name from environment variable
9. **`user=DB_USER`**: Use database user from environment variable
10. **`password=DB_PASSWORD`**: Use database password from environment variable
11. **`yield conn`**: Provide connection to the calling code (using `with` statement)
12. **`finally:`**: Block that always executes, even if exceptions occur
13. **`if conn:`**: Check if connection was successfully created
14. **`conn.close()`**: Close the database connection to free resources

**Usage Example:**
```python
# Using the context manager ensures connection is always closed
with get_db_connection() as conn:
    # Use connection here
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    # Connection automatically closed when exiting 'with' block
```

```python
def init_database():
    """Initialize the database with required tables."""
    # Use context manager to ensure proper connection handling
    with get_db_connection() as conn:
        # Use context manager for cursor to ensure proper cleanup
        with conn.cursor() as cursor:
            # Create users table if it doesn't exist (idempotent operation)
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
                    name VARCHAR(255) NOT NULL,               -- User name (required, max 255 chars)
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation time
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP   -- Record update time
                )
            """)
            
            # Check if table is empty by counting records
            cursor.execute("SELECT COUNT(*) FROM users")      # Count all records in users table
            count = cursor.fetchone()[0]                      # Get the count value (first column of first row)
            
            # Insert default user only if table is empty
            if count == 0:
                cursor.execute("""
                    INSERT INTO users (name) VALUES ('Default User')  -- Insert default user record
                """)
            
            # Commit the transaction to save changes
            conn.commit()
```

**Line-by-Line Explanation:**

1. **`def init_database():`**: Function definition for database initialization
2. **`with get_db_connection() as conn:`**: Use context manager for database connection
3. **`with conn.cursor() as cursor:`**: Use context manager for database cursor
4. **`cursor.execute("""...""")`**: Execute SQL to create table
5. **`CREATE TABLE IF NOT EXISTS users (`**: Create table only if it doesn't exist
6. **`id SERIAL PRIMARY KEY,`**: Auto-incrementing primary key column
7. **`name VARCHAR(255) NOT NULL,`**: Required name field with max 255 characters
8. **`created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,`**: Automatic timestamp for creation
9. **`updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`**: Automatic timestamp for updates
10. **`cursor.execute("SELECT COUNT(*) FROM users")`**: Count all records in users table
11. **`count = cursor.fetchone()[0]`**: Get the count value from query result
12. **`if count == 0:`**: Only proceed if table is empty
13. **`cursor.execute("""INSERT INTO users (name) VALUES ('Default User')""")`**: Insert default user
14. **`conn.commit()`**: Save all changes to database

**Why This Design?**
- **Idempotent**: Can be run multiple times safely
- **Default Data**: Ensures there's always a user to display
- **Transaction Safety**: Uses explicit commits for data integrity

```python
def get_user_name():
    """Get the current user name from the database."""
    # Use context manager for database connection
    with get_db_connection() as conn:
        # Use RealDictCursor for dictionary-like results
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            # Get the first user's name (ordered by ID)
            cursor.execute("SELECT name FROM users ORDER BY id LIMIT 1")
            result = cursor.fetchone()                    # Get the first row
            return result['name'] if result else 'Unknown User'  # Return name or default
```

**Line-by-Line Explanation:**

1. **`def get_user_name():`**: Function to retrieve current user name
2. **`with get_db_connection() as conn:`**: Use context manager for connection
3. **`with conn.cursor(cursor_factory=RealDictCursor) as cursor:`**: Use dictionary cursor
4. **`cursor.execute("SELECT name FROM users ORDER BY id LIMIT 1")`**: Query first user
5. **`result = cursor.fetchone()`**: Get the first row from query result
6. **`return result['name'] if result else 'Unknown User'`**: Return name or default

```python
def update_user_name(name):
    """Update the user name in the database."""
    # Use context manager for database connection
    with get_db_connection() as conn:
        # Use context manager for cursor
        with conn.cursor() as cursor:
            # Update the first user's name (ordered by ID)
            cursor.execute("""
                UPDATE users 
                SET name = %s, updated_at = CURRENT_TIMESTAMP 
                WHERE id = (SELECT MIN(id) FROM users)
            """, (name,))  # Parameterized query for security
            
            # If no rows were updated, insert a new user
            if cursor.rowcount == 0:
                cursor.execute("""
                    INSERT INTO users (name) VALUES (%s)
                """, (name,))  # Parameterized query for security
            
            # Commit the transaction
            conn.commit()
```

**Line-by-Line Explanation:**

1. **`def update_user_name(name):`**: Function to update user name with parameter
2. **`with get_db_connection() as conn:`**: Use context manager for connection
3. **`with conn.cursor() as cursor:`**: Use context manager for cursor
4. **`cursor.execute("""UPDATE users...""", (name,))`**: Update first user with parameterized query
5. **`SET name = %s, updated_at = CURRENT_TIMESTAMP`**: Update name and timestamp
6. **`WHERE id = (SELECT MIN(id) FROM users)`**: Target the first user by ID
7. **`if cursor.rowcount == 0:`**: Check if update affected any rows
8. **`cursor.execute("""INSERT INTO users...""", (name,))`**: Insert new user if none exists
9. **`conn.commit()`**: Save changes to database

**Security Features:**
- **Parameterized Queries**: Prevents SQL injection attacks
- **Transaction Safety**: Uses explicit commits
- **Error Handling**: Graceful fallback to insert if update fails

---

## Step 6: Frontend Implementation

**Objective**: Understand how the web frontend works and integrates with the backend.

**Estimated Time**: 15-20 minutes

### 6.1 Static HTML Frontend

The frontend is a simple HTML page that communicates with the API. Let's examine every line of the frontend HTML file:

### PostgreSQL Container (`db/Dockerfile`)

Let's examine every line of the PostgreSQL Dockerfile:

```dockerfile
# Use official PostgreSQL 15 Alpine image as base
FROM postgres:15-alpine

# Copy initialization script to PostgreSQL's init directory
COPY init.sql /docker-entrypoint-initdb.d/

# Set PostgreSQL environment variables
ENV POSTGRES_DB=milestone2        # Database name
ENV POSTGRES_USER=postgres        # Database username
ENV POSTGRES_PASSWORD=password123 # Database password

# Expose PostgreSQL default port
EXPOSE 5432

# Configure health check for container monitoring
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD pg_isready -U postgres -d milestone2 || exit 1
```

**Line-by-Line Explanation:**

1. **`FROM postgres:15-alpine`**: Use official PostgreSQL 15 Alpine Linux image as base
2. **`COPY init.sql /docker-entrypoint-initdb.d/`**: Copy our initialization script to PostgreSQL's auto-execution directory
3. **`ENV POSTGRES_DB=milestone2`**: Set environment variable for database name
4. **`ENV POSTGRES_USER=postgres`**: Set environment variable for database username
5. **`ENV POSTGRES_PASSWORD=password123`**: Set environment variable for database password
6. **`EXPOSE 5432`**: Document that the container listens on port 5432 (PostgreSQL default)
7. **`HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3`**: Configure health check parameters
8. **`CMD pg_isready -U postgres -d milestone2 || exit 1`**: Health check command that tests database connectivity

**Health Check Parameters Explained:**
- **`--interval=30s`**: Run health check every 30 seconds
- **`--timeout=3s`**: Wait up to 3 seconds for health check to complete
- **`--start-period=30s`**: Allow 30 seconds for container to start before first health check
- **`--retries=3`**: Mark container as unhealthy after 3 consecutive failures

### Database Initialization (`db/init.sql`)

Let's examine every line of the database initialization script:

```sql
-- Create the milestone2 database (if not exists)
-- This is handled by POSTGRES_DB environment variable in Dockerfile

-- Create users table with proper constraints
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
    name VARCHAR(255) NOT NULL,               -- User name (required, max 255 characters)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Automatic timestamp for record creation
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP   -- Automatic timestamp for record updates
);

-- Insert default user if no conflict exists
INSERT INTO users (name) VALUES ('Default User')
ON CONFLICT DO NOTHING;                       -- Skip insert if user already exists
```

**Line-by-Line Explanation:**

1. **`-- Create the milestone2 database...`**: Comment explaining database creation
2. **`-- This is handled by POSTGRES_DB environment variable`**: Comment explaining how database is created
3. **`-- Create users table with proper constraints`**: Comment explaining table creation
4. **`CREATE TABLE IF NOT EXISTS users (`**: Create table only if it doesn't already exist
5. **`id SERIAL PRIMARY KEY,`**: Define auto-incrementing primary key column
6. **`name VARCHAR(255) NOT NULL,`**: Define required name field with maximum 255 characters
7. **`created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,`**: Define automatic creation timestamp
8. **`updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`**: Define automatic update timestamp
9. **`);`**: End table definition
10. **`-- Insert default user if no conflict exists`**: Comment explaining insert operation
11. **`INSERT INTO users (name) VALUES ('Default User')`**: Insert default user record
12. **`ON CONFLICT DO NOTHING;`**: Skip insert if a conflict occurs (idempotent operation)

**SQL Features Explained:**
- **`IF NOT EXISTS`**: Prevents errors if table already exists
- **`SERIAL`**: Auto-incrementing integer (PostgreSQL equivalent of AUTO_INCREMENT)
- **`PRIMARY KEY`**: Ensures unique identification of records
- **`NOT NULL`**: Prevents null values in name field
- **`DEFAULT CURRENT_TIMESTAMP`**: Automatically sets timestamp when record is created/updated
- **`ON CONFLICT DO NOTHING`**: Makes the script idempotent (safe to run multiple times)

## Frontend Implementation

### Static HTML (`frontend/index.html`)

Let's examine every line of the frontend HTML file:

```html
<!DOCTYPE html>                    <!-- HTML5 document type declaration -->
<html lang="en">                   <!-- Root HTML element with English language -->
  <head>                           <!-- Document head section -->
    <meta charset="UTF-8" />       <!-- Character encoding for proper text display -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />  <!-- IE compatibility mode -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />  <!-- Mobile responsive viewport -->
    <title>Milestone 2</title>     <!-- Page title displayed in browser tab -->
  </head>
  <body>                           <!-- Document body section -->
    <!-- Main heading with dynamic user name -->
    <h1><span id="user">Loading...</span> has reached milestone 2!</h1>
    
    <!-- Container ID display for load balancing verification -->
    <p>Container ID: <span id="container-id">Loading...</span></p>
    
    <!-- Interactive buttons for testing -->
    <div style="margin-top: 20px;">
      <button onclick="refreshData()">Refresh Data</button>
      <button onclick="testLoadBalancing()">Test Load Balancing</button>
    </div>

    <!-- Results display area for load balancing tests -->
    <div id="load-balance-results" style="margin-top: 20px; display: none;">
      <h3>Load Balancing Test Results:</h3>
      <div id="results-list"></div>
    </div>

    <script>                       <!-- JavaScript section -->
      // Function to fetch user data from API
      async function fetchUserData() {
        try {
          const response = await fetch("/api/user");        // Make HTTP GET request to API
          const data = await response.json();               // Parse JSON response
          document.getElementById("user").innerText = data.name;  // Update user name display
        } catch (error) {
          console.error("Error fetching user data:", error);      // Log error to console
          document.getElementById("user").innerText = "Error loading user";  // Show error message
        }
      }

      // Function to fetch container ID for load balancing verification
      async function fetchContainerId() {
        try {
          const response = await fetch("/api/container-id");      // Make HTTP GET request to API
          const data = await response.json();                     // Parse JSON response
          document.getElementById("container-id").innerText = data.container_id;  // Update container ID display
        } catch (error) {
          console.error("Error fetching container ID:", error);   // Log error to console
          document.getElementById("container-id").innerText = "Error loading container ID";  // Show error message
        }
      }

      // Function to refresh all data on page
      function refreshData() {
        fetchUserData();           // Fetch user data
        fetchContainerId();        // Fetch container ID
      }

      // Function to test load balancing by making multiple requests
      async function testLoadBalancing() {
        const resultsDiv = document.getElementById("load-balance-results");    // Get results container
        const resultsList = document.getElementById("results-list");           // Get results list
        
        resultsDiv.style.display = "block";                    // Show results container
        resultsList.innerHTML = "<p>Testing load balancing...</p>";           // Show loading message
        
        const results = [];                                     // Array to store container IDs
        
        // Make 10 requests to test load balancing
        for (let i = 0; i < 10; i++) {
          try {
            const response = await fetch("/api/container-id");  // Make request to container ID endpoint
            const data = await response.json();                 // Parse response
            results.push(data.container_id);                    // Store container ID
            
            // Update results display in real-time
            resultsList.innerHTML = results.map((id, index) => 
              `<p>Request ${index + 1}: ${id}</p>`              // Show each request result
            ).join("");
            
            // Small delay between requests to avoid overwhelming the server
            await new Promise(resolve => setTimeout(resolve, 200));
          } catch (error) {
            console.error(`Error in request ${i + 1}:`, error); // Log any errors
          }
        }
        
        // Calculate and display summary statistics
        const uniqueIds = [...new Set(results)];               // Get unique container IDs
        resultsList.innerHTML += `<h4>Summary:</h4><p>Total requests: ${results.length}</p><p>Unique containers: ${uniqueIds.length}</p><p>Containers used: ${uniqueIds.join(", ")}</p>`;
      }

      // Load initial data when page loads
      refreshData();
    </script>
  </body>
</html>
```

**Line-by-Line Explanation:**

**HTML Structure:**
1. **`<!DOCTYPE html>`**: Declares this as an HTML5 document
2. **`<html lang="en">`**: Root element with English language specification
3. **`<head>`**: Contains document metadata
4. **`<meta charset="UTF-8" />`**: Ensures proper character encoding
5. **`<meta http-equiv="X-UA-Compatible" content="IE=edge" />`**: Forces IE to use latest rendering engine
6. **`<meta name="viewport" content="width=device-width, initial-scale=1.0" />`**: Makes page responsive on mobile devices
7. **`<title>Milestone 2</title>`**: Sets browser tab title

**Body Content:**
8. **`<h1><span id="user">Loading...</span> has reached milestone 2!</h1>`**: Main heading with dynamic user name
9. **`<p>Container ID: <span id="container-id">Loading...</span></p>`**: Shows which container is handling requests
10. **`<button onclick="refreshData()">Refresh Data</button>`**: Button to manually refresh data
11. **`<button onclick="testLoadBalancing()">Test Load Balancing</button>`**: Button to test load balancing
12. **`<div id="load-balance-results">`**: Container for displaying load balancing test results

**JavaScript Functions:**
13. **`async function fetchUserData()`**: Asynchronous function to get user data from API
14. **`const response = await fetch("/api/user")`**: Make HTTP request to user endpoint
15. **`const data = await response.json()`**: Parse JSON response
16. **`document.getElementById("user").innerText = data.name`**: Update DOM with user name
17. **`async function fetchContainerId()`**: Asynchronous function to get container ID
18. **`function refreshData()`**: Function to refresh both user data and container ID
19. **`async function testLoadBalancing()`**: Function to test load balancing with multiple requests
20. **`for (let i = 0; i < 10; i++)`**: Loop to make 10 requests
21. **`const uniqueIds = [...new Set(results)]`**: Get unique container IDs using Set
22. **`refreshData()`**: Call to load initial data when page loads

**Features:**
- **Responsive Design**: Works on mobile and desktop devices
- **Error Handling**: Gracefully handles API errors
- **Real-time Updates**: Shows load balancing results as they happen
- **Interactive Testing**: Allows users to test load balancing functionality
- **Async/Await**: Uses modern JavaScript for clean asynchronous code

### NGINX Configuration (`frontend/nginx.conf`)

Let's examine every line of the NGINX configuration file:

```nginx
# Global event configuration
events {
    worker_connections 1024;        # Maximum concurrent connections per worker process
}

# HTTP server configuration
http {
    include       /etc/nginx/mime.types;     # Include MIME type definitions
    default_type  application/octet-stream;  # Default MIME type for unknown files

    # Define log format for access logs
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    # Configure log file locations
    access_log /var/log/nginx/access.log main;  # Access log with main format
    error_log /var/log/nginx/error.log;         # Error log location

    # Performance optimization settings
    sendfile on;                    # Enable efficient file serving
    tcp_nopush on;                  # Optimize packet sending
    tcp_nodelay on;                 # Disable Nagle's algorithm
    keepalive_timeout 65;           # Keep connections alive for 65 seconds
    types_hash_max_size 2048;       # Maximum size of types hash table
```

**Line-by-Line Explanation:**

**Events Block:**
1. **`events {`**: Start of events configuration block
2. **`worker_connections 1024;`**: Set maximum concurrent connections per worker process

**HTTP Block:**
3. **`http {`**: Start of HTTP configuration block
4. **`include /etc/nginx/mime.types;`**: Include standard MIME type definitions
5. **`default_type application/octet-stream;`**: Set default MIME type for unknown files
6. **`log_format main '...'`**: Define custom log format with detailed information
7. **`access_log /var/log/nginx/access.log main;`**: Configure access log location and format
8. **`error_log /var/log/nginx/error.log;`**: Configure error log location
9. **`sendfile on;`**: Enable efficient file serving (bypasses user space)
10. **`tcp_nopush on;`**: Optimize packet sending for better performance
11. **`tcp_nodelay on;`**: Disable Nagle's algorithm for faster response
12. **`keepalive_timeout 65;`**: Keep connections alive for 65 seconds
13. **`types_hash_max_size 2048;`**: Set maximum size of MIME types hash table

**Log Format Variables Explained:**
- **`$remote_addr`**: Client IP address
- **`$remote_user`**: Username for HTTP authentication
- **`$time_local`**: Local time in standard format
- **`$request`**: Full HTTP request line
- **`$status`**: HTTP response status code
- **`$body_bytes_sent`**: Number of bytes sent to client
- **`$http_referer`**: Referer header from client
- **`$http_user_agent`**: User agent string from client
- **`$http_x_forwarded_for`**: X-Forwarded-For header (for proxy scenarios)

```nginx
    # Virtual server configuration
    server {
        listen 80;                          # Listen on port 80 for HTTP requests
        server_name localhost;              # Server name for this virtual host
        root /usr/share/nginx/html;         # Document root directory
        index index.html;                   # Default index file

        # Serve static files (HTML, CSS, JS)
        location / {
            try_files $uri $uri/ /index.html;  # Try exact file, then directory, then fallback to index.html
        }

        # Proxy API requests to FastAPI backend service
        location /api/ {
            proxy_pass http://api-lm:8000/;    # Forward requests to API service
            proxy_set_header Host $host;       # Preserve original Host header
            proxy_set_header X-Real-IP $remote_addr;  # Set real client IP
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  # Preserve client IP chain
            proxy_set_header X-Forwarded-Proto $scheme;  # Preserve original protocol (http/https)
        }

        # Health check endpoint for Kubernetes probes
        location /health {
            access_log off;                   # Disable access logging for health checks
            return 200 "healthy\n";           # Return simple health status
            add_header Content-Type text/plain;  # Set content type to plain text
        }

        # Prometheus metrics endpoint for monitoring
        location /metrics {
            stub_status on;                   # Enable NGINX status module
            access_log off;                   # Disable access logging for metrics
        }
    }
}
```

**Line-by-Line Explanation:**

**Server Block:**
1. **`server {`**: Start of virtual server configuration
2. **`listen 80;`**: Listen for HTTP requests on port 80
3. **`server_name localhost;`**: Server name for this virtual host
4. **`root /usr/share/nginx/html;`**: Set document root directory
5. **`index index.html;`**: Set default index file

**Static File Serving:**
6. **`location / {`**: Location block for root path
7. **`try_files $uri $uri/ /index.html;`**: Try to serve exact file, then directory, then fallback to index.html

**API Proxy Configuration:**
8. **`location /api/ {`**: Location block for API requests
9. **`proxy_pass http://api-lm:8000/;`**: Forward requests to FastAPI service
10. **`proxy_set_header Host $host;`**: Preserve original Host header
11. **`proxy_set_header X-Real-IP $remote_addr;`**: Set real client IP address
12. **`proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;`**: Preserve client IP chain
13. **`proxy_set_header X-Forwarded-Proto $scheme;`**: Preserve original protocol

**Health Check:**
14. **`location /health {`**: Location block for health checks
15. **`access_log off;`**: Disable access logging for health checks
16. **`return 200 "healthy\n";`**: Return HTTP 200 with health status
17. **`add_header Content-Type text/plain;`**: Set content type header

**Metrics Endpoint:**
18. **`location /metrics {`**: Location block for metrics
19. **`stub_status on;`**: Enable NGINX status module for metrics
20. **`access_log off;`**: Disable access logging for metrics

**Proxy Headers Explained:**
- **`Host`**: Preserves the original host header for proper routing
- **`X-Real-IP`**: Passes the real client IP address to the backend
- **`X-Forwarded-For`**: Maintains the chain of IP addresses through proxies
- **`X-Forwarded-Proto`**: Indicates the original protocol (http/https)

### Frontend Container (`frontend/Dockerfile`)

Let's examine every line of the frontend Dockerfile:

```dockerfile
# Use official NGINX Alpine image as base
FROM nginx:alpine

# Install curl package for health check functionality
RUN apk add --no-cache curl

# Copy the static HTML file to NGINX document root
COPY index.html /usr/share/nginx/html/index.html

# Copy custom NGINX configuration to replace default
COPY nginx.conf /etc/nginx/nginx.conf

# Expose HTTP port 80 for web traffic
EXPOSE 80

# Configure health check for container monitoring
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/health || exit 1
```

**Line-by-Line Explanation:**

1. **`FROM nginx:alpine`**: Use official NGINX Alpine Linux image as base (minimal size)
2. **`RUN apk add --no-cache curl`**: Install curl package for health check functionality
3. **`COPY index.html /usr/share/nginx/html/index.html`**: Copy our HTML file to NGINX document root
4. **`COPY nginx.conf /etc/nginx/nginx.conf`**: Copy our custom NGINX configuration
5. **`EXPOSE 80`**: Document that the container listens on port 80 (HTTP)
6. **`HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3`**: Configure health check parameters
7. **`CMD curl -f http://localhost/health || exit 1`**: Health check command that tests NGINX health endpoint

**Health Check Parameters Explained:**
- **`--interval=30s`**: Run health check every 30 seconds
- **`--timeout=3s`**: Wait up to 3 seconds for health check to complete
- **`--start-period=5s`**: Allow 5 seconds for container to start before first health check
- **`--retries=3`**: Mark container as unhealthy after 3 consecutive failures

**Why Alpine Linux?**
- **Small Size**: Alpine images are much smaller than standard Linux distributions
- **Security**: Minimal attack surface with fewer packages
- **Performance**: Faster container startup and deployment

---

## Step 7: Docker Containerization

**Objective**: Understand how each component is packaged into Docker containers.

**Estimated Time**: 15-20 minutes

### 7.1 Container Overview

Each component of our application is packaged into its own Docker container:
- **Frontend Container**: NGINX serving static HTML
- **API Container**: FastAPI Python application
- **Database Container**: PostgreSQL database

Let's examine each container configuration:

### API Container (`api/Dockerfile`)

Let's examine every line of the API Dockerfile:

```dockerfile
# Use official Python 3.11 slim image as base
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Install system dependencies required for Python packages
RUN apt-get update && apt-get install -y \
    gcc \                           # C compiler for building Python packages
    && rm -rf /var/lib/apt/lists/*  # Clean up package cache to reduce image size

# Copy requirements file and install Python dependencies
COPY requirements.txt .             # Copy requirements file to working directory
RUN pip install --no-cache-dir -r requirements.txt  # Install Python packages

# Copy application source code
COPY app.py .                       # Copy main FastAPI application file
COPY db.py .                        # Copy database connection module

# Expose port 8000 for FastAPI application
EXPOSE 8000

# Configure health check for container monitoring
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# Command to run the FastAPI application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Line-by-Line Explanation:**

1. **`FROM python:3.11-slim`**: Use official Python 3.11 slim image (smaller than full Python image)
2. **`WORKDIR /app`**: Set working directory to /app inside the container
3. **`RUN apt-get update && apt-get install -y gcc && rm -rf /var/lib/apt/lists/*`**: 
   - Update package list
   - Install gcc compiler (needed for some Python packages)
   - Clean up package cache to reduce image size
4. **`COPY requirements.txt .`**: Copy requirements file to working directory
5. **`RUN pip install --no-cache-dir -r requirements.txt`**: Install Python packages without caching
6. **`COPY app.py .`**: Copy main FastAPI application file
7. **`COPY db.py .`**: Copy database connection module
8. **`EXPOSE 8000`**: Document that the container listens on port 8000
9. **`HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3`**: Configure health check parameters
10. **`CMD curl -f http://localhost:8000/health || exit 1`**: Health check command
11. **`CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]`**: Run uvicorn ASGI server

**Uvicorn Command Explained:**
- **`uvicorn`**: ASGI server for running FastAPI applications
- **`app:app`**: Module name (app.py) and application instance (app)
- **`--host "0.0.0.0"`**: Bind to all network interfaces (not just localhost)
- **`--port "8000"`**: Listen on port 8000

**Why Python Slim?**
- **Smaller Size**: Slim images are much smaller than full Python images
- **Security**: Fewer packages means smaller attack surface
- **Performance**: Faster container startup and deployment

### Python Dependencies (`api/requirements.txt`)

Let's examine every line of the Python dependencies file:

```txt
fastapi==0.104.1              # Modern web framework for building APIs
uvicorn[standard]==0.24.0     # ASGI server with standard extras for running FastAPI
psycopg2-binary==2.9.9        # PostgreSQL adapter for Python (binary distribution)
sqlalchemy==2.0.23            # SQL toolkit and Object-Relational Mapping library
python-multipart==0.0.6       # Library for parsing multipart form data
prometheus-client==0.19.0     # Prometheus monitoring client for metrics collection
```

**Line-by-Line Explanation:**

1. **`fastapi==0.104.1`**: Modern, fast web framework for building APIs with automatic documentation
2. **`uvicorn[standard]==0.24.0`**: ASGI server with standard extras (websockets, etc.) for running FastAPI applications
3. **`psycopg2-binary==2.9.9`**: PostgreSQL adapter for Python (binary distribution, easier to install)
4. **`sqlalchemy==2.0.23`**: SQL toolkit and Object-Relational Mapping library for database operations
5. **`python-multipart==0.0.6`**: Library for parsing multipart form data (file uploads, etc.)
6. **`prometheus-client==0.19.0`**: Prometheus monitoring client for collecting and exposing metrics

**Dependency Purposes:**
- **FastAPI**: Provides the web framework with automatic API documentation
- **Uvicorn**: ASGI server that runs the FastAPI application
- **psycopg2-binary**: Enables PostgreSQL database connections
- **SQLAlchemy**: Provides database abstraction and ORM capabilities
- **python-multipart**: Handles file uploads and form data
- **prometheus-client**: Enables application monitoring and metrics collection

**Version Pinning:**
- **`==`**: Exact version pinning ensures reproducible builds
- **Specific versions**: Prevents unexpected breaking changes from dependency updates

---

## Step 8: Kubernetes Orchestration

**Objective**: Understand how Kubernetes manages and orchestrates our containers.

**Estimated Time**: 20-25 minutes

### 8.1 Kubernetes Overview

Kubernetes is a container orchestration platform that manages:
- **Deployments**: How many copies of each application to run
- **Services**: How applications communicate with each other
- **ConfigMaps and Secrets**: Configuration and sensitive data
- **Health Checks**: Monitoring application health
- **Load Balancing**: Distributing traffic across multiple instances

Let's examine the Kubernetes configuration files:

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

---

## Step 9: Deployment Automation

**Objective**: Understand how the deployment scripts automate the entire process.

**Estimated Time**: 10-15 minutes

### 9.1 Automation Overview

The project includes PowerShell scripts that automate:
- **Cluster Creation**: Setting up the Kubernetes cluster
- **Image Building**: Creating Docker containers
- **Deployment**: Deploying all components to Kubernetes
- **Status Monitoring**: Checking deployment status
- **Access Setup**: Setting up port forwarding

Let's examine the main deployment script:

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

---

## Step 10: Testing and Verification

**Objective**: Test the deployed application and verify all components are working.

**Estimated Time**: 15-20 minutes

### 10.1 Testing Strategy

We'll test the application in several ways:
- **Frontend Testing**: Verify the web interface works
- **API Testing**: Test all API endpoints
- **Database Testing**: Verify data persistence
- **Load Balancing Testing**: Test distribution across multiple instances
- **Integration Testing**: Verify all components work together

Let's start testing:

### 10.2 Check Deployment Status

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

---

## Step 11: Monitoring and Metrics

**Objective**: Understand how the application is monitored and how to view metrics.

**Estimated Time**: 10-15 minutes

### 11.1 Monitoring Overview

The application includes comprehensive monitoring:
- **Prometheus Metrics**: Application performance metrics
- **Health Checks**: Container and application health monitoring
- **Logs**: Application and system logs
- **Resource Monitoring**: CPU, memory, and network usage

### 11.2 Viewing Metrics

```powershell
# Check Prometheus metrics from the API
Invoke-WebRequest -Uri "http://localhost:8000/metrics" -Method GET

# Check NGINX metrics from the frontend
Invoke-WebRequest -Uri "http://localhost:8080/metrics" -Method GET
```

### 11.3 Application Logs

```powershell
# Check API logs
kubectl logs -n lm-webstack deployment/api-lm --tail=20

# Check frontend logs
kubectl logs -n lm-webstack deployment/frontend-lm --tail=20

# Check database logs
kubectl logs -n lm-webstack deployment/postgres-lm --tail=20
```

### 11.4 Resource Usage

```powershell
# Check pod resource usage
kubectl top pods -n lm-webstack

# Check node resource usage
kubectl top nodes
```

---

## Step 12: Load Balancing and Scaling

**Objective**: Understand how load balancing works and how to scale the application.

**Estimated Time**: 10-15 minutes

### 12.1 Load Balancing Overview

The application uses Kubernetes load balancing:
- **Multiple API Replicas**: 3 API instances handle requests
- **Automatic Distribution**: Requests are distributed across replicas
- **High Availability**: If one instance fails, others continue serving
- **Node Distribution**: Pods are distributed across multiple nodes

### 12.2 Testing Load Balancing

```powershell
# Test load balancing by making multiple requests
for ($i = 1; $i -le 10; $i++) {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/container-id" -Method GET
    $data = $response.Content | ConvertFrom-Json
    Write-Host "Request $i`: $($data.container_id)"
}
```

### 12.3 Scaling the Application

```powershell
# Scale the API to 5 replicas
kubectl scale deployment api-lm -n lm-webstack --replicas=5

# Check the new deployment status
kubectl get pods -n lm-webstack

# Scale back to 3 replicas
kubectl scale deployment api-lm -n lm-webstack --replicas=3
```

---

## Step 13: Troubleshooting and Cleanup

**Objective**: Learn how to troubleshoot issues and clean up resources.

**Estimated Time**: 10-15 minutes

### 13.1 Troubleshooting Common Issues

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

### 13.2 Cleanup Resources

When you're done with the application, you should clean up all resources:

```powershell
# Stop port forwarding (press Ctrl+C in terminal windows running port forwarding)

# Remove all Kubernetes resources
powershell -ExecutionPolicy Bypass -File run.ps1 clean

# Stop the cluster
powershell -ExecutionPolicy Bypass -File run.ps1 stop-cluster

# Optional: Remove Docker images
docker rmi frontend-lm:latest api-lm:latest postgres-lm:latest --force
```

**What This Does**:
- **clean**: Removes all resources in the lm-webstack namespace
- **stop-cluster**: Deletes the entire kind cluster
- **docker rmi**: Removes the Docker images to free up disk space

---

## Summary

Congratulations! You have successfully:

✅ **Installed all required tools** (Docker, kubectl, kind, Git)
✅ **Understood the project structure** and code organization
✅ **Deployed a complete web application** with frontend, backend, and database
✅ **Learned about containerization** with Docker
✅ **Mastered Kubernetes orchestration** with deployments, services, and configs
✅ **Tested load balancing** across multiple application instances
✅ **Monitored application performance** with metrics and logs
✅ **Scaled the application** horizontally
✅ **Troubleshot common issues** and cleaned up resources

You now have hands-on experience with modern containerized application development and deployment!

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
