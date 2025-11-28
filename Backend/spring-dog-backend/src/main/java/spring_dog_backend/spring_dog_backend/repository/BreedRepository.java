package spring_dog_backend.spring_dog_backend.repository;

import spring_dog_backend.spring_dog_backend.model.Breed;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BreedRepository extends JpaRepository<Breed, Long> {

    List<Breed> findBySpecies(Breed.Species species);

    Optional<Breed> findByName(String name);

    @Query("SELECT b FROM Breed b WHERE LOWER(b.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Breed> findByNameContainingIgnoreCase(@Param("name") String name);

    @Query("SELECT b FROM Breed b WHERE b.species = :species AND LOWER(b.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Breed> findBySpeciesAndNameContainingIgnoreCase(@Param("species") Breed.Species species, @Param("name") String name);

    boolean existsByName(String name);

    @Query("SELECT b FROM Breed b ORDER BY b.name ASC")
    List<Breed> findAllOrderByName();
}