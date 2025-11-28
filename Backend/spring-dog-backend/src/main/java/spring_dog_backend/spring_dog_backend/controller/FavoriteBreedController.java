

// src/main/java/com/petcare/controller/FavoriteBreedController.java
package spring_dog_backend.spring_dog_backend.controller;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import spring_dog_backend.spring_dog_backend.dto.request.FavoriteBreedRequest;
import spring_dog_backend.spring_dog_backend.dto.response.ApiResponse;
import spring_dog_backend.spring_dog_backend.dto.response.FavoriteBreedResponse;
import spring_dog_backend.spring_dog_backend.model.User;
import spring_dog_backend.spring_dog_backend.service.FavoriteBreedService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/favorites/breeds")
public class FavoriteBreedController {

    private final FavoriteBreedService favoriteBreedService;

    public FavoriteBreedController(FavoriteBreedService favoriteBreedService) {
        this.favoriteBreedService = favoriteBreedService;
    }
    @PostMapping
    public ResponseEntity<ApiResponse<FavoriteBreedResponse>> addFavoriteBreed(
            @AuthenticationPrincipal User userDetails,
            @Valid @RequestBody FavoriteBreedRequest request) {

        // Debug information
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        System.out.println("=== AUTHENTICATION DEBUG ===");
        System.out.println("Authentication: " + authentication);
        System.out.println("Is authenticated: " + (authentication != null && authentication.isAuthenticated()));
        System.out.println("Principal: " + (authentication != null ? authentication.getPrincipal() : "null"));
        System.out.println("Principal class: " + (authentication != null && authentication.getPrincipal() != null ?
                authentication.getPrincipal().getClass().getName() : "null"));
        System.out.println("UserDetails from @AuthenticationPrincipal: " + userDetails);

        if (userDetails == null) {
            // Try to get user from SecurityContext directly
            if (authentication != null && authentication.getPrincipal() instanceof User) {
                userDetails = (User) authentication.getPrincipal();
                System.out.println("Found user from SecurityContext: " + userDetails.getUsername());
            } else if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
                // If it's a UserDetails but not your User entity
                UserDetails details = (UserDetails) authentication.getPrincipal();
                System.out.println("Found UserDetails: " + details.getUsername());
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(ApiResponse.error("User entity not found in principal"));
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(ApiResponse.error("User not authenticated - no valid principal found"));
            }
        }

        FavoriteBreedResponse response = favoriteBreedService.addFavoriteBreed(userDetails.getId(), request);
        return ResponseEntity.ok(ApiResponse.success("Breed added to favorites", response));
    }
//    @PostMapping
//    public ResponseEntity<ApiResponse<FavoriteBreedResponse>> addFavoriteBreed(
//            @AuthenticationPrincipal User userDetails,
//            @Valid @RequestBody FavoriteBreedRequest request) {
//
//        FavoriteBreedResponse response = favoriteBreedService.addFavoriteBreed(userDetails.getId(), request);
//        return ResponseEntity.ok(ApiResponse.success("Breed added to favorites", response));
//    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<FavoriteBreedResponse>>> getUserFavoriteBreeds(
            @AuthenticationPrincipal User userDetails) {

        List<FavoriteBreedResponse> favorites = favoriteBreedService.getUserFavoriteBreeds(userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success("Favorites retrieved successfully", favorites));
    }

    @DeleteMapping("/{breedId}")
    public ResponseEntity<ApiResponse<Void>> removeFavoriteBreed(
            @AuthenticationPrincipal User userDetails,
            @PathVariable Long breedId) {

        favoriteBreedService.removeFavoriteBreed(userDetails.getId(), breedId);
        return ResponseEntity.ok(ApiResponse.success("Breed removed from favorites", null));
    }

    @GetMapping("/check/{breedId}")
    public ResponseEntity<ApiResponse<Boolean>> isBreedFavorited(
            @AuthenticationPrincipal User userDetails,
            @PathVariable Long breedId) {

        boolean isFavorited = favoriteBreedService.isBreedFavoritedByUser(userDetails.getId(), breedId);
        return ResponseEntity.ok(ApiResponse.success("Check completed", isFavorited));
    }

    @GetMapping("/count")
    public ResponseEntity<ApiResponse<Long>> getFavoriteCount(
            @AuthenticationPrincipal User userDetails) {

        long count = favoriteBreedService.getUserFavoriteCount(userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success("Count retrieved", count));
    }


}