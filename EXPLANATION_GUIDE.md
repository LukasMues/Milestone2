# Complete Explanation Guide - Milestone 2 Kubernetes Project

## 📋 **What is This Project?**

This is a **3-container web application** that demonstrates modern software development practices using **Kubernetes** (a system for managing computer programs). Think of it like a mini-version of how big companies like Netflix or Google run their websites.

### **The Big Picture**
- **Frontend**: A website that users see in their browser
- **API**: A program that handles requests and talks to the database
- **Database**: Where information is stored permanently

## 🏗️ **Architecture Overview**

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Frontend  │    │     API     │    │  Database   │
│   (NGINX)   │◄──►│  (FastAPI)  │◄──►│ (PostgreSQL)│
│  NodePort   │    │ ClusterIP   │    │ ClusterIP   │
└─────────────┘    └─────────────┘    └─────────────┘
```

### **What Each Part Does:**

1. **Frontend (NGINX)**
   - Shows a web page to users
   - Acts like a traffic director - sends API requests to the right place
   - Runs on port 80 (like a door number for the internet)

2. **API (FastAPI)**
   - Handles requests from the frontend
   - Talks to the database to get or save information
   - Runs on port 8000

3. **Database (PostgreSQL)**
   - Stores information permanently
   - In this case, stores user names
   - Runs on port 5432

## 🔧 **What is Kubernetes?**

**Kubernetes** (often called "K8s") is like a **smart manager** for computer programs. Instead of running programs directly on your computer, Kubernetes runs them in **containers** (like lightweight virtual machines).

### **Why Use Kubernetes?**
- **Scalability**: Can easily add more copies of programs when needed
- **Reliability**: If one program crashes, Kubernetes starts a new one
- **Management**: Easy to update, monitor, and manage programs
- **Portability**: Works the same way on different computers

## 📁 **Project Structure Explained**

```
Milestone2/
├── README.md                 # Instructions and overview
├── DEPLOYMENT.md             # Step-by-step setup guide
├── Makefile                  # Automation script (like a recipe)
├── run.ps1                   # Windows PowerShell runner
├── scripts/                  # Helper scripts
│   ├── kind-up.ps1          # Start Kubernetes cluster
│   ├── kind-down.ps1        # Stop Kubernetes cluster
│   └── test-api.ps1         # Test the API
├── k8s/                      # Kubernetes configuration files
│   ├── namespace.yaml       # Creates a workspace
│   ├── postgres/            # Database setup files
│   ├── api/                 # API setup files
│   └── frontend/            # Frontend setup files
├── frontend/                 # Website files
│   ├── Dockerfile           # How to build the website container
│   ├── index.html           # The actual web page
│   └── nginx.conf           # Website server configuration
├── api/                      # API program files
│   ├── Dockerfile           # How to build the API container
│   ├── app.py               # Main API program
│   ├── db.py                # Database connection code
│   └── requirements.txt     # Python libraries needed
└── db/                       # Database files
    ├── Dockerfile           # How to build the database container
    └── init.sql             # Database setup script
```

## 🐳 **What are Docker Containers?**

Think of a **Docker container** like a **shipping container** for computer programs:

### **Traditional Way (Without Containers)**
- Programs are installed directly on your computer
- They might conflict with each other
- Hard to move between different computers
- Different versions can cause problems

### **Container Way (With Docker)**
- Each program runs in its own isolated environment
- Contains everything the program needs to run
- Easy to move between computers
- Consistent behavior everywhere

### **Dockerfile Explained**
A Dockerfile is like a **recipe** that tells Docker how to build a container:

```dockerfile
# Example from our frontend/Dockerfile
FROM nginx:alpine                    # Start with a basic web server
COPY index.html /usr/share/nginx/html/  # Copy our web page
COPY nginx.conf /etc/nginx/nginx.conf   # Copy our configuration
EXPOSE 80                              # Open port 80 for web traffic
```

## ⚙️ **Kubernetes Configuration Files Explained**

### **1. Namespace (k8s/namespace.yaml)**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: lm-webstack
```
**What it does**: Creates a **workspace** called "lm-webstack" where all our programs live. Like creating a folder on your computer.

### **2. Deployment (k8s/api/deployment.yaml)**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-lm
spec:
  replicas: 1                    # Run 1 copy of the program
  selector:
    matchLabels:
      app: api-lm
  template:
    spec:
      containers:
      - name: api
        image: api-lm:latest      # Use our API container
        ports:
        - containerPort: 8000     # Program listens on port 8000
```
**What it does**: Tells Kubernetes to run our API program. Like telling a manager "start this program and keep it running."

### **3. Service (k8s/api/deployment.yaml)**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-lm
spec:
  selector:
    app: api-lm
  ports:
  - port: 8000
    targetPort: 8000
  type: ClusterIP
```
**What it does**: Creates a **network address** so other programs can talk to our API. Like giving the API a phone number.

### **4. ConfigMap (k8s/api/configmap.yaml)**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: api-config-lm
data:
  DATABASE_URL: "postgresql://postgres:password123@postgres-lm:5432/milestone2"
```
**What it does**: Stores **configuration settings** (like database connection info) that programs can use. Like a settings file.

### **5. Secret (k8s/postgres/secret.yaml)**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret-lm
data:
  username: cG9zdGdyZXM=        # "postgres" in secret code
  password: cGFzc3dvcmQxMjM=    # "password123" in secret code
```
**What it does**: Stores **sensitive information** (like passwords) in a secure way. Like a locked safe for secrets.

### **6. PersistentVolumeClaim (k8s/postgres/pvc.yaml)**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc-lm
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
**What it does**: Requests **permanent storage space** for the database. Like asking for a hard drive that won't be deleted when the program restarts.

## 🔄 **How Everything Works Together**

### **Step 1: User Visits Website**
1. User opens browser and goes to `http://localhost:8080`
2. Browser connects to the **Frontend** (NGINX)
3. NGINX shows the HTML page

### **Step 2: Website Loads User Data**
1. The HTML page has JavaScript that makes a request to `/api/user`
2. NGINX sees this request and forwards it to the **API** service
3. API receives the request and connects to the **Database**
4. Database returns the user's name
5. API sends the name back to the frontend
6. Frontend displays the name on the webpage

### **Step 3: User Updates Their Name**
1. User sends a request to update their name
2. API receives the request and updates the database
3. Database saves the new name permanently
4. When the user refreshes the page, they see the new name

## 🛠️ **The Tools We Used**

### **1. Docker**
- **What it is**: Tool for creating and running containers
- **Why we use it**: Makes programs portable and isolated
- **What we did**: Created containers for frontend, API, and database

### **2. Kubernetes (via kind)**
- **What it is**: System for managing containers
- **Why we use it**: Automates running, scaling, and managing programs
- **What we did**: Deployed our containers and made them work together

### **3. kind (Kubernetes in Docker)**
- **What it is**: Tool to run Kubernetes on your local computer
- **Why we use it**: Lets you test Kubernetes without expensive cloud servers
- **What we did**: Created a local Kubernetes cluster for testing

### **4. kubectl**
- **What it is**: Command-line tool to control Kubernetes
- **Why we use it**: How we tell Kubernetes what to do
- **What we did**: Deployed our application and checked its status

## 📊 **API Endpoints Explained**

Our API has 4 main functions:

### **1. GET /user**
- **What it does**: Gets the current user's name from the database
- **Returns**: `{"name": "John Doe"}`
- **When used**: When the website loads to show the user's name

### **2. POST /user**
- **What it does**: Updates the user's name in the database
- **Sends**: `{"name": "New Name"}`
- **Returns**: `{"message": "User name updated successfully", "name": "New Name"}`
- **When used**: When someone wants to change their name

### **3. GET /container-id**
- **What it does**: Returns the ID of the container running the API
- **Returns**: `{"container_id": "api-lm-abc123"}`
- **When used**: To see which container is handling requests (for debugging)

### **4. GET /health**
- **What it does**: Checks if the API is working properly
- **Returns**: `{"status": "healthy"}`
- **When used**: Kubernetes uses this to know if the program is working

## 🔍 **Key Concepts Explained**

### **Microservices Architecture**
Instead of one big program, we split our application into smaller, specialized programs:
- **Frontend**: Handles user interface
- **API**: Handles business logic
- **Database**: Handles data storage

**Benefits**:
- Easier to develop and maintain
- Can scale parts independently
- If one part breaks, others keep working

### **Container Orchestration**
Kubernetes manages multiple containers:
- **Starts** containers when needed
- **Monitors** if they're working properly
- **Restarts** them if they crash
- **Scales** them up or down based on demand

### **Service Discovery**
Programs can find and talk to each other:
- **API** knows how to find the **Database**
- **Frontend** knows how to find the **API**
- Kubernetes handles the networking automatically

### **Configuration Management**
Settings are stored separately from code:
- **ConfigMaps**: For regular settings
- **Secrets**: For sensitive information like passwords
- Programs read these settings when they start

### **Persistent Storage**
Data survives program restarts:
- **Database** data is stored on a persistent volume
- Even if the database container restarts, data is preserved
- Like saving a file to your hard drive instead of RAM

## 🚀 **How to Run the Project**

### **Prerequisites (What You Need)**
1. **Docker Desktop**: For running containers
2. **kubectl**: For controlling Kubernetes
3. **kind**: For running Kubernetes locally
4. **PowerShell**: For running commands (Windows)

### **Step-by-Step Process**

#### **Step 1: Start Kubernetes Cluster**
```powershell
powershell -ExecutionPolicy Bypass -File run.ps1 all
```
**What this does**:
- Creates a local Kubernetes cluster
- Builds Docker containers for all three parts
- Loads containers into the cluster
- Deploys the application
- Shows the status

#### **Step 2: Access the Application**
```powershell
# In one terminal (for frontend)
kubectl port-forward -n lm-webstack svc/frontend-lm 8080:80

# In another terminal (for API)
kubectl port-forward -n lm-webstack svc/api-lm 8000:8000
```
**What this does**:
- Makes the frontend available at `http://localhost:8080`
- Makes the API available at `http://localhost:8000`

#### **Step 3: Test the Application**
1. Open browser to `http://localhost:8080`
2. You should see: "**Default User** has reached milestone 2!"
3. Test API: `curl http://localhost:8000/user`
4. Update name: `curl -X POST http://localhost:8000/user -H "Content-Type: application/json" -d '{"name": "Your Name"}'`
5. Refresh browser to see the change

## 🔧 **Troubleshooting Common Issues**

### **Problem: Images Not Found**
**Symptoms**: Pods show "ImagePullBackOff" or "ErrImagePull"
**Solution**: 
```powershell
# Load images into the cluster
& "$env:USERPROFILE\tools\kind.exe" load docker-image frontend-lm:latest --name milestone2
& "$env:USERPROFILE\tools\kind.exe" load docker-image api-lm:latest --name milestone2
& "$env:USERPROFILE\tools\kind.exe" load docker-image postgres-lm:latest --name milestone2
```

### **Problem: Pods Not Starting**
**Symptoms**: Pods stuck in "Pending" or "ContainerCreating"
**Solution**:
```powershell
# Check what's wrong
kubectl describe pod <pod-name> -n lm-webstack
# Restart deployments
kubectl rollout restart deployment/api-lm -n lm-webstack
```

### **Problem: Can't Access Website**
**Symptoms**: Browser shows "Connection refused"
**Solution**:
```powershell
# Check if pods are running
kubectl get pods -n lm-webstack
# Check if port-forward is working
kubectl port-forward -n lm-webstack svc/frontend-lm 8080:80
```

## 📈 **What This Demonstrates**

### **For Your Teacher - Learning Objectives**

1. **Container Technology**
   - Understanding Docker containers
   - Building and managing containerized applications
   - Container isolation and portability

2. **Kubernetes Orchestration**
   - Deploying applications to Kubernetes
   - Managing application lifecycle
   - Service discovery and networking

3. **Microservices Architecture**
   - Breaking applications into smaller services
   - Service-to-service communication
   - Independent scaling and deployment

4. **DevOps Practices**
   - Infrastructure as Code (YAML configurations)
   - Automated deployment
   - Configuration management
   - Health monitoring

5. **Modern Web Development**
   - Frontend-backend separation
   - RESTful API design
   - Database integration
   - Reverse proxy configuration

### **Real-World Applications**

This project demonstrates skills used in:
- **Cloud Computing**: AWS, Google Cloud, Azure
- **Enterprise Software**: How big companies run their applications
- **DevOps Engineering**: Automating software deployment
- **System Administration**: Managing complex systems
- **Software Architecture**: Designing scalable applications

## 🎯 **Key Takeaways**

1. **Containers** make applications portable and isolated
2. **Kubernetes** automates running and managing applications
3. **Microservices** make applications easier to develop and maintain
4. **Configuration management** separates settings from code
5. **Service discovery** allows programs to find each other automatically
6. **Persistent storage** keeps data safe across restarts

## 🔗 **Next Steps**

To expand this project, you could:
- Add more API endpoints
- Implement user authentication
- Add a more complex frontend
- Set up monitoring and logging
- Deploy to a cloud provider
- Add automated testing
- Implement CI/CD pipelines

This project gives you a solid foundation in modern software development practices that are widely used in the industry! 