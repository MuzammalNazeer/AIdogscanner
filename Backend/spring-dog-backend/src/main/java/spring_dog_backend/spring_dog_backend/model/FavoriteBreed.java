// src/main/java/com/petcare/entity/FavoriteBreed.java
package spring_dog_backend.spring_dog_backend.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "favourite_breeds",
        uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "breed_id"}))
public class FavoriteBreed {

    // Getters and Setters
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "breed_id", nullable = false)
    private Breed breed;

    @CreationTimestamp
    @Column(name = "added_at", updatable = false)
    private LocalDateTime addedAt;

    @Column(columnDefinition = "TEXT")
    private String notes;

    // Constructors
    public FavoriteBreed() {}

    public FavoriteBreed(User user, Breed breed, String notes) {
        this.user = user;
        this.breed = breed;
        this.notes = notes;
    }

}