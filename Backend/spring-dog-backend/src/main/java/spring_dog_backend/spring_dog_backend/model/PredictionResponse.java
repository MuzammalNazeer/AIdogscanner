package spring_dog_backend.spring_dog_backend.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PredictionResponse {
    private String breed;
    private Double confidence;
    private Metadata metadata;
    private String source; // Add this field to track data source

    // Constructors
    public PredictionResponse() {}

    // Change parameter type from Map<String, Object> to Metadata
    public PredictionResponse(String breed, Double confidence, Metadata metadata) {
        this.breed = breed;
        this.confidence = confidence;
        this.metadata = metadata;
    }

    public PredictionResponse(String breed, Double confidence, Metadata metadata, String source) {
        this.breed = breed;
        this.confidence = confidence;
        this.metadata = metadata;
        this.source = source;
    }

    @Override
    public String toString() {
        return STR."PredictionResponse{breed='\{breed}', confidence=\{confidence}, source='\{source}', metadata=\{metadata != null ? metadata.toString() : "null"}}";
    }
}

//package spring_dog_backend.spring_dog_backend.model;
//
//import lombok.Getter;
//import lombok.Setter;
//
//import java.util.Map;
//
//@Getter
//@Setter
//public class PredictionResponse {
//    private String breed;
//    private Double confidence;
//    private Map<String, Object> metadata;
//    private String source; // Add this field to track data source
//
//    // Constructors
//    public PredictionResponse() {}
//
//    public PredictionResponse(String breed, Double confidence, Map<String, Object> metadata) {
//        this.breed = breed;
//        this.confidence = confidence;
//        this.metadata = metadata;
//    }
//
//    public PredictionResponse(String breed, Double confidence, Map<String, Object> metadata, String source) {
//        this.breed = breed;
//        this.confidence = confidence;
//        this.metadata = metadata;
//        this.source = source;
//    }
//
//    @Override
//    public String toString() {
//        return STR."PredictionResponse{breed='\{breed}', confidence=\{confidence}, source='\{source}', metadata=\{metadata != null ? metadata.keySet() : "null"}}";
//    }
//}
//
//
////package spring_dog_backend.spring_dog_backend.model;
////
////import lombok.Data;
////
////@Data
////public class PredictionResponse {
////    private String breed;
////    private double confidence;
////    private Metadata metadata;
////}