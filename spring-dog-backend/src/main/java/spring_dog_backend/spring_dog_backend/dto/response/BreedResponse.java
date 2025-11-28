package spring_dog_backend.spring_dog_backend.dto.response;

import lombok.Data;
import spring_dog_backend.spring_dog_backend.model.Breed;
import java.time.LocalDateTime;

@Data
public class BreedResponse {
    private Long id;
    private String name;
    private Breed.Species species;
    private String size;
    private String temperament;
    private String lifeExpectancy;
    private String origin;
    private String description;
    private String imageUrl;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}