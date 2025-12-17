package spring_dog_backend.spring_dog_backend.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import jakarta.validation.constraints.NotNull;
import spring_dog_backend.spring_dog_backend.model.Pet;

import java.time.LocalDate;

@Setter
@Getter


public class PetRequest {

    // Getters and Setters
    @NotNull(message = "User ID is required")
    @JsonProperty("userId")
    private Long userId;

    @NotBlank(message = "Pet name is required")
    @JsonProperty("name")
    private String name;

    @NotNull(message = "Species is required")
    @JsonProperty("species")
    private Pet.Species species;

    @JsonProperty("breedId")
    private Long breedId;

    @JsonProperty("customBreed")
    private String customBreed;

    @JsonProperty("birthDate")
    private LocalDate birthDate;

    @JsonProperty("adoptionDate")
    private LocalDate adoptionDate;

    @JsonProperty("gender")
    private Pet.Gender gender;

    @JsonProperty("weight")
    private Double weight;

    @JsonProperty("weightUnit")
    private Pet.WeightUnit weightUnit;

    @JsonProperty("color")
    private String color;

    @JsonProperty("healthNotes")
    private String healthNotes;

    @JsonProperty("behaviorNotes")
    private String behaviorNotes;

    // Default constructor
    public PetRequest() {}

}
