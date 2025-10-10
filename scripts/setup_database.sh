#!/bin/bash

# SickBall Database Setup Script
echo "🚀 Setting up SickBall PostgreSQL database..."

# Connect to database and create tables
psql -d sickball_dev << 'EOF'

-- Users table
CREATE TABLE IF NOT EXISTS users (
    uid VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    total_sick_days INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reasons table
CREATE TABLE IF NOT EXISTS reasons (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    category VARCHAR(100),
    is_used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sick leaves table
CREATE TABLE IF NOT EXISTS sick_leaves (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES users(uid) ON DELETE CASCADE,
    reason TEXT NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default reasons
INSERT INTO reasons (description, category) VALUES 
('Feeling unwell and need to rest at home', 'general'),
('Experiencing flu-like symptoms including fever and fatigue', 'general'),
('Dealing with a stomach bug and digestive issues', 'general'),
('Suffering from a severe migraine headache', 'general'),
('Food poisoning from last night''s dinner', 'general'),
('Caught a cold and have congestion', 'general'),
('Back pain preventing normal movement', 'general'),
('Dental emergency requiring immediate attention', 'general'),
('Eye infection causing vision problems', 'general'),
('Allergic reaction requiring medical monitoring', 'general'),
('Family emergency requiring immediate attention', 'general'),
('Medical appointment that couldn''t be scheduled outside work hours', 'general'),
('Recovering from a minor injury', 'general'),
('Experiencing severe stress and mental health day needed', 'general'),
('Childcare emergency - babysitter cancelled last minute', 'general')
ON CONFLICT DO NOTHING;

-- Show created tables
\dt

-- Show sample data
SELECT COUNT(*) as reason_count FROM reasons;

EOF

echo "✅ Database setup complete!"
echo "📊 You can now connect pgAdmin to:"
echo "   Host: localhost"
echo "   Port: 5432" 
echo "   Database: sickball_dev"
echo "   Username: $(whoami)"