package spring_dog_backend.spring_dog_backend.exception;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class FlexibleLocalDateDeserializer extends JsonDeserializer<LocalDate> {

    private static final DateTimeFormatter[] formatters = {
            DateTimeFormatter.ISO_LOCAL_DATE,
            DateTimeFormatter.ofPattern("yyyy-MM-dd"),
            DateTimeFormatter.ISO_LOCAL_DATE_TIME,
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss"),
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
    };

    @Override
    public LocalDate deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        String dateString = p.getValueAsString();

        for (DateTimeFormatter formatter : formatters) {
            try {
                if (formatter.equals(DateTimeFormatter.ISO_LOCAL_DATE_TIME) ||
                        formatter.equals(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss")) ||
                        formatter.equals(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))) {
                    // For datetime strings, extract just the date part
                    LocalDateTime dateTime = LocalDateTime.parse(dateString, formatter);
                    return dateTime.toLocalDate();
                } else {
                    // For date strings, parse directly
                    return LocalDate.parse(dateString, formatter);
                }
            } catch (DateTimeParseException e) {
                // Try next formatter
            }
        }

        throw new IllegalArgumentException("Could not parse date: " + dateString);
    }
}