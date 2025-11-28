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
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    private Pet pet;

    @Enumerated(EnumType.STRING)
    @Column(name = "item_type", nullable = false)
    private ItemType itemType;

    @Column(name = "cleaned_at", nullable = false)
    private LocalDate cleanedAt;

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

    public enum ItemType {
        BOWL, TOY, BED, CRATE, COLLAR, LEASH, BRUSH, OTHER
    }
}

//package spring_dog_backend.spring_dog_backend.model;
//
//import com.fasterxml.jackson.annotation.JsonProperty;
//import jakarta.persistence.*;
//import lombok.AllArgsConstructor;
//import lombok.Builder;
//import lombok.Data;
//import lombok.NoArgsConstructor;
//import org.hibernate.annotations.CreationTimestamp;
//
//import java.time.LocalDateTime;
//import java.util.Date;
//
//@Entity
//@Table(name = "cleaning_logs")
//@Data
//@Builder
//@NoArgsConstructor
//@AllArgsConstructor
//public class CleaningLog {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private Long id;
//
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "pet_id", nullable = false)
//    private Pet pet;
//
//    @Enumerated(EnumType.STRING)
//    @Column(name = "item_type", nullable = false)
//    private ItemType itemType;
//
//    @Column(name = "cleaned_at", nullable = false)
//    private LocalDateTime cleanedAt;
//
//    @Column(name = "cleaning_method")
//    private String cleaningMethod;
//
//    @JsonProperty("cleaningProducts")
//    private Object cleaningProducts;
//
//    @Column(name = "notes", columnDefinition = "TEXT")
//    private String notes;
//
//    @Column(name = "next_due_date")
//    private Date nextDueDate;
//
//    @CreationTimestamp
//    @Column(name = "created_at", updatable = false)
//    private LocalDateTime createdAt;
//
//    public enum ItemType {
//        FOOD_PLATE, BED, TOYS, WATER_FOUNTAIN, LEASH_COLLAR
//    }
//}