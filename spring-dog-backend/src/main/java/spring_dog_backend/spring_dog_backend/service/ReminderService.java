package spring_dog_backend.spring_dog_backend.service;

import jakarta.persistence.EntityNotFoundException;
import spring_dog_backend.spring_dog_backend.dto.request.ReminderRequest;
import spring_dog_backend.spring_dog_backend.dto.request.ReminderUpdateRequest;
import spring_dog_backend.spring_dog_backend.dto.response.ReminderResponse;
import spring_dog_backend.spring_dog_backend.model.Pet;
import spring_dog_backend.spring_dog_backend.model.Reminder;
import spring_dog_backend.spring_dog_backend.model.ReminderCategory;
import spring_dog_backend.spring_dog_backend.exception.ResourceNotFoundException;
import spring_dog_backend.spring_dog_backend.repository.PetRepository;
import spring_dog_backend.spring_dog_backend.repository.ReminderCategoryRepository;
import spring_dog_backend.spring_dog_backend.repository.ReminderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class ReminderService {

    @Autowired
    private ReminderRepository reminderRepository;

    @Autowired
    private PetRepository petRepository;

    @Autowired
    private ReminderCategoryRepository categoryRepository;

    @Autowired
    private NotificationService notificationService;

//    public ReminderResponse createReminder(ReminderRequest request) {
//        // TEMPORARY DEBUG - ADD THIS
//        System.out.println("=== DEBUG REMINDER CREATION ===");
//        System.out.println("Request petId: " + request.getPetId());
//        System.out.println("Request categoryId: " + request.getCategoryId());
//        System.out.println("Request title: " + request.getTitle());
//
//        try {
//            // Check if pet exists
//            boolean petExists = petRepository.existsById(request.getPetId());
//            System.out.println("Pet exists: " + petExists);
//
//            // Check if category exists
//            boolean categoryExists = categoryRepository.existsById(request.getCategoryId());
//            System.out.println("Category exists: " + categoryExists);
//
//            Pet pet = petRepository.findById(request.getPetId())
//                    .orElseThrow(() -> {
//                        System.out.println("PET NOT FOUND: " + request.getPetId());
//                        return new ResourceNotFoundException("Pet not found with id: " + request.getPetId());
//                    });
//
//            ReminderCategory category = categoryRepository.findById(request.getCategoryId())
//                    .orElseThrow(() -> {
//                        System.out.println("CATEGORY NOT FOUND: " + request.getCategoryId());
//                        return new ResourceNotFoundException("Category not found with id: " + request.getCategoryId());
//                    });
//
//            System.out.println("Found pet: " + pet.getName());
//            System.out.println("Found category: " + category.getName());
//
//            Reminder reminder = new Reminder();
//            reminder.setPet(pet);
//            reminder.setCategory(category);
//            reminder.setSubcategory(request.getSubcategory());
//            reminder.setTitle(request.getTitle());
//            reminder.setDescription(request.getDescription());
//            reminder.setDueDateTime(request.getDueDateTime());
//            reminder.setRepeatPattern(request.getRepeatPattern());
//            reminder.setRepeatInterval(request.getRepeatInterval());
//            reminder.setPriority(request.getPriority());
//            reminder.setNotes(request.getNotes());
//            reminder.setCustomData(request.getCustomData());
//
//            Reminder savedReminder = reminderRepository.save(reminder);
//            System.out.println("Reminder created successfully with ID: " + savedReminder.getId());
//            return convertToResponse(savedReminder);
//
//        } catch (Exception e) {
//            System.out.println("ERROR in createReminder: " + e.getMessage());
//            e.printStackTrace();
//            throw e;
//        }
//    }

    public ReminderResponse getReminderById(Long id) {
        Reminder reminder = reminderRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reminder not found with id: " + id));
        return convertToResponse(reminder);
    }

    public List<ReminderResponse> getRemindersByPetId(Long petId) {
        if (!petRepository.existsById(petId)) {
            throw new ResourceNotFoundException("Pet not found with id: " + petId);
        }

        return reminderRepository.findByPetIdOrderByDueDateTimeAsc(petId)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    // Fixed: Use userId instead of ownerId
    public List<ReminderResponse> getUpcomingRemindersByUser(Long userId, int days) {
        LocalDateTime start = LocalDateTime.now();
        LocalDateTime end = start.plusDays(days);

        return reminderRepository.findUpcomingRemindersByUser(userId, start, end)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    // Fixed: Use userId instead of ownerId
    public List<ReminderResponse> getUpcomingRemindersByUser(Long userId) {
        LocalDateTime now = LocalDateTime.now();
        return reminderRepository.findUpcomingRemindersByUser(userId, now)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    // Get all reminders for a user
    public List<ReminderResponse> getRemindersByUserId(Long userId) {
        return reminderRepository.findByUserId(userId)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public List<ReminderResponse> getOverdueReminders() {
        LocalDateTime now = LocalDateTime.now();
        return reminderRepository.findByIsCompletedFalseAndDueDateTimeBefore(now)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public ReminderResponse updateReminder(Long id, ReminderUpdateRequest request) {
        Reminder reminder = reminderRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException(STR."Reminder not found with id: \{id}"));

        if (request.getTitle() != null) {
            reminder.setTitle(request.getTitle());
        }
        if (request.getDescription() != null) {
            reminder.setDescription(request.getDescription());
        }
        if (request.getDueDateTime() != null) {
            reminder.setDueDateTime(request.getDueDateTime());
        }
        if (request.getNotes() != null) {
            reminder.setNotes(request.getNotes());
        }
        if (request.getCustomData() != null) {
            reminder.setCustomData(request.getCustomData());
        }

        if (request.getIsCompleted() != null && request.getIsCompleted()) {
            reminder.setIsCompleted(true);
            reminder.setCompletedAt(LocalDateTime.now());
        }

        Reminder updatedReminder = reminderRepository.save(reminder);
        return convertToResponse(updatedReminder);
    }

    public ReminderResponse markAsCompleted(Long id) {
        Reminder reminder = reminderRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reminder not found with id: " + id));

        reminder.setIsCompleted(true);
        reminder.setCompletedAt(LocalDateTime.now());

        Reminder completedReminder = reminderRepository.save(reminder);
        return convertToResponse(completedReminder);
    }

    public void deleteReminder(Long id) {
        if (!reminderRepository.existsById(id)) {
            throw new ResourceNotFoundException("Reminder not found with id: " + id);
        }
        reminderRepository.deleteById(id);
    }

    @Scheduled(cron = "0 0 8 * * ?")
    public void checkAndSendReminderNotifications() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime tomorrow = now.plusDays(1);

        List<Reminder> upcomingReminders = reminderRepository.findByIsCompletedFalseAndDueDateTimeBefore(tomorrow);

        for (Reminder reminder : upcomingReminders) {
            notificationService.sendReminderNotification(reminder);
        }
    }

    private ReminderResponse convertToResponse(Reminder reminder) {
        ReminderResponse response = new ReminderResponse();
        response.setId(reminder.getId());
        response.setPetId(reminder.getPet().getId());
        response.setPetName(reminder.getPet().getName());
        response.setCategoryId(reminder.getCategory().getId());
        response.setCategoryName(reminder.getCategory().getName());
        response.setSubcategory(reminder.getSubcategory());
        response.setTitle(reminder.getTitle());
        response.setDescription(reminder.getDescription());
        response.setDueDateTime(reminder.getDueDateTime());
        response.setRepeatPattern(reminder.getRepeatPattern());
        response.setRepeatInterval(reminder.getRepeatInterval());
        response.setPriority(reminder.getPriority());
        response.setIsCompleted(reminder.getIsCompleted());
        response.setCompletedAt(reminder.getCompletedAt());
        response.setNotes(reminder.getNotes());
        response.setCustomData(reminder.getCustomData());
        response.setCreatedAt(reminder.getCreatedAt());
        response.setUpdatedAt(reminder.getUpdatedAt());

        return response;
    }

    public ReminderResponse createReminder(ReminderRequest request) {
        System.out.println("=== DEBUG REMINDER CREATION ===");
        System.out.println("Request dueDateTime: " + request.getDueDateTime());
        System.out.println("Request dueDateTime class: " + (request.getDueDateTime() != null ? request.getDueDateTime().getClass() : "null"));

        // Validate pet exists
        if (!petRepository.existsById(request.getPetId())) {
            throw new ResourceNotFoundException("Pet not found with id: " + request.getPetId());
        }

        // Validate category exists
        if (!categoryRepository.existsById(request.getCategoryId())) {
            throw new ResourceNotFoundException("Category not found with id: " + request.getCategoryId());
        }

        // Get pet and category entities
        Pet pet = petRepository.findById(request.getPetId())
                .orElseThrow(() -> new ResourceNotFoundException("Pet not found with id: " + request.getPetId()));

        ReminderCategory category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + request.getCategoryId()));

        // Create reminder entity
        Reminder reminder = new Reminder();
        reminder.setPet(pet);
        reminder.setCategory(category);
        reminder.setTitle(request.getTitle());
        reminder.setDescription(request.getDescription());
        reminder.setDueDateTime(request.getDueDateTime()); // This is the critical line!
        reminder.setPriority(request.getPriority() != null ? request.getPriority() : Reminder.Priority.MEDIUM);
        reminder.setRepeatPattern(request.getRepeatPattern() != null ? request.getRepeatPattern() : Reminder.RepeatPattern.NONE);
        reminder.setRepeatInterval(request.getRepeatInterval() != null ? request.getRepeatInterval() : 1);
        reminder.setNotes(request.getNotes());
        reminder.setSubcategory(request.getSubcategory());
        reminder.setCustomData(request.getCustomData());
        reminder.setIsCompleted(false); // Default to not completed

        System.out.println("Entity dueDateTime before save: " + reminder.getDueDateTime());

        Reminder savedReminder = reminderRepository.save(reminder);

        System.out.println("Entity dueDateTime after save: " + savedReminder.getDueDateTime());
        System.out.println("=== END DEBUG ===");

        // FIXED: Using the correct method name
        return convertToResponse(savedReminder);
    }
//    public ReminderResponse createReminder(ReminderRequest request) {
//        // 1️⃣ Validate petId
//        if (request.getPetId() == null) {
//            throw new IllegalArgumentException("petId cannot be null");
//        }
//        if (!petRepository.existsById(request.getPetId())) {
//            throw new EntityNotFoundException("Pet not found with id " + request.getPetId());
//        }
//
//        // 2️⃣ Validate categoryId
//        if (request.getCategoryId() == null) {
//            throw new IllegalArgumentException("categoryId cannot be null");
//        }
//        if (!categoryRepository.existsById(request.getCategoryId())) {
//            throw new EntityNotFoundException("Category not found with id " + request.getCategoryId());
//        }
//
//        // 3️⃣ Now safe to create Reminder
//        Reminder reminder = new Reminder();
//        reminder.setPet(petRepository.findById(request.getPetId()).get());
//        reminder.setCategory(categoryRepository.findById(request.getCategoryId()).get());
//        reminder.setTitle(request.getTitle());
//        reminder.setDescription(request.getDescription());
//        reminder.setSubcategory(request.getSubcategory());
//        reminder = reminderRepository.save(reminder);
//
//        return new ReminderResponse();
//    }

}

//package spring_dog_backend.spring_dog_backend.service;
//
//import spring_dog_backend.spring_dog_backend.dto.request.ReminderRequest;
//import spring_dog_backend.spring_dog_backend.dto.request.ReminderUpdateRequest;
//import spring_dog_backend.spring_dog_backend.dto.response.ReminderResponse;
//import spring_dog_backend.spring_dog_backend.model.Pet;
//import spring_dog_backend.spring_dog_backend.model.Reminder;
//import spring_dog_backend.spring_dog_backend.model.ReminderCategory;
//import spring_dog_backend.spring_dog_backend.exception.ResourceNotFoundException;
//import spring_dog_backend.spring_dog_backend.repository.PetRepository;
//import spring_dog_backend.spring_dog_backend.repository.ReminderCategoryRepository;
//import spring_dog_backend.spring_dog_backend.repository.ReminderRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.scheduling.annotation.Scheduled;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//
//import java.time.LocalDateTime;
//import java.util.List;
//import java.util.stream.Collectors;
//
//@Service
//@Transactional
//public class ReminderService {
//
//    @Autowired
//    private ReminderRepository reminderRepository;
//
//    @Autowired
//    private PetRepository petRepository;
//
//    @Autowired
//    private ReminderCategoryRepository categoryRepository;
//
//    @Autowired
//    private NotificationService notificationService;
//
//    public ReminderResponse createReminder(ReminderRequest request) {
//        Pet pet = petRepository.findById(request.getPetId())
//                .orElseThrow(() -> new ResourceNotFoundException("Pet not found with id: " + request.getPetId()));
//
//        ReminderCategory category = categoryRepository.findById(request.getCategoryId())
//                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + request.getCategoryId()));
//
//        Reminder reminder = new Reminder();
//        reminder.setPet(pet);
//        reminder.setCategory(category);
//        reminder.setSubcategory(request.getSubcategory());
//        reminder.setTitle(request.getTitle());
//        reminder.setDescription(request.getDescription());
//        reminder.setDueDateTime(request.getDueDateTime());
//        reminder.setRepeatPattern(request.getRepeatPattern());
//        reminder.setRepeatInterval(request.getRepeatInterval());
//        reminder.setPriority(request.getPriority());
//        reminder.setNotes(request.getNotes());
//        reminder.setCustomData(request.getCustomData());
//
//        Reminder savedReminder = reminderRepository.save(reminder);
//        return convertToResponse(savedReminder);
//    }
//
//    public ReminderResponse getReminderById(Long id) {
//        Reminder reminder = reminderRepository.findById(id)
//                .orElseThrow(() -> new ResourceNotFoundException("Reminder not found with id: " + id));
//        return convertToResponse(reminder);
//    }
//
//    public List<ReminderResponse> getRemindersByPetId(Long petId) {
//        if (!petRepository.existsById(petId)) {
//            throw new ResourceNotFoundException("Pet not found with id: " + petId);
//        }
//
//        return reminderRepository.findByPetIdOrderByDueDateTimeAsc(petId)
//                .stream()
//                .map(this::convertToResponse)
//                .collect(Collectors.toList());
//    }
//
//    // Fixed: Use userId instead of ownerId
//    public List<ReminderResponse> getUpcomingRemindersByUser(Long userId, int days) {
//        LocalDateTime start = LocalDateTime.now();
//        LocalDateTime end = start.plusDays(days);
//
//        return reminderRepository.findUpcomingRemindersByUser(userId, start, end)
//                .stream()
//                .map(this::convertToResponse)
//                .collect(Collectors.toList());
//    }
//
//    // Fixed: Use userId instead of ownerId
//    public List<ReminderResponse> getUpcomingRemindersByUser(Long userId) {
//        LocalDateTime now = LocalDateTime.now();
//        return reminderRepository.findUpcomingRemindersByUser(userId, now)
//                .stream()
//                .map(this::convertToResponse)
//                .collect(Collectors.toList());
//    }
//
//    // Get all reminders for a user
//    public List<ReminderResponse> getRemindersByUserId(Long userId) {
//        return reminderRepository.findByUserId(userId)
//                .stream()
//                .map(this::convertToResponse)
//                .collect(Collectors.toList());
//    }
//
//    public List<ReminderResponse> getOverdueReminders() {
//        LocalDateTime now = LocalDateTime.now();
//        return reminderRepository.findByIsCompletedFalseAndDueDateTimeBefore(now)
//                .stream()
//                .map(this::convertToResponse)
//                .collect(Collectors.toList());
//    }
//
//    public ReminderResponse updateReminder(Long id, ReminderUpdateRequest request) {
//        Reminder reminder = reminderRepository.findById(id)
//                .orElseThrow(() -> new ResourceNotFoundException("Reminder not found with id: " + id));
//
//        if (request.getTitle() != null) {
//            reminder.setTitle(request.getTitle());
//        }
//        if (request.getDescription() != null) {
//            reminder.setDescription(request.getDescription());
//        }
//        if (request.getDueDateTime() != null) {
//            reminder.setDueDateTime(request.getDueDateTime());
//        }
//        if (request.getNotes() != null) {
//            reminder.setNotes(request.getNotes());
//        }
//        if (request.getCustomData() != null) {
//            reminder.setCustomData(request.getCustomData());
//        }
//
//        if (request.getIsCompleted() != null && request.getIsCompleted()) {
//            reminder.setIsCompleted(true);
//            reminder.setCompletedAt(LocalDateTime.now());
//        }
//
//        Reminder updatedReminder = reminderRepository.save(reminder);
//        return convertToResponse(updatedReminder);
//    }
//
//    public ReminderResponse markAsCompleted(Long id) {
//        Reminder reminder = reminderRepository.findById(id)
//                .orElseThrow(() -> new ResourceNotFoundException("Reminder not found with id: " + id));
//
//        reminder.setIsCompleted(true);
//        reminder.setCompletedAt(LocalDateTime.now());
//
//        Reminder completedReminder = reminderRepository.save(reminder);
//        return convertToResponse(completedReminder);
//    }
//
//    public void deleteReminder(Long id) {
//        if (!reminderRepository.existsById(id)) {
//            throw new ResourceNotFoundException("Reminder not found with id: " + id);
//        }
//        reminderRepository.deleteById(id);
//    }
//
//    @Scheduled(cron = "0 0 8 * * ?")
//    public void checkAndSendReminderNotifications() {
//        LocalDateTime now = LocalDateTime.now();
//        LocalDateTime tomorrow = now.plusDays(1);
//
//        List<Reminder> upcomingReminders = reminderRepository.findByIsCompletedFalseAndDueDateTimeBefore(tomorrow);
//
//        for (Reminder reminder : upcomingReminders) {
//            notificationService.sendReminderNotification(reminder);
//        }
//    }
//
//    private ReminderResponse convertToResponse(Reminder reminder) {
//        ReminderResponse response = new ReminderResponse();
//        response.setId(reminder.getId());
//        response.setPetId(reminder.getPet().getId());
//        response.setPetName(reminder.getPet().getName());
//        response.setCategoryId(reminder.getCategory().getId());
//        response.setCategoryName(reminder.getCategory().getName());
//        response.setSubcategory(reminder.getSubcategory());
//        response.setTitle(reminder.getTitle());
//        response.setDescription(reminder.getDescription());
//        response.setDueDateTime(reminder.getDueDateTime());
//        response.setRepeatPattern(reminder.getRepeatPattern());
//        response.setRepeatInterval(reminder.getRepeatInterval());
//        response.setPriority(reminder.getPriority());
//        response.setIsCompleted(reminder.getIsCompleted());
//        response.setCompletedAt(reminder.getCompletedAt());
//        response.setNotes(reminder.getNotes());
//        response.setCustomData(reminder.getCustomData());
//        response.setCreatedAt(reminder.getCreatedAt());
//        response.setUpdatedAt(reminder.getUpdatedAt());
//
//        return response;
//    }
//}