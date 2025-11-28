// src/main/java/com/petcare/repository/FavoriteBreedRepository.java
package spring_dog_backend.spring_dog_backend.repository;

import spring_dog_backend.spring_dog_backend.model.FavoriteBreed;
import spring_dog_backend.spring_dog_backend.model.User;
import spring_dog_backend.spring_dog_backend.model.Breed;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavoriteBreedRepository extends JpaRepository<FavoriteBreed, Long> {

    // Find all favorites for a user
    List<FavoriteBreed> findByUserOrderByAddedAtDesc(User user);

    // Check if a breed is already favorited by user
    boolean existsByUserAndBreed(User user, Breed breed);

    // Find specific favorite by user and breed
    Optional<FavoriteBreed> findByUserAndBreed(User user, Breed breed);

    // Count favorites for a user
    long countByUser(User user);

    // Find favorites with breed details eagerly loaded
    @Query("SELECT fb FROM FavoriteBreed fb JOIN FETCH fb.breed WHERE fb.user = :user")
    List<FavoriteBreed> findByUserWithBreedDetails(@Param("user") User user);

    // Delete favorite by user and breed
    void deleteByUserAndBreed(User user, Breed breed);
}