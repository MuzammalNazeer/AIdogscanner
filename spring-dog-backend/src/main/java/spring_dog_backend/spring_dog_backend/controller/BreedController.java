package spring_dog_backend.spring_dog_backend.controller;

import spring_dog_backend.spring_dog_backend.dto.response.ApiResponse;
import spring_dog_backend.spring_dog_backend.dto.response.BreedResponse;
import spring_dog_backend.spring_dog_backend.model.Breed;
import spring_dog_backend.spring_dog_backend.service.BreedService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/breeds")
public class BreedController {

    @Autowired
    private BreedService breedService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<BreedResponse>>> getAllBreeds() {
        List<BreedResponse> breeds = breedService.getAllBreeds();
        return ResponseEntity.ok(ApiResponse.success(breeds));
    }

    @GetMapping("/species/{species}")
    public ResponseEntity<ApiResponse<List<BreedResponse>>> getBreedsBySpecies(@PathVariable Breed.Species species) {
        List<BreedResponse> breeds = breedService.getBreedsBySpecies(species);
        return ResponseEntity.ok(ApiResponse.success(breeds));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<BreedResponse>> getBreed(@PathVariable Long id) {
        BreedResponse breed = breedService.getBreedById(id);
        return ResponseEntity.ok(ApiResponse.success(breed));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<BreedResponse>>> searchBreeds(@RequestParam String name) {
        List<BreedResponse> breeds = breedService.searchBreeds(name);
        return ResponseEntity.ok(ApiResponse.success(breeds));
    }

    @GetMapping("/species/{species}/search")
    public ResponseEntity<ApiResponse<List<BreedResponse>>> searchBreedsBySpecies(
            @PathVariable Breed.Species species,
            @RequestParam String name) {
        List<BreedResponse> breeds = breedService.searchBreedsBySpecies(species, name);
        return ResponseEntity.ok(ApiResponse.success(breeds));
    }

    @PostMapping("/initialize")
    public ResponseEntity<ApiResponse<Void>> initializeDefaultBreeds() {
        breedService.initializeDefaultBreeds();
        return ResponseEntity.ok(ApiResponse.success("Default breeds initialized", null));
    }
}