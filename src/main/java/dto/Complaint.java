package dto;

import lombok.*;

import java.io.Serializable;
import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class Complaint implements Serializable {
    private int id;
    private String title;
    private String description;
    private String category;
    private String status;
    private String priority;
    private int submittedBy;
    private Integer assignedTo;
    private String adminRemarks;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Additional fields for display
    private String submitterName;
    private String assigneeName;

    public Complaint(String title, String description, String category, int submittedBy) {
        this.title = title;
        this.description = description;
        this.category = category;
        this.submittedBy = submittedBy;
        this.status = "PENDING";
        this.priority = "MEDIUM";
    }

    public Complaint(int id, String title, String description, String category, String priority) {

    }
}

