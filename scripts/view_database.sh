#!/bin/bash

# SickBall Database Viewer Script
echo "📊 SickBall Database Overview"
echo "=============================="

psql -d sickball_dev << 'EOF'

\echo '🏗️  Database Tables:'
\dt

\echo ''
\echo '👥 Users:'
SELECT COUNT(*) as user_count FROM users;

\echo ''
\echo '💡 Available Reasons:'
SELECT COUNT(*) as total_reasons, 
       COUNT(*) FILTER (WHERE is_used = false) as unused_reasons,
       COUNT(*) FILTER (WHERE is_used = true) as used_reasons
FROM reasons;

\echo ''
\echo '🏥 Sick Leaves:'
SELECT COUNT(*) as total_sick_leaves FROM sick_leaves;

\echo ''
\echo '📝 Recent Reasons (Sample):'
SELECT id, LEFT(description, 50) || '...' as description, is_used 
FROM reasons 
ORDER BY created_at DESC 
LIMIT 5;

EOF