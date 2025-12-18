package spring_dog_backend.spring_dog_backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import spring_dog_backend.spring_dog_backend.model.MedicalRecord;
import java.time.LocalDate;
import java.util.List;

public interface MedicalRecordRepository extends JpaRepository<MedicalRecord, Long> {

    // Find all records for a specific pet
    List<MedicalRecord> findByPetId(Long petId);

    // Find records by pet ID and record type
    List<MedicalRecord> findByPetIdAndRecordType(Long petId, MedicalRecord.RecordType recordType);

    // Find records by record type
    List<MedicalRecord> findByRecordType(MedicalRecord.RecordType recordType);

    // Find upcoming due records (next due date is within X days)
    @Query("SELECT mr FROM MedicalRecord mr WHERE mr.nextDueDate IS NOT NULL AND mr.nextDueDate BETWEEN :startDate AND :endDate")
    List<MedicalRecord> findUpcomingDueRecords(
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );

    @Query("SELECT mr FROM MedicalRecord mr WHERE mr.nextDueDate IS NOT NULL AND mr.nextDueDate <= :today")
    List<MedicalRecord> findDueRecords(@Param("today") LocalDate today);
    @Query("SELECT mr FROM MedicalRecord mr " +
            "WHERE mr.pet.id = :petId " +
            "AND mr.nextDueDate IS NOT NULL " +
            "AND mr.nextDueDate >= :today " +
            "AND mr.nextDueDate <= :futureDate " +
            "ORDER BY mr.nextDueDate ASC")
    List<MedicalRecord> findUpcomingDueRecordsByPetId(
            @Param("petId") Long petId,
            @Param("today") LocalDate today,
            @Param("futureDate") LocalDate futureDate
    );
    // Find by veterinarian name
    List<MedicalRecord> findByVeterinarianContainingIgnoreCase(String veterinarian);

    // Find by clinic name
    List<MedicalRecord> findByClinicNameContainingIgnoreCase(String clinicName);

    // Find by medication name
    List<MedicalRecord> findByMedicationNameContainingIgnoreCase(String medicationName);
}