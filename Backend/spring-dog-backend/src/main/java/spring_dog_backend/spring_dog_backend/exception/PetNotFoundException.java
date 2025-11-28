package spring_dog_backend.spring_dog_backend.exception;

public class PetNotFoundException extends RuntimeException {
    public PetNotFoundException(Long petId) {
        super("Pet not found with id: " + petId);
    }
}

