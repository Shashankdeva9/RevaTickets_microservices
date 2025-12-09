-- RevTickets Database Setup Script
-- This script creates all required schemas for the microservices architecture
-- Username: root
-- Password: abc@123

-- Drop existing databases if they exist (optional - uncomment if you want fresh start)
-- DROP DATABASE IF EXISTS revtickets_user_db;
-- DROP DATABASE IF EXISTS revtickets_movie_db;
-- DROP DATABASE IF EXISTS revtickets_venue_db;
-- DROP DATABASE IF EXISTS revtickets_booking_db;
-- DROP DATABASE IF EXISTS revtickets_payment_db;

-- Create databases for each microservice
CREATE DATABASE IF NOT EXISTS revtickets_user_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS revtickets_movie_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS revtickets_venue_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS revtickets_booking_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS revtickets_payment_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Verify databases were created
SHOW DATABASES LIKE 'revtickets_%';

-- Note: The admin user will be created automatically by the DataSeeder component
-- when the user-service starts for the first time.
-- Default admin credentials:
-- Email: admin@revature.com
-- Password: admin@123
-- Role: ADMIN
