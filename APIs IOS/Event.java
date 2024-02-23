import java.time.LocalDateTime;

public class Event {
    private String name;
    private LocalDateTime dateTime;
    private String place;
    private String organizerName;
    private String imageUrl;

    // Constructors
    public Event() {}

    public Event(String name, LocalDateTime dateTime, String place, String organizerName, String imageUrl) {
        this.name = name;
        this.dateTime = dateTime;
        this.place = place;
        this.organizerName = organizerName;
        this.imageUrl = imageUrl;
    }

    // Getters
    public String getName() {
        return name;
    }

    public LocalDateTime getDateTime() {
        return dateTime;
    }

    public String getPlace() {
        return place;
    }

    public String getOrganizerName() {
        return organizerName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    // Setters
    public void setName(String name) {
        this.name = name;
    }

    public void setDateTime(LocalDateTime dateTime) {
        this.dateTime = dateTime;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public void setOrganizerName(String organizerName) {
        this.organizerName = organizerName;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
