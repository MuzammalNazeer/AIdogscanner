package spring_dog_backend.spring_dog_backend.exception;

public class CleaningLogNotFoundException extends RuntimeException {
    public CleaningLogNotFoundException(Long logId) {
        super("Cleaning log not found with id: " + logId);
    }
}
