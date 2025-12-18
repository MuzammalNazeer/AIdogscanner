package spring_dog_backend.spring_dog_backend.exception;

public class MedicalRecordNotFoundException extends RuntimeException {
    public MedicalRecordNotFoundException(Long id) {
        super(STR."Medical record not found with id: \{id}");
    }

    public MedicalRecordNotFoundException(String message) {
        super(message);
    }
}