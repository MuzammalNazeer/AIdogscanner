package spring_dog_backend.spring_dog_backend.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import spring_dog_backend.spring_dog_backend.dto.request.CreateCleaningLogRequest;
import spring_dog_backend.spring_dog_backend.dto.request.UpdateCleaningLogRequest;
import spring_dog_backend.spring_dog_backend.dto.response.CleaningLogResponse;
import spring_dog_backend.spring_dog_backend.exception.CleaningLogNotFoundException;
import spring_dog_backend.spring_dog_backend.exception.PetNotFoundException;
import spring_dog_backend.spring_dog_backend.model.CleaningLog;
import spring_dog_backend.spring_dog_backend.model.Pet;
import spring_dog_backend.spring_dog_backend.repository.CleaningLogRepository;
import spring_dog_backend.spring_dog_backend.repository.CleaningLogService;
import spring_dog_backend.spring_dog_backend.repository.PetRepository;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import static spring_dog_backend.spring_dog_backend.model.Pet.Species.OTHER;

@Slf4j
@Service
@RequiredArgsConstructor
public class CleaningLogServiceImpl implements CleaningLogService {

    private final CleaningLogRepository cleaningLogRepository;
    private final PetRepository petRepository;
    private final ObjectMapper objectMapper;

    @Override
    @Transactional
    public CleaningLogResponse createCleaningLog(CreateCleaningLogRequest request) {
        log.info("Creating cleaning log for pet ID: {}", request.getPetId());

        Pet pet = petRepository.findById(request.getPetId())
                .orElseThrow(() -> new PetNotFoundException(request.getPetId()));

        String cleaningProductsJson = convertCleaningProductsToJson(request.getCleaningProducts());

        // Calculate next due date if not provided
        LocalDate nextDueDate = request.getNextDueDate();
        if (nextDueDate == null) {
            nextDueDate = calculateNextDueDate(request.getCleanedAt(), request.getItemType());
        }

        CleaningLog cleaningLog = CleaningLog.builder()
                .pet(pet)
                .itemType(CleaningLog.ItemType.valueOf(String.valueOf(request.getItemType())))
                .cleanedAt(request.getCleanedAt().atStartOfDay())
                .cleaningMethod(request.getCleaningMethod())
                .cleaningProducts(cleaningProductsJson)
                .notes(request.getNotes())
                .nextDueDate(nextDueDate)
                .build();

        CleaningLog savedLog = cleaningLogRepository.save(cleaningLog);
        log.info("Cleaning log created successfully with ID: {}", savedLog.getId());

        return convertToResponse(savedLog);
    }

    @Override
    @Transactional
    public List<CleaningLogResponse> createBulkCleaningLogs(List<CreateCleaningLogRequest> requests) {
        log.info("Creating {} cleaning logs in bulk", requests.size());

        List<CleaningLogResponse> responses = new ArrayList<>();
        for (CreateCleaningLogRequest request : requests) {
            try {
                CleaningLogResponse response = createCleaningLog(request);
                responses.add(response);
                log.info("✅ Created cleaning log with ID: {} for item: {}",
                        response.getId(), response.getItemType());
            } catch (Exception e) {
                log.error("❌ Failed to create cleaning log for item {}: {}",
                        request.getItemType(), e.getMessage());
                responses.add(null);
            }
        }

        long successfulCount = responses.stream().filter(Objects::nonNull).count();
        log.info("Bulk creation completed: {}/{} successful", successfulCount, requests.size());
        return responses;
    }

    @Override
    @Transactional(readOnly = true)
    public CleaningLogResponse getCleaningLogById(Long id) {
        log.info("Fetching cleaning log with ID: {}", id);

        CleaningLog cleaningLog = cleaningLogRepository.findById(id)
                .orElseThrow(() -> new CleaningLogNotFoundException(id));

        return convertToResponse(cleaningLog);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CleaningLogResponse> getCleaningLogsByPetId(Long petId) {
        log.info("Fetching all cleaning logs for pet ID: {}", petId);

        validatePetExists(petId);

        return cleaningLogRepository.findByPetId(petId)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<CleaningLogResponse> getRecentCleaningLogs(Long petId, int days) {
        log.info("Fetching recent cleaning logs for pet ID: {} from last {} days", petId, days);

        validatePetExists(petId);

        LocalDate sinceDate = LocalDate.now().minusDays(days);
        return cleaningLogRepository.findRecentByPetId(petId, sinceDate)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<CleaningLogResponse> getDueCleaningActivities() {
        log.info("Fetching due cleaning activities");

        return cleaningLogRepository.findDueForCleaning()
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<CleaningLogResponse> getCleaningLogsByItemType(Long petId, CleaningLog.ItemType itemType) {
        log.info("Fetching cleaning logs for pet ID: {} with item type: {}", petId, itemType);

        validatePetExists(petId);

        return cleaningLogRepository.findByPetIdAndItemType(petId, itemType)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<CleaningLogResponse> getCleaningLogsByDateRange(Long petId, LocalDate startDate, LocalDate endDate) {
        log.info("Fetching cleaning logs for pet ID: {} between {} and {}", petId, startDate, endDate);

        validatePetExists(petId);

        return cleaningLogRepository.findByPetIdAndCleanedAtBetween(petId, startDate, endDate)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Long> getCleaningStatsByPetId(Long petId) {
        log.info("Fetching cleaning statistics for pet ID: {}", petId);

        validatePetExists(petId);

        List<Object[]> stats = cleaningLogRepository.findCleaningCountByItemType(petId);
        return stats.stream()
                .collect(Collectors.toMap(
                        obj -> ((CleaningLog.ItemType) obj[0]).name(),
                        obj -> (Long) obj[1]
                ));
    }

    @Override
    @Transactional
    public CleaningLogResponse updateCleaningLog(Long id, UpdateCleaningLogRequest request) {
        log.info("Updating cleaning log with ID: {}", id);

        CleaningLog cleaningLog = cleaningLogRepository.findById(id)
                .orElseThrow(() -> new CleaningLogNotFoundException(id));

        // Update fields if provided
        if (request.getItemType() != null) {
            cleaningLog.setItemType(CleaningLog.ItemType.valueOf(String.valueOf(request.getItemType())));
        }

        if (request.getCleanedAt() != null) {
            cleaningLog.setCleanedAt(request.getCleanedAt().atStartOfDay());
        }

        if (request.getCleaningMethod() != null) {
            cleaningLog.setCleaningMethod(request.getCleaningMethod());
        }

        if (request.getNotes() != null) {
            cleaningLog.setNotes(request.getNotes());
        }

        if (request.getNextDueDate() != null) {
            cleaningLog.setNextDueDate(request.getNextDueDate());
        }

        // Update cleaning products if provided
        if (request.getCleaningProducts() != null) {
            String cleaningProductsJson = convertCleaningProductsToJson(request.getCleaningProducts());
            cleaningLog.setCleaningProducts(cleaningProductsJson);
        }

//        // Recalculate next due date if cleaned date or item type changed
//        if (request.getCleanedAt() != null || request.getItemType() != null) {
//            LocalDate cleanedAt = (request.getCleanedAt() != null ? request.getCleanedAt() : cleaningLog.getCleanedAt()).atStartOfDay();
//            CleaningLog.ItemType itemType = request.getItemType() != null ? request.getItemType() : cleaningLog.getItemType();
//            LocalDate nextDueDate = calculateNextDueDate(cleanedAt, itemType);
//            cleaningLog.setNextDueDate(nextDueDate);
//        }

        CleaningLog updatedLog = cleaningLogRepository.save(cleaningLog);
        log.info("Cleaning log updated successfully with ID: {}", updatedLog.getId());

        return convertToResponse(updatedLog);
    }

    @Override
    @Transactional
    public void deleteCleaningLog(Long id) {
        log.info("Deleting cleaning log with ID: {}", id);

        if (!cleaningLogRepository.existsById(id)) {
            throw new CleaningLogNotFoundException(id);
        }

        cleaningLogRepository.deleteById(id);
        log.info("Cleaning log deleted successfully with ID: {}", id);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<CleaningLogResponse> getCleaningLogsByPetIdWithPagination(Long petId, Pageable pageable) {
        log.info("Fetching cleaning logs for pet ID: {} with pagination", petId);

        validatePetExists(petId);

        return cleaningLogRepository.findByPetId(petId, pageable)
                .map(this::convertToResponse);
    }

    private void validatePetExists(Long petId) {
        if (!petRepository.existsById(petId)) {
            throw new PetNotFoundException(petId);
        }
    }

    private String convertCleaningProductsToJson(Map<String, Object> cleaningProducts) {
        if (cleaningProducts == null) {
            return null;
        }

        try {
            return objectMapper.writeValueAsString(cleaningProducts);
        } catch (JsonProcessingException e) {
            log.warn("Failed to convert cleaning products to JSON: {}", e.getMessage());
            return null;
        }
    }

    private LocalDate calculateNextDueDate(LocalDate cleanedAt, CleaningLog.ItemType itemType) {
        switch (itemType) {
            case FOOD_PLATE:
                return cleanedAt.plusDays(1);     // Clean food plates daily
            case WATER_FOUNTAIN:
                return cleanedAt.plusDays(2);     // Clean water fountains every 2 days
            case BED:
                return cleanedAt.plusWeeks(2);    // Clean beds bi-weekly
            case TOYS:
                return cleanedAt.plusWeeks(1);    // Clean toys weekly
            case LEASH_COLLAR:
                return cleanedAt.plusWeeks(3);    // Clean leash/collar every 3 weeks
//            case OTHER:
//                return cleanedAt.plusWeeks(1);    // Default weekly for other items
            default:
                return cleanedAt.plusWeeks(1);
        }
    }

    private CleaningLogResponse convertToResponse(CleaningLog cleaningLog) {
        CleaningLogResponse response = new CleaningLogResponse();
        response.setId(Long.valueOf(cleaningLog.getId()));
        response.setPetId(cleaningLog.getPet().getId());
        response.setPetName(cleaningLog.getPet().getName());
        response.setItemType(CleaningLog.ItemType.valueOf(String.valueOf(cleaningLog.getItemType())));
        response.setCleanedAt(LocalDate.from(cleaningLog.getCleanedAt()));
        response.setCleaningMethod(cleaningLog.getCleaningMethod());
        response.setNotes(cleaningLog.getNotes());
        response.setNextDueDate(cleaningLog.getNextDueDate());
        response.setCreatedAt(cleaningLog.getCreatedAt());

        // Convert JSON string back to Map for response
        try {
            if (cleaningLog.getCleaningProducts() != null && !cleaningLog.getCleaningProducts().trim().isEmpty()) {
                Map<String, Object> cleaningProductsMap = objectMapper.readValue(
                        cleaningLog.getCleaningProducts(),
                        new TypeReference<Map<String, Object>>() {}
                );
                response.setCleaningProducts(cleaningProductsMap);
            } else {
                response.setCleaningProducts(null);
            }
        } catch (Exception e) {
            log.warn("Error parsing cleaning products JSON: {}", e.getMessage());
            response.setCleaningProducts(null);
        }

        return response;
    }
}

