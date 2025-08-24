import os
import socket
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from db import init_database, get_user_name, update_user_name
import time
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import Response
from starlette.middleware.base import BaseHTTPMiddleware
import time

# Initialize FastAPI app
app = FastAPI(title="Milestone 2 API", version="1.0.0")

# Prometheus metrics for monitoring
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint', 'status'])
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'HTTP request latency', ['method', 'endpoint'])
USER_OPERATIONS = Counter('user_operations_total', 'Total user operations', ['operation'])

# Pydantic model for user data validation
class UserUpdate(BaseModel):
    name: str

# Middleware for automatic metrics collection
class MetricsMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        start_time = time.time()  # Start timing the request
        
        response = await call_next(request)
        
        duration = time.time() - start_time  # Calculate request duration
        REQUEST_LATENCY.labels(method=request.method, endpoint=request.url.path).observe(duration)
        REQUEST_COUNT.labels(method=request.method, endpoint=request.url.path, status=response.status_code).inc()
        
        return response

# Add middleware to app
app.add_middleware(MetricsMiddleware)

@app.on_event("startup")
async def startup_event():
    """Initialize database on startup."""
    # Wait for database to be ready
    max_retries = 30
    retry_count = 0
    
    while retry_count < max_retries:
        try:
            init_database()  # Initialize database connection
            print("Database initialized successfully")
            break
        except Exception as e:
            print(f"Database connection failed (attempt {retry_count + 1}/{max_retries}): {e}")
            retry_count += 1
            time.sleep(2)
    
    if retry_count >= max_retries:
        print("Failed to initialize database after maximum retries")

@app.get("/")
async def root():
    """Root endpoint."""
    return {"message": "Milestone 2 API is running"}

@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy"}

@app.get("/user")
async def get_user():
    """Get current user name from database."""
    try:
        name = get_user_name()  # Retrieve user name from database
        USER_OPERATIONS.labels(operation="get_user").inc()
        return {"name": name}
    except Exception as e:
        USER_OPERATIONS.labels(operation="get_user_error").inc()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

@app.post("/user")
async def update_user(user_data: UserUpdate):
    """Update user name in database."""
    try:
        update_user_name(user_data.name)  # Update user name in database
        USER_OPERATIONS.labels(operation="update_user").inc()
        return {"message": "User name updated successfully", "name": user_data.name}
    except Exception as e:
        USER_OPERATIONS.labels(operation="update_user_error").inc()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

@app.get("/container-id")
async def get_container_id():
    """Get container ID/hostname."""
    hostname = socket.gethostname()  # Get container hostname
    return {"container_id": hostname}

@app.get("/node-info")
async def get_node_info():
    """Get node and pod information."""
    hostname = socket.gethostname()
    pod_name = os.getenv('HOSTNAME', hostname)  # Get pod name from Kubernetes
    node_name = os.getenv('NODE_NAME', 'unknown')  # Get node name from Kubernetes
    
    return {
        "container_id": hostname,
        "pod_name": pod_name,
        "node_name": node_name
    }

@app.get("/metrics")
async def get_metrics():
    """Get Prometheus metrics."""
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)  # Expose metrics for Prometheus

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)  # Start the server 