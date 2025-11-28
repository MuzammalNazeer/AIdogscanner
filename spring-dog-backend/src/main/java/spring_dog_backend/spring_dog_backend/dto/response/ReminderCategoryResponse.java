package spring_dog_backend.spring_dog_backend.dto.response;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ReminderCategoryResponse {
    private Long id;
    private String name;
    private String description;
    private String color;
    private String icon;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}