package spring_dog_backend.spring_dog_backend.model;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class ItemTypeConverter implements AttributeConverter<CleaningLog.ItemType, String> {

    @Override
    public String convertToDatabaseColumn(CleaningLog.ItemType attribute) {
        return attribute != null ? attribute.name() : null;
    }

    @Override
    public CleaningLog.ItemType convertToEntityAttribute(String dbData) {
        if (dbData == null) return null;

        // Normalize the input
        String normalized = dbData.trim().toUpperCase().replace(' ', '_');

        // Handle legacy values
        switch (normalized) {
            case "FOOD_BOWL":
            case "BOWL":
                return CleaningLog.ItemType.FOOD_PLATE;
            case "WATER_BOWL":
            case "FOUNTAIN":
                return CleaningLog.ItemType.WATER_FOUNTAIN;
            case "LEASH":
            case "COLLAR":
                return CleaningLog.ItemType.LEASH_COLLAR;
            default:
                try {
                    return CleaningLog.ItemType.valueOf(normalized);
                } catch (IllegalArgumentException e) {
                    throw new IllegalArgumentException(STR."Unknown item type: \{dbData} (normalized: \{normalized})");
                }
        }
    }
}