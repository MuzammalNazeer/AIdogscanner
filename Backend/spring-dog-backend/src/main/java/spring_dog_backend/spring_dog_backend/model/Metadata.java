package spring_dog_backend.spring_dog_backend.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Metadata {
    private String size;
    private String weight;
    private String height;
    private String age;
    private String coat;
    private String color;
    private String headFace;
    private String body;
    private String purpose;

    @JsonProperty("temperament")
    private Temperament temperament;


}
