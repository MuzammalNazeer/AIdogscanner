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
import java.util.Optional;
@Repository
public interface CleaningLogRepository extends JpaRepository<CleaningLog, Integer> {

    List<CleaningLog> findByPetId(Long petId);

    Page<CleaningLog> findByPetId(Long petId, Pageable pageable);

    @Query("SELECT cl FROM CleaningLog cl WHERE cl.pet.id = :petId AND DATE(cl.cleanedAt) >= :sinceDate ORDER BY cl.cleanedAt DESC")
    List<CleaningLog> findRecentByPetId(@Param("petId") Long petId, @Param("sinceDate") LocalDate sinceDate);

    @Query("SELECT cl FROM CleaningLog cl WHERE cl.nextDueDate <= CURRENT_DATE ORDER BY cl.nextDueDate ASC")
    List<CleaningLog> findDueForCleaning();

    List<CleaningLog> findByPetIdAndItemType(Long petId, CleaningLog.ItemType itemType);

    @Query("SELECT cl FROM CleaningLog cl WHERE cl.pet.id = :petId AND DATE(cl.cleanedAt) BETWEEN :startDate AND :endDate")
    List<CleaningLog> findByPetIdAndCleanedAtBetween(@Param("petId") Long petId,
                                                     @Param("startDate") LocalDate startDate,
                                                     @Param("endDate") LocalDate endDate);

    @Query("SELECT cl.itemType, COUNT(cl) FROM CleaningLog cl WHERE cl.pet.id = :petId GROUP BY cl.itemType")
    List<Object[]> findCleaningCountByItemType(@Param("petId") Long petId);

    Optional<CleaningLog> findByIdAndItemType(Long id, CleaningLog.ItemType itemType);
    // For Option 2
    @Query("SELECT c FROM CleaningLog c WHERE c.itemType = :itemType AND c.nextDueDate <= :today")
    List<CleaningLog> findByItemTypeAndNextDueDateBeforeOrEqual(
            @Param("itemType") CleaningLog.ItemType itemType,
            @Param("today") LocalDate today);

}



