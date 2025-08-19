# 🚀 Getting Started Guide - Milestone 2 Project

Welcome to the Milestone 2 Kubernetes project! This guide will help you get everything set up and running on your local machine.

## 📋 **Prerequisites**

Before you begin, make sure you have the following installed on your system:

### **Required Software**
- **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop/)
- **kubectl** - [Installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- **PowerShell** (Windows) or **Bash** (Linux/macOS)

### **System Requirements**
- **Windows 10/11** (recommended) or **macOS** or **Linux**
- **8GB RAM** minimum (16GB recommended)
- **10GB free disk space**
- **Administrator privileges** (for Docker installation)

---

## 🔧 **Installation Steps**

### **Step 1: Install Docker Desktop**

1. **Download Docker Desktop** from [docker.com](https://www.docker.com/products/docker-desktop/)
2. **Run the installer** and follow the setup wizard
3. **Restart your computer** when prompted
4. **Start Docker Desktop** and wait for it to be ready (you'll see the Docker icon in your system tray)

### **Step 2: Install kubectl**

#### **Windows (using Chocolatey):**
```powershell
# Install Chocolatey first if you don't have it
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install kubectl
choco install kubernetes-cli
```

#### **Windows (manual installation):**
1. Download the latest kubectl from [GitHub releases](https://github.com/kubernetes/kubernetes/releases)
2. Extract the `kubectl.exe` file
3. Add it to your PATH or place it in a directory that's already in your PATH

#### **macOS:**
```bash
# Using Homebrew
brew install kubectl

# Or using curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

#### **Linux:**
```bash
# Using curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### **Step 3: Install kind (Kubernetes in Docker)**

#### **Windows:**
```powershell
# Create tools directory
New-Item -ItemType Directory -Path "$env:USERPROFILE\tools" -Force

# Download kind
$kindUrl = "https://kind.sigs.k8s.io/dl/v0.20.0/kind-windows-amd64"
$kindPath = "$env:USERPROFILE\tools\kind.exe"
Invoke-WebRequest -Uri $kindUrl -OutFile $kindPath

# Add to PATH (restart terminal after this)
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
[Environment]::SetEnvironmentVariable("PATH", "$currentPath;$env:USERPROFILE\tools", "User")
```

#### **macOS/Linux:**
```bash
# Using curl
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-$(uname)-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

---

## 🚀 **Quick Start Guide**

### **Step 1: Clone the Repository**
```bash
git clone <your-repository-url>
cd Milestone2
```

### **Step 2: Verify Prerequisites**
```powershell
# Check Docker
docker --version

# Check kubectl
kubectl version --client

# Check kind (Windows)
& "$env:USERPROFILE\tools\kind.exe" version

# Check kind (macOS/Linux)
kind version
```

### **Step 3: Start the Application**

#### **Option A: One-Command Setup (Recommended)**
```powershell
# Windows
powershell -ExecutionPolicy Bypass -File run.ps1 all

# macOS/Linux
make all
```

#### **Option B: Step-by-Step Setup**
```powershell
# 1. Start Kubernetes cluster
powershell -ExecutionPolicy Bypass -File run.ps1 start-cluster

# 2. Build Docker images
powershell -ExecutionPolicy Bypass -File run.ps1 build

# 3. Load images to cluster
powershell -ExecutionPolicy Bypass -File run.ps1 load-images

# 4. Deploy application
powershell -ExecutionPolicy Bypass -File run.ps1 deploy
```

### **Step 4: Access the Application**

#### **Set up Port Forwarding**
Open **two separate terminal windows** and run:

**Terminal 1 (Frontend):**
```powershell
kubectl port-forward -n lm-webstack svc/frontend-lm 8080:80
```

**Terminal 2 (API):**
```powershell
kubectl port-forward -n lm-webstack svc/api-lm 8000:8000
```

#### **Access the Application**
1. **Frontend**: Open your browser and go to `http://localhost:8080`
2. **API**: Test the API at `http://localhost:8000`

---

## 🧪 **Testing the Application**

### **Test API Endpoints**
```powershell
# Health check
Invoke-WebRequest -Uri "http://localhost:8000/health" -Method GET

# Get current user
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method GET

# Update user name
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method POST -Headers @{ "Content-Type" = "application/json" } -Body '{"name":"Your Name"}'

# Get container ID
Invoke-WebRequest -Uri "http://localhost:8000/container-id" -Method GET
```

### **Test Frontend**
1. Open `http://localhost:8080` in your browser
2. You should see: "**[Default User]** has reached milestone 2!"
3. Update the name using the API command above
4. Refresh the browser to see the change

---

## 📊 **Monitoring and Status**

### **Check Application Status**
```powershell
# Check pods
kubectl get pods -n lm-webstack

# Check services
kubectl get services -n lm-webstack

# Check logs
kubectl logs api-lm-xxxxx -n lm-webstack
kubectl logs frontend-lm-xxxxx -n lm-webstack
kubectl logs postgres-lm-xxxxx -n lm-webstack
```

### **Expected Output**
```
NAME                           READY   STATUS    RESTARTS   AGE
api-lm-xxxxx                   1/1     Running   0          2m
frontend-lm-xxxxx              1/1     Running   0          2m
postgres-lm-xxxxx              1/1     Running   0          2m
```

---

## 🛠️ **Troubleshooting**

### **Common Issues and Solutions**

#### **1. Docker Desktop Not Running**
**Problem**: `docker: command not found` or connection errors
**Solution**: 
- Start Docker Desktop
- Wait for it to fully initialize (check system tray icon)
- Restart your terminal

#### **2. Port Already in Use**
**Problem**: `bind: Only one usage of each socket address is normally permitted`
**Solution**:
```powershell
# Find and kill processes using the ports
netstat -ano | findstr :8080
netstat -ano | findstr :8000
taskkill /PID <process-id> /F
```

#### **3. Kubernetes Cluster Issues**
**Problem**: Pods not starting or in error state
**Solution**:
```powershell
# Check pod details
kubectl describe pod <pod-name> -n lm-webstack

# Check pod logs
kubectl logs <pod-name> -n lm-webstack

# Restart deployments
kubectl rollout restart deployment/api-lm -n lm-webstack
kubectl rollout restart deployment/frontend-lm -n lm-webstack
kubectl rollout restart deployment/postgres-lm -n lm-webstack
```

#### **4. Images Not Found**
**Problem**: `ImagePullBackOff` or `ErrImagePull` errors
**Solution**:
```powershell
# Rebuild and reload images
docker build -t api-lm:latest api/
docker build -t frontend-lm:latest frontend/
docker build -t postgres-lm:latest db/

& "$env:USERPROFILE\tools\kind.exe" load docker-image api-lm:latest --name milestone2
& "$env:USERPROFILE\tools\kind.exe" load docker-image frontend-lm:latest --name milestone2
& "$env:USERPROFILE\tools\kind.exe" load docker-image postgres-lm:latest --name milestone2
```

#### **5. Permission Issues (Windows)**
**Problem**: PowerShell execution policy errors
**Solution**:
```powershell
# Run with bypass
powershell -ExecutionPolicy Bypass -File run.ps1 all

# Or change execution policy (requires admin)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 🧹 **Cleanup**

### **Stop the Application**
```powershell
# Stop port forwarding (Ctrl+C in the terminal windows)

# Clean up Kubernetes resources
powershell -ExecutionPolicy Bypass -File run.ps1 clean

# Stop the cluster
powershell -ExecutionPolicy Bypass -File run.ps1 stop-cluster
```

### **Complete Cleanup**
```powershell
# Delete the entire cluster
& "$env:USERPROFILE\tools\kind.exe" delete cluster --name milestone2

# Remove Docker images (optional)
docker rmi api-lm:latest frontend-lm:latest postgres-lm:latest
```

---

## 📚 **Additional Resources**

### **Project Documentation**
- `README.md` - Project overview and architecture
- `EXPLANATION_GUIDE.md` - Detailed technical explanations
- `QUICK_REFERENCE.md` - Quick reference for presentations
- `VERIFICATION_CHECKLIST.md` - Complete testing checklist

### **Useful Commands**
```powershell
# Quick status check
kubectl get pods -n lm-webstack

# View logs
kubectl logs -f <pod-name> -n lm-webstack

# Access shell in container
kubectl exec -it <pod-name> -n lm-webstack -- /bin/bash

# Scale deployments
kubectl scale deployment api-lm --replicas=2 -n lm-webstack
```

### **Learning Resources**
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [kind Documentation](https://kind.sigs.k8s.io/)

---

## 🎯 **Next Steps**

Once you have the application running:

1. **Explore the code** - Look at the different components
2. **Try modifications** - Change the frontend, add API endpoints
3. **Learn Kubernetes** - Experiment with scaling, rolling updates
4. **Add features** - Implement authentication, additional endpoints
5. **Deploy to cloud** - Try deploying to a cloud Kubernetes service

---

## 🆘 **Getting Help**

If you encounter issues:

1. **Check the troubleshooting section** above
2. **Review the logs** using `kubectl logs`
3. **Check the verification checklist** in `VERIFICATION_CHECKLIST.md`
4. **Search the documentation** in the project files
5. **Ask for help** - Provide error messages and system information

---

## 🎉 **Congratulations!**

You've successfully set up a complete Kubernetes application with:
- ✅ **3-container architecture** (Frontend, API, Database)
- ✅ **Container orchestration** with Kubernetes
- ✅ **Persistent storage** for the database
- ✅ **Service discovery** and networking
- ✅ **Health monitoring** and automated recovery

**Your Milestone 2 project is ready to demonstrate!** 🚀 