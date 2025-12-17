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


