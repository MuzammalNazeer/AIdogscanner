package spring_dog_backend.spring_dog_backend.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import spring_dog_backend.spring_dog_backend.model.CleaningLog;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CleaningLogResponse {

    @JsonProperty("id")
    private Long id;

    @JsonProperty("petId")
    private Long petId;

    @JsonProperty("petName")
    private String petName;

    @JsonProperty("itemType")
    private CleaningLog.ItemType itemType;

    @JsonProperty("cleanedAt")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate cleanedAt;

    @JsonProperty("cleaningMethod")
    private String cleaningMethod;

    @JsonProperty("cleaningProducts")
    private Map<String, Object> cleaningProducts;

    @JsonProperty("notes")
    private String notes;

    @JsonProperty("nextDueDate")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate nextDueDate;

    @JsonProperty("createdAt")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime createdAt;
}


//package spring_dog_backend.spring_dog_backend.dto.response;
//
//import com.fasterxml.jackson.annotation.JsonFormat;
//import com.fasterxml.jackson.annotation.JsonProperty;
//import lombok.AllArgsConstructor;
//import lombok.Data;
//import lombok.NoArgsConstructor;
//import spring_dog_backend.spring_dog_backend.model.CleaningLog;
//
//import java.time.LocalDate;
//import java.time.LocalDateTime;
//import java.util.Date;
//import java.util.Map;
//
//@Data
//@NoArgsConstructor
//@AllArgsConstructor
//public class CleaningLogResponse {
//
//    @JsonProperty("id")
//    private Long id;
//
//    @JsonProperty("petId")
//    private Long petId;
//
//    @JsonProperty("petName")
//    private String petName;
//
//    @JsonProperty("itemType")
//    private CleaningLog.ItemType itemType;
//
//    @JsonProperty("cleanedAt")
//    @JsonFormat(pattern = "yyyy-MM-dd")
//    private LocalDate cleanedAt;
//
//    @JsonProperty("cleaningMethod")
//    private String cleaningMethod;
//
//    @JsonProperty("cleaningProducts")
//    private Map<String, Object> cleaningProducts;
//
//    @JsonProperty("notes")
//    private String notes;
//
//    @JsonProperty("nextDueDate")
//    @JsonFormat(pattern = "yyyy-MM-dd")
//    private LocalDate nextDueDate;
//
//    @JsonProperty("createdAt")
//    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
//    private LocalDateTime createdAt;
//}