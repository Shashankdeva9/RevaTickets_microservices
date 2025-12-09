# RevTickets Microservices - Setup Guide

## Database Configuration

### MySQL Credentials
- **Username**: `root`
- **Password**: `abc@123`

### Database Schemas
The following schemas will be created automatically on first run:
- `revtickets_user_db` - User management and authentication
- `revtickets_movie_db` - Movies and events management
- `revtickets_venue_db` - Venues and locations
- `revtickets_booking_db` - Booking and seat management
- `revtickets_payment_db` - Payment processing

### Setup Steps

1. **Run the Database Setup Script**
   ```bash
   mysql -u root -p < database-setup.sql
   ```
   Enter password: `abc@123`

2. **Verify Databases Created**
   ```sql
   SHOW DATABASES LIKE 'revtickets_%';
   ```

## Default Admin User

On first startup, the system will automatically create an admin user:

- **Email**: `admin@revature.com`
- **Password**: `admin@123`
- **Role**: ADMIN

## Microservices Architecture

### Service Ports
- **Eureka Server**: 8761
- **API Gateway**: 9090
- **User Service**: 8081
- **Movie Service**: 8082
- **Venue Service**: 8083
- **Booking Service**: 8084
- **Payment Service**: 8085
- **Frontend**: 4200 (Angular default)

### Service URLs (via API Gateway)
All requests go through the API Gateway at `http://localhost:9090`

**Authentication:**
- POST `/api/auth/register` - Register new user
- POST `/api/auth/login` - Login
- GET `/api/auth/profile` - Get user profile

**Movies & Events:**
- GET `/api/movies` - List all movies
- GET `/api/events` - List all events
- GET `/display/{filename}` - Display images
- GET `/banner/{filename}` - Banner images

**Admin Endpoints:**
- GET `/api/admin/dashboard/**` - Admin dashboard
- GET `/api/admin/users` - Manage users
- GET `/api/admin/movies/**` - Manage movies
- GET `/api/admin/events/**` - Manage events
- GET `/api/admin/venues/**` - Manage venues
- GET `/api/admin/bookings/**` - Manage bookings

**Bookings:**
- POST `/api/bookings` - Create booking
- GET `/api/bookings` - List bookings
- GET `/api/shows` - Available shows
- GET `/api/seats` - Seat availability

**Payments:**
- POST `/api/payments` - Process payment

## Media Files Organization

### Image Storage
All banner and display images are stored in the movie-service:
- **Display Images**: `microservices/movie-service/public/display/`
- **Banner Images**: `microservices/movie-service/public/banner/`

These folders are served statically and accessible through:
- `http://localhost:9090/display/{filename}`
- `http://localhost:9090/banner/{filename}`

## Starting the Application

### Option 1: Start All Services (Recommended)
```bash
# Windows
start-all-services.bat
```

This will start:
1. Eureka Server (Service Discovery)
2. All Microservices (User, Movie, Venue, Booking, Payment)
3. API Gateway

### Option 2: Start Services Individually

**1. Start Eureka Server:**
```bash
cd microservices/eureka-server
mvn spring-boot:run
```

**2. Start All Microservices:**
```bash
cd microservices
start-all-services.bat
```

**3. Start API Gateway:**
```bash
cd microservices/api-gateway
mvn spring-boot:run
```

**4. Start Frontend:**
```bash
cd frontend
npm install
npm start
```

Access the application at `http://localhost:4200`

## Frontend Configuration

The frontend is configured to connect to microservices through the API Gateway:

- **Development**: `http://localhost:9090/api`
- **WebSocket**: `ws://localhost:9090/ws`

## Verification Checklist

✅ MySQL is running with credentials `root/abc@123`
✅ All 5 databases created (user, movie, venue, booking, payment)
✅ Eureka Server running on port 8761
✅ All microservices registered with Eureka
✅ API Gateway running on port 9090
✅ Frontend connected to API Gateway
✅ Admin user created: `admin@revature.com`
✅ Image folders configured in `movie-service/public/`

## Troubleshooting

### Database Connection Issues
- Verify MySQL is running: `mysql -u root -p`
- Check password is set to `abc@123`
- Ensure all databases exist: `SHOW DATABASES LIKE 'revtickets_%';`

### Service Discovery Issues
- Ensure Eureka Server is running first
- Check all services are registered: `http://localhost:8761`
- Wait 30 seconds for services to register

### Frontend Not Connecting
- Verify API Gateway is running on port 9090
- Check browser console for CORS errors
- Ensure environment.ts has correct apiUrl

### Image Loading Issues
- Verify images exist in `movie-service/public/display/` and `movie-service/public/banner/`
- Check API Gateway routing for `/display/**` and `/banner/**`
- Ensure movie-service WebConfig is serving static resources

## Development Notes

### Adding New Images
Place image files in:
- Display images: `microservices/movie-service/public/display/`
- Banner images: `microservices/movie-service/public/banner/`

### Database Schema Updates
Spring JPA is configured with `spring.jpa.hibernate.ddl-auto=update`
- Schema changes will be applied automatically
- For production, consider using migration tools like Flyway or Liquibase

### Creating New Users
- Register through frontend: `http://localhost:4200/auth/register`
- Default role is CUSTOMER
- Admin can manage users through admin panel

## Security Notes

⚠️ **Important**: Change these default credentials before deploying to production:
- Database password
- Admin user password
- JWT secret in user-service
- Stripe API keys

## Support

For issues or questions, refer to:
- Eureka Dashboard: `http://localhost:8761`
- API Gateway: `http://localhost:9090`
- Check service logs in respective microservice directories
