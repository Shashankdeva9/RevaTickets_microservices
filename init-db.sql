-- Initialize all databases for RevTickets microservices
CREATE DATABASE IF NOT EXISTS revtickets_user_db;
CREATE DATABASE IF NOT EXISTS revtickets_movie_db;
CREATE DATABASE IF NOT EXISTS revtickets_venue_db;
CREATE DATABASE IF NOT EXISTS revtickets_booking_db;
CREATE DATABASE IF NOT EXISTS revtickets_payment_db;

-- Grant privileges
GRANT ALL PRIVILEGES ON revtickets_user_db.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON revtickets_movie_db.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON revtickets_venue_db.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON revtickets_booking_db.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON revtickets_payment_db.* TO 'root'@'%';
FLUSH PRIVILEGES;
