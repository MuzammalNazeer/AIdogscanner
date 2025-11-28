package spring_dog_backend.spring_dog_backend.service;

import jakarta.validation.Valid;
import spring_dog_backend.spring_dog_backend.dto.request.PetRequest;
import spring_dog_backend.spring_dog_backend.dto.request.PetUpdateRequest;
import spring_dog_backend.spring_dog_backend.dto.response.PetResponse;
import spring_dog_backend.spring_dog_backend.model.Pet;
import spring_dog_backend.spring_dog_backend.model.User;
import spring_dog_backend.spring_dog_backend.model.Breed;
import spring_dog_backend.spring_dog_backend.exception.ResourceNotFoundException;
import spring_dog_backend.spring_dog_backend.repository.PetRepository;
import spring_dog_backend.spring_dog_backend.repository.UserRepository;
import spring_dog_backend.spring_dog_backend.repository.BreedRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.Period;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class PetService {

    @Autowired
    private PetRepository petRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BreedRepository breedRepository;

    public PetResponse createPet(@Valid PetRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + request.getUserId()));

        Pet pet = new Pet();
        pet.setUser(user);
        pet.setName(request.getName());
        pet.setSpecies(request.getSpecies());
        pet.setBirthDate(request.getBirthDate());
        pet.setAdoptionDate(request.getAdoptionDate());
        pet.setGender(request.getGender());
        pet.setWeight(request.getWeight());
        pet.setWeightUnit(request.getWeightUnit());
        pet.setColor(request.getColor());
        pet.setHealthNotes(request.getHealthNotes());
        pet.setBehaviorNotes(request.getBehaviorNotes());
        pet.setCustomBreed(request.getCustomBreed());

        // Set breed if provided
        if (request.getBreedId() != null) {
            Breed breed = breedRepository.findById(request.getBreedId())
                    .orElseThrow(() -> new ResourceNotFoundException("Breed not found with id: " + request.getBreedId()));
            pet.setBreed(breed);
        }

        Pet savedPet = petRepository.save(pet);
        return convertToResponse(savedPet);
    }

    public PetResponse getPetById(Long id) {
        Pet pet = petRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Pet not found with id: " + id));
        return convertToResponse(pet);
    }

    public PetResponse getPetByIdAndUserId(Long id, Long userId) {
        Pet pet = petRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Pet not found with id: " + id + " for user: " + userId));
        return convertToResponse(pet);
    }

    public List<PetResponse> getPetsByUserId(Long userId) {
        if (!userRepository.existsById(userId)) {
            throw new ResourceNotFoundException("User not found with id: " + userId);
        }

        return petRepository.findByUserId(userId)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public List<PetResponse> getPetsByUserIdAndSpecies(Long userId, Pet.Species species) {
        return petRepository.findByUserIdAndSpecies(userId, species)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public List<PetResponse> searchPetsByName(Long userId, String name) {
        return petRepository.findByUserIdAndNameContainingIgnoreCase(userId, name)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public PetResponse updatePet(Long id, PetUpdateRequest request) {
        Pet pet = petRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Pet not found with id: " + id));

        if (request.getName() != null) pet.setName(request.getName());
        if (request.getSpecies() != null) pet.setSpecies(request.getSpecies());
        if (request.getBirthDate() != null) pet.setBirthDate(request.getBirthDate());
        if (request.getAdoptionDate() != null) pet.setAdoptionDate(request.getAdoptionDate());
        if (request.getGender() != null) pet.setGender(request.getGender());
        if (request.getWeight() != null) pet.setWeight(request.getWeight());
        if (request.getWeightUnit() != null) pet.setWeightUnit(request.getWeightUnit());
        if (request.getColor() != null) pet.setColor(request.getColor());
        if (request.getHealthNotes() != null) pet.setHealthNotes(request.getHealthNotes());
        if (request.getBehaviorNotes() != null) pet.setBehaviorNotes(request.getBehaviorNotes());
        if (request.getCustomBreed() != null) pet.setCustomBreed(request.getCustomBreed());

        // Update breed if provided
        if (request.getBreedId() != null) {
            Breed breed = breedRepository.findById(request.getBreedId())
                    .orElseThrow(() -> new ResourceNotFoundException("Breed not found with id: " + request.getBreedId()));
            pet.setBreed(breed);
        } else if (request.getBreedId() == null) {
            pet.setBreed(null);
        }

        Pet updatedPet = petRepository.save(pet);
        return convertToResponse(updatedPet);
    }

    public void deletePet(Long id) {
        if (!petRepository.existsById(id)) {
            throw new ResourceNotFoundException("Pet not found with id: " + id);
        }
        petRepository.deleteById(id);
    }

    public void deletePetByUser(Long id, Long userId) {
        if (!petRepository.existsByIdAndUserId(id, userId)) {
            throw new ResourceNotFoundException("Pet not found with id: " + id + " for user: " + userId);
        }
        petRepository.deleteById(id);
    }

    public Long getPetCountByUser(Long userId) {
        return petRepository.countByUserId(userId);
    }

    private PetResponse convertToResponse(Pet pet) {
        PetResponse response = new PetResponse();
        response.setId(pet.getId());
        response.setUserId(pet.getUser().getId());

        // Fixed: Use proper getter methods for user name
        String userName = pet.getUser().getFullName();
        if (pet.getUser().getFullName() != null) {
            userName += " " + pet.getUser().getFullName();
        }
        response.setUserName(userName);

        response.setName(pet.getName());
        response.setSpecies(pet.getSpecies());
        response.setBirthDate(pet.getBirthDate());
        response.setAdoptionDate(pet.getAdoptionDate());
        response.setGender(pet.getGender());
        response.setWeight(pet.getWeight());
        response.setWeightUnit(pet.getWeightUnit());
        response.setColor(pet.getColor());
        response.setHealthNotes(pet.getHealthNotes());
        response.setBehaviorNotes(pet.getBehaviorNotes());
        response.setCustomBreed(pet.getCustomBreed());
        response.setCreatedAt(pet.getCreatedAt());
        response.setUpdatedAt(pet.getUpdatedAt());

        // Set breed information
        if (pet.getBreed() != null) {
            response.setBreedId(pet.getBreed().getId());
            response.setBreedName(pet.getBreed().getName());
        }

        // Calculate age
        if (pet.getBirthDate() != null) {
            calculateAge(response, pet.getBirthDate());
        }

        return response;
    }

    private void calculateAge(PetResponse response, LocalDate birthDate) {
        LocalDate today = LocalDate.now();
        Period period = Period.between(birthDate, today);

        response.setAgeInYears(period.getYears());
        response.setAgeInMonths(period.getMonths());

        long totalMonths = ChronoUnit.MONTHS.between(birthDate, today);
        if (totalMonths < 12) {
            response.setDisplayAge(totalMonths + " months");
        } else {
            response.setDisplayAge(period.getYears() + " years, " + period.getMonths() + " months");
        }
    }
}