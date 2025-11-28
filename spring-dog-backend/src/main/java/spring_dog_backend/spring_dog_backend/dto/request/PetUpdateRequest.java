package spring_dog_backend.spring_dog_backend.dto.request;

import lombok.Data;
import spring_dog_backend.spring_dog_backend.model.Pet;
import java.time.LocalDate;

@Data
public class PetUpdateRequest {
    private String name;
    private Pet.Species species;
    private Long breedId;
    private String customBreed;
    private LocalDate birthDate;
    private LocalDate adoptionDate;
    private Pet.Gender gender;
    private Double weight;
    private Pet.WeightUnit weightUnit;
    private String color;
    private String healthNotes;
    private String behaviorNotes;
}