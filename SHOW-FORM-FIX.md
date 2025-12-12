# Show Form 400 Bad Request Fix

## Problem
When creating shows (especially for events with open ground), the system returned:
```
Failed to load resource: the server responded with a status of 400 (Bad Request)
POST http://localhost:9090/api/admin/shows
```

## Root Cause
The `Show` entity in `booking-service` had NOT NULL constraints on `venue_id` and `screen_id`:

```java
@Column(name = "venue_id", nullable = false)  // ❌ Cannot be null
private Long venueId;

@Column(name = "screen_id", nullable = false) // ❌ Cannot be null
private Long screenId;
```

When creating open ground events, the frontend sends:
```typescript
formData.venueId = null;
formData.screenId = null;
formData.isOpenGround = true;
```

This violated the database NOT NULL constraints, causing a 400 Bad Request error.

## Solution

### 1. Updated Show Entity
**File**: `microservices/booking-service/src/main/java/com/revature/bookingservice/entity/Show.java`

Changed:
```java
@Column(name = "venue_id")  // ✅ Now nullable
private Long venueId;

@Column(name = "screen_id") // ✅ Now nullable
private Long screenId;
```

### 2. Updated ShowService
**File**: `microservices/booking-service/src/main/java/com/revature/bookingservice/service/ShowService.java`

Added support for pricing zones in open ground events:

```java
// Handle pricing zones for open ground events
if (showData.get("pricingZones") != null) {
    // Store in pricingTiers JSON field
    java.util.Map<String, java.math.BigDecimal> pricingTiers = new java.util.HashMap<>();
    java.util.List<java.util.Map<String, Object>> zones = 
        (java.util.List<java.util.Map<String, Object>>) showData.get("pricingZones");
    for (java.util.Map<String, Object> zone : zones) {
        String zoneName = zone.get("name").toString();
        java.math.BigDecimal zonePrice = new java.math.BigDecimal(zone.get("price").toString());
        pricingTiers.put(zoneName, zonePrice);
    }
    show.setPricingTiers(pricingTiers);
}

// Calculate total capacity from pricing zones for open ground
if (showData.get("pricingZones") != null) {
    java.util.List<java.util.Map<String, Object>> zones = 
        (java.util.List<java.util.Map<String, Object>>) showData.get("pricingZones");
    totalSeats = zones.stream()
        .mapToInt(zone -> Integer.parseInt(zone.get("capacity").toString()))
        .sum();
}
```

### 3. Updated Database Schema
**Database**: `revtickets_booking_db`

```sql
ALTER TABLE shows MODIFY COLUMN venue_id BIGINT NULL;
ALTER TABLE shows MODIFY COLUMN screen_id BIGINT NULL;
```

## How It Works Now

### Regular Shows (Movies/Events in Venues)
```typescript
{
  showType: "MOVIE",
  movieId: 1,
  venueId: 1,        // ✅ Set to venue
  screenId: 2,       // ✅ Set to screen
  standardPrice: 200,
  premiumPrice: 200,
  vipPrice: 200
}
```

### Open Ground Shows (Events Only)
```typescript
{
  showType: "EVENT",
  eventId: 1,
  venueId: null,     // ✅ NULL allowed
  screenId: null,    // ✅ NULL allowed
  isOpenGround: true,
  pricingZones: [
    { name: "VIP", price: 1000, capacity: 50 },
    { name: "Gold", price: 500, capacity: 100 },
    { name: "Silver", price: 300, capacity: 200 }
  ]
}
```

The backend now:
1. ✅ Accepts null venue/screen for open ground events
2. ✅ Stores pricing zones in the `pricing_tiers` JSON column
3. ✅ Calculates total capacity from pricing zones
4. ✅ Uses first zone price as base price

## Testing
1. Navigate to Admin > Shows > Create Show
2. Select "Event" as show type
3. Select "Open Ground" as venue
4. Add multiple pricing zones (VIP, Gold, Silver)
5. Set show date and time
6. Click "Create Show"
7. ✅ Show should be created successfully without 400 error

## Files Modified
- `microservices/booking-service/src/main/java/com/revature/bookingservice/entity/Show.java`
- `microservices/booking-service/src/main/java/com/revature/bookingservice/service/ShowService.java`
- Database: `revtickets_booking_db.shows` table schema

## Build Command
```bash
cd microservices/booking-service
mvn clean package -DskipTests
```

## Restart Services
All services have been rebuilt and restarted with the fix.
