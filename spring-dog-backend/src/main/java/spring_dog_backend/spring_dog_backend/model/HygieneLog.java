package spring_dog_backend.spring_dog_backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Table(name = "hygiene_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HygieneLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    private Pet pet;

    @Enumerated(EnumType.STRING)
    @Column(name = "activity_type", nullable = false)
    private ActivityType activityType;

    @Column(name = "performed_at", nullable = false)
    private LocalDateTime performedAt;

    @Column(name = "duration_minutes")
    private Integer durationMinutes;

    // Change from Map to String for JSON fields
    @Column(name = "products_used", columnDefinition = "json")
    private String productsUsed;

    @Column(name = "tools_used", columnDefinition = "json")
    private String toolsUsed;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "next_recommended_date")
    private LocalDate nextRecommendedDate;

    @Column(name = "cost")
    private Double cost;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;





    public enum ActivityType {
        BATH,
        GROOMING,
        EARS_CLEANING,
        TEETH_BRUSHING,
        NAIL_CLIPPING
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
//import org.hibernate.annotations.JdbcTypeCode;
//import org.hibernate.type.SqlTypes;
//
//import java.time.LocalDateTime;
//import java.util.Date;
//import java.util.Map;
//
//@Entity
//@Table(name = "hygiene_logs")
//@Data
//@Builder
//@NoArgsConstructor
//@AllArgsConstructor
//public class HygieneLog {
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
//    @Column(name = "activity_type", nullable = false)
//    private ActivityType activityType;
//
//    @Column(name = "performed_at", nullable = false)
//    private LocalDateTime performedAt;
//
//    @Column(name = "duration_minutes")
//    private Integer durationMinutes;
//
//    @Column(name = "products_used", columnDefinition = "json")
//    @JdbcTypeCode(SqlTypes.JSON)
//    private Map<String, Object> productsUsed;
//
//    @Column(name = "tools_used", columnDefinition = "json")
//    @JdbcTypeCode(SqlTypes.JSON)
//    private Map<String, Object> toolsUsed;
//
//    @Column(name = "notes", columnDefinition = "TEXT")
//    private String notes;
//
//    @Column(name = "next_recommended_date")
//    private Date nextRecommendedDate;
//
//    @Column(name = "cost")
//    private Double cost;
//
//    @CreationTimestamp
//    @Column(name = "created_at", updatable = false)
//    private LocalDateTime createdAt;
//
//    public enum ActivityType {
//        BATH, GROOMING, EARS_CLEANING, TEETH_BRUSHING, NAIL_CLIPPING
//    }
//}