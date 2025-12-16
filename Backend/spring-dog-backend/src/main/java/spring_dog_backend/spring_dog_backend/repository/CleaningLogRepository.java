package spring_dog_backend.spring_dog_backend.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import spring_dog_backend.spring_dog_backend.model.CleaningLog;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface CleaningLogRepository extends JpaRepository<CleaningLog, Long> {

    List<CleaningLog> findByPetId(Long petId);
    Page<CleaningLog> findByPetId(Long petId, Pageable pageable);

    @Query("SELECT cl FROM CleaningLog cl WHERE cl.pet.id = :petId AND cl.cleanedAt >= :sinceDate ORDER BY cl.cleanedAt DESC")
    List<CleaningLog> findRecentByPetId(@Param("petId") Long petId, @Param("sinceDate") LocalDate sinceDate);

    @Query("SELECT cl FROM CleaningLog cl WHERE cl.nextDueDate <= CURRENT_DATE ORDER BY cl.nextDueDate ASC")
    List<CleaningLog> findDueForCleaning();

    List<CleaningLog> findByPetIdAndItemType(Long petId, CleaningLog.ItemType itemType);

    List<CleaningLog> findByPetIdAndCleanedAtBetween(Long petId, LocalDate startDate, LocalDate endDate);

    @Query("SELECT cl.itemType, COUNT(cl) FROM CleaningLog cl WHERE cl.pet.id = :petId GROUP BY cl.itemType")
    List<Object[]> findCleaningCountByItemType(@Param("petId") Long petId);

    @Query(value = "SELECT * FROM cleaning_logs WHERE pet_id = :petId AND item_type IN ('FOOD_PLATE', 'BED', 'TOYS', 'WATER_FOUNTAIN', 'LEASH_COLLAR', 'OTHER')", nativeQuery = true)
    List<CleaningLog> findValidCleaningLogsByPetId(@Param("petId") Long petId);
}
