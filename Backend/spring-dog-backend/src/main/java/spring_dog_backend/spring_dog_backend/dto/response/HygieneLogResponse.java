package spring_dog_backend.spring_dog_backend.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import spring_dog_backend.spring_dog_backend.model.HygieneLog;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HygieneLogResponse {

    @JsonProperty("id")
    private Long id;

    @JsonProperty("petId")
    private Long petId;

    @JsonProperty("petName")
    private String petName;

    @JsonProperty("activityType")
    private HygieneLog.ActivityType activityType;

    @JsonProperty("performedAt")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime performedAt;

    @JsonProperty("durationMinutes")
    private Integer durationMinutes;

    @JsonProperty("productsUsed")
    private Map<String, String> productsUsed;

    @JsonProperty("toolsUsed")
    private Map<String, String> toolsUsed;

    @JsonProperty("notes")
    private String notes;

    @JsonProperty("nextRecommendedDate")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate nextRecommendedDate;

    @JsonProperty("cost")
    private Double cost;

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
//import spring_dog_backend.spring_dog_backend.model.HygieneLog;
//
//import java.time.LocalDateTime;
//import java.util.Date;
//
//@Data
//@NoArgsConstructor
//@AllArgsConstructor
//public class HygieneLogResponse {
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
//    @JsonProperty("activityType")
//    private HygieneLog.ActivityType activityType;
//
//    @JsonProperty("performedAt")
//    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
//    private LocalDateTime performedAt;
//
//    @JsonProperty("durationMinutes")
//    private Integer durationMinutes;
//
//    // Change from Map to Object
//    @JsonProperty("productsUsed")
//    private Object productsUsed;
//
//    @JsonProperty("toolsUsed")
//    private Object toolsUsed;
//
//    @JsonProperty("notes")
//    private String notes;
//
//    @JsonProperty("nextRecommendedDate")
//    @JsonFormat(pattern = "yyyy-MM-dd")
//    private Date nextRecommendedDate;
//
//    @JsonProperty("cost")
//    private Double cost;
//
//    @JsonProperty("createdAt")
//    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
//    private LocalDateTime createdAt;
//}

//package spring_dog_backend.spring_dog_backend.dto.response;
//
//import com.fasterxml.jackson.annotation.JsonFormat;
//import com.fasterxml.jackson.annotation.JsonProperty;
//import lombok.AllArgsConstructor;
//import lombok.Data;
//import lombok.NoArgsConstructor;
//import spring_dog_backend.spring_dog_backend.model.HygieneLog;
//
//import java.time.LocalDateTime;
//import java.util.Date;
//import java.util.Map;
//
//@Data
//@NoArgsConstructor
//@AllArgsConstructor
//public class HygieneLogResponse {
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
//    @JsonProperty("activityType")
//    private HygieneLog.ActivityType activityType;
//
//    @JsonProperty("performedAt")
//    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
//    private LocalDateTime performedAt;
//
//    @JsonProperty("durationMinutes")
//    private Integer durationMinutes;
//
//    @JsonProperty("productsUsed")
//    private Map<String, Object> productsUsed;
//
//    @JsonProperty("toolsUsed")
//    private Map<String, Object> toolsUsed;
//
//    @JsonProperty("notes")
//    private String notes;
//
//    @JsonProperty("nextRecommendedDate")
//    @JsonFormat(pattern = "yyyy-MM-dd")
//    private Date nextRecommendedDate;
//
//    @JsonProperty("cost")
//    private Double cost;
//
//    @JsonProperty("createdAt")
//    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
//    private LocalDateTime createdAt;
//}
//
