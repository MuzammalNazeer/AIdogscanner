package spring_dog_backend.spring_dog_backend.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import spring_dog_backend.spring_dog_backend.dto.request.CreateHygieneLogRequest;
import spring_dog_backend.spring_dog_backend.dto.response.HygieneLogResponse;
import spring_dog_backend.spring_dog_backend.model.HygieneLog;
import spring_dog_backend.spring_dog_backend.model.Pet;
import spring_dog_backend.spring_dog_backend.repository.HygieneLogRepository;
import spring_dog_backend.spring_dog_backend.repository.PetRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class HygieneLogServiceImpl implements HygieneLogService {

    private final HygieneLogRepository hygieneLogRepository;
    private final PetRepository petRepository;
    private final ObjectMapper objectMapper;

    @Override
    @Transactional
    public HygieneLogResponse createHygieneLog(CreateHygieneLogRequest request) {
        log.info("Creating hygiene log for pet ID: {}", request.getPetId());

        Pet pet = petRepository.findById(request.getPetId())
                .orElseThrow(() -> new RuntimeException("Pet not found with id: " + request.getPetId()));

        HygieneLog hygieneLog = new HygieneLog();
        hygieneLog.setPet(pet);
        hygieneLog.setActivityType(request.getActivityType());
        hygieneLog.setPerformedAt(request.getPerformedAt());
        hygieneLog.setDurationMinutes(request.getDurationMinutes());

        // Handle Map to JSON conversion for productsUsed
        if (request.getProductsUsed() != null) {
            try {
                String productsUsedJson = objectMapper.writeValueAsString(request.getProductsUsed());
                hygieneLog.setProductsUsed(productsUsedJson);
            } catch (Exception e) {
                log.warn("Failed to serialize productsUsed to JSON, storing as null");
                hygieneLog.setProductsUsed(null);
            }
        } else {
            hygieneLog.setProductsUsed(null);
        }

        // Handle Map to JSON conversion for toolsUsed
        if (request.getToolsUsed() != null) {
            try {
                String toolsUsedJson = objectMapper.writeValueAsString(request.getToolsUsed());
                hygieneLog.setToolsUsed(toolsUsedJson);
            } catch (Exception e) {
                log.warn("Failed to serialize toolsUsed to JSON, storing as null");
                hygieneLog.setToolsUsed(null);
            }
        } else {
            hygieneLog.setToolsUsed(null);
        }

        hygieneLog.setNotes(request.getNotes());
        hygieneLog.setNextRecommendedDate(request.getNextRecommendedDate());
        hygieneLog.setCost(request.getCost());

        HygieneLog savedLog = hygieneLogRepository.save(hygieneLog);
        log.info("Hygiene log created successfully with ID: {}", savedLog.getId());

        return convertToResponse(savedLog);
    }

    @Transactional(readOnly = true)
    public List<HygieneLogResponse> getDueHygieneActivitiesByType(Long activityType) {
        log.info("Fetching due hygiene activities for type: {}", activityType);

        // Get current date for comparison
        LocalDate currentDate = LocalDate.now();
        log.info("Current date for due comparison: {}", currentDate);

        // Get all logs of this activity type
        List<HygieneLog> allLogsOfType = hygieneLogRepository.findByPetId(activityType);
        log.info("Found {} total logs for activity type: {}", allLogsOfType.size(), activityType);

        // Filter logs where nextRecommendedDate is today or in the past
        List<HygieneLog> dueLogs = allLogsOfType.stream()
                .filter(log -> log.getNextRecommendedDate() != null)
                .filter(log -> !log.getNextRecommendedDate().isAfter(currentDate)) // due today or past due
                .collect(Collectors.toList());

        log.info("Found {} due logs for activity type: {}", dueLogs.size(), activityType);

        for (HygieneLog dueLog : dueLogs) {
            log.info("Due log - ID: {}, Pet: {}, Next Date: {}",
                    dueLog.getId(), dueLog.getPet().getName(), dueLog.getNextRecommendedDate());
        }

        return dueLogs.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }
    @Override
    @Transactional(readOnly = true)
    public HygieneLogResponse getHygieneLogById(Long id) {
        log.info("Fetching hygiene log with ID: {}", id);

        HygieneLog hygieneLog = hygieneLogRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Hygiene log not found with id: " + id));

        return convertToResponse(hygieneLog);
    }

    @Override
    @Transactional(readOnly = true)
    public List<HygieneLogResponse> getHygieneLogsByPetId(Long petId) {
        log.info("Fetching all hygiene logs for pet ID: {}", petId);

        if (!petRepository.existsById(petId)) {
            throw new RuntimeException("Pet not found with id: " + petId);
        }

        return hygieneLogRepository.findByPetId(petId)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<HygieneLogResponse> getRecentHygieneLogs(Long petId, int days) {
        log.info("Fetching recent hygiene logs for pet ID: {} from last {} days", petId, days);

        if (!petRepository.existsById(petId)) {
            throw new RuntimeException("Pet not found with id: " + petId);
        }

        LocalDateTime sinceDate = LocalDateTime.now().minusDays(days);
        return hygieneLogRepository.findRecentByPetId(petId, sinceDate)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<HygieneLogResponse> getDueHygieneActivities() {
        log.info("Fetching due hygiene activities");

        return hygieneLogRepository.findDueForHygiene()
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<HygieneLogResponse> getHygieneLogsByActivityType(Long petId, HygieneLog.ActivityType activityType) {
        log.info("Fetching hygiene logs for pet ID: {} with activity type: {}", petId, activityType);

        if (!petRepository.existsById(petId)) {
            throw new RuntimeException("Pet not found with id: " + petId);
        }

        return hygieneLogRepository.findByPetIdAndActivityType(petId, activityType)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public HygieneLogResponse updateHygieneLog(Long id, CreateHygieneLogRequest request) {
        log.info("Updating hygiene log with ID: {}", id);

        HygieneLog hygieneLog = hygieneLogRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Hygiene log not found with id: " + id));

        // Update fields
        hygieneLog.setActivityType(request.getActivityType());
        hygieneLog.setPerformedAt(request.getPerformedAt());
        hygieneLog.setDurationMinutes(request.getDurationMinutes());

        // Handle Map to JSON conversion for productsUsed
        if (request.getProductsUsed() != null) {
            try {
                String productsUsedJson = objectMapper.writeValueAsString(request.getProductsUsed());
                hygieneLog.setProductsUsed(productsUsedJson);
            } catch (Exception e) {
                log.warn("Failed to serialize productsUsed to JSON, storing as null");
                hygieneLog.setProductsUsed(null);
            }
        } else {
            hygieneLog.setProductsUsed(null);
        }

        // Handle Map to JSON conversion for toolsUsed
        if (request.getToolsUsed() != null) {
            try {
                String toolsUsedJson = objectMapper.writeValueAsString(request.getToolsUsed());
                hygieneLog.setToolsUsed(toolsUsedJson);
            } catch (Exception e) {
                log.warn("Failed to serialize toolsUsed to JSON, storing as null");
                hygieneLog.setToolsUsed(null);
            }
        } else {
            hygieneLog.setToolsUsed(null);
        }

        hygieneLog.setNotes(request.getNotes());
        hygieneLog.setNextRecommendedDate(request.getNextRecommendedDate());
        hygieneLog.setCost(request.getCost());

        HygieneLog updatedLog = hygieneLogRepository.save(hygieneLog);
        log.info("Hygiene log updated successfully with ID: {}", updatedLog.getId());

        return convertToResponse(updatedLog);
    }


    // Additional service methods for better functionality
    @Transactional(readOnly = true)
    public Page<HygieneLogResponse> getHygieneLogsByPetIdWithPagination(Long petId, Pageable pageable) {
        log.info("Fetching hygiene logs for pet ID: {} with pagination", petId);

        if (!petRepository.existsById(petId)) {
            throw new RuntimeException("Pet not found with id: " + petId);
        }

        return hygieneLogRepository.findByPetId(petId, pageable)
                .map(this::convertToResponse);
    }

    @Transactional(readOnly = true)
    public List<HygieneLogResponse> getHygieneLogsByDateRange(Long petId, LocalDateTime startDate, LocalDateTime endDate) {
        log.info("Fetching hygiene logs for pet ID: {} between {} and {}", petId, startDate, endDate);

        if (!petRepository.existsById(petId)) {
            throw new RuntimeException("Pet not found with id: " + petId);
        }

        return hygieneLogRepository.findByPetIdAndPerformedAtBetween(petId, startDate, endDate)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Double getTotalHygieneCostByPetId(Long petId) {
        log.info("Calculating total hygiene cost for pet ID: {}", petId);

        if (!petRepository.existsById(petId)) {
            throw new RuntimeException("Pet not found with id: " + petId);
        }

        return hygieneLogRepository.findByPetId(petId)
                .stream()
                .mapToDouble(log -> log.getCost() != null ? log.getCost() : 0.0)
                .sum();
    }
    private HygieneLogResponse convertToResponse(HygieneLog hygieneLog) {
        HygieneLogResponse response = new HygieneLogResponse();
        response.setId(hygieneLog.getId());
        response.setPetId(hygieneLog.getPet().getId());
        response.setPetName(hygieneLog.getPet().getName());
        response.setActivityType(hygieneLog.getActivityType());
        response.setPerformedAt(hygieneLog.getPerformedAt());
        response.setDurationMinutes(hygieneLog.getDurationMinutes());
        response.setNotes(hygieneLog.getNotes());
        response.setNextRecommendedDate(hygieneLog.getNextRecommendedDate());
        response.setCost(hygieneLog.getCost());
        response.setCreatedAt(hygieneLog.getCreatedAt());

        // Convert JSON string back to Map for response
        try {
            if (hygieneLog.getProductsUsed() != null) {
                Map<String, String> productsMap = objectMapper.readValue(
                        hygieneLog.getProductsUsed(),
                        new TypeReference<Map<String, String>>() {}
                );
                response.setProductsUsed(productsMap);
            }
            if (hygieneLog.getToolsUsed() != null) {
                Map<String, String> toolsMap = objectMapper.readValue(
                        hygieneLog.getToolsUsed(),
                        new TypeReference<Map<String, String>>() {}
                );
                response.setToolsUsed(toolsMap);
            }
        } catch (Exception e) {
            log.warn("Error parsing JSON fields: {}", e.getMessage());
            response.setProductsUsed(null);
            response.setToolsUsed(null);
        }

        return response;
    }


    @Override
    @Transactional
    public List<HygieneLogResponse> createHygieneLogs(List<CreateHygieneLogRequest> requests) {
        log.info("Creating {} hygiene logs in batch", requests.size());

        List<HygieneLogResponse> responses = requests.stream()
                .map(this::createHygieneLog)
                .collect(Collectors.toList());

        log.info("Successfully created {} hygiene logs", responses.size());
        return responses;
    }

    // Add this method for debugging
    @Transactional(readOnly = true)
    @Override
    public List<HygieneLogResponse> getAllHygieneLogs() {
        log.info("Fetching ALL hygiene logs from database");

        List<HygieneLog> allLogs = hygieneLogRepository.findAll();
        log.info("Total hygiene logs in database: {}", allLogs.size());

        for (HygieneLog hygieneLog : allLogs) {
            log.info("Log ID: {}, Pet ID: {}, Activity: {}, Performed At: {}",
                    hygieneLog.getId(), hygieneLog.getPet().getId(), hygieneLog.getActivityType(), hygieneLog.getPerformedAt());
        }

        return allLogs.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<HygieneLogResponse> getDueHygieneActivitiesByType(HygieneLog.ActivityType activityType) {
        log.info("Fetching due hygiene activities for type: {}", activityType);

        LocalDate currentDate = LocalDate.now();
        log.info("Current date for due comparison: {}", currentDate);

        // Get all logs of this activity type
        List<HygieneLog> allLogsOfType = hygieneLogRepository.findByActivityType(activityType);
        log.info("Found {} total logs for activity type: {}", allLogsOfType.size(), activityType);

        for (HygieneLog hygieneLog : allLogsOfType) {
            log.info("Log - ID: {}, Pet: {}, Next Date: {}, Is Due: {}",
                    hygieneLog.getId(),
                    hygieneLog.getPet().getName(),
                    hygieneLog.getNextRecommendedDate(),
                    hygieneLog.getNextRecommendedDate() != null && !hygieneLog.getNextRecommendedDate().isAfter(currentDate));
        }

        // Filter due logs
        List<HygieneLog> dueLogs = allLogsOfType.stream()
                .filter(hygieneLog -> {  // ← CHANGED 'log' to 'hygieneLog'
                    boolean hasDate = hygieneLog.getNextRecommendedDate() != null;
                    boolean isDue = hasDate && !hygieneLog.getNextRecommendedDate().isAfter(currentDate);
                    log.info("Filtering - Log ID: {}, Has Date: {}, Is Due: {}",
                            hygieneLog.getId(), hasDate, isDue);
                    return isDue;
                })
                .collect(Collectors.toList());

        log.info("Found {} due logs for activity type: {}", dueLogs.size(), activityType);

        return dueLogs.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }


    @Override
    @Transactional
    public void deleteHygieneLog(Long id) {
        log.info("🗑️ Attempting to delete hygiene log with ID: {}", id);

        // Check if log exists first
        boolean exists = hygieneLogRepository.existsById(id);
        log.info("📊 Hygiene log exists in database: {}", exists);

        if (!exists) {
            log.error("❌ Hygiene log not found with ID: {}", id);
            throw new RuntimeException("Hygiene log not found with id: " + id);
        }

        // Optional: Log the details of what we're about to delete
        hygieneLogRepository.findById(id).ifPresent(hygieneLog -> {
            log.info("📝 About to delete - ID: {}, Pet: {}, Activity: {}",  // ← Using logger 'log.info()'
                    hygieneLog.getId(), hygieneLog.getPet().getName(), hygieneLog.getActivityType());
        });

        hygieneLogRepository.deleteById(id);

        // Verify deletion
        boolean stillExists = hygieneLogRepository.existsById(id);
        log.info("✅ Deletion verification - Still exists: {}", stillExists);

        log.info("🗑️ Hygiene log deleted successfully with ID: {}", id);
    }
}
