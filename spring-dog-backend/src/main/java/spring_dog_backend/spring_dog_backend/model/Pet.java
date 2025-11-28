package spring_dog_backend.spring_dog_backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "pets")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Pet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, length = 100)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Species species;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "breed_id")
    private Breed breed;

    @Column(name = "custom_breed", length = 100)
    private String customBreed;

    private LocalDate birthDate;
    private LocalDate adoptionDate;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    private Double weight;

    @Enumerated(EnumType.STRING)
    @Column(name = "weight_unit")
    private WeightUnit weightUnit = WeightUnit.KG;

    private String color;

    @Column(name = "health_notes", columnDefinition = "TEXT")
    private String healthNotes;

    @Column(name = "behavior_notes", columnDefinition = "TEXT")
    private String behaviorNotes;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public enum Species { DOG, CAT, BIRD, RABBIT, OTHER }
    public enum Gender { MALE, FEMALE, UNKNOWN }
    public enum WeightUnit { KG, LBS }
}


//package spring_dog_backend.spring_dog_backend.model;
//
//import lombok.Data;
//import lombok.NoArgsConstructor;
//import lombok.AllArgsConstructor;
//
//import jakarta.persistence.*;
//import java.time.LocalDate;
//import java.time.LocalDateTime;
//
//@Data
//@NoArgsConstructor
//@AllArgsConstructor
//@Entity
//@Table(name = "pets")
//public class Pet {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private Long id;
//
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "user_id", nullable = false)  // This matches your database schema
//    private User user;  // This is the field name used in the JPQL queries
//
//    // ... rest of the fields remain the same
//    @Column(nullable = false, length = 100)
//    private String name;
//
//    @Enumerated(EnumType.STRING)
//    @Column(nullable = false)
//    private Species species;
//
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "breed_id")
//    private Breed breed;
//
//    @Column(name = "custom_breed", length = 100)
//    private String customBreed;
//
//    @Column(name = "birth_date")
//    private LocalDate birthDate;
//
//    @Column(name = "adoption_date")
//    private LocalDate adoptionDate;
//
//    @Enumerated(EnumType.STRING)
//    private Gender gender;
//
//    private Double weight;
//
//    @Enumerated(EnumType.STRING)
//    @Column(name = "weight_unit")
//    private WeightUnit weightUnit = WeightUnit.KG;
//
//    private String color;
//
//    @Column(name = "health_notes", columnDefinition = "TEXT")
//    private String healthNotes;
//
//    @Column(name = "behavior_notes", columnDefinition = "TEXT")
//    private String behaviorNotes;
//
//    @Column(name = "created_at")
//    private LocalDateTime createdAt;
//
//    @Column(name = "updated_at")
//    private LocalDateTime updatedAt;
//
//    @PrePersist
//    protected void onCreate() {
//        createdAt = LocalDateTime.now();
//        updatedAt = LocalDateTime.now();
//    }
//
//    @PreUpdate
//    protected void onUpdate() {
//        updatedAt = LocalDateTime.now();
//    }
//
//    public enum Species {
//        DOG, CAT, BIRD, RABBIT, OTHER
//    }
//
//    public enum Gender {
//        MALE, FEMALE, UNKNOWN
//    }
//
//    public enum WeightUnit {
//        KG, LBS
//    }
//}