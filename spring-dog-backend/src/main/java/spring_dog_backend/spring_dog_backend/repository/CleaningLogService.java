package spring_dog_backend.spring_dog_backend.repository;

import spring_dog_backend.spring_dog_backend.dto.request.CreateCleaningLogRequest;
import spring_dog_backend.spring_dog_backend.dto.response.CleaningLogResponse;
import spring_dog_backend.spring_dog_backend.model.CleaningLog;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface CleaningLogService {
    CleaningLogResponse createCleaningLog(CreateCleaningLogRequest request);
    CleaningLogResponse getCleaningLogById(Long id);
    List<CleaningLogResponse> getCleaningLogsByPetId(Long petId);
    List<CleaningLogResponse> getRecentCleaningLogs(Long petId, int days);
    List<CleaningLogResponse> getDueCleaningActivities();
    CleaningLogResponse updateCleaningLog(Long id, CreateCleaningLogRequest request);
    void deleteCleaningLog(Long id);
    List<CleaningLogResponse> getCleaningLogsByItemType(Long petId, CleaningLog.ItemType itemType);
    List<CleaningLogResponse> getCleaningLogsByDateRange(Long petId, LocalDateTime startDate, LocalDateTime endDate);
    Map<String, Long> getCleaningStatsByPetId(Long petId);
    List<CleaningLogResponse> createBulkCleaningLogs(List<CreateCleaningLogRequest> requests);
}