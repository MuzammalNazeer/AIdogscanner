package spring_dog_backend.spring_dog_backend.dto.response;

import lombok.Data;
import spring_dog_backend.spring_dog_backend.dto.request.ReminderRequest;
import spring_dog_backend.spring_dog_backend.exception.ResourceNotFoundException;
import spring_dog_backend.spring_dog_backend.model.Reminder;

import java.time.LocalDateTime;

@Data
public class ReminderResponse {

    private Long id;

    private Long petId;
    private String petName;

    private Long categoryId;
    private String categoryName;

    private String subcategory;
    private String title;
    private String description;

    private LocalDateTime dueDateTime;
    private Reminder.RepeatPattern repeatPattern;
    private Integer repeatInterval;
    private Reminder.Priority priority;

    private Boolean isCompleted;
    private LocalDateTime completedAt;

    private String notes;
    private String customData;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;



    private ReminderResponse mapToResponse(Reminder reminder) {
        if (reminder == null) {
            return null;
        }

        ReminderResponse response = new ReminderResponse();
        response.setId(reminder.getId());
        response.setPetId(reminder.getPet().getId());
        response.setPetName(reminder.getPet().getName());
        response.setCategoryId(reminder.getCategory().getId());
        response.setCategoryName(reminder.getCategory().getName());
        response.setSubcategory(reminder.getSubcategory());
        response.setTitle(reminder.getTitle());
        response.setDescription(reminder.getDescription());
        response.setDueDateTime(reminder.getDueDateTime());
        response.setRepeatPattern(reminder.getRepeatPattern());
        response.setRepeatInterval(reminder.getRepeatInterval());
        response.setPriority(reminder.getPriority());
        response.setIsCompleted(reminder.getIsCompleted());
        response.setCompletedAt(reminder.getCompletedAt());
        response.setNotes(reminder.getNotes());
        response.setCustomData(reminder.getCustomData());
        response.setCreatedAt(reminder.getCreatedAt());
        response.setUpdatedAt(reminder.getUpdatedAt());

        return response;
    }}

