package spring_dog_backend.spring_dog_backend.service;

import spring_dog_backend.spring_dog_backend.dto.response.BreedResponse;
import spring_dog_backend.spring_dog_backend.model.Breed;
import spring_dog_backend.spring_dog_backend.exception.ResourceNotFoundException;
import spring_dog_backend.spring_dog_backend.repository.BreedRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class BreedService {

    @Autowired
    private BreedRepository breedRepository;

    public List<BreedResponse> getAllBreeds() {
        return breedRepository.findAllOrderByName()
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public List<BreedResponse> getBreedsBySpecies(Breed.Species species) {
        return breedRepository.findBySpecies(species)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public BreedResponse getBreedById(Long id) {
        Breed breed = breedRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Breed not found with id: " + id));
        return convertToResponse(breed);
    }

    public List<BreedResponse> searchBreeds(String name) {
        return breedRepository.findByNameContainingIgnoreCase(name)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public List<BreedResponse> searchBreedsBySpecies(Breed.Species species, String name) {
        return breedRepository.findBySpeciesAndNameContainingIgnoreCase(species, name)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public BreedResponse createBreed(Breed breed) {
        if (breedRepository.existsByName(breed.getName())) {
            throw new IllegalArgumentException("Breed with name '" + breed.getName() + "' already exists");
        }

        Breed savedBreed = breedRepository.save(breed);
        return convertToResponse(savedBreed);
    }

    public void initializeDefaultBreeds() {
        if (breedRepository.count() == 0) {
            // Add some common dog breeds
            String[][] dogBreeds = {
                    {"Labrador Retriever", "Friendly, Active, Outgoing"},
                    {"German Shepherd", "Confident, Courageous, Smart"},
                    {"Golden Retriever", "Intelligent, Friendly, Devoted"},
                    {"French Bulldog", "Adaptable, Playful, Smart"},
                    {"Bulldog", "Friendly, Courageous, Calm"},
                    {"Poodle", "Active, Proud, Very Smart"},
                    {"Beagle", "Friendly, Curious, Merry"},
                    {"Rottweiler", "Loyal, Loving, Confident Guardian"},
                    {"Yorkshire Terrier", "Bold, Independent, Confident"}
            };

            for (String[] breedData : dogBreeds) {
                Breed breed = new Breed();
                breed.setName(breedData[0]);
                breed.setSpecies(Breed.Species.DOG);
                breed.setTemperament(breedData[1]);
                breed.setSize("MEDIUM");
                breed.setLifeExpectancy("10-12 years");
                breedRepository.save(breed);
            }
        }
    }

    private BreedResponse convertToResponse(Breed breed) {
        BreedResponse response = new BreedResponse();
        response.setId(breed.getId());
        response.setName(breed.getName());
        response.setSpecies(breed.getSpecies());
        response.setSize(breed.getSize());
        response.setTemperament(breed.getTemperament());
        response.setLifeExpectancy(breed.getLifeExpectancy());
        response.setOrigin(breed.getOrigin());
        response.setDescription(breed.getDescription());
        response.setImageUrl(breed.getImageUrl());
        response.setCreatedAt(breed.getCreatedAt());
        response.setUpdatedAt(breed.getUpdatedAt());
        return response;
    }
}