package spring_dog_backend.spring_dog_backend.repository;

import spring_dog_backend.spring_dog_backend.model.ReminderCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReminderCategoryRepository extends JpaRepository<ReminderCategory, Long> {

    Optional<ReminderCategory> findByName(String name);

    List<ReminderCategory> findByIsActiveTrue();

    boolean existsByName(String name);
}