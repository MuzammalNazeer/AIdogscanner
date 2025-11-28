// src/main/java/com/petcare/service/FavoriteBreedService.java
package spring_dog_backend.spring_dog_backend.service;

import spring_dog_backend.spring_dog_backend.model.FavoriteBreed;
import spring_dog_backend.spring_dog_backend.model.User;
import spring_dog_backend.spring_dog_backend.model.Breed;
import spring_dog_backend.spring_dog_backend.repository.FavoriteBreedRepository;
import spring_dog_backend.spring_dog_backend.repository.UserRepository;
import spring_dog_backend.spring_dog_backend.repository.BreedRepository;
import spring_dog_backend.spring_dog_backend.dto.request.FavoriteBreedRequest;
import spring_dog_backend.spring_dog_backend.dto.response.FavoriteBreedResponse;
import spring_dog_backend.spring_dog_backend.exception.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class FavoriteBreedService {

    private final FavoriteBreedRepository favoriteBreedRepository;
    private final UserRepository userRepository;
    private final BreedRepository breedRepository;

    public FavoriteBreedService(FavoriteBreedRepository favoriteBreedRepository,
                                UserRepository userRepository,
                                BreedRepository breedRepository) {
        this.favoriteBreedRepository = favoriteBreedRepository;
        this.userRepository = userRepository;
        this.breedRepository = breedRepository;
    }

    public FavoriteBreedResponse addFavoriteBreed(Long userId, FavoriteBreedRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        Breed breed = breedRepository.findById(request.getBreedId())
                .orElseThrow(() -> new ResourceNotFoundException("Breed not found with id: " + request.getBreedId()));

        // Check if already favorited
        if (favoriteBreedRepository.existsByUserAndBreed(user, breed)) {
            throw new IllegalArgumentException("Breed is already in favorites");
        }

        FavoriteBreed favoriteBreed = new FavoriteBreed(user, breed, request.getNotes());
        FavoriteBreed saved = favoriteBreedRepository.save(favoriteBreed);

        return mapToResponse(saved);
    }

    @Transactional(readOnly = true)
    public List<FavoriteBreedResponse> getUserFavoriteBreeds(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        return favoriteBreedRepository.findByUserWithBreedDetails(user)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public void removeFavoriteBreed(Long userId, Long breedId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        Breed breed = breedRepository.findById(breedId)
                .orElseThrow(() -> new ResourceNotFoundException("Breed not found with id: " + breedId));

        FavoriteBreed favorite = favoriteBreedRepository.findByUserAndBreed(user, breed)
                .orElseThrow(() -> new ResourceNotFoundException("Favorite breed not found"));

        favoriteBreedRepository.delete(favorite);
    }

    @Transactional(readOnly = true)
    public boolean isBreedFavoritedByUser(Long userId, Long breedId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        Breed breed = breedRepository.findById(breedId)
                .orElseThrow(() -> new ResourceNotFoundException("Breed not found with id: " + breedId));

        return favoriteBreedRepository.existsByUserAndBreed(user, breed);
    }

    @Transactional(readOnly = true)
    public long getUserFavoriteCount(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        return favoriteBreedRepository.countByUser(user);
    }

    private FavoriteBreedResponse mapToResponse(FavoriteBreed favoriteBreed) {
        FavoriteBreedResponse response = new FavoriteBreedResponse();
        response.setId(favoriteBreed.getId());
        response.setBreedId(favoriteBreed.getBreed().getId());
        response.setBreedName(favoriteBreed.getBreed().getName());
        response.setNotes(favoriteBreed.getNotes());
        response.setAddedAt(favoriteBreed.getAddedAt());
        return response;
    }
}