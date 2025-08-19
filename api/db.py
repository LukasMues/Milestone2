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

def get_user_name():
    """Get the current user name from the database."""
    with get_db_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SELECT name FROM users ORDER BY id LIMIT 1")
            result = cursor.fetchone()
            return result['name'] if result else 'Unknown User'

def update_user_name(name):
    """Update the user name in the database."""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Update the first user (or insert if none exists)
            cursor.execute("""
                UPDATE users 
                SET name = %s, updated_at = CURRENT_TIMESTAMP 
                WHERE id = (SELECT MIN(id) FROM users)
            """, (name,))
            
            # If no rows were updated, insert a new user
            if cursor.rowcount == 0:
                cursor.execute("""
                    INSERT INTO users (name) VALUES (%s)
                """, (name,))
            
            conn.commit() 