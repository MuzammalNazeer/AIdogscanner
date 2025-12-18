package spring_dog_backend.spring_dog_backend.dto.response;
import lombok.Data;
import spring_dog_backend.spring_dog_backend.model.MedicalRecord.RecordType;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class MedicalRecordResponse {
    private Long id;
    private Long petId;
    private String petName;
    private RecordType recordType;
    private String subtype;
    private String title;
    private LocalDate administeredDate;
    private LocalDate nextDueDate;
    private String veterinarian;
    private String clinicName;
    private String dosage;
    private String medicationName;
    private String frequency;
    private String duration;
    private String notes;
    private Double cost;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}