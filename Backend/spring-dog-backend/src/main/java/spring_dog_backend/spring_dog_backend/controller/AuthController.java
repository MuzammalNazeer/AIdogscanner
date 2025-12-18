
package spring_dog_backend.spring_dog_backend.controller;

import jakarta.validation.Valid;
import org.springframework.validation.BindingResult;
import spring_dog_backend.spring_dog_backend.dto.request.LoginRequest;
import spring_dog_backend.spring_dog_backend.dto.request.SignupRequest;
import spring_dog_backend.spring_dog_backend.model.User;
import spring_dog_backend.spring_dog_backend.repository.UserRepository;
import spring_dog_backend.spring_dog_backend.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/signup")
    public ResponseEntity<?> register(@Valid @RequestBody SignupRequest signupRequest, BindingResult bindingResult) {
        try {
            System.out.println("=== 👤 REGISTRATION ATTEMPT ===");

            // ✅ Check if Spring validation failed FIRST
            if (bindingResult.hasErrors()) {
                Map<String, String> errors = new HashMap<>();
                bindingResult.getFieldErrors().forEach(error ->
                        errors.put(error.getField(), error.getDefaultMessage()));

                System.out.println(STR."❌ SPRING VALIDATION FAILED: \{errors}");
                return ResponseEntity.badRequest()
                        .body(Map.of(
                                "success", false,
                                "error", "Validation failed",
                                "message", "Please check your input fields",
                                "errors", errors
                        ));
            }

            // ✅ Now proceed with manual validation and business logic
            System.out.println("📦 RECEIVED DATA:");
            System.out.println(STR."   - Username: \{signupRequest.getUsername()}");
            System.out.println(STR."   - Email: \{signupRequest.getEmail()}");
            System.out.println(STR."   - Full name: \{signupRequest.getFullname()}");
            System.out.println(STR."   - Password length: \{signupRequest.getPassword() != null ? signupRequest.getPassword().length() : 0}");

            // Trim and prepare data
            String username = signupRequest.getUsername().trim();
            String email = signupRequest.getEmail().trim().toLowerCase();
            String fullName = signupRequest.getFullname().trim();
            String password = signupRequest.getPassword();

            // ✅ MANUAL VALIDATION: Username length (3-50 characters)
            if (username.length() < 3 || username.length() > 50) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "error", "Registration failed",
                                "message", "Username must be between 3 and 50 characters")
                );
            }

            // ✅ MANUAL VALIDATION: Password length (6-100 characters)
            if (password.length() < 6) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "error", "Registration failed",
                                "message", "Password must be at least 6 characters long")
                );
            }

            if (password.length() > 100) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "error", "Registration failed",
                                "message", "Password must be no more than 100 characters long")
                );
            }

            // ✅ MANUAL VALIDATION: Full name length (2-100 characters)
            if (fullName.length() < 2 || fullName.length() > 100) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "error", "Registration failed",
                                "message", "Full name must be between 2 and 100 characters")
                );
            }

            // ✅ Check if username already exists
            if (userRepository.findByUsername(username).isPresent()) {
                System.out.println("❌ USERNAME ALREADY EXISTS: " + username);
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "error", "Registration failed",
                                "message", "Username already exists")
                );
            }

            // ✅ Check if email already exists
            if (userRepository.findByEmail(email).isPresent()) {
                System.out.println("❌ EMAIL ALREADY EXISTS: " + email);
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "error", "Registration failed",
                                "message", "Email already exists")
                );
            }

            // ✅ Create new user
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setFullName(fullName);

            // Encode password before saving
            String encodedPassword = passwordEncoder.encode(password);
            user.setPassword(encodedPassword);

            // ✅ DEBUG: Before saving
            System.out.println(" ABOUT TO SAVE USER:");
            System.out.println("   - Username: " + user.getUsername());
            System.out.println("   - Email: " + user.getEmail());
            System.out.println("   - Full Name: " + user.getFullName());
            System.out.println("   - Password encoded: " + (user.getPassword() != null));

            // ✅ Save user to database
            User savedUser = userRepository.save(user);

            // ✅ DEBUG: After saving
            System.out.println("✅ USER SAVED SUCCESSFULLY:");
            System.out.println("   - ID: " + savedUser.getId());
            System.out.println("   - Username: " + savedUser.getUsername());
            System.out.println("   - Email: " + savedUser.getEmail());
            System.out.println("   - Full Name: " + savedUser.getFullName());
            System.out.println("   - Created At: " + savedUser.getCreatedAt());

            // ✅ Verify the user was actually saved
            Optional<User> verifiedUser = userRepository.findById(savedUser.getId());
            if (verifiedUser.isPresent()) {
                System.out.println("✅ USER VERIFIED IN DATABASE");
                User foundUser = verifiedUser.get();
                System.out.println("   - Verified Username: " + foundUser.getUsername());
                System.out.println("   - Verified Email: " + foundUser.getEmail());
                System.out.println("   - Verified Full Name: " + foundUser.getFullName());
            } else {
                System.out.println("❌ USER NOT FOUND AFTER SAVE!");
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "error", "Registration failed",
                                "message", "User not saved to database")
                );
            }

            // ✅ Generate JWT token
            String token = jwtUtil.generateJwtToken(savedUser.getUsername());

            // ✅ Prepare user info for response
            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("id", savedUser.getId());
            userInfo.put("username", savedUser.getUsername());
            userInfo.put("email", savedUser.getEmail());
            userInfo.put("fullName", savedUser.getFullName());
            userInfo.put("createdAt", savedUser.getCreatedAt());

            // ✅ Prepare success response
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("token", token);
            response.put("user", userInfo);
            response.put("message", "Registration successful");

            System.out.println(" REGISTRATION COMPLETED SUCCESSFULLY FOR: " + savedUser.getUsername());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.out.println(" REGISTRATION ERROR: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(
                    Map.of("success", false, "error", "Registration failed",
                            "message", "An unexpected error occurred: " + e.getMessage())
            );
        }
    }





    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        try {
            System.out.println("=== 🔐 LOGIN ATTEMPT ===");
            System.out.println("Username: " + loginRequest.getUsername());
            System.out.println("Password length: " + (loginRequest.getPassword() != null ? loginRequest.getPassword().length() : 0));

            // ✅ MANUAL VALIDATION: Check if fields are provided
            if (loginRequest.getUsername() == null || loginRequest.getUsername().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                        Map.of("error", "Login failed", "message", "Username is required")
                );
            }

            if (loginRequest.getPassword() == null || loginRequest.getPassword().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                        Map.of("error", "Login failed", "message", "Password is required")
                );
            }

            // ✅ MANUAL VALIDATION: Password length (3-20 characters)
            String password = loginRequest.getPassword();
            if (password.length() < 3) {
                return ResponseEntity.badRequest().body(
                        Map.of("error", "Login failed",
                                "message", "Password must be at least 3 characters long")
                );
            }

            if (password.length() > 20) {
                return ResponseEntity.badRequest().body(
                        Map.of("error", "Login failed",
                                "message", "Password must be no more than 20 characters long")
                );
            }

            // ... rest of your existing login code
            // [Keep all your existing login logic here - finding user, checking password, etc.]

            // Find the specific user
            Optional<User> userOpt = userRepository.findByUsername(loginRequest.getUsername());

            if (userOpt.isEmpty()) {
                System.out.println("❌ USER NOT FOUND: " + loginRequest.getUsername());
                return ResponseEntity.badRequest().body(
                        Map.of("error", "Invalid username or password", "message", "User not found")
                );
            }

            User user = userOpt.get();
            System.out.println("✅ USER FOUND: " + user.getUsername());

            // Verify password
            boolean passwordMatches = passwordEncoder.matches(loginRequest.getPassword(), user.getPassword());
            System.out.println("✅ Password matches: " + passwordMatches);

            if (!passwordMatches) {
                return ResponseEntity.badRequest().body(
                        Map.of("error", "Invalid username or password", "message", "Password incorrect")
                );
            }

            // Generate token
            String token = jwtUtil.generateJwtToken(user.getUsername());
            System.out.println("🎉 LOGIN SUCCESSFUL");

            // Response
            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("id", user.getId());
            userInfo.put("username", user.getUsername());
            userInfo.put("email", user.getEmail());
            userInfo.put("fullName", user.getFullName());

            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            response.put("user", userInfo);
            response.put("message", "Login successful");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.out.println("💥 LOGIN ERROR: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body(
                    Map.of("error", "Login failed", "message", e.getMessage())
            );
        }
    }

    @GetMapping("/test-users")
    public ResponseEntity<?> testUsers() {
        try {
            System.out.println("=== 👥 TESTING USER DATA ===");
            var users = userRepository.findAll();

            users.forEach(user -> {
                System.out.println("User: " + user.getUsername() + " | Password: " + user.getPassword() + " | Length: " + user.getPassword().length());
            });

            return ResponseEntity.ok(Map.of(
                    "totalUsers", users.size(),
                    "users", users.stream().map(u -> Map.of(
                            "id", u.getId(),
                            "username", u.getUsername(),
                            "passwordLength", u.getPassword().length(),
                            "passwordPrefix", u.getPassword().substring(0, Math.min(10, u.getPassword().length()))
                    )).toList()
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("error", "Test failed", "message", e.getMessage())
            );
        }
    }

    @GetMapping("/verify-setup")
    public ResponseEntity<?> verifySetup() {
        try {
            System.out.println("=== ✅ VERIFYING SETUP ===");

            // Check database connection and users
            long userCount = userRepository.count();
            System.out.println(STR."Total users in database: \{userCount}");

            var users = userRepository.findAll();
            users.forEach(user -> {
                System.out.println(STR."User: \{user.getUsername()} | Password length: \{user.getPassword().length()} | Email: \{user.getEmail()}");
            });

            // Test password encoder
            String testPassword = "test123";
            String encoded = passwordEncoder.encode(testPassword);
            boolean matches = passwordEncoder.matches(testPassword, encoded);

            System.out.println("Password encoder working: " + matches);
            System.out.println("Sample encoded password: " + encoded);

            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "totalUsers", userCount,
                    "passwordEncoderWorking", matches,
                    "users", users.stream().map(u -> Map.of(
                            "username", u.getUsername(),
                            "email", u.getEmail(),
                            "passwordHashLength", u.getPassword().length()
                    )).toList()
            ));

        } catch (Exception e) {
            System.out.println(STR."\uD83D\uDCA5 VERIFICATION FAILED: \{e.getMessage()}");
            return ResponseEntity.badRequest().body(
                    Map.of("status", "error", "message", e.getMessage())
            );
        }
    }

    @GetMapping("/check-password/{username}")
    public ResponseEntity<?> checkPassword(@PathVariable String username) {
        try {
            Optional<User> userOpt = userRepository.findByUsername(username);

            if (userOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("User not found: " + username);
            }

            User user = userOpt.get();

            // Test common passwords
            String[] testPasswords = {"password", "Password", "Password123", "admin", "123456"};

            Map<String, Object> result = new HashMap<>();
            result.put("username", user.getUsername());
            result.put("storedPasswordHash", user.getPassword());
            result.put("hashLength", user.getPassword().length());
            result.put("hashPrefix", user.getPassword().substring(0, Math.min(10, user.getPassword().length())));

            Map<String, Boolean> passwordTests = new HashMap<>();
            for (String testPassword : testPasswords) {
                boolean matches = passwordEncoder.matches(testPassword, user.getPassword());
                passwordTests.put(testPassword, matches);
                System.out.println("Password '" + testPassword + "' matches: " + matches);
            }

            result.put("passwordTests", passwordTests);

            return ResponseEntity.ok(result);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    @GetMapping("/diagnose-db-columns")
    public ResponseEntity<?> diagnoseDatabaseColumns() {
        try {
            System.out.println("=== 🗄️ DATABASE COLUMN DIAGNOSIS ===");

            // This will help us see if there are any column issues
            var users = userRepository.findAll();

            if (users.isEmpty()) {
                System.out.println("❌ No users found in database");
            } else {
                System.out.println("✅ Users table is accessible");
                System.out.println("📊 Total users: " + users.size());

                // Try to create and save a test user to see the exact error
                User testUser = new User();
                testUser.setUsername("column_test_user");
                testUser.setEmail("column_test@example.com");
                testUser.setPassword(passwordEncoder.encode("testpassword"));
                testUser.setFullName("Column Test User");

                try {
                    User savedUser = userRepository.save(testUser);
                    System.out.println("✅ SUCCESS: Can insert into users table");
                    System.out.println("✅ Saved user ID: " + savedUser.getId());

                    // Clean up
                    userRepository.delete(savedUser);
                    System.out.println("✅ Cleaned up test user");

                    return ResponseEntity.ok(Map.of(
                            "status", "success",
                            "message", "Database is working correctly - no column issues",
                            "test_insert", "successful"
                    ));

                } catch (Exception e) {
                    System.out.println("❌ INSERT FAILED: " + e.getMessage());
                    System.out.println("💥 This confirms the database has column structure issues");

                    return ResponseEntity.badRequest().body(Map.of(
                            "status", "error",
                            "message", "Database column issue detected",
                            "error", e.getMessage(),
                            "solution", "Run: ALTER TABLE users DROP COLUMN password_hash;"
                    ));
                }
            }

            return ResponseEntity.ok(Map.of(
                    "status", "diagnosis_complete",
                    "table_accessible", !users.isEmpty(),
                    "total_users", users.size()
            ));

        } catch (Exception e) {
            System.out.println("💥 DIAGNOSIS FAILED: " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    Map.of("status", "diagnosis_failed", "message", e.getMessage())
            );
        }
    }

    @GetMapping("/database-status")
    public ResponseEntity<?> databaseStatus() {
        try {
            System.out.println("=== 🗃️ DATABASE STATUS ===");

            var users = userRepository.findAll();
            long userCount = userRepository.count();

            System.out.println("📊 Total users: " + userCount);
            System.out.println("🔧 UserRepository: " + userRepository.getClass().getName());
            System.out.println("🔑 PasswordEncoder: " + passwordEncoder.getClass().getName());

            Map<String, Object> status = new HashMap<>();
            status.put("database", "connected");
            status.put("totalUsers", userCount);
            status.put("userRepository", userRepository.getClass().getSimpleName());
            status.put("passwordEncoder", passwordEncoder.getClass().getSimpleName());
            status.put("users", users.stream().map(u -> Map.of(
                    "id", u.getId(),
                    "username", u.getUsername(),
                    "email", u.getEmail()
            )).toList());

            return ResponseEntity.ok(status);

        } catch (Exception e) {
            System.out.println("💥 DATABASE STATUS CHECK FAILED: " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    Map.of("database", "error", "message", e.getMessage())
            );
        }
    }

    @GetMapping("/test-insert")
    public ResponseEntity<?> testInsert() {
        try {
            System.out.println("=== 🧪 TEST INSERT OPERATION ===");

            User testUser = new User();
            testUser.setUsername("test_insert_user");
            testUser.setEmail("test_insert@example.com");
            testUser.setPassword(passwordEncoder.encode("testpassword123"));
            testUser.setFullName("Test Insert User");

            System.out.println("Attempting to save test user...");
            User savedUser = userRepository.save(testUser);
            System.out.println("✅ INSERT SUCCESSFUL: User ID = " + savedUser.getId());

            // Clean up
            userRepository.delete(savedUser);
            System.out.println("✅ Cleanup successful");

            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "message", "Database insert operation is working correctly",
                    "testUser", Map.of(
                            "id", savedUser.getId(),
                            "username", savedUser.getUsername(),
                            "passwordLength", savedUser.getPassword().length()
                    )
            ));

        } catch (Exception e) {
            System.out.println("❌ INSERT TEST FAILED: " + e.getMessage());
            e.printStackTrace();

            return ResponseEntity.badRequest().body(Map.of(
                    "status", "error",
                    "message", "Insert test failed",
                    "error", e.getMessage(),
                    "solution", "The database has column issues. Run: ALTER TABLE users DROP COLUMN password_hash;"
            ));
        }
    }
}

