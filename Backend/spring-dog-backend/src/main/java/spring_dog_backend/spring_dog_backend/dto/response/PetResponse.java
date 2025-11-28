package spring_dog_backend.spring_dog_backend.dto.response;

import lombok.Data;
import spring_dog_backend.spring_dog_backend.model.Pet;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class PetResponse {
    private Long id;
    private Long userId;
    private String userName;
    private String name;
    private Pet.Species species;
    private Long breedId;
    private String breedName;
    private String customBreed;
    private LocalDate birthDate;
    private LocalDate adoptionDate;
    private Pet.Gender gender;
    private Double weight;
    private Pet.WeightUnit weightUnit;
    private String color;
    private String healthNotes;
    private String behaviorNotes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Calculated fields
    private Integer ageInYears;
    private Integer ageInMonths;
    private String displayAge;
}