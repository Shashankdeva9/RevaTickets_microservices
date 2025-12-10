package com.revature.movieservice.controller;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
public class ImageController {

    @GetMapping("/display/{filename}")
    public ResponseEntity<Resource> getDisplayImage(@PathVariable String filename) {
        try {
            Path filePath = Paths.get("public/display/" + filename);
            File file = filePath.toFile();
            
            if (file.exists() && file.isFile()) {
                Resource resource = new FileSystemResource(file);
                MediaType mediaType = getMediaType(filename);
                return ResponseEntity.ok()
                    .contentType(mediaType)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + filename + "\"")
                    .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/banner/{filename}")
    public ResponseEntity<Resource> getBannerImage(@PathVariable String filename) {
        try {
            Path filePath = Paths.get("public/banner/" + filename);
            File file = filePath.toFile();
            
            if (file.exists() && file.isFile()) {
                Resource resource = new FileSystemResource(file);
                MediaType mediaType = getMediaType(filename);
                return ResponseEntity.ok()
                    .contentType(mediaType)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + filename + "\"")
                    .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    private MediaType getMediaType(String filename) {
        String extension = filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
        switch (extension) {
            case "png": return MediaType.IMAGE_PNG;
            case "gif": return MediaType.IMAGE_GIF;
            case "webp": return MediaType.valueOf("image/webp");
            default: return MediaType.IMAGE_JPEG;
        }
    }
}