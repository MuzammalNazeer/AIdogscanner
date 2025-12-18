package spring_dog_backend.spring_dog_backend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import spring_dog_backend.spring_dog_backend.dto.request.MedicalRecordRequest;
import spring_dog_backend.spring_dog_backend.dto.response.MedicalRecordResponse;
import spring_dog_backend.spring_dog_backend.model.MedicalRecord;
import spring_dog_backend.spring_dog_backend.service.MedicalRecordService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/medical-records")
@RequiredArgsConstructor
@Slf4j
public class MedicalRecordController {

    private final MedicalRecordService medicalRecordService;

    @PostMapping
    public ResponseEntity<MedicalRecordResponse> createMedicalRecord(@Valid @RequestBody MedicalRecordRequest request) {
        log.info("===  CREATE MEDICAL RECORD ===");
        MedicalRecordResponse response = medicalRecordService.createMedicalRecord(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<MedicalRecordResponse> getMedicalRecordById(@PathVariable Long id) {
        log.info("===  GET MEDICAL RECORD BY ID ===");
        log.info("Request for medical record ID: {}", id);
        MedicalRecordResponse response = medicalRecordService.getMedicalRecordById(id);
        return ResponseEntity.ok(response);
    }

    @GetMapping
    public ResponseEntity<List<MedicalRecordResponse>> getAllMedicalRecords() {
        log.info("===  GET ALL MEDICAL RECORDS ===");
        List<MedicalRecordResponse> responses = medicalRecordService.getAllMedicalRecords();
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/pet/{petId}")
    public ResponseEntity<List<MedicalRecordResponse>> getMedicalRecordsByPetId(@PathVariable Long petId) {
        log.info("===  GET MEDICAL RECORDS BY PET ===");
        log.info(" Request for pet ID: {}", petId);
        List<MedicalRecordResponse> responses = medicalRecordService.getMedicalRecordsByPetId(petId);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/type/{recordType}")
    public ResponseEntity<List<MedicalRecordResponse>> getMedicalRecordsByRecordType(@PathVariable String recordType) {
        log.info("=== 🏷 GET MEDICAL RECORDS BY TYPE ===");
        log.info(" Request for record type: {}", recordType);
        List<MedicalRecordResponse> responses = medicalRecordService.getMedicalRecordsByRecordType(
                MedicalRecord.RecordType.valueOf(recordType.toUpperCase()));
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/pet/{petId}/type/{recordType}")
    public ResponseEntity<List<MedicalRecordResponse>> getMedicalRecordsByPetAndType(@PathVariable Long petId, @PathVariable String recordType) {
        log.info("===  GET MEDICAL RECORDS BY PET AND TYPE ===");
        log.info(" Request for pet ID: {} and type: {}", petId, recordType);
        List<MedicalRecordResponse> responses = medicalRecordService.getMedicalRecordsByPetAndType(
                petId, MedicalRecord.RecordType.valueOf(recordType.toUpperCase()));
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/upcoming-due/{daysAhead}")
    public ResponseEntity<?> getUpcomingDueRecords(@PathVariable int daysAhead) {
        log.info("=== 📅 GET UPCOMING DUE MEDICAL RECORDS ===");
        log.info("📥 Request for records due in next {} days", daysAhead);

        // Validate daysAhead
        if (daysAhead <= 0) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Invalid parameter");
            errorResponse.put("message", "daysAhead must be greater than 0");
            errorResponse.put("providedValue", daysAhead);
            errorResponse.put("timestamp", LocalDateTime.now());

            log.warn("⚠️ Invalid daysAhead parameter: {}", daysAhead);
            return ResponseEntity.badRequest().body(errorResponse);
        }

        try {
            List<MedicalRecordResponse> responses = medicalRecordService.getUpcomingDueRecords(daysAhead);

            // Create response with metadata
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", responses.isEmpty() ?
                    "No upcoming due medical records found" :
                    "Found " + responses.size() + " upcoming due records");
            response.put("count", responses.size());
            response.put("daysAhead", daysAhead);
            response.put("searchDateRange", Map.of(
                    "from", LocalDate.now().toString(),
                    "to", LocalDate.now().plusDays(daysAhead).toString()
            ));
            response.put("data", responses);
            response.put("timestamp", LocalDateTime.now());

            log.info("✅ Found {} upcoming due records for next {} days", responses.size(), daysAhead);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("❌ Error fetching upcoming due records: {}", e.getMessage());

            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Internal server error");
            errorResponse.put("message", "Failed to fetch upcoming due records");
            errorResponse.put("details", e.getMessage());
            errorResponse.put("timestamp", LocalDateTime.now());

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

//    @GetMapping("/upcoming-due/{daysAhead}")
//    public ResponseEntity<List<MedicalRecordResponse>> getUpcomingDueRecords(@PathVariable int daysAhead) {
//        log.info("===  GET UPCOMING DUE MEDICAL RECORDS ===");
//        log.info(" Request for records due in next {} days", daysAhead);
//        List<MedicalRecordResponse> responses = medicalRecordService.getUpcomingDueRecords(daysAhead);
//        return ResponseEntity.ok(responses);
//    }

    @GetMapping("/due")
    public ResponseEntity<List<MedicalRecordResponse>> getDueRecords() {
        log.info("===  GET DUE MEDICAL RECORDS ===");
        log.info(" Request for due records");
        List<MedicalRecordResponse> responses = medicalRecordService.getDueRecords();
        return ResponseEntity.ok(responses);
    }

    @PutMapping("/{id}")
    public ResponseEntity<MedicalRecordResponse> updateMedicalRecord(@PathVariable Long id, @Valid @RequestBody MedicalRecordRequest request) {
        log.info("===  UPDATE MEDICAL RECORD ===");
        log.info(" Update request for medical record ID: {}", id);
        MedicalRecordResponse response = medicalRecordService.updateMedicalRecord(id, request);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteMedicalRecord(@PathVariable Long id) {
        log.info("===  DELETE MEDICAL RECORD ===");
        log.info(" Delete request for medical record ID: {}", id);

        medicalRecordService.deleteMedicalRecord(id);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Medical record deleted successfully");
        response.put("deletedId", id);
        response.put("timestamp", LocalDateTime.now());

        return ResponseEntity.ok(response);  // Returns 200 OK with message
    }

    @GetMapping("/search/veterinarian")
    public ResponseEntity<List<MedicalRecordResponse>> searchByVeterinarian(@RequestParam String name) {
        log.info("===  SEARCH MEDICAL RECORDS BY VETERINARIAN ===");
        log.info(" Search for veterinarian: {}", name);
        List<MedicalRecordResponse> responses = medicalRecordService.searchByVeterinarian(name);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/search/clinic")
    public ResponseEntity<List<MedicalRecordResponse>> searchByClinic(
            @RequestParam String name) {
        log.info("===  SEARCH MEDICAL RECORDS BY CLINIC ===");
        log.info(" Search for clinic: {}", name);
        List<MedicalRecordResponse> responses = medicalRecordService.searchByClinic(name);
        return ResponseEntity.ok(responses);
    }
    @GetMapping("/search/medication")
    public ResponseEntity<?> searchByMedication(@RequestParam String name, @RequestParam(required = false, defaultValue = "false") boolean exactMatch) {

        log.info("===  SEARCH MEDICAL RECORDS BY MEDICATION ===");
        log.info(" Search for medication: {}, exactMatch: {}", name, exactMatch);
        try {
            List<MedicalRecordResponse> responses = medicalRecordService.searchByMedication(name,  exactMatch);

            if (responses.isEmpty()) {
                Map<String, Object> emptyResponse = new HashMap<>();
                emptyResponse.put("message", STR."No medical records found for medication: \{name}");
                emptyResponse.put("searchTerm", name);
                emptyResponse.put("count", 0);
                emptyResponse.put("timestamp", LocalDateTime.now());

                log.info(" No records found for medication: {}", name);
                return ResponseEntity.ok(emptyResponse);  // Return 200 with empty message
            }
            log.info("✅ Found {} records for medication: {}", responses.size(), name);
            return ResponseEntity.ok(responses);

        } catch (Exception e) {
            log.error("❌ Error searching by medication: {}", e.getMessage());

            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Search failed");
            errorResponse.put("message", e.getMessage());
            errorResponse.put("searchTerm", name);
            errorResponse.put("timestamp", LocalDateTime.now());

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(errorResponse);
        }
    }

}