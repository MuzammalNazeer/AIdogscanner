package spring_dog_backend.spring_dog_backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "cleaning_logs")
public class CleaningLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;  // Matches SQL: id INT PRIMARY KEY AUTO_INCREMENT

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    private Pet pet;

    @Column(name = "cleaned_at", nullable = false)
    private LocalDateTime cleanedAt;

    @Column(name = "item_type", nullable = false)
    @Convert(converter = ItemTypeConverter.class, attributeName = "itemType")
    private ItemType itemType;

    @Column(name = "cleaning_method", length = 100)
    private String cleaningMethod;

    @Column(name = "cleaning_products", columnDefinition = "JSON")
    private String cleaningProducts;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "next_due_date")
    private LocalDate nextDueDate;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Updated to match SQL ENUM
    public enum ItemType {
        FOOD_PLATE,
        FOOD_BOWL,
        BED,
        TOYS,
        WATER_FOUNTAIN,
        LEASH_COLLAR
    }
}



