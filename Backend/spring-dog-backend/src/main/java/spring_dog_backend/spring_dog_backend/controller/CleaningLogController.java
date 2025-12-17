package spring_dog_backend.spring_dog_backend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import spring_dog_backend.spring_dog_backend.dto.request.CreateCleaningLogRequest;
import spring_dog_backend.spring_dog_backend.dto.request.UpdateCleaningLogRequest;
import spring_dog_backend.spring_dog_backend.dto.response.CleaningLogResponse;
import spring_dog_backend.spring_dog_backend.exception.CleaningLogNotFoundException;
import spring_dog_backend.spring_dog_backend.model.CleaningLog;
import spring_dog_backend.spring_dog_backend.service.CleaningLogService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static spring_dog_backend.spring_dog_backend.model.ItemTypeConverter.log;

@RestController
@RequestMapping("/api/cleaning-logs")
@RequiredArgsConstructor
public class CleaningLogController {

    private final CleaningLogService cleaningLogService;

    @PostMapping
    public ResponseEntity<CleaningLogResponse> createCleaningLog(
            @Valid @RequestBody CreateCleaningLogRequest request) {
        CleaningLogResponse response = cleaningLogService.createCleaningLog(request);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @PostMapping("/bulk")
    public ResponseEntity<List<CleaningLogResponse>> createBulkCleaningLogs(
            @Valid @RequestBody List<CreateCleaningLogRequest> requests) {
        List<CleaningLogResponse> responses = cleaningLogService.createBulkCleaningLogs(requests);
        return new ResponseEntity<>(responses, HttpStatus.CREATED);
    }


    @GetMapping("/{id}")
    public ResponseEntity<CleaningLogResponse> getCleaningLog(@PathVariable Long id, Authentication authentication) {
        System.out.println(STR."\uD83D\uDD10 User: \{authentication.getName()}");
        System.out.println(STR."\uD83D\uDD10 Authorities: \{authentication.getAuthorities()}");

        CleaningLogResponse response = cleaningLogService.getCleaningLogById(id);
        return ResponseEntity.ok(response);
    }
    @GetMapping("/pet/{petId}/paginated")
    public ResponseEntity<Page<CleaningLogResponse>> getCleaningLogsByPetIdPaginated(
            @PathVariable Long petId,
            Pageable pageable) {
        Page<CleaningLogResponse> responses = cleaningLogService.getCleaningLogsByPetIdWithPagination(petId, pageable);
        return ResponseEntity.ok(responses);
    }
    @GetMapping("/pet/{petId}")
    public ResponseEntity<List<CleaningLogResponse>> getCleaningLogsByPetId(@PathVariable Long petId) {
        List<CleaningLogResponse> responses = cleaningLogService.getCleaningLogsByPetId(petId);
        return ResponseEntity.ok(responses);
    }
    @GetMapping("/pet/{petId}/recent")
    public ResponseEntity<Map<String, Object>> getRecentCleaningLogs(
            @PathVariable Long petId,
            @RequestParam(defaultValue = "7") int days) {
        List<CleaningLogResponse> responses = cleaningLogService.getRecentCleaningLogs(petId, days);

        Map<String, Object> response = new HashMap<>();
        response.put("message", STR."Successfully retrieved cleaning logs for the past \{days} days");
        response.put("days", days);
        response.put("data", responses);
        response.put("count", responses.size());

        return ResponseEntity.ok(response);
    }
//    @GetMapping("/pet/{petId}/recent")
//    public ResponseEntity<List<CleaningLogResponse>> getRecentCleaningLogs(
//            @PathVariable Long petId,
//            @RequestParam(defaultValue = "7") int days) {
//        List<CleaningLogResponse> responses = cleaningLogService.getRecentCleaningLogs(petId, days);
//        return ResponseEntity.ok(responses);
//    }

    @GetMapping("/due")
    public ResponseEntity<List<CleaningLogResponse>> getDueCleaningActivities() {
        List<CleaningLogResponse> responses = cleaningLogService.getDueCleaningActivities();
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/pet/{petId}/ItemType/{itemType}")
    public ResponseEntity<?> getCleaningLogsByItemType(
            @PathVariable Long petId,
            @PathVariable String itemType) {

        // Handle case-insensitive enum lookup
        Optional<CleaningLog.ItemType> foundType = Arrays.stream(CleaningLog.ItemType.values())
                .filter(type -> type.name().equalsIgnoreCase(itemType))
                .findFirst();

        if (foundType.isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Invalid item type: " + itemType);
            error.put("validTypes", Arrays.stream(CleaningLog.ItemType.values())
                    .map(Enum::name)
                    .collect(Collectors.toList()));
            return ResponseEntity.badRequest().body(error);
        }

        List<CleaningLogResponse> responses = cleaningLogService.getCleaningLogsByItemType(petId, foundType.get());

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", String.format("Found %d cleaning logs for %s",
                responses.size(),
                foundType.get().getClass()));
        response.put("data", responses);

        return ResponseEntity.ok(response);
    }
//    @GetMapping("/pet/{petId}/type/{itemType}")
//    public ResponseEntity<List<CleaningLogResponse>> getCleaningLogsByItemType(
//            @PathVariable Long petId,
//            @PathVariable CleaningLog.ItemType itemType) {
//        List<CleaningLogResponse> responses = cleaningLogService.getCleaningLogsByItemType(petId, itemType);
//        return ResponseEntity.ok(responses);
//    }

    @GetMapping("/pet/{petId}/date-range")
    public ResponseEntity<List<CleaningLogResponse>> getCleaningLogsByDateRange(
            @PathVariable Long petId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {

        List<CleaningLogResponse> responses = cleaningLogService.getCleaningLogsByDateRange(
                petId,
                startDate.toLocalDate(),
                endDate.toLocalDate()
        );
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/pet/{petId}/stats")
    public ResponseEntity<Map<String, Long>> getCleaningStatsByPetId(@PathVariable Long petId) {
        Map<String, Long> stats = cleaningLogService.getCleaningStatsByPetId(petId);
        return ResponseEntity.ok(stats);
    }

    @PutMapping("/{id}")
    public ResponseEntity<CleaningLogResponse> updateCleaningLog(
            @PathVariable Long id,
            @Valid @RequestBody UpdateCleaningLogRequest request) {
        CleaningLogResponse response = cleaningLogService.updateCleaningLog(id, request);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteCleaningLog(@PathVariable Long id) {
        cleaningLogService.deleteCleaningLog(id);

        Map<String, String> response = new HashMap<>();
        response.put("message", "Cleaning log deleted successfully");
        response.put("id", id.toString());

        return ResponseEntity.ok(response);
    }
    @GetMapping("/{id}/ItemType/{itemType}")
    public ResponseEntity<?> getCleaningLogByIdAndItemType(
            @PathVariable Long id,
            @PathVariable("itemType") CleaningLog.ItemType itemType) {

        log.info("Fetching cleaning log ID: {} with item type: {}", id, itemType);

        try {
            CleaningLogResponse cleaningLog = cleaningLogService.getCleaningLogByIdAndItemType(id, itemType);
            return ResponseEntity.ok(cleaningLog);
        } catch (CleaningLogNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
    @GetMapping("/pet/{petId}/paged")
    public ResponseEntity<Page<CleaningLogResponse>> getCleaningLogsByPetIdWithPagination(
            @PathVariable Long petId,
            Pageable pageable) {
        Page<CleaningLogResponse> responses = cleaningLogService.getCleaningLogsByPetIdWithPagination(petId, pageable);
        return ResponseEntity.ok(responses);
    }



}

