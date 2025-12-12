# MongoDB Quick Setup for RevTickets

## Why MongoDB?

MongoDB is used for storing **movie and event reviews** in the Movie Service. It provides flexible schema for review data including ratings, comments, and user feedback.

---

## Installation Steps

### Option 1: MongoDB Community Server (Recommended)

1. **Download MongoDB**
   - Visit: https://www.mongodb.com/try/download/community
   - Select: Windows x64
   - Version: 7.0 or later (Community Edition)

2. **Install MongoDB**
   - Run the installer
   - Choose "Complete" installation
   - **Important**: Check "Install MongoDB as a Service"
   - Keep default service name: `MongoDB`
   - Default port: `27017`

3. **Verify Installation**
   ```bash
   # Check MongoDB is running
   sc query MongoDB
   
   # Check MongoDB version
   mongod --version
   ```

4. **Start/Stop MongoDB Service**
   ```bash
   # Start MongoDB
   net start MongoDB
   
   # Stop MongoDB
   net stop MongoDB
   
   # Check status
   sc query MongoDB
   ```

---

### Option 2: MongoDB Compass (GUI Tool - Optional)

MongoDB Compass provides a graphical interface to view and manage your databases.

1. **Download**: https://www.mongodb.com/try/download/compass
2. **Install**: Run installer with default settings
3. **Connect**: Use connection string `mongodb://localhost:27017`
4. **Browse**: View `revtickets_reviews` database after first app run

---

## Database Details

**Database Name**: `revtickets_reviews`  
**Connection URI**: `mongodb://localhost:27017/revtickets_reviews`  
**Used By**: Movie Service (port 8082)

### Collections

The following collections are created automatically:

- `reviews` - Movie and event reviews
  - Fields: userId, movieId/eventId, rating, comment, createdAt

---

## Verification

After installation, verify MongoDB is working:

```bash
# Method 1: Check service status
sc query MongoDB

# Method 2: Test connection with mongosh
mongosh
> show dbs
> exit
```

---

## Troubleshooting

### MongoDB Service Not Starting

**Error**: "The MongoDB service could not be started"

**Solutions**:
1. Check if port 27017 is available:
   ```bash
   netstat -ano | findstr :27017
   ```
2. Check MongoDB log files:
   ```
   C:\Program Files\MongoDB\Server\7.0\log\mongod.log
   ```
3. Try manual start:
   ```bash
   net start MongoDB
   ```

### Connection Refused

**Error**: "Connection refused to localhost:27017"

**Solutions**:
1. Verify MongoDB service is running
2. Check firewall settings
3. Ensure MongoDB is bound to localhost

### Database Not Created

**Issue**: `revtickets_reviews` database doesn't exist

**Solution**: 
- Database is created automatically when the Movie Service first writes data
- No manual database creation needed
- Just ensure MongoDB is running before starting Movie Service

---

## Alternative: Docker MongoDB (Advanced)

If you prefer Docker:

```bash
# Pull MongoDB image
docker pull mongo:latest

# Run MongoDB container
docker run -d -p 27017:27017 --name mongodb mongo:latest

# Verify running
docker ps | findstr mongodb
```

---

## What Happens Without MongoDB?

If MongoDB is not installed:
- ✅ All other features work normally
- ❌ Movie/Event reviews feature will fail
- ❌ Movie Service will log connection errors
- ❌ Users cannot submit or view reviews

**Recommendation**: Install MongoDB to enable the full review system functionality.

---

## Quick Check

Run this to verify MongoDB is ready:

```bash
VERIFY-SYSTEM.bat
```

This script checks:
- MongoDB installation
- Service status
- Port availability
- Connection test
