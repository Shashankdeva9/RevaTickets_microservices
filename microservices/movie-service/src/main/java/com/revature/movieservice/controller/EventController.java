package com.revature.movieservice.controller;

import com.revature.movieservice.dto.ApiResponse;
import com.revature.movieservice.entity.Event;
import com.revature.movieservice.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/events")
public class EventController {

    @Autowired
    private EventService eventService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Event>>> getAllEvents() {
        try {
            List<Event> events = eventService.getAllActiveEvents();
            return ResponseEntity.ok(new ApiResponse<>(true, "Events retrieved successfully", events));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Event>> getEventById(@PathVariable Long id) {
        try {
            Event event = eventService.getEventById(id);
            return ResponseEntity.ok(new ApiResponse<>(true, "Event retrieved successfully", event));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }

    @GetMapping("/upcoming")
    public ResponseEntity<ApiResponse<List<Event>>> getUpcomingEvents() {
        try {
            List<Event> events = eventService.getUpcomingEvents();
            return ResponseEntity.ok(new ApiResponse<>(true, "Upcoming events retrieved", events));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }

    @GetMapping("/admin")
    public ResponseEntity<ApiResponse<List<Event>>> getAdminEvents(@RequestParam(defaultValue = "false") boolean activeOnly) {
        try {
            List<Event> events = activeOnly ? eventService.getAllActiveEvents() : eventService.getAllEvents();
            return ResponseEntity.ok(new ApiResponse<>(true, "Events retrieved successfully", events));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }

    @GetMapping("/admin/{id}")
    public ResponseEntity<ApiResponse<Event>> getAdminEventById(@PathVariable Long id) {
        try {
            Event event = eventService.getEventById(id);
            return ResponseEntity.ok(new ApiResponse<>(true, "Event retrieved successfully", event));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }

    @PostMapping(value = "/admin", consumes = {"multipart/form-data"})
    public ResponseEntity<ApiResponse<Event>> createAdminEvent(
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("category") String category,
            @RequestParam("artist") String artist,
            @RequestParam("duration") Integer duration,
            @RequestParam("eventDate") String eventDate,
            @RequestParam("eventTime") String eventTime,
            @RequestParam("language") String language,
            @RequestParam("ageRestriction") String ageRestriction,
            @RequestParam(value = "displayImage", required = false) MultipartFile displayImage,
            @RequestParam(value = "bannerImage", required = false) MultipartFile bannerImage) {
        try {
            Event event = new Event();
            event.setTitle(title);
            event.setDescription(description);
            event.setCategory(category);
            event.setArtistOrTeam(artist);
            event.setDurationMinutes(duration);
            event.setEventDate(java.time.LocalDate.parse(eventDate));
            event.setEventTime(java.time.LocalTime.parse(eventTime));
            event.setLanguage(language);
            event.setAgeRestriction(ageRestriction);
            event.setIsActive(true);
            
            Event savedEvent = eventService.createEvent(event, displayImage, bannerImage);
            return ResponseEntity.ok(new ApiResponse<>(true, "Event created successfully", savedEvent));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }

    @PutMapping(value = "/admin/{id}", consumes = {"multipart/form-data"})
    public ResponseEntity<ApiResponse<Event>> updateAdminEvent(
            @PathVariable Long id,
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("category") String category,
            @RequestParam("artist") String artist,
            @RequestParam("duration") Integer duration,
            @RequestParam("eventDate") String eventDate,
            @RequestParam("eventTime") String eventTime,
            @RequestParam("language") String language,
            @RequestParam("ageRestriction") String ageRestriction,
            @RequestParam(value = "displayImage", required = false) MultipartFile displayImage,
            @RequestParam(value = "bannerImage", required = false) MultipartFile bannerImage) {
        try {
            Event event = new Event();
            event.setTitle(title);
            event.setDescription(description);
            event.setCategory(category);
            event.setArtistOrTeam(artist);
            event.setDurationMinutes(duration);
            event.setEventDate(java.time.LocalDate.parse(eventDate));
            event.setEventTime(java.time.LocalTime.parse(eventTime));
            event.setLanguage(language);
            event.setAgeRestriction(ageRestriction);
            
            Event updatedEvent = eventService.updateEvent(id, event, displayImage, bannerImage);
            return ResponseEntity.ok(new ApiResponse<>(true, "Event updated successfully", updatedEvent));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }

    @DeleteMapping("/admin/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteAdminEvent(@PathVariable Long id) {
        try {
            eventService.deleteEvent(id);
            return ResponseEntity.ok(new ApiResponse<>(true, "Event deactivated successfully", null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }

    @PutMapping("/admin/{id}/activate")
    public ResponseEntity<ApiResponse<Event>> activateAdminEvent(@PathVariable Long id) {
        try {
            Event event = eventService.activateEvent(id);
            return ResponseEntity.ok(new ApiResponse<>(true, "Event activated successfully", event));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }
}
