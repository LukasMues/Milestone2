# Milestone 2 - Kubernetes Web Stack

## 🚀 **Quick Start for New Users**

**First time here?** Check out the **[Getting Started Guide](GETTING_STARTED.md)** for complete setup instructions!

### **Prerequisites**
- Docker Desktop
- kubectl
- kind (Kubernetes in Docker)

### **One-Command Setup**
```powershell
# Windows
powershell -ExecutionPolicy Bypass -File run.ps1 all

# Then access the application:
# Frontend: http://localhost:8080
# API: http://localhost:8000
```

### **Need Help?**
- **New users**: Start with [GETTING_STARTED.md](GETTING_STARTED.md)
- **Troubleshooting**: See [VERIFICATION_CHECKLIST.md](VERIFICATION_CHECKLIST.md)
- **Understanding**: Read [EXPLANATION_GUIDE.md](EXPLANATION_GUIDE.md)

---

## 📋 **Project Overview**

This is a **3-container web application** demonstrating modern software development practices using **Kubernetes**. The application consists of:

- **Frontend**: NGINX serving a static HTML page
- **API**: FastAPI (Python) with REST endpoints
- **Database**: PostgreSQL with persistent storage

### **Architecture**
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Frontend  │    │     API     │    │  Database   │
│   (NGINX)   │◄──►│  (FastAPI)  │◄──►│ (PostgreSQL)│
│  NodePort   │    │ ClusterIP   │    │ ClusterIP   │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 🔧 **API Endpoints**

- `GET /user` - Returns current user name from database
- `POST /user` - Updates user name in database
- `GET /container-id` - Returns container ID/hostname
- `GET /health` - Health check endpoint

## 🛠️ **Technologies Used**

- **Containerization**: Docker
- **Orchestration**: Kubernetes (kind)
- **Frontend**: NGINX
- **Backend**: FastAPI (Python)
- **Database**: PostgreSQL
- **Configuration**: ConfigMaps, Secrets, PVC

## 📁 **Project Structure**

```
Milestone2/
├── README.md                 # This file
├── GETTING_STARTED.md        # Complete setup guide
├── EXPLANATION_GUIDE.md      # Detailed explanations
├── QUICK_REFERENCE.md        # Presentation guide
├── VERIFICATION_CHECKLIST.md # Testing checklist
├── run.ps1                   # Windows automation script
├── Makefile                  # Linux/macOS automation
├── scripts/                  # Helper scripts
├── k8s/                      # Kubernetes manifests
├── frontend/                 # NGINX frontend
├── api/                      # FastAPI backend
└── db/                       # PostgreSQL database
```

## 🚀 **Getting Started**

### **Option 1: Automated Setup (Recommended)**
```powershell
# Install prerequisites (Windows)
powershell -ExecutionPolicy Bypass -File install-prerequisites.ps1

# Start the application
powershell -ExecutionPolicy Bypass -File run.ps1 all
```

### **Option 2: Manual Setup**
See [GETTING_STARTED.md](GETTING_STARTED.md) for detailed step-by-step instructions.

## 🌐 **Accessing the Application**

After deployment, access the application at:
- **Frontend**: http://localhost:8080
- **API**: http://localhost:8000

### **Testing the API**
```powershell
# Get current user
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method GET

# Update user name
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method POST -Headers @{ "Content-Type" = "application/json" } -Body '{"name":"Your Name"}'
```

## 📊 **Monitoring**

```powershell
# Check pod status
kubectl get pods -n lm-webstack

# Check services
kubectl get services -n lm-webstack

# View logs
kubectl logs <pod-name> -n lm-webstack
```

## 🧹 **Cleanup**

```powershell
# Stop the application
powershell -ExecutionPolicy Bypass -File run.ps1 clean

# Stop the cluster
powershell -ExecutionPolicy Bypass -File run.ps1 stop-cluster
```

## 📚 **Documentation**

- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Complete setup guide for new users
- **[EXPLANATION_GUIDE.md](EXPLANATION_GUIDE.md)** - Detailed technical explanations
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick reference for presentations
- **[VERIFICATION_CHECKLIST.md](VERIFICATION_CHECKLIST.md)** - Complete testing checklist

## 🎯 **Learning Objectives**

This project demonstrates:
- **Container Technology** - Docker containers and isolation
- **Kubernetes Orchestration** - Managing containerized applications
- **Microservices Architecture** - Breaking applications into services
- **DevOps Practices** - Infrastructure as Code, automated deployment
- **Modern Web Development** - Frontend/backend separation, REST APIs

## 🆘 **Troubleshooting**

If you encounter issues:
1. Check [VERIFICATION_CHECKLIST.md](VERIFICATION_CHECKLIST.md)
2. Review the troubleshooting section in [GETTING_STARTED.md](GETTING_STARTED.md)
3. Check pod logs: `kubectl logs <pod-name> -n lm-webstack`
4. Verify prerequisites are installed correctly

## 📄 **License**

This project is created for educational purposes as part of a school assignment.

---

**Happy coding! 🚀** 