package spring_dog_backend.spring_dog_backend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import org.jetbrains.annotations.NotNull;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "reminders")
public class Reminder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    private Pet pet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private ReminderCategory category;

    private String subcategory;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;


    @Enumerated(EnumType.STRING)
    @Column(name = "repeat_pattern")
    private RepeatPattern repeatPattern = RepeatPattern.NONE;

    @Column(name = "repeat_interval")
    private Integer repeatInterval = 1;

    @Enumerated(EnumType.STRING)
    private Priority priority = Priority.MEDIUM;

    @Column(name = "is_completed")
    private Boolean isCompleted = false;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "custom_data", columnDefinition = "TEXT")
    private String customData;

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

    public enum RepeatPattern {
        NONE, DAILY, WEEKLY, MONTHLY, YEARLY
    }

    public enum Priority {
        LOW, MEDIUM, HIGH, CRITICAL
    }

    @Column(name = "due_datetime", nullable = false)
    @NotNull
    private LocalDateTime dueDateTime;

}

