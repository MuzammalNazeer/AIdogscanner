package spring_dog_backend.spring_dog_backend.dto.request;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import spring_dog_backend.spring_dog_backend.model.MedicalRecord;
import java.time.LocalDate;

@Getter
@Setter
@ToString
public class MedicalRecordRequest {

    @JsonProperty("petId")
    private Long petId;

    @JsonProperty("recordType")
    private MedicalRecord.RecordType recordType;

    @JsonProperty("subtype")
    private String subtype;

    @JsonProperty("title")
    private String title;

    @JsonProperty("administeredDate")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate administeredDate;

    @JsonProperty("nextDueDate")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate nextDueDate;

    @JsonProperty("veterinarian")
    private String veterinarian;

    @JsonProperty("clinicName")
    private String clinicName;

    @JsonProperty("dosage")
    private String dosage;

    @JsonProperty("medicationName")
    private String medicationName;

    @JsonProperty("frequency")
    private String frequency;

    @JsonProperty("duration")
    private String duration;

    @JsonProperty("notes")
    private String notes;

    @JsonProperty("cost")
    private Double cost;

    // Constructor for Jackson
    @JsonCreator
    public MedicalRecordRequest(
            @JsonProperty("petId") Long petId,
            @JsonProperty("recordType") MedicalRecord.RecordType recordType,
            @JsonProperty("title") String title,
            @JsonProperty("administeredDate") LocalDate administeredDate) {
        this.petId = petId;
        this.recordType = recordType;
        this.title = title;
        this.administeredDate = administeredDate;
    }

    // Default constructor
    public MedicalRecordRequest() {
    }
}


