// src/main/java/com/petcare/dto/response/FavoriteBreedResponse.java
package spring_dog_backend.spring_dog_backend.dto.response;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class FavoriteBreedResponse {
    // Getters and Setters
    private Long id;
    private Long breedId;
    private String breedName;
    private String breedGroup;
    private String notes;
    private LocalDateTime addedAt;

}