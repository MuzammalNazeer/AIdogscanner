package spring_dog_backend.spring_dog_backend.dto.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import spring_dog_backend.spring_dog_backend.exception.FlexibleLocalDateDeserializer;
import spring_dog_backend.spring_dog_backend.model.CleaningLog;

import java.time.LocalDate;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateCleaningLogRequest {

    @JsonProperty("itemType")
    private CleaningLog.ItemType itemType;

    @JsonProperty("cleanedAt")
    @JsonDeserialize(using = FlexibleLocalDateDeserializer.class)
    private LocalDate cleanedAt;

    @JsonProperty("cleaningMethod")
    private String cleaningMethod;

    @JsonProperty("cleaningProducts")
    private Map<String, Object> cleaningProducts;

    @JsonProperty("notes")
    private String notes;

    @JsonProperty("nextDueDate")
    @JsonDeserialize(using = FlexibleLocalDateDeserializer.class)
    private LocalDate nextDueDate;
}