package spring_dog_backend.spring_dog_backend.dto.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import spring_dog_backend.spring_dog_backend.model.Reminder;

import java.time.LocalDateTime;

@Data
public class ReminderRequest {

    @NotNull(message = "Pet ID is required")
    @JsonProperty("petId")
    private Long petId;

    @NotNull(message = "Category ID is required")
    @JsonProperty("categoryId")
    private Long categoryId;

    @NotBlank(message = "Title is required")
    @JsonProperty("title")
    private String title;

    @NotNull(message = "Due date time is required")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    @JsonProperty("dueDateTime")
    private LocalDateTime dueDateTime;

    @JsonProperty("description")
    private String description;

    @JsonProperty("priority")
    private Reminder.Priority priority = Reminder.Priority.MEDIUM;

    @JsonProperty("repeatPattern")
    private Reminder.RepeatPattern repeatPattern = Reminder.RepeatPattern.NONE;

    @JsonProperty("notes")
    private String notes;

    @JsonProperty("subcategory")
    private String subcategory;

    @JsonProperty("repeatInterval")
    private Integer repeatInterval = 1;

    @JsonProperty("customData")
    private String customData;
}

//package spring_dog_backend.spring_dog_backend.dto.request;
//
//import com.fasterxml.jackson.annotation.JsonFormat;
//import jakarta.validation.constraints.NotBlank;
//import jakarta.validation.constraints.NotNull;
//import lombok.Data;
//import spring_dog_backend.spring_dog_backend.model.Reminder;
//
//import java.time.LocalDateTime;
//
//@Data
//public class ReminderRequest {
//
//    @NotNull(message = "Pet ID is required")
//    private Long petId;
//
//    @NotNull(message = "Category ID is required")
//    private Long categoryId;
//
//    @NotBlank(message = "Title is required")
//    private String title;
//
//    @NotNull(message = "Due date time is required")
//    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")  // <-- important
//    private LocalDateTime dueDateTime;
//
//    private String description;
//
//    private Reminder.Priority priority;
//
//    private Reminder.RepeatPattern repeatPattern;
//
//    private String notes;
//
//    private String subcategory;
//
//    private Integer repeatInterval = 1;
//
//    private String customData;
//}
//
//
////package spring_dog_backend.spring_dog_backend.dto.request;
////
////import lombok.Data;
////import spring_dog_backend.spring_dog_backend.model.Reminder;
////
////import jakarta.validation.constraints.NotBlank;
////import jakarta.validation.constraints.NotNull;
////import java.time.LocalDateTime;
////
////@Data
////public class     ReminderRequest {
////
////    @NotNull(message = "Pet ID is required")
////    private Long petId;
////
////    @NotNull(message = "Category ID is required")
////    private Long categoryId;
////
////    private String subcategory;
////
////    @NotBlank(message = "Title is required")
////    private String title;
////
////    private String description;
////
////    @NotNull(message = "Due date time is required")
////    private LocalDateTime dueDateTime;
////
////    private Reminder.RepeatPattern repeatPattern = Reminder.RepeatPattern.NONE;
////
////    private Integer repeatInterval = 1;
////
////    private Reminder.Priority priority = Reminder.Priority.MEDIUM;
////
////    private String notes;
////
////    private String customData;
////}
////
//////package spring_dog_backend.spring_dog_backend.dto.request;
//////
//////import lombok.Data;
//////import spring_dog_backend.spring_dog_backend.model.Reminder;
//////
//////import jakarta.validation.constraints.NotBlank;
//////import jakarta.validation.constraints.NotNull;
//////import java.time.LocalDateTime;
//////
//////@Data
//////public class ReminderRequest {
//////
//////    @NotNull(message = "Pet ID is required")
//////    private Long petId;
//////
//////    @NotNull(message = "Category ID is required")
//////    private Long categoryId;
//////
//////    private String subcategory;
//////
//////    @NotBlank(message = "Title is required")
//////    private String title;
//////
//////    private String description;
//////
//////    @NotNull(message = "Due date time is required")
//////    private LocalDateTime dueDateTime;
//////
//////    private Reminder.RepeatPattern repeatPattern = Reminder.RepeatPattern.NONE;
//////
//////    private Integer repeatInterval = 1;
//////
//////    private Reminder.Priority priority = Reminder.Priority.MEDIUM;
//////
//////    private String notes;
//////
//////    private String customData;
//////}