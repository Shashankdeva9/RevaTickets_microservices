package com.revature.userservice.config;

import com.revature.userservice.entity.User;
import com.revature.userservice.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * DataSeeder - Initializes the database with default admin user
 * This component runs on application startup and creates the admin user if it doesn't exist
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataSeeder implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        log.info("Starting data seeding process...");
        
        // Create admin user if not exists
        createAdminUser();
        
        log.info("Data seeding completed successfully!");
    }

    private void createAdminUser() {
        String adminEmail = "admin@revature.com";
        
        if (!userRepository.existsByEmail(adminEmail)) {
            User admin = new User();
            admin.setEmail(adminEmail);
            admin.setPassword(passwordEncoder.encode("admin@123"));
            admin.setFullName("Admin");
            admin.setPhone("1234567890");
            admin.setRole(User.UserRole.ADMIN);
            admin.setIsActive(true);
            
            userRepository.save(admin);
            log.info("✓ Admin user created successfully - Email: {}", adminEmail);
        } else {
            log.info("✓ Admin user already exists - Email: {}", adminEmail);
        }
    }
}
