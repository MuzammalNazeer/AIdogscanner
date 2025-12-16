package spring_dog_backend.spring_dog_backend.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import spring_dog_backend.spring_dog_backend.dto.request.CreateCleaningLogRequest;
import spring_dog_backend.spring_dog_backend.dto.request.UpdateCleaningLogRequest;
import spring_dog_backend.spring_dog_backend.dto.response.CleaningLogResponse;
import spring_dog_backend.spring_dog_backend.model.CleaningLog;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface CleaningLogService {
    CleaningLogResponse createCleaningLog(CreateCleaningLogRequest request);
    List<CleaningLogResponse> createBulkCleaningLogs(List<CreateCleaningLogRequest> requests);
    CleaningLogResponse getCleaningLogById(Long id);
    List<CleaningLogResponse> getCleaningLogsByPetId(Long petId);
    List<CleaningLogResponse> getRecentCleaningLogs(Long petId, int days);
    List<CleaningLogResponse> getDueCleaningActivities();
    List<CleaningLogResponse> getCleaningLogsByItemType(Long petId, CleaningLog.ItemType itemType);
    List<CleaningLogResponse> getCleaningLogsByDateRange(Long petId, LocalDate startDate, LocalDate endDate);
    Map<String, Long> getCleaningStatsByPetId(Long petId);
    CleaningLogResponse updateCleaningLog(Long id, UpdateCleaningLogRequest request);
    void deleteCleaningLog(Long id);
    Page<CleaningLogResponse> getCleaningLogsByPetIdWithPagination(Long petId, Pageable pageable);

}

