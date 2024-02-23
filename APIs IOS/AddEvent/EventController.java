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

    @PostMapping("/add")
    public ResponseEntity<String> addEvent(@RequestBody Event event) {
        events.add(event);
        return ResponseEntity.status(HttpStatus.CREATED).body("Event added successfully");
    }

    @GetMapping("/all")
    public ResponseEntity<List<Event>> getAllEvents() {
        return ResponseEntity.ok(events);
    }
}
