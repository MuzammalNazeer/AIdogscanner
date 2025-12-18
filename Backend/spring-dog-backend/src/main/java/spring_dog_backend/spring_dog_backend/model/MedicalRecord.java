package spring_dog_backend.spring_dog_backend.model;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "medical_records")
@Data
public class MedicalRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    private Pet pet;

    @Enumerated(EnumType.STRING)
    @Column(name = "record_type", nullable = false)
    private RecordType recordType;

    @Column(name = "subtype")
    private String subtype;

    @Column(name = "title", nullable = false)
    private String title;

    @NotNull(message = "Administered date is required")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate administeredDate;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate nextDueDate;

    @Column(name = "veterinarian")
    private String veterinarian;

    @Column(name = "clinic_name")
    private String clinicName;

    @Column(name = "dosage")
    private String dosage;

    @Column(name = "medication_name")
    private String medicationName;

    @Column(name = "frequency")
    private String frequency;

    @Column(name = "duration")
    private String duration;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "cost")
    private Double cost;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public enum RecordType {
        VACCINATION,
        MEDICATION,
        DEWORMING,
        ALLERGY,
        SURGERY,
        INJURY,
        CHRONIC_CONDITION
    }
}