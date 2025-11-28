package spring_dog_backend.spring_dog_backend.controller;

import jakarta.validation.Valid;
import spring_dog_backend.spring_dog_backend.dto.request.ReminderRequest;
import spring_dog_backend.spring_dog_backend.dto.request.ReminderUpdateRequest;
import spring_dog_backend.spring_dog_backend.dto.response.ApiResponse;
import spring_dog_backend.spring_dog_backend.dto.response.ReminderResponse;
import spring_dog_backend.spring_dog_backend.service.ReminderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reminders")
public class ReminderController {

    @Autowired
    private ReminderService reminderService;

//    @PostMapping
//    @PreAuthorize("hasRole('USER')")
//    public ResponseEntity<ApiResponse<ReminderResponse>> createReminder(
//            @RequestBody ReminderRequest request) {
//        ReminderResponse reminder = reminderService.createReminder(request);
//        return ResponseEntity.ok(ApiResponse.success("Reminder created successfully", reminder));
//    }



    @GetMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<ReminderResponse>> getReminder(@PathVariable Long id) {
        ReminderResponse reminder = reminderService.getReminderById(id);
        return ResponseEntity.ok(ApiResponse.success(reminder));
    }

//    @GetMapping("/{id}")
//    @PreAuthorize("hasRole('USER')")
//    public ResponseEntity<ApiResponse<ReminderResponse>> getReminder(@PathVariable Long id) {
//        ReminderResponse reminder = reminderService.getReminderById(id);
//        return ResponseEntity.ok(ApiResponse.success(reminder));
//    }


    @PostMapping
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<ReminderResponse>> createReminder(
            @Valid @RequestBody ReminderRequest request) {

        // Log what we received (for debugging)
        System.out.println("✅ SUCCESS - Received reminder:");
        System.out.println("   petId: " + request.getPetId());
        System.out.println("   categoryId: " + request.getCategoryId());
        System.out.println("   title: " + request.getTitle());
        System.out.println("   dueDateTime: " + request.getDueDateTime());

        ReminderResponse reminder = reminderService.createReminder(request);
        return ResponseEntity.ok(ApiResponse.success("Reminder created successfully", reminder));
    }

    @GetMapping("/pet/{petId}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<List<ReminderResponse>>> getPetReminders(@PathVariable Long petId) {
        List<ReminderResponse> reminders = reminderService.getRemindersByPetId(petId);
        return ResponseEntity.ok(ApiResponse.success(reminders));
    }

    @GetMapping("/user/{userId}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<List<ReminderResponse>>> getUserReminders(@PathVariable Long userId) {
        List<ReminderResponse> reminders = reminderService.getRemindersByUserId(userId);
        return ResponseEntity.ok(ApiResponse.success(reminders));
    }

    @GetMapping("/user/{userId}/upcoming")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<List<ReminderResponse>>> getUpcomingReminders(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "7") int days) {
        List<ReminderResponse> reminders = reminderService.getUpcomingRemindersByUser(userId, days);
        return ResponseEntity.ok(ApiResponse.success(reminders));
    }

    @GetMapping("/overdue")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<List<ReminderResponse>>> getOverdueReminders() {
        List<ReminderResponse> reminders = reminderService.getOverdueReminders();
        return ResponseEntity.ok(ApiResponse.success(reminders));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<ReminderResponse>> updateReminder(
            @PathVariable Long id,
            @RequestBody ReminderUpdateRequest request) {
        ReminderResponse reminder = reminderService.updateReminder(id, request);
        return ResponseEntity.ok(ApiResponse.success("Reminder updated successfully", reminder));
    }

    @PatchMapping("/{id}/complete")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<ReminderResponse>> markAsCompleted(@PathVariable Long id) {
        ReminderResponse reminder = reminderService.markAsCompleted(id);
        return ResponseEntity.ok(ApiResponse.success("Reminder marked as completed", reminder));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<Void>> deleteReminder(@PathVariable Long id) {
        reminderService.deleteReminder(id);
        return ResponseEntity.ok(ApiResponse.success("Reminder deleted successfully", null));
    }
}