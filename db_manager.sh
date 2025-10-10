#!/bin/bash

# SickBall PostgreSQL Database Management Script

DB_NAME="sickball_dev"
DB_USER="postgres"

echo "🎯 SickBall PostgreSQL Database Manager"
echo "========================================"

case "$1" in
  "status")
    echo "📊 Database Status:"
    psql -d $DB_NAME -c "\dt" 2>/dev/null || echo "❌ Database not accessible"
    ;;
  
  "tables")
    echo "📋 Database Tables:"
    psql -d $DB_NAME -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null
    ;;
    
  "users")
    echo "👥 Users in Database:"
    psql -d $DB_NAME -c "SELECT uid, email, name, total_sick_days, created_at FROM users;" 2>/dev/null
    ;;
    
  "reasons")
    echo "📝 Available Reasons:"
    psql -d $DB_NAME -c "SELECT id, description, category, is_used FROM reasons ORDER BY id;" 2>/dev/null
    ;;
    
  "sick-leaves")
    echo "🏥 Sick Leave Records:"
    psql -d $DB_NAME -c "SELECT id, user_id, reason, date FROM sick_leaves ORDER BY date DESC LIMIT 10;" 2>/dev/null
    ;;
    
  "reset")
    echo "🔄 Resetting Database..."
    psql -d $DB_NAME -c "DROP TABLE IF EXISTS sick_leaves CASCADE;" 2>/dev/null
    psql -d $DB_NAME -c "DROP TABLE IF EXISTS reasons CASCADE;" 2>/dev/null
    psql -d $DB_NAME -c "DROP TABLE IF EXISTS users CASCADE;" 2>/dev/null
    echo "✅ Database tables dropped. Restart your app to recreate them."
    ;;
    
  "backup")
    BACKUP_FILE="sickball_backup_$(date +%Y%m%d_%H%M%S).sql"
    pg_dump $DB_NAME > $BACKUP_FILE
    echo "💾 Database backed up to: $BACKUP_FILE"
    ;;
    
  *)
    echo "Usage: $0 {status|tables|users|reasons|sick-leaves|reset|backup}"
    echo ""
    echo "Commands:"
    echo "  status      - Check database connection and status"
    echo "  tables      - List all tables"
    echo "  users       - Show all users"
    echo "  reasons     - Show all sick leave reasons"
    echo "  sick-leaves - Show recent sick leave records"
    echo "  reset       - Reset all database tables (WARNING: deletes all data)"
    echo "  backup      - Create a backup of the database"
    ;;
esac