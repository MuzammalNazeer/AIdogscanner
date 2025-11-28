package spring_dog_backend.spring_dog_backend.repository;

import spring_dog_backend.spring_dog_backend.model.HygieneLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface HygieneLogRepository extends JpaRepository<HygieneLog, Long> {

    List<HygieneLog> findByPetId(Long petId);

    // Add this method for pagination
    Page<HygieneLog> findByPetId(Long petId, Pageable pageable);

    List<HygieneLog> findByPetIdAndActivityType(Long petId, HygieneLog.ActivityType activityType);

    List<HygieneLog> findByPerformedAtBetween(LocalDateTime startDate, LocalDateTime endDate);

    // Add this method for date range by pet
    List<HygieneLog> findByPetIdAndPerformedAtBetween(Long petId, LocalDateTime startDate, LocalDateTime endDate);

    @Query("SELECT hl FROM HygieneLog hl WHERE hl.pet.id = :petId AND hl.performedAt >= :sinceDate")
    List<HygieneLog> findRecentByPetId(@Param("petId") Long petId, @Param("sinceDate") LocalDateTime sinceDate);

    @Query("SELECT hl FROM HygieneLog hl WHERE hl.nextRecommendedDate <= CURRENT_DATE")
    List<HygieneLog> findDueForHygiene();

    List<HygieneLog> findByActivityType(HygieneLog.ActivityType activityType);
}