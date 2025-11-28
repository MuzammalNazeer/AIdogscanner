package spring_dog_backend.spring_dog_backend.service;

import org.springframework.transaction.annotation.Transactional;
import spring_dog_backend.spring_dog_backend.dto.request.CreateHygieneLogRequest;
import spring_dog_backend.spring_dog_backend.dto.response.HygieneLogResponse;
import spring_dog_backend.spring_dog_backend.model.HygieneLog;

import java.util.List;

public interface HygieneLogService {
    spring_dog_backend.spring_dog_backend.dto.response.HygieneLogResponse createHygieneLog(CreateHygieneLogRequest request);

    @Transactional
    List<HygieneLogResponse> createHygieneLogs(List<CreateHygieneLogRequest> requests);

    HygieneLogResponse getHygieneLogById(Long id);
    List<HygieneLogResponse> getHygieneLogsByPetId(Long petId);
    List<HygieneLogResponse> getRecentHygieneLogs(Long petId, int days);
    List<HygieneLogResponse> getDueHygieneActivities();
    HygieneLogResponse updateHygieneLog(Long id, CreateHygieneLogRequest request);
    void deleteHygieneLog(Long id);
    List<HygieneLogResponse> getHygieneLogsByActivityType(Long petId, HygieneLog.ActivityType activityType);

    // Add this method for debugging
    @Transactional(readOnly = true)
    List<HygieneLogResponse> getAllHygieneLogs();

    List<HygieneLogResponse> getDueHygieneActivitiesByType(HygieneLog.ActivityType activityType);
}