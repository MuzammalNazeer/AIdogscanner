package spring_dog_backend.spring_dog_backend.repository;

import spring_dog_backend.spring_dog_backend.model.Reminder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ReminderRepository extends JpaRepository<Reminder, Long> {

    List<Reminder> findByPetIdOrderByDueDateTimeAsc(Long petId);

    List<Reminder> findByIsCompletedFalseAndDueDateTimeBefore(LocalDateTime dateTime);

    List<Reminder> findByCategoryId(Long categoryId);

    // Fixed: Use "user" instead of "owner" since Pet has a "user" field, not "owner"
    @Query("SELECT r FROM Reminder r WHERE r.pet.user.id = :userId AND r.isCompleted = false AND r.dueDateTime BETWEEN :start AND :end ORDER BY r.dueDateTime ASC")
    List<Reminder> findUpcomingRemindersByUser(@Param("userId") Long userId,
                                               @Param("start") LocalDateTime start,
                                               @Param("end") LocalDateTime end);

    // Fixed: Use "user" instead of "owner"
    @Query("SELECT r FROM Reminder r WHERE r.pet.user.id = :userId AND r.isCompleted = false AND r.dueDateTime >= :now ORDER BY r.dueDateTime ASC")
    List<Reminder> findUpcomingRemindersByUser(@Param("userId") Long userId, @Param("now") LocalDateTime now);

    // Simple method to get all reminders for a user
    @Query("SELECT r FROM Reminder r WHERE r.pet.user.id = :userId ORDER BY r.dueDateTime ASC")
    List<Reminder> findByUserId(@Param("userId") Long userId);
}