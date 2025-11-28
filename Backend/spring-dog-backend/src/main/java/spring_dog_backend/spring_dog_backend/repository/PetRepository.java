package spring_dog_backend.spring_dog_backend.repository;

import spring_dog_backend.spring_dog_backend.model.Pet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PetRepository extends JpaRepository<Pet, Long> {

    List<Pet> findByUserId(Long userId);

    List<Pet> findByUserIdAndSpecies(Long userId, Pet.Species species);

    Optional<Pet> findByIdAndUserId(Long id, Long userId);

    @Query("SELECT p FROM Pet p WHERE p.user.id = :userId AND LOWER(p.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Pet> findByUserIdAndNameContainingIgnoreCase(@Param("userId") Long userId, @Param("name") String name);

    @Query("SELECT COUNT(p) FROM Pet p WHERE p.user.id = :userId")
    Long countByUserId(@Param("userId") Long userId);

    @Query("SELECT p FROM Pet p WHERE p.user.id = :userId AND p.birthDate IS NOT NULL ORDER BY p.birthDate DESC")
    List<Pet> findRecentPetsByUserId(@Param("userId") Long userId);

    boolean existsByIdAndUserId(Long id, Long userId);
}