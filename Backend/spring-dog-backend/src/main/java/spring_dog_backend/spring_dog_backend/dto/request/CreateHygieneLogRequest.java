package spring_dog_backend.spring_dog_backend.dto.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import spring_dog_backend.spring_dog_backend.model.HygieneLog;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateHygieneLogRequest {

    @NotNull(message = "Pet ID is required")
    @JsonProperty("petId")
    private Long petId;

    @NotNull(message = "Activity type is required")
    @JsonProperty("activityType")
    private HygieneLog.ActivityType activityType;

    @NotNull(message = "Performed date is required")
    @JsonProperty("performedAt")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime performedAt;

    @JsonProperty("durationMinutes")
    private Integer durationMinutes;

    @JsonProperty("productsUsed")
    private Map<String, String> productsUsed;

    @JsonProperty("toolsUsed")
    private Map<String, String> toolsUsed;

    @JsonProperty("notes")
    private String notes;

    @JsonProperty("nextRecommendedDate")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate nextRecommendedDate;

    @JsonProperty("cost")
    private Double cost;
}
