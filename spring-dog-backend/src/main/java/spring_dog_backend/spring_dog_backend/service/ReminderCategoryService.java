package spring_dog_backend.spring_dog_backend.service;

import spring_dog_backend.spring_dog_backend.dto.request.ReminderUpdateRequest;
import spring_dog_backend.spring_dog_backend.dto.response.ReminderCategoryResponse;
import spring_dog_backend.spring_dog_backend.dto.response.ReminderResponse;
import spring_dog_backend.spring_dog_backend.model.ReminderCategory;
import spring_dog_backend.spring_dog_backend.exception.ResourceNotFoundException;
import spring_dog_backend.spring_dog_backend.repository.ReminderCategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class ReminderCategoryService {

    @Autowired
    private ReminderCategoryRepository categoryRepository;

    public static ReminderResponse updateReminder(Long id, ReminderUpdateRequest reminderUpdateRequest) {
        return null;
    }

    public List<ReminderCategoryResponse> getAllCategories() {
        return categoryRepository.findByIsActiveTrue()
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public ReminderCategoryResponse getCategoryById(Long id) {
        ReminderCategory category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + id));
        return convertToResponse(category);
    }

    public ReminderCategoryResponse createCategory(ReminderCategory category) {
        if (categoryRepository.existsByName(category.getName())) {
            throw new IllegalArgumentException("Category with name '" + category.getName() + "' already exists");
        }

        ReminderCategory savedCategory = categoryRepository.save(category);
        return convertToResponse(savedCategory);
    }

    public void initializeDefaultCategories() {
        if (categoryRepository.count() == 0) {
            String[][] defaultCategories = {
                    {"FEEDING", "Feeding Schedule", "#4CAF50", "restaurant"},
                    {"MEDICAL", "Medical Care", "#F44336", "local_hospital"},
                    {"HYGIENE", "Grooming & Hygiene", "#2196F3", "bathtub"},
                    {"ACTIVITY", "Exercise & Activity", "#FF9800", "directions_run"},
                    {"VET", "Veterinary Visits", "#9C27B0", "pets"},
                    {"MEDICATION", "Medication", "#795548", "medication"},
                    {"VACCINATION", "Vaccinations", "#607D8B", "vaccines"},
                    {"GROOMING", "Grooming", "#00BCD4", "content_cut"},
                    {"TRAINING", "Training", "#8BC34A", "school"},
                    {"OTHER", "Other Reminders", "#9E9E9E", "notifications"}
            };

            for (String[] categoryData : defaultCategories) {
                ReminderCategory category = new ReminderCategory();
                category.setName(categoryData[0]);
                category.setDescription(categoryData[1]);
                category.setColor(categoryData[2]);
                category.setIcon(categoryData[3]);
                category.setIsActive(true);
                categoryRepository.save(category);
            }
        }
    }

    private ReminderCategoryResponse convertToResponse(ReminderCategory category) {
        ReminderCategoryResponse response = new ReminderCategoryResponse();
        response.setId(category.getId());
        response.setName(category.getName());
        response.setDescription(category.getDescription());
        response.setColor(category.getColor());
        response.setIcon(category.getIcon());
        response.setIsActive(category.getIsActive());
        response.setCreatedAt(category.getCreatedAt());
        response.setUpdatedAt(category.getUpdatedAt());
        return response;
    }
}