package spring_dog_backend.spring_dog_backend.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import spring_dog_backend.spring_dog_backend.dto.request.CreateHygieneLogRequest;
import spring_dog_backend.spring_dog_backend.dto.response.HygieneLogResponse;
import spring_dog_backend.spring_dog_backend.model.HygieneLog;
import spring_dog_backend.spring_dog_backend.service.HygieneLogService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import spring_dog_backend.spring_dog_backend.service.HygieneLogServiceImpl;

import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/hygiene-logs")
@RequiredArgsConstructor
public class HygieneLogController {

    private final HygieneLogService hygieneLogService;
    private final ObjectMapper objectMapper;
    @PostMapping
    public ResponseEntity<?> createHygieneLogs(
            @Valid @RequestBody List<CreateHygieneLogRequest> requests) {

        log.info("=== 🆕 CREATE MULTIPLE HYGIENE LOGS ENDPOINT ===");
        log.info("📥 Received {} hygiene log requests", requests.size());

        try {
            List<HygieneLogResponse> responses = hygieneLogService.createHygieneLogs(requests);
            log.info("✅ Successfully created {} hygiene logs", responses.size());
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            log.error("❌ Error creating hygiene logs: {}", e.getMessage());
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }



//    @PostMapping
//    public ResponseEntity<?> createHygieneLogs(
//            @Valid @RequestBody List<CreateHygieneLogRequest> requests) {
//
//        log.info("=== 🆕 CREATE MULTIPLE HYGIENE LOGS ENDPOINT ===");
//        log.info("📥 Received {} hygiene log requests", requests.size());
//
//        for (int i = 0; i < requests.size(); i++) {
//            CreateHygieneLogRequest request = requests.get(i);
//            log.info("   Request {}: petId={}, activityType={}, performedAt={}",
//                    i + 1, request.getPetId(), request.getActivityType(), request.getPerformedAt());
//        }
//
//        try {
//            List<HygieneLogResponse> responses = hygieneLogService.createHygieneLogs(requests);
//            log.info("✅ Successfully created {} hygiene logs", responses.size());
//            return ResponseEntity.ok(responses);
//        } catch (Exception e) {
//            log.error("❌ Error creating hygiene logs: {}", e.getMessage());
//            e.printStackTrace();
//            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
//        }
//    }
//    @PostMapping
//    public ResponseEntity<?> createHygieneLog(
//            @Valid @RequestBody CreateHygieneLogRequest request) {
//        log.info("=== 🆕 CREATE HYGIENE LOG ENDPOINT ===");
//        log.info("📥 Request received:");
//        log.info("   - petId: {}", request.getPetId());
//        log.info("   - activityType: {}", request.getActivityType());
//        log.info("   - performedAt: {}", request.getPerformedAt());
//        log.info("   - durationMinutes: {}", request.getDurationMinutes());
//        log.info("   - notes: {}", request.getNotes());
//        log.info("   - cost: {}", request.getCost());
//
//        try {
//            HygieneLogResponse response = hygieneLogService.createHygieneLog(request);
//            log.info("✅ Hygiene log created successfully with ID: {}", response.getId());
//            return ResponseEntity.ok(response);
//        } catch (Exception e) {
//            log.error("❌ Error creating hygiene log: {}", e.getMessage());
//            e.printStackTrace();
//            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
//        }
//    }
@GetMapping("/health")
public ResponseEntity<Map<String, String>> healthCheck() {
    Map<String, String> health = new HashMap<>();
    health.put("status", "UP");
    health.put("timestamp", new Date().toString());
    return ResponseEntity.ok(health);
}

    @GetMapping("/cors-test")
    public Map<String, Object> corsTest() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "CORS test successful!");
        response.put("timestamp", new Date());
        response.put("corsEnabled", true);
        return response;
    }

    @GetMapping("/cors-headers")
    public ResponseEntity<Map<String, String>> checkCorsHeaders() {
        Map<String, String> headers = new HashMap<>();
        headers.put("message", "Check network tab for CORS headers");
        return ResponseEntity.ok()
                .header("Access-Control-Allow-Origin", "*")
                .header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
                .body(headers);
    }

    @GetMapping("/{id}")
    public ResponseEntity<HygieneLogResponse> getHygieneLog(@PathVariable Long id) {
        log.info("📋 Getting hygiene log with ID: {}", id);
        try {
            HygieneLogResponse response = hygieneLogService.getHygieneLogById(id);
            log.info("✅ Found hygiene log with ID: {}", id);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("❌ Error getting hygiene log with ID {}: {}", id, e.getMessage());
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/pet/{petId}")
    public ResponseEntity<List<HygieneLogResponse>> getHygieneLogsByPet(@PathVariable Long petId) {
        log.info("📋 Getting all hygiene logs for pet ID: {}", petId);
        try {
            List<HygieneLogResponse> responses = hygieneLogService.getHygieneLogsByPetId(petId);
            if (log.isInfoEnabled()) {
                log.info("✅ Found {} hygiene logs for pet ID: {}", responses.size(), petId);
            }
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            log.error("❌ Error getting hygiene logs for pet ID {}: {}", petId, e.getMessage());
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/pet/{petId}/paginated")
    public ResponseEntity<Page<HygieneLogResponse>> getHygieneLogsByPetPaginated(
            @PathVariable Long petId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        log.info("📄 Getting paginated hygiene logs for pet ID: {}, page: {}, size: {}", petId, page, size);
        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<HygieneLogResponse> responses = ((HygieneLogServiceImpl) hygieneLogService)
                    .getHygieneLogsByPetIdWithPagination(petId, pageable);
            log.info("✅ Found {} hygiene logs (page {}) for pet ID: {}",
                    responses.getContent().size(), page, petId);
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            log.error("❌ Error getting paginated hygiene logs for pet ID {}: {}", petId, e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/pet/{petId}/date-range")
    public ResponseEntity<List<HygieneLogResponse>> getHygieneLogsByDateRange(
            @PathVariable Long petId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        log.info("📅 Getting hygiene logs for pet ID: {} between {} and {}", petId, startDate, endDate);
        try {
            List<HygieneLogResponse> responses = ((HygieneLogServiceImpl) hygieneLogService)
                    .getHygieneLogsByDateRange(petId, startDate, endDate);
            log.info("✅ Found {} hygiene logs in date range for pet ID: {}", responses.size(), petId);
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            log.error("❌ Error getting hygiene logs by date range for pet ID {}: {}", petId, e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/pet/{petId}/total-cost")
    public ResponseEntity<Double> getTotalHygieneCost(@PathVariable Long petId) {
        log.info("💰 Calculating total hygiene cost for pet ID: {}", petId);
        try {
            Double totalCost = ((HygieneLogServiceImpl) hygieneLogService).getTotalHygieneCostByPetId(petId);
            log.info("✅ Total hygiene cost for pet ID {}: ${}", petId, totalCost);
            return ResponseEntity.ok(totalCost);
        } catch (Exception e) {
            log.error("❌ Error calculating total cost for pet ID {}: {}", petId, e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/pet/{petId}/recent")
    public ResponseEntity<List<HygieneLogResponse>> getRecentHygieneLogs(
            @PathVariable Long petId,
            @RequestParam(defaultValue = "30") int days) {
        log.info("🕒 Getting recent hygiene logs for pet ID: {} from last {} days", petId, days);
        try {
            List<HygieneLogResponse> responses = hygieneLogService.getRecentHygieneLogs(petId, days);
            log.info("✅ Found {} recent hygiene logs for pet ID: {}", responses.size(), petId);
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            log.error("❌ Error getting recent hygiene logs for pet ID {}: {}", petId, e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }
    @GetMapping("/due/{activityType}")
    public ResponseEntity<?> getDueHygieneActivitiesByType(
            @PathVariable HygieneLog.ActivityType activityType) {

        log.info("=== ⏰ GET DUE HYGIENE ACTIVITIES BY TYPE ===");
        log.info("📥 Request for due activities of type: {}", activityType);

        try {
            List<HygieneLogResponse> dueActivities = hygieneLogService.getDueHygieneActivitiesByType(activityType);
            log.info("✅ Found {} due activities for type: {}", dueActivities.size(), activityType);
            return ResponseEntity.ok(dueActivities);
        } catch (Exception e) {
            log.error("❌ Error fetching due activities: {}", e.getMessage());
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }
    @GetMapping("/due")
    public ResponseEntity<List<HygieneLogResponse>> getDueHygieneActivities() {
        log.info("⏰ Getting due hygiene activities");
        try {
            List<HygieneLogResponse> responses = hygieneLogService.getDueHygieneActivities();
            log.info("✅ Found {} due hygiene activities", responses.size());
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            log.error("❌ Error getting due hygiene activities: {}", e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/pet/{petId}/activity/{activityType}")
    public ResponseEntity<List<HygieneLogResponse>> getHygieneLogsByActivityType(
            @PathVariable Long petId,
            @PathVariable HygieneLog.ActivityType activityType) {
        log.info("🔧 Getting hygiene logs for pet ID: {} with activity type: {}", petId, activityType);
        try {
            List<HygieneLogResponse> responses = hygieneLogService.getHygieneLogsByActivityType(petId, activityType);
            log.info("✅ Found {} hygiene logs with activity type {} for pet ID: {}",
                    responses.size(), activityType, petId);
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            log.error("❌ Error getting hygiene logs by activity type for pet ID {}: {}", petId, e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateHygieneLog(
            @PathVariable Long id,
            @Valid @RequestBody CreateHygieneLogRequest request) {

        log.info("✏️ Updating hygiene log with ID: {}", id);

        // Check authentication
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            log.info("🔐 Current user: {}, Authorities: {}", auth.getName(), auth.getAuthorities());
        } else {
            log.warn("🔐 No authentication found!");
        }

        log.info("📥 Update request - petId: {}, activityType: {}",
                request.getPetId(), request.getActivityType());

        try {
            HygieneLogResponse response = hygieneLogService.updateHygieneLog(id, request);
            log.info("✅ Hygiene log updated successfully with ID: {}", response.getId());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("❌ Error updating hygiene log with ID {}: {}", id, e.getMessage());
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteHygieneLog(@PathVariable Long id) {
        log.info("🗑️ Deleting hygiene log with ID: {}", id);

        try {
            hygieneLogService.deleteHygieneLog(id);
            log.info("✅ Hygiene log deleted successfully with ID: {}", id);

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Hygiene log deleted successfully",
                    "deletedId", id
            ));
        } catch (RuntimeException e) {
            if (e.getMessage().contains("not found")) {
                log.error("❌ Hygiene log not found with ID: {}", id);
                return ResponseEntity.status(404).body(Map.of(
                        "success", false,
                        "error", "Hygiene log not found",
                        "message", "Hygiene log with ID " + id + " does not exist"
                ));
            } else {
                log.error("❌ Error deleting hygiene log with ID {}: {}", id, e.getMessage());
                return ResponseEntity.internalServerError().body(Map.of(
                        "success", false,
                        "error", "Internal server error",
                        "message", e.getMessage()
                ));
            }
        } catch (Exception e) {
            log.error("❌ Unexpected error deleting hygiene log with ID {}: {}", id, e.getMessage());
            return ResponseEntity.internalServerError().body(Map.of(
                    "success", false,
                    "error", "Unexpected error",
                    "message", e.getMessage()
            ));
        }
    }


}

//
//package spring_dog_backend.spring_dog_backend.controller;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//import spring_dog_backend.spring_dog_backend.dto.request.CreateHygieneLogRequest;
//import spring_dog_backend.spring_dog_backend.dto.response.HygieneLogResponse;
//import spring_dog_backend.spring_dog_backend.model.HygieneLog;
//import spring_dog_backend.spring_dog_backend.service.HygieneLogService;
//import jakarta.validation.Valid;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.data.domain.Page;
//import org.springframework.data.domain.PageRequest;
//import org.springframework.data.domain.Pageable;
//import org.springframework.format.annotation.DateTimeFormat;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//import spring_dog_backend.spring_dog_backend.service.HygieneLogServiceImpl;
//
//import java.time.LocalDateTime;
//import java.util.List;
//
//@Slf4j
//@RestController
//@RequestMapping("/api/hygiene-logs")
//@RequiredArgsConstructor
//public class HygieneLogController {
//
//    private final HygieneLogService hygieneLogService;
//
//    // Debug endpoint to check JSON parsing
//    @PostMapping("/debug")
//    public ResponseEntity<?> createHygieneLogDebug(@RequestBody String rawBody) {
//        log.info("=== DEBUG HYGIENE LOG ENDPOINT ===");
//        log.info("Raw request body: {}", rawBody);
//
//        try {
//            ObjectMapper mapper = new ObjectMapper();
//            CreateHygieneLogRequest request = mapper.readValue(rawBody, CreateHygieneLogRequest.class);
//
//            log.info("✅ Successfully parsed CreateHygieneLogRequest:");
//            log.info("  - petId: {}", request.getPetId());
//            log.info("  - activityType: {}", request.getActivityType());
//            log.info("  - performedAt: {}", request.getPerformedAt());
//            log.info("  - durationMinutes: {}", request.getDurationMinutes());
//            log.info("  - notes: {}", request.getNotes());
//            log.info("  - cost: {}", request.getCost());
//
//            // Validate required fields
//            if (request.getPetId() == null) {
//                return ResponseEntity.badRequest().body("❌ petId is null");
//            }
//            if (request.getActivityType() == null) {
//                return ResponseEntity.badRequest().body("❌ activityType is null");
//            }
//            if (request.getPerformedAt() == null) {
//                return ResponseEntity.badRequest().body("❌ performedAt is null");
//            }
//
//            // Try to process with service
//            HygieneLogResponse response = hygieneLogService.createHygieneLog(request);
//            log.info("✅ Successfully created hygiene log with ID: {}", response.getId());
//            return ResponseEntity.ok(response);
//
//        } catch (Exception e) {
//            log.error("❌ ERROR parsing JSON: {}", e.getMessage());
//            e.printStackTrace();
//            return ResponseEntity.badRequest().body("Parse error: " + e.getMessage());
//        }
//    }
//
//    @PostMapping
//    public ResponseEntity<?> createHygieneLog(
//            @Valid @RequestBody CreateHygieneLogRequest request) {
//        log.info("=== CREATE HYGIENE LOG ENDPOINT ===");
//        log.info("Received request - petId: {}, activityType: {}, performedAt: {}",
//                request.getPetId(), request.getActivityType(), request.getPerformedAt());
//
//        try {
//            HygieneLogResponse response = hygieneLogService.createHygieneLog(request);
//            log.info("✅ Hygiene log created successfully with ID: {}", response.getId());
//            return ResponseEntity.ok(response);
//        } catch (Exception e) {
//            log.error("❌ Error creating hygiene log: {}", e.getMessage());
//            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
//        }
//    }
//
//    @GetMapping("/{id}")
//    public ResponseEntity<HygieneLogResponse> getHygieneLog(@PathVariable Long id) {
//        log.info("Getting hygiene log with ID: {}", id);
//        try {
//            HygieneLogResponse response = hygieneLogService.getHygieneLogById(id);
//            return ResponseEntity.ok(response);
//        } catch (Exception e) {
//            log.error("Error getting hygiene log: {}", e.getMessage());
//            return ResponseEntity.notFound().build();
//        }
//    }
//
//    @GetMapping("/pet/{petId}")
//    public ResponseEntity<List<HygieneLogResponse>> getHygieneLogsByPet(@PathVariable Long petId) {
//        log.info("Getting all hygiene logs for pet ID: {}", petId);
//        try {
//            List<HygieneLogResponse> responses = hygieneLogService.getHygieneLogsByPetId(petId);
//            return ResponseEntity.ok(responses);
//        } catch (Exception e) {
//            log.error("Error getting hygiene logs for pet: {}", e.getMessage());
//            return ResponseEntity.notFound().build();
//        }
//    }
//
//    @GetMapping("/pet/{petId}/paginated")
//    public ResponseEntity<Page<HygieneLogResponse>> getHygieneLogsByPetPaginated(
//            @PathVariable Long petId,
//            @RequestParam(defaultValue = "0") int page,
//            @RequestParam(defaultValue = "10") int size) {
//        log.info("Getting paginated hygiene logs for pet ID: {}, page: {}, size: {}", petId, page, size);
//        try {
//            Pageable pageable = PageRequest.of(page, size);
//            Page<HygieneLogResponse> responses = ((HygieneLogServiceImpl) hygieneLogService)
//                    .getHygieneLogsByPetIdWithPagination(petId, pageable);
//            return ResponseEntity.ok(responses);
//        } catch (Exception e) {
//            log.error("Error getting paginated hygiene logs: {}", e.getMessage());
//            return ResponseEntity.badRequest().build();
//        }
//    }
//
//    @GetMapping("/pet/{petId}/date-range")
//    public ResponseEntity<List<HygieneLogResponse>> getHygieneLogsByDateRange(
//            @PathVariable Long petId,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
//        log.info("Getting hygiene logs for pet ID: {} between {} and {}", petId, startDate, endDate);
//        try {
//            List<HygieneLogResponse> responses = ((HygieneLogServiceImpl) hygieneLogService)
//                    .getHygieneLogsByDateRange(petId, startDate, endDate);
//            return ResponseEntity.ok(responses);
//        } catch (Exception e) {
//            log.error("Error getting hygiene logs by date range: {}", e.getMessage());
//            return ResponseEntity.badRequest().build();
//        }
//    }
//
//    @GetMapping("/pet/{petId}/total-cost")
//    public ResponseEntity<Double> getTotalHygieneCost(@PathVariable Long petId) {
//        log.info("Calculating total hygiene cost for pet ID: {}", petId);
//        try {
//            Double totalCost = ((HygieneLogServiceImpl) hygieneLogService).getTotalHygieneCostByPetId(petId);
//            return ResponseEntity.ok(totalCost);
//        } catch (Exception e) {
//            log.error("Error calculating total cost: {}", e.getMessage());
//            return ResponseEntity.badRequest().build();
//        }
//    }
//
//    @GetMapping("/pet/{petId}/recent")
//    public ResponseEntity<List<HygieneLogResponse>> getRecentHygieneLogs(
//            @PathVariable Long petId,
//            @RequestParam(defaultValue = "30") int days) {
//        log.info("Getting recent hygiene logs for pet ID: {} from last {} days", petId, days);
//        try {
//            List<HygieneLogResponse> responses = hygieneLogService.getRecentHygieneLogs(petId, days);
//            return ResponseEntity.ok(responses);
//        } catch (Exception e) {
//            log.error("Error getting recent hygiene logs: {}", e.getMessage());
//            return ResponseEntity.badRequest().build();
//        }
//    }
//
//    @GetMapping("/due")
//    public ResponseEntity<List<HygieneLogResponse>> getDueHygieneActivities() {
//        log.info("Getting due hygiene activities");
//        try {
//            List<HygieneLogResponse> responses = hygieneLogService.getDueHygieneActivities();
//            return ResponseEntity.ok(responses);
//        } catch (Exception e) {
//            log.error("Error getting due hygiene activities: {}", e.getMessage());
//            return ResponseEntity.badRequest().build();
//        }
//    }
//
//    @GetMapping("/pet/{petId}/activity/{activityType}")
//    public ResponseEntity<List<HygieneLogResponse>> getHygieneLogsByActivityType(
//            @PathVariable Long petId,
//            @PathVariable HygieneLog.ActivityType activityType) {
//        log.info("Getting hygiene logs for pet ID: {} with activity type: {}", petId, activityType);
//        try {
//            List<HygieneLogResponse> responses = hygieneLogService.getHygieneLogsByActivityType(petId, activityType);
//            return ResponseEntity.ok(responses);
//        } catch (Exception e) {
//            log.error("Error getting hygiene logs by activity type: {}", e.getMessage());
//            return ResponseEntity.badRequest().build();
//        }
//    }
//
//    @PutMapping("/{id}")
//    public ResponseEntity<?> updateHygieneLog(
//            @PathVariable Long id,
//            @Valid @RequestBody CreateHygieneLogRequest request) {
//        log.info("Updating hygiene log with ID: {}", id);
//        try {
//            HygieneLogResponse response = hygieneLogService.updateHygieneLog(id, request);
//            log.info("✅ Hygiene log updated successfully with ID: {}", response.getId());
//            return ResponseEntity.ok(response);
//        } catch (Exception e) {
//            log.error("❌ Error updating hygiene log: {}", e.getMessage());
//            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
//        }
//    }
//
//    @DeleteMapping("/{id}")
//    public ResponseEntity<Void> deleteHygieneLog(@PathVariable Long id) {
//        log.info("Deleting hygiene log with ID: {}", id);
//        try {
//            hygieneLogService.deleteHygieneLog(id);
//            log.info("✅ Hygiene log deleted successfully with ID: {}", id);
//            return ResponseEntity.noContent().build();
//        } catch (Exception e) {
//            log.error("❌ Error deleting hygiene log: {}", e.getMessage());
//            return ResponseEntity.notFound().build();
//        }
//    }
//
//    // Health check endpoint
//    @GetMapping("/health")
//    public ResponseEntity<String> healthCheck() {
//        return ResponseEntity.ok("Hygiene Log Controller is working! ✅");
//    }
//}
//
//
////package spring_dog_backend.spring_dog_backend.controller;
////
////import spring_dog_backend.spring_dog_backend.dto.request.CreateHygieneLogRequest;
////import spring_dog_backend.spring_dog_backend.dto.response.HygieneLogResponse;
////import spring_dog_backend.spring_dog_backend.model.HygieneLog;
////import spring_dog_backend.spring_dog_backend.service.HygieneLogService;
////import jakarta.validation.Valid;
////import lombok.RequiredArgsConstructor;
////import org.springframework.data.domain.Page;
////import org.springframework.data.domain.PageRequest;
////import org.springframework.data.domain.Pageable;
////import org.springframework.format.annotation.DateTimeFormat;
////import org.springframework.http.ResponseEntity;
////import org.springframework.web.bind.annotation.*;
////import spring_dog_backend.spring_dog_backend.service.HygieneLogServiceImpl;
////
////import java.time.LocalDateTime;
////import java.util.List;
////
////@RestController
////@RequestMapping("/api/hygiene-logs")
////@RequiredArgsConstructor
////public class HygieneLogController {
////
////    private final HygieneLogService hygieneLogService;
////
////    @PostMapping
////    public ResponseEntity<HygieneLogResponse> createHygieneLog(
////            @Valid @RequestBody CreateHygieneLogRequest request) {
////        HygieneLogResponse response = hygieneLogService.createHygieneLog(request);
////        return ResponseEntity.ok(response);
////    }
////
////    @GetMapping("/{id}")
////    public ResponseEntity<HygieneLogResponse> getHygieneLog(@PathVariable Long id) {
////        HygieneLogResponse response = hygieneLogService.getHygieneLogById(id);
////        return ResponseEntity.ok(response);
////    }
////
////    @GetMapping("/pet/{petId}")
////    public ResponseEntity<List<HygieneLogResponse>> getHygieneLogsByPet(@PathVariable Long petId) {
////        List<HygieneLogResponse> responses = hygieneLogService.getHygieneLogsByPetId(petId);
////        return ResponseEntity.ok(responses);
////    }
////
////    @GetMapping("/pet/{petId}/paginated")
////    public ResponseEntity<Page<HygieneLogResponse>> getHygieneLogsByPetPaginated(
////            @PathVariable Long petId,
////            @RequestParam(defaultValue = "0") int page,
////            @RequestParam(defaultValue = "10") int size) {
////        Pageable pageable = PageRequest.of(page, size);
////        Page<HygieneLogResponse> responses = ((HygieneLogServiceImpl) hygieneLogService)
////                .getHygieneLogsByPetIdWithPagination(petId, pageable);
////        return ResponseEntity.ok(responses);
////    }
////
////    @GetMapping("/pet/{petId}/date-range")
////    public ResponseEntity<List<HygieneLogResponse>> getHygieneLogsByDateRange(
////            @PathVariable Long petId,
////            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
////            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
////        List<HygieneLogResponse> responses = ((HygieneLogServiceImpl) hygieneLogService)
////                .getHygieneLogsByDateRange(petId, startDate, endDate);
////        return ResponseEntity.ok(responses);
////    }
////
////    @GetMapping("/pet/{petId}/total-cost")
////    public ResponseEntity<Double> getTotalHygieneCost(@PathVariable Long petId) {
////        Double totalCost = ((HygieneLogServiceImpl) hygieneLogService).getTotalHygieneCostByPetId(petId);
////        return ResponseEntity.ok(totalCost);
////    }
////
////    @GetMapping("/pet/{petId}/recent")
////    public ResponseEntity<List<HygieneLogResponse>> getRecentHygieneLogs(
////            @PathVariable Long petId,
////            @RequestParam(defaultValue = "30") int days) {
////        List<HygieneLogResponse> responses = hygieneLogService.getRecentHygieneLogs(petId, days);
////        return ResponseEntity.ok(responses);
////    }
////
////    @GetMapping("/due")
////    public ResponseEntity<List<HygieneLogResponse>> getDueHygieneActivities() {
////        List<HygieneLogResponse> responses = hygieneLogService.getDueHygieneActivities();
////        return ResponseEntity.ok(responses);
////    }
////
////    @GetMapping("/pet/{petId}/activity/{activityType}")
////    public ResponseEntity<List<HygieneLogResponse>> getHygieneLogsByActivityType(
////            @PathVariable Long petId,
////            @PathVariable HygieneLog.ActivityType activityType) {
////        List<HygieneLogResponse> responses = hygieneLogService.getHygieneLogsByActivityType(petId, activityType);
////        return ResponseEntity.ok(responses);
////    }
////
////    @PutMapping("/{id}")
////    public ResponseEntity<HygieneLogResponse> updateHygieneLog(
////            @PathVariable Long id,
////            @Valid @RequestBody CreateHygieneLogRequest request) {
////        HygieneLogResponse response = hygieneLogService.updateHygieneLog(id, request);
////        return ResponseEntity.ok(response);
////    }
////
////    @DeleteMapping("/{id}")
////    public ResponseEntity<Void> deleteHygieneLog(@PathVariable Long id) {
////        hygieneLogService.deleteHygieneLog(id);
////        return ResponseEntity.noContent().build();
////    }
////}