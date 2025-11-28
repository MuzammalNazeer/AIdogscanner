package spring_dog_backend.spring_dog_backend.controller;

import spring_dog_backend.spring_dog_backend.dto.request.ReminderUpdateRequest;
import spring_dog_backend.spring_dog_backend.dto.response.ApiResponse;
import spring_dog_backend.spring_dog_backend.dto.response.ReminderCategoryResponse;
import spring_dog_backend.spring_dog_backend.dto.response.ReminderResponse;
import spring_dog_backend.spring_dog_backend.service.ReminderCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/reminder-categories")
public class ReminderCategoryController {

    @Autowired
    private ReminderCategoryService categoryService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<ReminderCategoryResponse>>> getAllCategories() {
        List<ReminderCategoryResponse> categories = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success(categories));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ReminderCategoryResponse>> getCategory(@PathVariable Long id) {
        ReminderCategoryResponse category = categoryService.getCategoryById(id);
        return ResponseEntity.ok(ApiResponse.success(category));
    }
    @PutMapping("/reminders/{id}")
    public ResponseEntity<ReminderResponse> updateReminder(
            @PathVariable Long id,
            @RequestBody ReminderUpdateRequest reminderUpdateRequest) {
        return ResponseEntity.ok(ReminderCategoryService.updateReminder(id, reminderUpdateRequest));
    }

    @PostMapping("/initialize")
    public ResponseEntity<ApiResponse<Void>> initializeDefaultCategories() {
        categoryService.initializeDefaultCategories();
        return ResponseEntity.ok(ApiResponse.success("Default categories initialized", null));
    }
}