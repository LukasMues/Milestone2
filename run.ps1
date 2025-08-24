# Simple project runner for Milestone 2
# This script provides a comprehensive automation tool for managing a Kubernetes-based web application
# It handles cluster creation, Docker image building, deployment, and access to various services

# Define a parameter for the action to perform, defaulting to "help" if no action is specified
param([string]$action = "help")

# Function to create and start a multi-node Kubernetes cluster using kind
function Start-Cluster {
    # Display a message indicating the cluster creation process is starting
    Write-Host "Starting multi-node Kubernetes cluster..." -ForegroundColor Green
    # Execute the kind command to create a cluster named "milestone2" using the specified config file
    & "$env:USERPROFILE\tools\kind.exe" create cluster --name milestone2 --config kind-config.yaml
    # Display a success message when cluster creation is complete
    Write-Host "Multi-node cluster created successfully!" -ForegroundColor Green
}

# Function to build all Docker images for the application components
function Build-Images {
    # Display a message indicating the Docker build process is starting
    Write-Host "Building Docker images..." -ForegroundColor Green
    # Build the frontend Docker image from the frontend directory
    docker build -t frontend-lm:latest frontend/
    # Build the API Docker image from the api directory
    docker build -t api-lm:latest api/
    # Build the PostgreSQL database Docker image from the db directory
    docker build -t postgres-lm:latest db/
    # Display a success message when all images are built
    Write-Host "Images built successfully!" -ForegroundColor Green
}

# Function to load the built Docker images into the Kubernetes cluster
function Load-Images {
    # Display a message indicating the image loading process is starting
    Write-Host "Loading images to cluster..." -ForegroundColor Green
    # Load the frontend image into the kind cluster
    & "$env:USERPROFILE\tools\kind.exe" load docker-image frontend-lm:latest --name milestone2
    # Load the API image into the kind cluster
    & "$env:USERPROFILE\tools\kind.exe" load docker-image api-lm:latest --name milestone2
    # Load the PostgreSQL image into the kind cluster
    & "$env:USERPROFILE\tools\kind.exe" load docker-image postgres-lm:latest --name milestone2
    # Display a success message when all images are loaded
    Write-Host "Images loaded successfully!" -ForegroundColor Green
}

# Function to deploy all Kubernetes resources to the cluster
function Deploy-Application {
    # Display a message indicating the deployment process is starting
    Write-Host "Deploying to Kubernetes..." -ForegroundColor Green
    # Apply the namespace configuration to create the lm-webstack namespace
    kubectl apply -f k8s/namespace.yaml
    # Apply all PostgreSQL-related Kubernetes resources (deployment, service, PVC, secrets)
    kubectl apply -f k8s/postgres/
    # Apply all API-related Kubernetes resources (deployment, service, configmap)
    kubectl apply -f k8s/api/
    # Apply all frontend-related Kubernetes resources (deployment, service, configmap)
    kubectl apply -f k8s/frontend/
    # Apply all monitoring-related Kubernetes resources (Prometheus, Grafana)
    kubectl apply -f k8s/monitoring/
    # Display a success message when deployment is complete
    Write-Host "Application deployed successfully!" -ForegroundColor Green
}

# Function to display the current status of all Kubernetes resources
function Show-Status {
    # Display the namespace information
    Write-Host "=== Namespace ===" -ForegroundColor Cyan
    kubectl get namespace lm-webstack
    # Display information about all nodes in the cluster
    Write-Host "`n=== Nodes ===" -ForegroundColor Cyan
    kubectl get nodes
    # Display information about all pods in the lm-webstack namespace with wide output format
    Write-Host "`n=== Pods ===" -ForegroundColor Cyan
    kubectl get pods -n lm-webstack -o wide
    # Display information about all services in the lm-webstack namespace
    Write-Host "`n=== Services ===" -ForegroundColor Cyan
    kubectl get services -n lm-webstack
}

# Function to set up port forwarding to access the frontend service
function Access-Frontend {
    # Display a message indicating port forwarding is being set up
    Write-Host "Port forwarding to frontend service..." -ForegroundColor Green
    # Display the URL where the frontend will be accessible
    Write-Host "Access at: http://localhost:8080" -ForegroundColor Cyan
    # Set up port forwarding from local port 8080 to the frontend service port 80
    kubectl port-forward -n lm-webstack svc/frontend-lm 8080:80
}

# Function to set up port forwarding to access the API service
function Access-API {
    # Display a message indicating port forwarding is being set up
    Write-Host "Port forwarding to API service..." -ForegroundColor Green
    # Display the URL where the API will be accessible
    Write-Host "Access at: http://localhost:8000" -ForegroundColor Cyan
    # Set up port forwarding from local port 8000 to the API service port 8000
    kubectl port-forward -n lm-webstack svc/api-lm 8000:8000
}

# Function to set up port forwarding to access the Prometheus monitoring service
function Access-Prometheus {
    # Display a message indicating port forwarding is being set up
    Write-Host "Port forwarding to Prometheus..." -ForegroundColor Green
    # Display the URL where Prometheus will be accessible
    Write-Host "Access at: http://localhost:9090" -ForegroundColor Cyan
    # Set up port forwarding from local port 9090 to the Prometheus service port 9090
    kubectl port-forward -n monitoring svc/prometheus 9090:9090
}

# Function to clean up all Kubernetes resources in the lm-webstack namespace
function Clean-Resources {
    # Display a message indicating the cleanup process is starting
    Write-Host "Cleaning up Kubernetes resources..." -ForegroundColor Yellow
    # Delete the lm-webstack namespace and all its resources, ignoring errors if namespace doesn't exist
    kubectl delete namespace lm-webstack --ignore-not-found=true
}

# Function to stop and delete the entire Kubernetes cluster
function Stop-Cluster {
    # Display a message indicating the cluster shutdown process is starting
    Write-Host "Stopping Kubernetes cluster..." -ForegroundColor Yellow
    # Delete the milestone2 cluster using kind
    & "$env:USERPROFILE\tools\kind.exe" delete cluster --name milestone2
    # Display a success message when cluster is stopped
    Write-Host "Cluster stopped successfully!" -ForegroundColor Green
}

# Function to perform a complete deployment from start to finish
function Deploy-All {
    # Display a header message for the complete deployment process
    Write-Host "=== Starting complete deployment ===" -ForegroundColor Green
    # Start the Kubernetes cluster
    Start-Cluster
    # Build all Docker images
    Build-Images
    # Load images into the cluster
    Load-Images
    # Deploy the application to Kubernetes
    Deploy-Application
    # Display a message about waiting for pods to be ready
    Write-Host "`nWaiting for pods to be ready..." -ForegroundColor Yellow
    # Wait for 30 seconds to allow pods to start up
    Start-Sleep -Seconds 30
    # Show the current status of all resources
    Show-Status
    # Display completion message
    Write-Host "`n=== Deployment completed! ===" -ForegroundColor Green
    # Display instructions for accessing the frontend
    Write-Host "To access the frontend, run: .\run.ps1 access-frontend" -ForegroundColor Cyan
    # Display instructions for accessing the API
    Write-Host "To access the API, run: .\run.ps1 access-api" -ForegroundColor Cyan
}

# Function to display help information and available commands
function Show-Help {
    # Display the script title
    Write-Host "=== Milestone 2 Project Runner ===" -ForegroundColor Cyan
    # Display a header for available actions
    Write-Host "Available actions:" -ForegroundColor Yellow
    # List all available commands with descriptions
    Write-Host "  start-cluster    - Start multi-node Kubernetes cluster"
    Write-Host "  build           - Build all Docker images"
    Write-Host "  load-images     - Load images to cluster"
    Write-Host "  deploy          - Deploy application to Kubernetes"
    Write-Host "  status          - Show deployment status"
    Write-Host "  access-frontend - Port forward to frontend service"
    Write-Host "  access-api      - Port forward to API service"
    Write-Host "  access-prometheus - Port forward to Prometheus monitoring"
    Write-Host "  clean           - Remove all Kubernetes resources"
    Write-Host "  stop-cluster    - Stop Kubernetes cluster"
    Write-Host "  all             - Complete deployment (start, build, load, deploy)"
    Write-Host "  help            - Show this help message"
    # Display a blank line for spacing
    Write-Host ""
    # Display the quick start command
    Write-Host "Quick start: .\run.ps1 all" -ForegroundColor Green
}

# Main switch statement that handles all the different actions based on the parameter
switch ($action) {
    # If action is "start-cluster", call the Start-Cluster function
    "start-cluster" { Start-Cluster }
    # If action is "build", call the Build-Images function
    "build" { Build-Images }
    # If action is "load-images", call the Load-Images function
    "load-images" { Load-Images }
    # If action is "deploy", call the Deploy-Application function
    "deploy" { Deploy-Application }
    # If action is "status", call the Show-Status function
    "status" { Show-Status }
    # If action is "access-frontend", call the Access-Frontend function
    "access-frontend" { Access-Frontend }
    # If action is "access-api", call the Access-API function
    "access-api" { Access-API }
    # If action is "access-prometheus", call the Access-Prometheus function
    "access-prometheus" { Access-Prometheus }
    # If action is "clean", call the Clean-Resources function
    "clean" { Clean-Resources }
    # If action is "stop-cluster", call the Stop-Cluster function
    "stop-cluster" { Stop-Cluster }
    # If action is "all", call the Deploy-All function
    "all" { Deploy-All }
    # For any other action (including default), show the help information
    default { Show-Help }
} 