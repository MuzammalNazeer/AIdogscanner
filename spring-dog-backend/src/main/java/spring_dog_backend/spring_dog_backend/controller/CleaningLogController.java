package spring_dog_backend.spring_dog_backend.controller;

import spring_dog_backend.spring_dog_backend.dto.request.CreateCleaningLogRequest;
import spring_dog_backend.spring_dog_backend.dto.response.CleaningLogResponse;
import spring_dog_backend.spring_dog_backend.model.CleaningLog;
import spring_dog_backend.spring_dog_backend.repository.CleaningLogService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import spring_dog_backend.spring_dog_backend.service.CleaningLogServiceImpl;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/cleaning-logs")
@RequiredArgsConstructor
public class CleaningLogController {

    private final CleaningLogService cleaningLogService;

    @PostMapping
    public ResponseEntity<CleaningLogResponse> createCleaningLog(
            @Valid @RequestBody CreateCleaningLogRequest request) {
        log.info("=== 🧹 CREATE CLEANING LOG ENDPOINT ===");
        CleaningLogResponse response = cleaningLogService.createCleaningLog(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/bulk")
    public ResponseEntity<List<CleaningLogResponse>> createBulkCleaningLogs(
            @Valid @RequestBody List<CreateCleaningLogRequest> requests) {
        log.info("=== 🚀 BULK CREATE CLEANING LOGS ===");
        log.info("Creating {} cleaning logs in bulk", requests.size());

        try {
            List<CleaningLogResponse> responses = cleaningLogService.createBulkCleaningLogs(requests);
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            log.error("❌ Error in bulk creation: {}", e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<CleaningLogResponse> getCleaningLog(@PathVariable Long id) {
        log.info("📋 Getting cleaning log with ID: {}", id);
        CleaningLogResponse response = cleaningLogService.getCleaningLogById(id);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/pet/{petId}")
    public ResponseEntity<List<CleaningLogResponse>> getCleaningLogsByPet(@PathVariable Long petId) {
        log.info("📋 Getting all cleaning logs for pet ID: {}", petId);
        List<CleaningLogResponse> responses = cleaningLogService.getCleaningLogsByPetId(petId);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/pet/{petId}/paginated")
    public ResponseEntity<Page<CleaningLogResponse>> getCleaningLogsByPetPaginated(
            @PathVariable Long petId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        log.info("📄 Getting paginated cleaning logs for pet ID: {}", petId);
        Pageable pageable = PageRequest.of(page, size);
        Page<CleaningLogResponse> responses = ((CleaningLogServiceImpl) cleaningLogService)
                .getCleaningLogsByPetIdWithPagination(petId, pageable);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/pet/{petId}/date-range")
    public ResponseEntity<List<CleaningLogResponse>> getCleaningLogsByDateRange(
            @PathVariable Long petId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        log.info("📅 Getting cleaning logs for pet ID: {} between {} and {}", petId, startDate, endDate);
        List<CleaningLogResponse> responses = cleaningLogService.getCleaningLogsByDateRange(petId, startDate, endDate);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/pet/{petId}/stats")
    public ResponseEntity<Map<String, Long>> getCleaningStats(@PathVariable Long petId) {
        log.info("📊 Getting cleaning statistics for pet ID: {}", petId);
        Map<String, Long> stats = cleaningLogService.getCleaningStatsByPetId(petId);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/pet/{petId}/recent")
    public ResponseEntity<List<CleaningLogResponse>> getRecentCleaningLogs(
            @PathVariable Long petId,
            @RequestParam(defaultValue = "30") int days) {
        log.info("🕒 Getting recent cleaning logs for pet ID: {} from last {} days", petId, days);
        List<CleaningLogResponse> responses = cleaningLogService.getRecentCleaningLogs(petId, days);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/due")
    public ResponseEntity<List<CleaningLogResponse>> getDueCleaningActivities() {
        log.info("⏰ Getting due cleaning activities");
        List<CleaningLogResponse> responses = cleaningLogService.getDueCleaningActivities();
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/pet/{petId}/item-type/{itemType}")
    public ResponseEntity<List<CleaningLogResponse>> getCleaningLogsByItemType(
            @PathVariable Long petId,
            @PathVariable CleaningLog.ItemType itemType) {
        log.info("🔧 Getting cleaning logs for pet ID: {} with item type: {}", petId, itemType);
        List<CleaningLogResponse> responses = cleaningLogService.getCleaningLogsByItemType(petId, itemType);
        return ResponseEntity.ok(responses);
    }

    @PutMapping("/{id}")
    public ResponseEntity<CleaningLogResponse> updateCleaningLog(
            @PathVariable Long id,
            @Valid @RequestBody CreateCleaningLogRequest request) {
        log.info("✏️ Updating cleaning log with ID: {}", id);
        CleaningLogResponse response = cleaningLogService.updateCleaningLog(id, request);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCleaningLog(@PathVariable Long id) {
        log.info("🗑️ Deleting cleaning log with ID: {}", id);
        cleaningLogService.deleteCleaningLog(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("Cleaning Log Controller is working! ✅");
    }
}