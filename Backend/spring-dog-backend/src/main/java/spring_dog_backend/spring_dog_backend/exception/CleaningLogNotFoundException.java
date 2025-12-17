package spring_dog_backend.spring_dog_backend.exception;

public class CleaningLogNotFoundException extends RuntimeException {
    public CleaningLogNotFoundException(Long id) {  // Only accepts Long
        super("Cleaning log not found with id: " + id);
    }
}