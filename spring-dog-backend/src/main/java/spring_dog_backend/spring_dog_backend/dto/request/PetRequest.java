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

//package spring_dog_backend.spring_dog_backend.dto.request;
//
//import spring_dog_backend.spring_dog_backend.model.Pet;
//
//import jakarta.validation.constraints.NotBlank;
//import jakarta.validation.constraints.NotNull;
//import java.time.LocalDate;
//import java.util.Objects;
//
//public class PetRequest {
//
//    @NotNull(message = "User ID is required")
//    private Long userId;
//
//    @NotBlank(message = "Pet name is required")
//    private String name;
//
//    @NotNull(message = "Species is required")
//    private Pet.Species species;
//
//    private Long breedId;
//    private String customBreed;
//    private LocalDate birthDate;
//    private LocalDate adoptionDate;
//    private Pet.Gender gender;
//    private Double weight;
//    private Pet.WeightUnit weightUnit;
//    private String color;
//    private String healthNotes;
//    private String behaviorNotes;
//
//    // Default constructor
//    public PetRequest() {}
//
//    // Getters and Setters
//    public Long getUserId() { return userId; }
//    public void setUserId(Long userId) { this.userId = userId; }
//
//    public String getName() { return name; }
//    public void setName(String name) { this.name = name; }
//
//    public Pet.Species getSpecies() { return species; }
//    public void setSpecies(Pet.Species species) { this.species = species; }
//
//    public Long getBreedId() { return breedId; }
//    public void setBreedId(Long breedId) { this.breedId = breedId; }
//
//    public String getCustomBreed() { return customBreed; }
//    public void setCustomBreed(String customBreed) { this.customBreed = customBreed; }
//
//    public LocalDate getBirthDate() { return birthDate; }
//    public void setBirthDate(LocalDate birthDate) { this.birthDate = birthDate; }
//
//    public LocalDate getAdoptionDate() { return adoptionDate; }
//    public void setAdoptionDate(LocalDate adoptionDate) { this.adoptionDate = adoptionDate; }
//
//    public Pet.Gender getGender() { return gender; }
//    public void setGender(Pet.Gender gender) { this.gender = gender; }
//
//    public Double getWeight() { return weight; }
//    public void setWeight(Double weight) { this.weight = weight; }
//
//    public Pet.WeightUnit getWeightUnit() { return weightUnit; }
//    public void setWeightUnit(Pet.WeightUnit weightUnit) { this.weightUnit = weightUnit; }
//
//    public String getColor() { return color; }
//    public void setColor(String color) { this.color = color; }
//
//    public String getHealthNotes() { return healthNotes; }
//    public void setHealthNotes(String healthNotes) { this.healthNotes = healthNotes; }
//
//    public String getBehaviorNotes() { return behaviorNotes; }
//    public void setBehaviorNotes(String behaviorNotes) { this.behaviorNotes = behaviorNotes; }
//
//    // toString for debugging
//    @Override
//    public String toString() {
//        return "PetRequest{" +
//                "userId=" + userId +
//                ", name='" + name + '\'' +
//                ", species=" + species +
//                ", breedId=" + breedId +
//                ", customBreed='" + customBreed + '\'' +
//                ", birthDate=" + birthDate +
//                ", adoptionDate=" + adoptionDate +
//                ", gender=" + gender +
//                ", weight=" + weight +
//                ", weightUnit=" + weightUnit +
//                ", color='" + color + '\'' +
//                ", healthNotes='" + healthNotes + '\'' +
//                ", behaviorNotes='" + behaviorNotes + '\'' +
//                '}';
//    }
//
//    // equals and hashCode
//    @Override
//    public boolean equals(Object o) {
//        if (this == o) return true;
//        if (o == null || getClass() != o.getClass()) return false;
//        PetRequest that = (PetRequest) o;
//        return Objects.equals(userId, that.userId) &&
//                Objects.equals(name, that.name) &&
//                species == that.species &&
//                Objects.equals(breedId, that.breedId) &&
//                Objects.equals(customBreed, that.customBreed) &&
//                Objects.equals(birthDate, that.birthDate) &&
//                Objects.equals(adoptionDate, that.adoptionDate) &&
//                gender == that.gender &&
//                Objects.equals(weight, that.weight) &&
//                weightUnit == that.weightUnit &&
//                Objects.equals(color, that.color) &&
//                Objects.equals(healthNotes, that.healthNotes) &&
//                Objects.equals(behaviorNotes, that.behaviorNotes);
//    }
//
//    @Override
//    public int hashCode() {
//        return Objects.hash(userId, name, species, breedId, customBreed, birthDate, adoptionDate, gender, weight, weightUnit, color, healthNotes, behaviorNotes);
//    }
//}
//
////package spring_dog_backend.spring_dog_backend.dto.request;
////
////import lombok.Data;
////import spring_dog_backend.spring_dog_backend.model.Pet;
////
////import jakarta.validation.constraints.NotBlank;
////import jakarta.validation.constraints.NotNull;
////import java.time.LocalDate;
////
////@Data
////public class PetRequest {
////
////    @NotNull(message = "User ID is required")
////    private Long userId;
////
////    @NotBlank(message = "Pet name is required")
////    private String name;
////
////    @NotNull(message = "Species is required")
////    private Pet.Species species;
////
////    private Long breedId;
////    private String customBreed;
////    private LocalDate birthDate;
////    private LocalDate adoptionDate;
////    private Pet.Gender gender;
////    private Double weight;
////    private Pet.WeightUnit weightUnit;
////    private String color;
////    private String healthNotes;
////    private String behaviorNotes;
////}