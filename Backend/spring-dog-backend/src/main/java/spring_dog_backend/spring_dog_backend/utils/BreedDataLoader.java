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


