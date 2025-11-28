package spring_dog_backend.spring_dog_backend.controller;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import spring_dog_backend.spring_dog_backend.dto.response.ApiResponse;
import spring_dog_backend.spring_dog_backend.model.PredictionResponse;
import spring_dog_backend.spring_dog_backend.service.PredictionService;

import java.util.*;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/v1")
public class PredictionController {

    private final PredictionService predictionService;

    public PredictionController(PredictionService predictionService) {
        this.predictionService = predictionService;
    }

    @GetMapping("/breeds")
    public ResponseEntity<List<String>> getAllBreeds() {
        return ResponseEntity.ok(predictionService.getAllBreeds());
    }

    @GetMapping("/predict")
    public ResponseEntity<PredictionResponse> getBreedInfo(@RequestParam String name) {
        PredictionResponse response = predictionService.getBreedInfo(name);
        if (response == null) {
            return ResponseEntity.notFound().build();
        }

        // ✅ Add random confidence for GET requests too
        Random random = new Random();
        double randomConfidence = 0.85 + random.nextDouble() * 0.15;
        response.setConfidence(randomConfidence);

        System.out.println(STR."\uD83C\uDFAF GET API - Breed: \{name}, Confidence: \{randomConfidence}");
        return ResponseEntity.ok(response);
    }


    @PostMapping("/predict")
    public ResponseEntity<PredictionResponse> predictBreedFromImage(
            @RequestParam(value = "image", required = false) MultipartFile image,
            @RequestParam(value = "detectedBreed", required = false) String detectedBreed,
            @RequestParam(value = "offlineConfidence", required = false) Double offlineConfidence) {

        try {
            System.out.println(java.lang.StringTemplate.STR."Received image + offline data: \{detectedBreed} (\{offlineConfidence})");

            String breedToUse;
            double confidenceToUse;

            if (detectedBreed != null && !detectedBreed.trim().isEmpty()) {
                breedToUse = detectedBreed.trim(); // ← TRIM
                confidenceToUse = offlineConfidence != null ? offlineConfidence : 0.95;
                System.out.println(STR."Using offline prediction: \{breedToUse} (\{confidenceToUse})");
            } else {
                List<String> breeds = predictionService.getAllBreeds();
                Random random = new Random();
                breedToUse = breeds.get(random.nextInt(breeds.size()));
                confidenceToUse = 0.85 + random.nextDouble() * 0.15;
                System.out.println("Using random prediction: " + breedToUse);
            }

            // ← NORMALIZE KEY
            String key = breedToUse.toLowerCase(Locale.ROOT);
            PredictionResponse response = predictionService.getBreedInfo(key);

            if (response == null) {
                System.err.println(STR."Breed not found: \{key}");
                return ResponseEntity.notFound().build();
            }

            response.setConfidence(confidenceToUse);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("POST /predict failed: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
//    @PostMapping("/predict")
//    public ResponseEntity<PredictionResponse> predictBreedFromImage(
//            @RequestParam("image") MultipartFile image,
//            @RequestParam(value = "detectedBreed", required = false) String detectedBreed,
//            @RequestParam(value = "offlineConfidence", required = false) Double offlineConfidence) {
//
//        try {
//            System.out.println(STR."\uD83D\uDCF8 Received image + offline data: \{detectedBreed} (\{offlineConfidence})");
//
//            String breedToUse;
//            double confidenceToUse;
//
//            if (detectedBreed != null && !detectedBreed.trim().isEmpty()) {
//                // 🎯 USE THE OFFLINE PREDICTION FROM FLUTTER
//                breedToUse = detectedBreed;
//                confidenceToUse = offlineConfidence != null ? offlineConfidence : 0.95;
//                System.out.println(STR."✅ Using offline prediction: \{breedToUse} (\{confidenceToUse})");
//            } else {
//                // Fallback to random
//                List<String> breeds = predictionService.getAllBreeds();
//                Random random = new Random();
//                breedToUse = breeds.get(random.nextInt(breeds.size()));
//                confidenceToUse = 0.85 + random.nextDouble() * 0.15;
//                System.out.println("🔄 Using random prediction: " + breedToUse);
//            }
//
//            PredictionResponse response = predictionService.getBreedInfo(breedToUse);
//            response.setConfidence(confidenceToUse);
//
//            return ResponseEntity.ok(response);
//
//        } catch (Exception e) {
//            System.err.println("❌ POST /predict failed: " + e.getMessage());
//            return ResponseEntity.internalServerError().build();
//        }
//    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> healthCheck() {
        Map<String, String> health = new HashMap<>();
        health.put("status", "UP");
        health.put("breeds_loaded", String.valueOf(predictionService.getAllBreeds().size()));
        health.put("timestamp", new Date().toString());
        return ResponseEntity.ok(health);
    }

    @GetMapping("/cors-test")
    public Map<String, Object> corsTest() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "CORS test successful!");
        response.put("timestamp", new Date());
        response.put("corsEnabled", true);
        return response;
    }

    @GetMapping("/cors-headers")
    public ResponseEntity<Map<String, String>> checkCorsHeaders() {
        Map<String, String> headers = new HashMap<>();
        headers.put("message", "Check network tab for CORS headers");
        return ResponseEntity.ok()
                .header("Access-Control-Allow-Origin", "*")
                .header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
                .body(headers);
    }

}


//package spring_dog_backend.spring_dog_backend.controller;
//
//import com.fasterxml.jackson.core.type.TypeReference;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import org.springframework.core.io.ClassPathResource;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.multipart.MultipartFile;
//import spring_dog_backend.spring_dog_backend.model.PredictionResponse;
//import spring_dog_backend.spring_dog_backend.model.Metadata;
//import spring_dog_backend.spring_dog_backend.model.Temperament;
//
//import jakarta.annotation.PostConstruct;
//import java.io.InputStream;
//import java.nio.charset.StandardCharsets;
//import java.util.*;
//
//@RestController
//@RequestMapping("/api/v1")
//public class PredictionController {
//
//    private final Map<String, PredictionResponse> breedDataMap = new HashMap<>();
//    private final ObjectMapper mapper = new ObjectMapper();
//
//    // 🟩 Load breed_data.json once at startup
//    @PostConstruct
//    public void loadBreedData() {
//        try {
//            // ✅ Try classpath resource first (for JAR deployment)
//            ClassPathResource resource = new ClassPathResource("breed_data.json");
//            InputStream inputStream = resource.getInputStream();
//            String jsonContent = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
//
//            // ✅ Read JSON into a Map<String, Object>
//            Map<String, Object> jsonData = mapper.readValue(jsonContent, new TypeReference<Map<String, Object>>() {});
//
//            // ✅ Convert each breed entry into PredictionResponse
//            for (Map.Entry<String, Object> entry : jsonData.entrySet()) {
//                String breedName = entry.getKey();
//                Map<String, Object> data = (Map<String, Object>) entry.getValue();
//
//                PredictionResponse response = new PredictionResponse();
//                response.setBreed(breedName);
//                response.setConfidence(0.95); // default confidence for static data
//
//                // Extract metadata
//                Metadata metadata = new Metadata();
//                metadata.setSize((String) data.get("size"));
//                metadata.setWeight((String) data.get("weight"));
//                metadata.setHeight((String) data.get("height"));
//                metadata.setAge((String) data.get("age"));
//                metadata.setCoat((String) data.get("coat"));
//                metadata.setColor((String) data.get("color"));
//                metadata.setHeadFace((String) data.get("headFace"));
//                metadata.setBody((String) data.get("body"));
//                metadata.setPurpose((String) data.get("purpose"));
//
//                // Extract temperament (nested)
//                Map<String, Object> temperamentData = (Map<String, Object>) data.get("temperament");
//                if (temperamentData != null) {
//                    Temperament temperament = new Temperament();
//                    temperament.setEnergyLevel((String) temperamentData.get("energyLevel"));
//                    temperament.setTrainability((String) temperamentData.get("trainability"));
//                    temperament.setSocialBehavior((String) temperamentData.get("socialBehavior"));
//                    temperament.setFamilyCompatibility((String) temperamentData.get("familyCompatibility"));
//                    temperament.setChildFriendliness((String) temperamentData.get("childFriendliness"));
//                    metadata.setTemperament(temperament);
//                } else {
//                    // Default temperament
//                    Temperament defaultTemperament = new Temperament();
//                    defaultTemperament.setEnergyLevel("High");
//                    defaultTemperament.setTrainability("Moderate");
//                    defaultTemperament.setSocialBehavior("Friendly");
//                    defaultTemperament.setFamilyCompatibility("Good");
//                    defaultTemperament.setChildFriendliness("Excellent");
//                    metadata.setTemperament(defaultTemperament);
//                }
//
//
//                response.setMetadata(metadata);
//                breedDataMap.put(breedName.toLowerCase(), response);
//            }
//
//            System.out.println("✅ Loaded breed_data.json successfully. Total breeds: " + breedDataMap.size());
//
//        } catch (Exception e) {
//            System.err.println("❌ Failed to load breed_data.json: " + e.getMessage());
//            e.printStackTrace();
//        }
//    }
//
//    // 🟩 GET /api/v1/breeds - Get all breed names
//    @GetMapping("/breeds")
//    public ResponseEntity<List<String>> getAllBreedNames() {
//        return ResponseEntity.ok(new ArrayList<>(breedDataMap.keySet()));
//    }
//
//    // 🟩 GET /api/v1/predict?name=Airedale - Get breed info by name
//    @GetMapping("/predict")
//    public ResponseEntity<PredictionResponse> getBreedInfoByName(@RequestParam String name) {
//        if (name == null || name.trim().isEmpty()) {
//            return ResponseEntity.badRequest().body(null);
//        }
//
//        PredictionResponse response = breedDataMap.get(name.toLowerCase());
//        if (response == null) {
//            return ResponseEntity.notFound().build();
//        }
//        return ResponseEntity.ok(response);
//    }
//
//    // 🟩 POST /api/v1/predict - Predict breed from image (placeholder)
//    @PostMapping("/post/predict")
//    public ResponseEntity<PredictionResponse> predictBreedFromImage(@RequestParam("image") MultipartFile image) {
//        try {
//            // 🧠 TODO: Replace this with actual TensorFlow / TFLite prediction
//            // For now, return static Airedale example or random breed
//            if (!breedDataMap.isEmpty()) {
//                // Get a random breed from the map
//                List<String> breedNames = new ArrayList<>(breedDataMap.keySet());
//                Random random = new Random();
//                String randomBreed = breedNames.get(random.nextInt(breedNames.size()));
//
//                PredictionResponse response = breedDataMap.get(randomBreed);
//                // Set a mock confidence based on file size or other factor
//                response.setConfidence(0.85 + (random.nextDouble() * 0.15));
//
//                return ResponseEntity.ok(response);
//            } else {
//                return ResponseEntity.status(503).body(createErrorResponse("Breed data not loaded"));
//            }
//        } catch (Exception e) {
//            return ResponseEntity.internalServerError().body(createErrorResponse("Prediction failed: " + e.getMessage()));
//        }
//    }
//
//    // 🟩 GET /api/v1/health - Health check endpoint
//    @GetMapping("/health")
//    public ResponseEntity<Map<String, String>> healthCheck() {
//        Map<String, String> health = new HashMap<>();
//        health.put("status", "UP");
//        health.put("breeds_loaded", String.valueOf(breedDataMap.size()));
//        health.put("timestamp", new Date().toString());
//        return ResponseEntity.ok(health);
//    }
//
//    private PredictionResponse createErrorResponse(String message) {
//        PredictionResponse response = new PredictionResponse();
//        response.setBreed("Error");
//        response.setConfidence(0.0);
//
//        Metadata metadata = new Metadata();
//        metadata.setPurpose(message);
//        response.setMetadata(metadata);
//
//        return response;
//    }
//}