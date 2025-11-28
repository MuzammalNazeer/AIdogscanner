// src/main/java/com/petcare/dto/request/FavoriteBreedRequest.java
package spring_dog_backend.spring_dog_backend.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class FavoriteBreedRequest {

    @NotNull(message = "Breed ID is required")
    @JsonProperty("breedId")
    private Long breedId;

    private String notes;

}