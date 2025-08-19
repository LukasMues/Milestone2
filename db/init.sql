-- Initialize database for Milestone 2

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default user if table is empty
INSERT INTO users (name) 
SELECT 'Default User' 
WHERE NOT EXISTS (SELECT 1 FROM users);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_users_id ON users(id); 