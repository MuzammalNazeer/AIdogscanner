package spring_dog_backend.spring_dog_backend.dto.request;

import lombok.Data;
import spring_dog_backend.spring_dog_backend.model.Reminder;

import java.time.LocalDateTime;

@Data
public class ReminderUpdateRequest {

    private String title;
    private String description;
    private LocalDateTime dueDateTime;
    private Reminder.RepeatPattern repeatPattern;
    private Integer repeatInterval;
    private Reminder.Priority priority;
    private Boolean isCompleted;
    private String notes;
    private String customData;
}

