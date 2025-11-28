package spring_dog_backend.spring_dog_backend.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Temperament {
    @JsonProperty("Energy Level")
    private String energyLevel;

    @JsonProperty("Trainability")
    private String trainability;

    @JsonProperty("Social Behavior")
    private String socialBehavior;

    @JsonProperty("Family Compatibility")
    private String familyCompatibility;

    @JsonProperty("Child Friendliness")
    private String childFriendliness;
}
