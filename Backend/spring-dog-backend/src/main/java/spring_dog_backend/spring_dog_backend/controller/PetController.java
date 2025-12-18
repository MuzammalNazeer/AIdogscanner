package spring_dog_backend.spring_dog_backend.controller;

import jakarta.validation.constraints.NotNull;
import spring_dog_backend.spring_dog_backend.dto.request.PetRequest;
import spring_dog_backend.spring_dog_backend.dto.request.PetUpdateRequest;
import spring_dog_backend.spring_dog_backend.dto.response.ApiResponse;
import spring_dog_backend.spring_dog_backend.dto.response.PetResponse;
import spring_dog_backend.spring_dog_backend.model.Pet;
import spring_dog_backend.spring_dog_backend.service.PetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/pets")
public class PetController {

    @Autowired
    private PetService petService;

    // =================================================================
    // 🐕 PET CRUD OPERATIONS (SECURED)
    // =================================================================

    @PostMapping
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<PetResponse>> createPet(@Valid @RequestBody PetRequest request) {
        System.out.println(STR."\uD83D\uDC15 CREATE PET - userId: \{request.getUserId()}, name: \{request.getName()}");
        PetResponse pet = petService.createPet(request);
        return ResponseEntity.ok(ApiResponse.success("Pet created successfully", pet));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<PetResponse>> getPet(@PathVariable Long id) {
        PetResponse pet = petService.getPetById(id);
        return ResponseEntity.ok(ApiResponse.success("Pet retrieved successfully", pet));
    }

    @GetMapping("/user/{userId}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<List<PetResponse>>> getUserPets(@PathVariable Long userId) {
        List<PetResponse> pets = petService.getPetsByUserId(userId);
        return ResponseEntity.ok(ApiResponse.success("User pets retrieved successfully", pets));
    }

    @GetMapping("/user/{userId}/species/{species}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<List<PetResponse>>> getPetsBySpecies(
            @PathVariable Long userId,
            @PathVariable Pet.Species species) {
        List<PetResponse> pets = petService.getPetsByUserIdAndSpecies(userId, species);
        return ResponseEntity.ok(ApiResponse.success("Pets by species retrieved successfully", pets));
    }

    @GetMapping("/user/{userId}/search")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<List<PetResponse>>> searchPets(
            @PathVariable Long userId,
            @RequestParam String name) {
        List<PetResponse> pets = petService.searchPetsByName(userId, name);
        return ResponseEntity.ok(ApiResponse.success("Pets search completed", pets));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<PetResponse>> updatePet(
            @PathVariable Long id,
            @Valid @RequestBody PetUpdateRequest request) {
        PetResponse pet = petService.updatePet(id, request);
        return ResponseEntity.ok(ApiResponse.success("Pet updated successfully", pet));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<Void>> deletePet(@PathVariable Long id) {
        petService.deletePet(id);
        return ResponseEntity.ok(ApiResponse.success("Pet deleted successfully", null));
    }

    @DeleteMapping("/{id}/user/{userId}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<Void>> deleteUserPet(
            @PathVariable Long id,
            @PathVariable Long userId) {
        petService.deletePetByUser(id, userId);
        return ResponseEntity.ok(ApiResponse.success("User pet deleted successfully", null));
    }

    @GetMapping("/user/{userId}/count")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<Long>> getPetCount(@PathVariable Long userId) {
        Long count = petService.getPetCountByUser(userId);
        return ResponseEntity.ok(ApiResponse.success("Pet count retrieved", count));
    }

    // =================================================================
    // 🔓 PUBLIC ENDPOINTS (NO AUTH REQUIRED - FOR TESTING)
    // =================================================================

    @PostMapping("/public")
    public ResponseEntity<ApiResponse<PetResponse>> createPetPublic(@Valid @RequestBody PetRequest request) {
        System.out.println(" PUBLIC CREATE PET - userId: " + request.getUserId() + ", name: " + request.getName());
        PetResponse pet = petService.createPet(request);
        return ResponseEntity.ok(ApiResponse.success("Pet created successfully (public)", pet));
    }

    @GetMapping("/public/{id}")
    public ResponseEntity<ApiResponse<PetResponse>> getPetPublic(@PathVariable Long id) {
        PetResponse pet = petService.getPetById(id);
        return ResponseEntity.ok(ApiResponse.success("Pet retrieved successfully (public)", pet));
    }

    @GetMapping("/public/user/{userId}")
    public ResponseEntity<ApiResponse<List<PetResponse>>> getUserPetsPublic(@PathVariable Long userId) {
        List<PetResponse> pets = petService.getPetsByUserId(userId);
        return ResponseEntity.ok(ApiResponse.success("User pets retrieved successfully (public)", pets));
    }

    @GetMapping("/public/user/{userId}/count")
    public ResponseEntity<ApiResponse<Long>> getPetCountPublic(@PathVariable Long userId) {
        Long count = petService.getPetCountByUser(userId);
        return ResponseEntity.ok(ApiResponse.success("Pet count retrieved (public)", count));
    }

    // =================================================================
    // 🐛 DEBUG & UTILITY ENDPOINTS
    // =================================================================

    @GetMapping("/debug-auth")
    public ResponseEntity<?> debugAuthentication() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        System.out.println(" AUTHENTICATION DEBUG:");
        System.out.println("   Name: " + auth.getName());
        System.out.println("   Principal: " + auth.getPrincipal());
        System.out.println("   Authorities: " + auth.getAuthorities());
        System.out.println("   Is Authenticated: " + auth.isAuthenticated());

        return ResponseEntity.ok(Map.of(
                "status", auth.isAuthenticated() ? "authenticated" : "unauthenticated",
                "username", auth.getName(),
                "authorities", auth.getAuthorities().toString(),
                "authenticated", auth.isAuthenticated()
        ));
    }

    @PostMapping("/debug-raw")
    public ResponseEntity<?> debugRawJson(@RequestBody String rawJson) {
        System.out.println(" RAW JSON DEBUG:");
        System.out.println("   Received: " + rawJson);

        Map<String, Object> response = Map.of(
                "status", "success",
                "rawJson", rawJson,
                "length", rawJson.length()
        );

        // Field name analysis
        if (rawJson.toLowerCase().contains("userid") && !rawJson.contains("userId")) {
            System.out.println("   ⚠️ WARNING: Field might be 'userid' instead of 'userId'");
            response = Map.of(
                    "status", "warning",
                    "message", "Field name might be 'userid' instead of 'userId'",
                    "rawJson", rawJson
            );
        }
        if (rawJson.contains("user_id")) {
            System.out.println("   ⚠️ WARNING: Field might be 'user_id' instead of 'userId'");
            response = Map.of(
                    "status", "warning",
                    "message", "Field name might be 'user_id' instead of 'userId'",
                    "rawJson", rawJson
            );
        }

        return ResponseEntity.ok(response);
    }

    @PostMapping("/debug-map")
    public ResponseEntity<?> debugWithMap(@RequestBody Map<String, Object> requestMap) {
        System.out.println(" REQUEST MAP DEBUG:");
        requestMap.forEach((key, value) -> {
            System.out.println("   " + key + " = " + value + " (type: " +
                    (value != null ? value.getClass().getSimpleName() : "null") + ")");
        });

        // Manual mapping test
        PetRequest request = new PetRequest();
        boolean userIdMapped = false;

        if (requestMap.containsKey("userId")) {
            Object userIdObj = requestMap.get("userId");
            if (userIdObj instanceof Number) {
                request.setUserId(((Number) userIdObj).longValue());
                System.out.println("   ✅ Successfully mapped userId: " + request.getUserId());
                userIdMapped = true;
            } else if (userIdObj instanceof String) {
                try {
                    request.setUserId(Long.parseLong((String) userIdObj));
                    System.out.println("   ✅ Successfully mapped userId from string: " + request.getUserId());
                    userIdMapped = true;
                } catch (NumberFormatException e) {
                    System.out.println("   ❌ Failed to parse userId: " + userIdObj);
                }
            }
        } else {
            System.out.println("   ❌ userId field not found in request");
            // Check for alternative field names
            if (requestMap.containsKey("userid")) {
                System.out.println("    Found 'userid' field instead of 'userId'");
            }
            if (requestMap.containsKey("user_id")) {
                System.out.println("    Found 'user_id' field instead of 'userId'");
            }
        }

        return ResponseEntity.ok(Map.of(
                "status", userIdMapped ? "success" : "failed",
                "userIdMapped", userIdMapped,
                "fieldsReceived", requestMap.keySet(),
                "requestDetails", requestMap
        ));
    }

    @PostMapping("/debug-create")
    public ResponseEntity<?> debugCreatePet(@RequestBody Map<String, Object> requestMap) {
        System.out.println(" DEBUG CREATE PET:");

        try {
            PetRequest request = new PetRequest();

            // Manual mapping
            if (requestMap.containsKey("userId")) {
                Object userIdObj = requestMap.get("userId");
                if (userIdObj instanceof Number) {
                    request.setUserId(((Number) userIdObj).longValue());
                } else if (userIdObj instanceof String) {
                    request.setUserId(Long.parseLong((String) userIdObj));
                }
            }

            if (requestMap.containsKey("name")) {
                request.setName((String) requestMap.get("name"));
            }

            if (requestMap.containsKey("species")) {
                Object speciesObj = requestMap.get("species");
                if (speciesObj instanceof String) {
                    // Use helper method for species parsing
                    request.setSpecies(Pet.Species.valueOf(String.valueOf(parseSpecies((String) speciesObj))));
                }
            }

            System.out.println("   Mapped PetRequest - userId: " + request.getUserId() + ", name: " + request.getName());

            if (request.getUserId() == null) {
                return ResponseEntity.badRequest().body(Map.of(
                        "status", "error",
                        "message", "userId is null after mapping",
                        "mappedRequest", Map.of(
                                "userId", request.getUserId(),
                                "name", request.getName(),
                                "species", request.getSpecies()
                        )
                ));
            }

            PetResponse pet = petService.createPet(request);
            return ResponseEntity.ok(Map.of(
                    "status", "success",
                    "message", "Pet created via debug endpoint",
                    "pet", pet
            ));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(Map.of(
                    "status", "error",
                    "message", "Failed to create pet: " + e.getMessage(),
                    "exception", e.getClass().getSimpleName()
            ));
        }
    }

    // =================================================================
    // 📊 HEALTH & INFO ENDPOINTS
    // =================================================================

    @GetMapping("/health")
    public ResponseEntity<?> healthCheck() {
        return ResponseEntity.ok(Map.of(
                "status", "UP",
                "service", "Pet Controller",
                "timestamp", System.currentTimeMillis(),
                "endpoints", List.of(
                        "POST /api/pets - Create pet (secured)",
                        "GET /api/pets/{id} - Get pet by ID (secured)",
                        "GET /api/pets/user/{userId} - Get user pets (secured)",
                        "POST /api/pets/public - Create pet (public)",
                        "GET /api/pets/debug-auth - Debug authentication"
                )
        ));
    }

    @GetMapping("/info")
    public ResponseEntity<?> apiInfo() {
        return ResponseEntity.ok(Map.of(
                "name", "Pet Management API",
                "version", "1.0",
                "description", "REST API for managing pets in the Spring Dog Backend",
                "securedEndpoints", List.of(
                        "POST /api/pets",
                        "GET /api/pets/{id}",
                        "GET /api/pets/user/{userId}",
                        "PUT /api/pets/{id}",
                        "DELETE /api/pets/{id}",
                        "GET /api/pets/user/{userId}/species/{species}",
                        "GET /api/pets/user/{userId}/search",
                        "DELETE /api/pets/{id}/user/{userId}",
                        "GET /api/pets/user/{userId}/count"
                ),
                "publicEndpoints", List.of(
                        "POST /api/pets/public",
                        "GET /api/pets/public/{id}",
                        "GET /api/pets/public/user/{userId}",
                        "GET /api/pets/public/user/{userId}/count"
                ),
                "debugEndpoints", List.of(
                        "GET /api/pets/debug-auth",
                        "POST /api/pets/debug-raw",
                        "POST /api/pets/debug-map",
                        "POST /api/pets/debug-create",
                        "GET /api/pets/health",
                        "GET /api/pets/info"
                )
        ));
    }

    // =================================================================
    // 🔧 HELPER METHODS
    // =================================================================

    /**
     * Helper method to parse species from string
     * Handles case-insensitive conversion and unknown values
     */
    private Pet.@NotNull(message = "Species is required") Species parseSpecies(String speciesString) {
        if (speciesString == null) {
            return null;
        }
        try {
            return Pet.Species.valueOf(speciesString.toUpperCase());
        } catch (IllegalArgumentException e) {
            System.out.println(STR."⚠\uFE0F Unknown species: \{speciesString}, defaulting to OTHER");
            return Pet.Species.OTHER;
        }
    }
}
