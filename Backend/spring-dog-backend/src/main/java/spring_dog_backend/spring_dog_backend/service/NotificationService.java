package spring_dog_backend.spring_dog_backend.service;

import spring_dog_backend.spring_dog_backend.model.Reminder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);

    @Async
    public void sendReminderNotification(Reminder reminder) {
        // Implement notification logic (email, push notification, SMS, etc.)
        logger.info("Sending reminder notification: {} for pet: {}",
                reminder.getTitle(), reminder.getPet().getName());

        // Example implementation:
        // emailService.sendReminderEmail(reminder);
        // pushNotificationService.sendPushNotification(reminder);
    }
}