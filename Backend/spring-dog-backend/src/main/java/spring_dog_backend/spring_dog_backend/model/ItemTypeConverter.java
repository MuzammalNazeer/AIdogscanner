package spring_dog_backend.spring_dog_backend.model;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Converter(autoApply = true)
public class ItemTypeConverter implements AttributeConverter<CleaningLog.ItemType, String> {

    public static final Logger log = LoggerFactory.getLogger(ItemTypeConverter.class);

    @Override
    public String convertToDatabaseColumn(CleaningLog.ItemType itemType) {
        if (itemType == null) {
            return null;
        }
        return itemType.name();
    }

    @Override
    public CleaningLog.ItemType convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.trim().isEmpty()) {
            return null;
        }

        String normalized = dbData.trim().toUpperCase();
        log.debug("Converting item_type from database: '{}' (normalized: '{}')", dbData, normalized);

        try {
            // First try exact match
            return CleaningLog.ItemType.valueOf(normalized);
        } catch (IllegalArgumentException e) {
            log.debug("Failed exact match for '{}', trying to map...", normalized);

            // Map FOOD_BOWL to FOOD_PLATE (they're essentially the same)
            switch (normalized) {
                case "FOOD_BOWL":
                case "FOODBOWL":
                    log.info("Mapping '{}' to FOOD_PLATE", dbData);
                    return CleaningLog.ItemType.FOOD_PLATE;

                case "FOOD_PLATE":
                case "FOODPLATE":
                    return CleaningLog.ItemType.FOOD_PLATE;

                case "BED":
                case "DOGBED":
                case "DOG_BED":
                    return CleaningLog.ItemType.BED;

                case "TOYS":
                case "TOY":
                case "DOGTOYS":
                case "DOG_TOYS":
                    return CleaningLog.ItemType.TOYS;

                case "WATER_FOUNTAIN":
                case "WATERFOUNTAIN":
                case "WATER_BOWL":
                case "WATERBOWL":
                    return CleaningLog.ItemType.WATER_FOUNTAIN;

                case "LEASH_COLLAR":
                case "LEASHCOLLAR":
                case "LEASH":
                case "COLLAR":
                    return CleaningLog.ItemType.LEASH_COLLAR;

                default:
                    log.error("Cannot convert item_type '{}' to any known enum value. Defaulting to FOOD_PLATE.", dbData);
                    // Instead of throwing exception, return a default value
                    return CleaningLog.ItemType.FOOD_PLATE;
            }
        }
    }
}

