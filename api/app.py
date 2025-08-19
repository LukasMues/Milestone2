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

@app.get("/container-id")
async def get_container_id():
    """Get container ID/hostname."""
    hostname = socket.gethostname()
    return {"container_id": hostname}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 