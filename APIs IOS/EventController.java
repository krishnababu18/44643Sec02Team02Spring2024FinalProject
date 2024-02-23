import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/events")
public class EventController {

    private final List<Event> events = new ArrayList<>();
    private final NotificationService notificationService;

    public EventController(EventService eventService, NotificationService          notificationService) {
        this.eventService = eventService;
        this.notificationService = notificationService;
    }

    @PostMapping("/add")
    public ResponseEntity<String> addEvent(@RequestBody Event event) {
        events.add(event);
        return ResponseEntity.status(HttpStatus.CREATED).body("Event added successfully");

    try {
                notificationService.sendNotificationToUsers(event);
            } catch (FirebaseMessagingException e) {
                e.printStackTrace();
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to send notifications");
        }
    }
}

