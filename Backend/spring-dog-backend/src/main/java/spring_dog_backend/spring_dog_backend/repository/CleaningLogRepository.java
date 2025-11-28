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

//package spring_dog_backend.spring_dog_backend.repository;
//
//import spring_dog_backend.spring_dog_backend.model.CleaningLog;
//import org.springframework.data.domain.Page;
//import org.springframework.data.domain.Pageable;
//import org.springframework.data.jpa.repository.JpaRepository;
//import org.springframework.data.jpa.repository.Query;
//import org.springframework.data.repository.query.Param;
//import org.springframework.stereotype.Repository;
//
//import java.time.LocalDateTime;
//import java.util.List;
//import java.util.Optional;
//
//@Repository
//public interface CleaningLogRepository extends JpaRepository<CleaningLog, Long> {
//
//    // Basic CRUD operations are provided by JpaRepository
//
//    // Find all cleaning logs for a specific pet
//    List<CleaningLog> findByPetId(Long petId);
//
//    // Find all cleaning logs for a specific pet with pagination
//    Page<CleaningLog> findByPetId(Long petId, Pageable pageable);
//
//    // Find recent cleaning logs for a pet since a specific date
//    @Query("SELECT cl FROM CleaningLog cl WHERE cl.pet.id = :petId AND cl.cleanedAt >= :sinceDate ORDER BY cl.cleanedAt DESC")
//    List<CleaningLog> findRecentByPetId(@Param("petId") Long petId, @Param("sinceDate") LocalDateTime sinceDate);
//
//    // Find cleaning logs by pet ID and item type
//    List<CleaningLog> findByPetIdAndItemType(Long petId, CleaningLog.ItemType itemType);
//
//    // Find cleaning logs by date range
//    @Query("SELECT cl FROM CleaningLog cl WHERE cl.pet.id = :petId AND cl.cleanedAt BETWEEN :startDate AND :endDate ORDER BY cl.cleanedAt DESC")
//    List<CleaningLog> findByPetIdAndCleanedAtBetween(@Param("petId") Long petId,
//                                                     @Param("startDate") LocalDateTime startDate,
//                                                     @Param("endDate") LocalDateTime endDate);
//
//    // Find due cleaning activities (nextDueDate is today or in the past)
//    @Query("SELECT cl FROM CleaningLog cl WHERE cl.nextDueDate <= CURRENT_DATE ORDER BY cl.nextDueDate ASC")
//    List<CleaningLog> findDueForCleaning();
//
//    // Get cleaning statistics by item type for a pet
//    @Query("SELECT cl.itemType, COUNT(cl) FROM CleaningLog cl WHERE cl.pet.id = :petId GROUP BY cl.itemType")
//    List<Object[]> findCleaningCountByItemType(@Param("petId") Long petId);
//
//    // === NATIVE QUERY METHODS FOR ENUM FALLBACK ===
//
//    // Safe method with custom handling
//    @Query("SELECT cl FROM CleaningLog cl WHERE cl.pet.id = :petId")
//    List<CleaningLog> findByPetIdSafe(@Param("petId") Long petId);
//
//    // Native query methods
//    @Query(value = "SELECT * FROM cleaning_logs WHERE id = :id", nativeQuery = true)
//    Optional<CleaningLog> findByIdNative(@Param("id") Long id);
//
//    @Query(value = "SELECT * FROM cleaning_logs WHERE pet_id = :petId", nativeQuery = true)
//    List<CleaningLog> findByPetIdNative(@Param("petId") Long petId);
//
//    @Query(value = "SELECT * FROM cleaning_logs WHERE pet_id = :petId AND cleaned_at >= :sinceDate ORDER BY cleaned_at DESC", nativeQuery = true)
//    List<CleaningLog> findRecentByPetIdNative(@Param("petId") Long petId, @Param("sinceDate") LocalDateTime sinceDate);
//
//    @Query(value = "SELECT * FROM cleaning_logs WHERE next_due_date <= CURRENT_DATE ORDER BY next_due_date ASC", nativeQuery = true)
//    List<CleaningLog> findDueForCleaningNative();
//
//    @Query(value = "SELECT * FROM cleaning_logs WHERE pet_id = :petId AND item_type = :itemType", nativeQuery = true)
//    List<CleaningLog> findByPetIdAndItemTypeNative(@Param("petId") Long petId, @Param("itemType") String itemType);
//
//    @Query(value = "SELECT * FROM cleaning_logs WHERE pet_id = :petId AND cleaned_at BETWEEN :startDate AND :endDate ORDER BY cleaned_at DESC", nativeQuery = true)
//    List<CleaningLog> findByPetIdAndCleanedAtBetweenNative(@Param("petId") Long petId,
//                                                           @Param("startDate") LocalDateTime startDate,
//                                                           @Param("endDate") LocalDateTime endDate);
//
//    @Query(value = "SELECT item_type, COUNT(*) FROM cleaning_logs WHERE pet_id = :petId GROUP BY item_type", nativeQuery = true)
//    List<Object[]> findCleaningCountByItemTypeNative(@Param("petId") Long petId);
//
//    // Debug methods to see raw item_type values
//    @Query(value = "SELECT id, item_type FROM cleaning_logs", nativeQuery = true)
//    List<Object[]> findRawItemTypes();
//
//    @Query(value = "SELECT id, item_type FROM cleaning_logs WHERE pet_id = :petId", nativeQuery = true)
//    List<Object[]> findRawItemTypesByPetId(@Param("petId") Long petId);
//
//    // Find cleaning logs with custom enum handling
//    @Query(value = "SELECT * FROM cleaning_logs WHERE pet_id = :petId AND item_type IN :allowedTypes", nativeQuery = true)
//    List<CleaningLog> findByPetIdWithAllowedTypes(@Param("petId") Long petId,
//                                                  @Param("allowedTypes") List<String> allowedTypes);
//
//    // Native query with pagination support
//    @Query(value = "SELECT * FROM cleaning_logs WHERE pet_id = :petId LIMIT :limit OFFSET :offset", nativeQuery = true)
//    List<CleaningLog> findByPetIdNativeWithPagination(@Param("petId") Long petId,
//                                                      @Param("limit") int limit,
//                                                      @Param("offset") int offset);
//
//    // Count query for native pagination
//    @Query(value = "SELECT COUNT(*) FROM cleaning_logs WHERE pet_id = :petId", nativeQuery = true)
//    long countByPetIdNative(@Param("petId") Long petId);
//}
//
//
//
////package spring_dog_backend.spring_dog_backend.repository;
////
////import spring_dog_backend.spring_dog_backend.model.CleaningLog;
////import org.springframework.data.domain.Page;
////import org.springframework.data.domain.Pageable;
////import org.springframework.data.jpa.repository.JpaRepository;
////import org.springframework.data.jpa.repository.Query;
////import org.springframework.data.repository.query.Param;
////import org.springframework.stereotype.Repository;
////
////import java.time.LocalDateTime;
////import java.util.List;
////
////@Repository
////public interface CleaningLogRepository extends JpaRepository<CleaningLog, Long> {
////
////    // Basic CRUD operations are provided by JpaRepository
////
////    // Find all cleaning logs for a specific pet
////    List<CleaningLog> findByPetId(Long petId);
////
////    // Find all cleaning logs for a specific pet with pagination
////    Page<CleaningLog> findByPetId(Long petId, Pageable pageable);
////
////    // Find recent cleaning logs for a pet since a specific date
////    @Query("SELECT cl FROM CleaningLog cl WHERE cl.pet.id = :petId AND cl.cleanedAt >= :sinceDate ORDER BY cl.cleanedAt DESC")
////    List<CleaningLog> findRecentByPetId(@Param("petId") Long petId, @Param("sinceDate") LocalDateTime sinceDate);
////
////    // Find cleaning logs by pet ID and item type
////    List<CleaningLog> findByPetIdAndItemType(Long petId, CleaningLog.ItemType itemType);
////
////    // Find cleaning logs by date range
////    @Query("SELECT cl FROM CleaningLog cl WHERE cl.pet.id = :petId AND cl.cleanedAt BETWEEN :startDate AND :endDate ORDER BY cl.cleanedAt DESC")
////    List<CleaningLog> findByPetIdAndCleanedAtBetween(@Param("petId") Long petId,
////                                                     @Param("startDate") LocalDateTime startDate,
////                                                     @Param("endDate") LocalDateTime endDate);
////
////    // Find due cleaning activities (nextDueDate is today or in the past)
////    @Query("SELECT cl FROM CleaningLog cl WHERE cl.nextDueDate <= CURRENT_DATE ORDER BY cl.nextDueDate ASC")
////    List<CleaningLog> findDueForCleaning();
////
////    // Get cleaning statistics by item type for a pet
////    @Query("SELECT cl.itemType, COUNT(cl) FROM CleaningLog cl WHERE cl.pet.id = :petId GROUP BY cl.itemType")
////    List<Object[]> findCleaningCountByItemType(@Param("petId") Long petId);
////
////    // Native query methods for handling enum issues
////    @Query(value = "SELECT * FROM cleaning_logs WHERE pet_id = :petId", nativeQuery = true)
////    List<CleaningLog> findByPetIdNative(@Param("petId") Long petId);
////
////    // Safe method with custom handling
////    @Query("SELECT cl FROM CleaningLog cl WHERE cl.pet.id = :petId")
////    List<CleaningLog> findByPetIdSafe(@Param("petId") Long petId);
////
////    // Debug method to see raw item_type values
////    @Query(value = "SELECT id, item_type FROM cleaning_logs", nativeQuery = true)
////    List<Object[]> findRawItemTypes();
////
////    // Debug method for specific pet
////    @Query(value = "SELECT id, item_type FROM cleaning_logs WHERE pet_id = :petId", nativeQuery = true)
////    List<Object[]> findRawItemTypesByPetId(@Param("petId") Long petId);
////
////    // Find cleaning logs with custom enum handling
////    @Query(value = "SELECT * FROM cleaning_logs WHERE pet_id = :petId AND item_type IN :allowedTypes", nativeQuery = true)
////    List<CleaningLog> findByPetIdWithAllowedTypes(@Param("petId") Long petId,
////                                                  @Param("allowedTypes") List<String> allowedTypes);
////}
////
//////package spring_dog_backend.spring_dog_backend.repository;
//////
//////import spring_dog_backend.spring_dog_backend.model.CleaningLog;
//////import org.springframework.data.domain.Page;
//////import org.springframework.data.domain.Pageable;
//////import org.springframework.data.jpa.repository.JpaRepository;
//////import org.springframework.data.jpa.repository.Query;
//////import org.springframework.data.repository.query.Param;
//////import org.springframework.stereotype.Repository;
//////
//////import java.time.LocalDateTime;
//////import java.util.List;
//////
//////@Repository
//////public interface CleaningLogRepository extends JpaRepository<CleaningLog, Long> {
//////
//////    List<CleaningLog> findByPetId(Long petId);
//////
//////    Page<CleaningLog> findByPetId(Long petId, Pageable pageable);
//////
//////    List<CleaningLog> findByPetIdAndItemType(Long petId, CleaningLog.ItemType itemType);
//////
//////    List<CleaningLog> findByCleanedAtBetween(LocalDateTime startDate, LocalDateTime endDate);
//////
//////    List<CleaningLog> findByPetIdAndCleanedAtBetween(Long petId, LocalDateTime startDate, LocalDateTime endDate);
//////
//////    @Query("SELECT cl FROM CleaningLog cl WHERE cl.pet.id = :petId AND cl.cleanedAt >= :sinceDate")
//////    List<CleaningLog> findRecentByPetId(@Param("petId") Long petId, @Param("sinceDate") LocalDateTime sinceDate);
//////
//////    @Query("SELECT cl FROM CleaningLog cl WHERE cl.nextDueDate <= CURRENT_DATE")
//////    List<CleaningLog> findDueForCleaning();
//////
//////    @Query("SELECT cl.itemType, COUNT(cl) FROM CleaningLog cl WHERE cl.pet.id = :petId GROUP BY cl.itemType")
//////    List<Object[]> findCleaningCountByItemType(@Param("petId") Long petId);
//////}