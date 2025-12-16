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
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id")
    private Pet pet;

    @Column(name = "cleaned_at")
    private LocalDateTime cleanedAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "item_type", nullable = false)
    private ItemType itemType;

    @Column(name = "cleaning_method")
    private String cleaningMethod;

    @Column(name = "cleaning_products", columnDefinition = "TEXT")
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

    // Keep ONLY these 5 values
    public enum ItemType {
        FOOD_PLATE,
        BED,
        TOYS,
        WATER_FOUNTAIN,
        LEASH_COLLAR
    }
}

//package spring_dog_backend.spring_dog_backend.model;
//
//import jakarta.persistence.*;
//import lombok.AllArgsConstructor;
//import lombok.Builder;
//import lombok.Data;
//import lombok.NoArgsConstructor;
//import org.hibernate.annotations.CreationTimestamp;
//import org.hibernate.annotations.UpdateTimestamp;
//
//import java.time.LocalDate;
//import java.time.LocalDateTime;
//
//@Data
//@Builder
//@NoArgsConstructor
//@AllArgsConstructor
//@Entity
//@Table(name = "cleaning_logs")
//public class CleaningLog {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private Integer  id;
//
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "pet_id")
//    private Pet pet;
//
//    @Column(name = "cleaned_at")
//    private LocalDateTime cleanedAt;
//
//    @Enumerated(EnumType.STRING)
//    @Column(name = "item_type", nullable = false)
//    private ItemType itemType;
//
//    @Column(name = "cleaning_method")
//    private String cleaningMethod;
//
//    @Column(name = "cleaning_products", columnDefinition = "TEXT")
//    private String cleaningProducts;
//
//    @Column(name = "notes", columnDefinition = "TEXT")
//    private String notes;
//
//    @Column(name = "next_due_date")
//    private LocalDate nextDueDate;
//
//    @CreationTimestamp
//    @Column(name = "created_at", updatable = false)
//    private LocalDateTime createdAt;
//
//    @UpdateTimestamp
//    @Column(name = "updated_at")
//    private LocalDateTime updatedAt;
//
//    public enum ItemType {
//        FOOD_PLATE, BED, TOYS, WATER_FOUNTAIN, LEASH_COLLAR
//    }
//}
//
//
