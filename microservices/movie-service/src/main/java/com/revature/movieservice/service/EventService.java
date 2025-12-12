package com.revature.movieservice.service;

import com.revature.movieservice.entity.Event;
import com.revature.movieservice.repository.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class EventService {

    @Autowired
    private EventRepository eventRepository;

    public List<Event> getAllActiveEvents() {
        return eventRepository.findByIsActiveTrue();
    }

    public List<Event> getAllEvents() {
        return eventRepository.findAll();
    }

    public Event getEventById(Long id) {
        return eventRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Event not found"));
    }

    public List<Event> getUpcomingEvents() {
        return eventRepository.findByEventDateGreaterThanEqualAndIsActiveTrue(LocalDate.now());
    }

    public Event activateEvent(Long id) {
        Event event = getEventById(id);
        event.setIsActive(true);
        return eventRepository.save(event);
    }

    public void deleteEvent(Long id) {
        Event event = getEventById(id);
        event.setIsActive(false);
        eventRepository.save(event);
    }

    public Event createEvent(Event event) {
        return eventRepository.save(event);
    }
    
    public Event createEvent(Event event, MultipartFile displayImage, MultipartFile bannerImage) {
        try {
            if (displayImage != null && !displayImage.isEmpty()) {
                String displayPath = saveImage(displayImage, "display");
                event.setDisplayImageUrl(displayPath);
            }
            if (bannerImage != null && !bannerImage.isEmpty()) {
                String bannerPath = saveImage(bannerImage, "banner");
                event.setBannerImageUrl(bannerPath);
            }
            return eventRepository.save(event);
        } catch (IOException e) {
            throw new RuntimeException("Failed to save images: " + e.getMessage());
        }
    }

    public Event updateEvent(Long id, Event eventDetails) {
        Event event = getEventById(id);
        event.setTitle(eventDetails.getTitle());
        event.setDescription(eventDetails.getDescription());
        event.setCategory(eventDetails.getCategory());
        event.setArtistOrTeam(eventDetails.getArtistOrTeam());
        event.setAgeRestriction(eventDetails.getAgeRestriction());
        event.setDurationMinutes(eventDetails.getDurationMinutes());
        event.setEventDate(eventDetails.getEventDate());
        event.setEventTime(eventDetails.getEventTime());
        event.setLanguage(eventDetails.getLanguage());
        return eventRepository.save(event);
    }
    
    public Event updateEvent(Long id, Event eventDetails, MultipartFile displayImage, MultipartFile bannerImage) {
        try {
            Event event = getEventById(id);
            event.setTitle(eventDetails.getTitle());
            event.setDescription(eventDetails.getDescription());
            event.setCategory(eventDetails.getCategory());
            event.setArtistOrTeam(eventDetails.getArtistOrTeam());
            event.setAgeRestriction(eventDetails.getAgeRestriction());
            event.setDurationMinutes(eventDetails.getDurationMinutes());
            event.setEventDate(eventDetails.getEventDate());
            event.setEventTime(eventDetails.getEventTime());
            event.setLanguage(eventDetails.getLanguage());
            
            if (displayImage != null && !displayImage.isEmpty()) {
                String displayPath = saveImage(displayImage, "display");
                event.setDisplayImageUrl(displayPath);
            }
            if (bannerImage != null && !bannerImage.isEmpty()) {
                String bannerPath = saveImage(bannerImage, "banner");
                event.setBannerImageUrl(bannerPath);
            }
            
            return eventRepository.save(event);
        } catch (IOException e) {
            throw new RuntimeException("Failed to save images: " + e.getMessage());
        }
    }
    
    private String saveImage(MultipartFile file, String type) throws IOException {
        String uploadDir = System.getProperty("user.dir") + "/public/" + type;
        Path uploadPath = Paths.get(uploadDir);
        
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        String originalFileName = file.getOriginalFilename();
        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String newFileName = UUID.randomUUID().toString() + fileExtension;
        
        Path filePath = uploadPath.resolve(newFileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
        return "/" + type + "/" + newFileName;
    }
}
