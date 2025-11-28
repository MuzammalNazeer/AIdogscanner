package spring_dog_backend.spring_dog_backend.utils;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.*;

@Component
public class BreedDataLoader {

    private final Map<String, Map<String, Object>> breedDataMap = new HashMap<>();
    private final ObjectMapper mapper = new ObjectMapper();
    private boolean dataLoaded = false;

    @PostConstruct
    public void loadBreedData() {
        try {
            System.out.println("🟢 Attempting to load breed_data.json...");

            ClassPathResource resource = new ClassPathResource("breed_data.json");

            if (!resource.exists()) {
                System.err.println("❌ breed_data.json not found in classpath!");
                return;
            }

            System.out.println("✅ Found breed_data.json");

            try (InputStream inputStream = resource.getInputStream()) {
                String jsonContent = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);

                // Read JSON into a Map
                Map<String, Object> jsonData = mapper.readValue(jsonContent, new TypeReference<Map<String, Object>>() {});

                // Store each breed's data
                for (Map.Entry<String, Object> entry : jsonData.entrySet()) {
                    String breedName = entry.getKey();
                    Map<String, Object> breedInfo = (Map<String, Object>) entry.getValue();
                    breedDataMap.put(breedName.toLowerCase(), breedInfo);
                }

                dataLoaded = true;
                System.out.println("✅ Successfully loaded " + breedDataMap.size() + " breeds from breed_data.json");
                System.out.println("📋 Available breeds: " + breedDataMap.keySet());

            } catch (Exception e) {
                System.err.println("❌ Error parsing breed_data.json: " + e.getMessage());
                e.printStackTrace();
            }

        } catch (Exception e) {
            System.err.println("❌ Failed to load breed_data.json: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public Map<String, Object> getBreedInfo(String breedName) {
        if (!dataLoaded) {
            System.err.println("⚠️ breed_data.json not loaded, cannot get breed info for: " + breedName);
            return null;
        }

        if (breedName == null || breedName.trim().isEmpty()) {
            return null;
        }

        String key = breedName.toLowerCase().trim();
        Map<String, Object> breedInfo = breedDataMap.get(key);

        if (breedInfo == null) {
            System.out.println("❌ Breed not found in JSON: " + key);
            System.out.println("📋 Available JSON breeds: " + breedDataMap.keySet());
        } else {
            System.out.println("✅ Found breed in JSON: " + key);
        }

        return breedInfo;
    }

    public List<String> getAllBreedNames() {
        if (!dataLoaded) {
            System.err.println("⚠️ breed_data.json not loaded, returning empty list");
            return new ArrayList<>();
        }
        return new ArrayList<>(breedDataMap.keySet());
    }

    public boolean isDataLoaded() {
        return dataLoaded;
    }

    public int getLoadedBreedCount() {
        return breedDataMap.size();
    }
}

//package spring_dog_backend.spring_dog_backend.utils;
//
//import com.fasterxml.jackson.core.type.TypeReference;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import lombok.Getter;
//import org.springframework.core.io.ClassPathResource;
//import org.springframework.stereotype.Component;
//
//import jakarta.annotation.PostConstruct;
//import java.io.InputStream;
//import java.nio.charset.StandardCharsets;
//import java.sql.*;
//import java.util.*;
//
//@Getter
//@Component
//public class BreedDataLoader {
//
//    private final Map<String, Map<String, Object>> breedData = new HashMap<>();
//
//    @PostConstruct
//    public void loadBreedData() {
//        boolean dbLoaded = false;
//
//        try (Connection conn = DriverManager.getConnection(
//                "jdbc:mysql://localhost:3306/petcare_management?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
//                "root", "root123")) {
//
//            Statement stmt = conn.createStatement();
//            ResultSet rs = stmt.executeQuery("SELECT * FROM breeds");
//
//            while (rs.next()) {
//                String name = rs.getString("name").toLowerCase();
//                Map<String, Object> info = new HashMap<>();
//                info.put("size", rs.getString("size"));
//                info.put("weight", rs.getString("weight"));
//                info.put("height", rs.getString("height"));
//                info.put("age", rs.getString("age"));
//                info.put("coat", rs.getString("coat"));
//                info.put("color", rs.getString("color"));
//                info.put("headFace", rs.getString("headFace"));
//                info.put("body", rs.getString("body"));
//                info.put("purpose", rs.getString("purpose"));
//                breedData.put(name, info);
//            }
//
//            if (!breedData.isEmpty()) {
//                System.out.println("✅ Loaded " + breedData.size() + " breeds from DB");
//                dbLoaded = true;
//            }
//
//        } catch (Exception e) {
//            System.err.println("⚠️ DB not found or invalid: " + e.getMessage());
//        }
//
//        // --- JSON fallback ---
//        if (!dbLoaded) {
//            try {
//                System.out.println("📦 Loading fallback: breed_data.json...");
//                ClassPathResource resource = new ClassPathResource("breed_data.json");
//                InputStream inputStream = resource.getInputStream();
//                String jsonContent = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
//
//                ObjectMapper mapper = new ObjectMapper();
//                Map<String, Map<String, Object>> breeds = mapper.readValue(
//                        jsonContent, new TypeReference<>() {}
//                );
//
//                breeds.forEach((name, info) -> breedData.put(name.toLowerCase(), info));
//                System.out.println("✅ Loaded " + breedData.size() + " breeds from breed_data.json");
//
//            } catch (Exception e) {
//                System.err.println("❌ Failed to load breed_data.json: " + e.getMessage());
//            }
//        }
//    }
//
//    public Map<String, Object> getBreedInfo(String breedName) {
//        return breedData.get(breedName.toLowerCase());
//    }
//
//    public List<String> getAllBreedNames() {
//        return new ArrayList<>(breedData.keySet());
//    }
//}
//
//
//
