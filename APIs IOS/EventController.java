import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/events")
public class EventController {

    private final EventService eventService;
    private final NotificationService notificationService;

    public EventController(EventService eventService, NotificationService notificationService) {
        this.eventService = eventService;
        this.notificationService = notificationService;
    }

    @PostMapping("/add")
    public ResponseEntity<String> addEvent(@RequestBody Event event) {
        eventService.addEvent(event);
        try {
            notificationService.sendNotificationToUsers(event);
        } catch (FirebaseMessagingException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to send notifications");
        }
        return ResponseEntity.status(HttpStatus.CREATED).body("Event added successfully");
    }

    @PutMapping("/{eventId}")
    public ResponseEntity<String> updateEvent(@PathVariable Long eventId, @RequestBody Event updatedEvent) {
        Event existingEvent = eventService.getEventById(eventId);
        if (existingEvent == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Event not found");
        }
        eventService.updateEvent(eventId, updatedEvent);
        try {
            notificationService.sendEventUpdatedNotification(existingEvent, updatedEvent);
        } catch (FirebaseMessagingException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to send notifications");
        }
        return ResponseEntity.status(HttpStatus.OK).body("Event updated successfully");
    }

    @DeleteMapping("/{eventId}")
    public ResponseEntity<String> removeEvent(@PathVariable Long eventId) {
        Event event = eventService.getEventById(eventId);
        if (event == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Event not found");
        }
        eventService.removeEvent(eventId);
        try {
            notificationService.sendEventRemovedNotification(event);
        } catch (FirebaseMessagingException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to send notifications");
        }
        return ResponseEntity.status(HttpStatus.OK).body("Event removed successfully");
    }
}
