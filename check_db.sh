#!/bin/bash

# Database connection details
DB_USER=${DB_USER:-admin}
DB_NAME=${DB_NAME:-wiki_db}

echo "=== Checking PostgreSQL Database: $DB_NAME ==="
echo ""

echo "--- Users Table ---"
psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT * FROM users;"
echo ""

echo "--- Posts Table ---"
psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT * FROM posts;"
echo ""

echo "--- Count Summary ---"
psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT 'Users' as table_name, COUNT(*) as count FROM users UNION ALL SELECT 'Posts', COUNT(*) FROM posts;"
echo ""

echo "--- Users with their Posts ---"
psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT u.id as user_id, u.name, u.created_time as user_created, COUNT(p.id) as post_count FROM users u LEFT JOIN posts p ON u.id = p.user_id GROUP BY u.id, u.name, u.created_time ORDER BY u.id;"

