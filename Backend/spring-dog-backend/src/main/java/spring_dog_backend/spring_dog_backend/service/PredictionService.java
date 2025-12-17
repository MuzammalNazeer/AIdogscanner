package spring_dog_backend.spring_dog_backend.service;

import org.springframework.stereotype.Service;

import spring_dog_backend.spring_dog_backend.model.Metadata;
import spring_dog_backend.spring_dog_backend.model.PredictionResponse;
import spring_dog_backend.spring_dog_backend.model.Temperament;
import spring_dog_backend.spring_dog_backend.utils.BreedDataLoader;

import java.util.List;
import java.util.Map;

@Service
public class PredictionService {

    private final BreedDataLoader breedDataLoader;

    public PredictionService(BreedDataLoader breedDataLoader) {
        this.breedDataLoader = breedDataLoader;
    }

    public PredictionResponse getBreedInfo(String breedName) {
        System.out.println(STR."\uD83D\uDD0D PredictionService looking for breed: \{breedName}");

        Map<String, Object> breedInfo = breedDataLoader.getBreedInfo(breedName);
        if (breedInfo == null) {
            System.out.println(STR."❌ Breed not found in JSON data: \{breedName}");
            return null;
        }

        System.out.println(STR."✅ Found breed in JSON, creating response for: \{breedName}");

        Metadata metadata = new Metadata();
        metadata.setSize((String) breedInfo.get("size"));
        metadata.setWeight((String) breedInfo.get("weight"));
        metadata.setHeight((String) breedInfo.get("height"));
        metadata.setAge((String) breedInfo.get("age"));
        metadata.setCoat((String) breedInfo.get("coat"));
        metadata.setColor((String) breedInfo.get("color"));
        metadata.setHeadFace((String) breedInfo.get("headFace"));
        metadata.setBody((String) breedInfo.get("body"));
        metadata.setPurpose((String) breedInfo.get("purpose"));

        // Handle temperament
        Map<String, Object> temperamentData = (Map<String, Object>) breedInfo.get("temperament");
        Temperament temperament = new Temperament();
        if (temperamentData != null) {
            temperament.setEnergyLevel((String) temperamentData.getOrDefault("energyLevel", "High"));
            temperament.setTrainability((String) temperamentData.getOrDefault("trainability", "Moderate"));
            temperament.setSocialBehavior((String) temperamentData.getOrDefault("socialBehavior", "Friendly"));
            temperament.setFamilyCompatibility((String) temperamentData.getOrDefault("familyCompatibility", "Good"));
            temperament.setChildFriendliness((String) temperamentData.getOrDefault("childFriendliness", "Excellent"));
        } else {
            // Default temperament
            temperament.setEnergyLevel("High");
            temperament.setTrainability("Moderate");
            temperament.setSocialBehavior("Friendly");
            temperament.setFamilyCompatibility("Good");
            temperament.setChildFriendliness("Excellent");
        }

        metadata.setTemperament(temperament);

        PredictionResponse response = new PredictionResponse();
        response.setBreed(breedName);
        response.setConfidence(0.95);
        response.setMetadata((Metadata) metadata);
        response.setSource("json");

        System.out.println(STR."✅ Successfully created PredictionResponse for: \{breedName}");
        return response;
    }

    public List<String> getAllBreeds() {
        List<String> breeds = breedDataLoader.getAllBreedNames();
        System.out.println(STR." PredictionService returning \{breeds.size()} breeds from JSON");
        return breeds;
    }

    // Add diagnostic method
    public boolean isJsonDataLoaded() {
        return breedDataLoader.isDataLoaded();
    }

    public int getJsonBreedCount() {
        return breedDataLoader.getLoadedBreedCount();
    }
}


//package spring_dog_backend.spring_dog_backend.service;
//
//import org.springframework.stereotype.Service;
//import spring_dog_backend.spring_dog_backend.model.Metadata;
//import spring_dog_backend.spring_dog_backend.model.PredictionResponse;
//import spring_dog_backend.spring_dog_backend.model.Temperament;
//import spring_dog_backend.spring_dog_backend.utils.BreedDataLoader;
//
//import java.util.LinkedHashMap;
//import java.util.List;
//import java.util.Map;
//
//@Service
//public class PredictionService {
//
//    private final BreedDataLoader breedDataLoader;
//
//    public PredictionService(BreedDataLoader breedDataLoader) {
//        this.breedDataLoader = breedDataLoader;
//    }
//
//    public PredictionResponse getBreedInfo(String breedName) {
//        Map<String, Object> breedInfo = breedDataLoader.getBreedInfo(breedName);
//        if (breedInfo == null) {
//            return null;
//        }
//
//        Metadata metadata = new Metadata();
//        metadata.setSize((String) breedInfo.get("size"));
//        metadata.setWeight((String) breedInfo.get("weight"));
//        metadata.setHeight((String) breedInfo.get("height"));
//        metadata.setAge((String) breedInfo.get("age"));
//        metadata.setCoat((String) breedInfo.get("coat"));
//        metadata.setColor((String) breedInfo.get("color"));
//        metadata.setHeadFace((String) breedInfo.get("headFace"));
//        metadata.setBody((String) breedInfo.get("body"));
//        metadata.setPurpose((String) breedInfo.get("purpose"));
//
//        // Handle temperament
//        Map<String, Object> temperamentData = (Map<String, Object>) breedInfo.get("temperament");
//        Temperament temperament = new Temperament();
//        if (temperamentData != null) {
//            temperament.setEnergyLevel((String) temperamentData.getOrDefault("energyLevel", "High"));
//            temperament.setTrainability((String) temperamentData.getOrDefault("trainability", "Moderate"));
//            temperament.setSocialBehavior((String) temperamentData.getOrDefault("socialBehavior", "Friendly"));
//            temperament.setFamilyCompatibility((String) temperamentData.getOrDefault("familyCompatibility", "Good"));
//            temperament.setChildFriendliness((String) temperamentData.getOrDefault("childFriendliness", "Excellent"));
//        } else {
//            // Default temperament
//            temperament.setEnergyLevel("High");
//            temperament.setTrainability("Moderate");
//            temperament.setSocialBehavior("Friendly");
//            temperament.setFamilyCompatibility("Good");
//            temperament.setChildFriendliness("Excellent");
//        }
//
//        metadata.setTemperament(temperament);
//
//        PredictionResponse response = new PredictionResponse();
//        response.setBreed(breedName);        // ✅ Use setBreed
//        response.setConfidence(0.95);        // ✅ Use setConfidence
//        response.setMetadata(metadata);
//
//        return response;
//    }
//
//    public List<String> getAllBreeds() {
//        return breedDataLoader.getAllBreedNames();
//    }
//}
//
