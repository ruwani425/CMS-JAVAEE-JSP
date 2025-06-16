CREATE DATABASE IF NOT EXISTS complaint_management;
USE complaint_management;

CREATE TABLE users
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    username   VARCHAR(50) UNIQUE         NOT NULL,
    password   VARCHAR(255)               NOT NULL,
    full_name  VARCHAR(100)               NOT NULL,
    email      VARCHAR(100)               NOT NULL,
    role       ENUM ('EMPLOYEE', 'ADMIN') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE complaints
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    title         VARCHAR(200) NOT NULL,
    description   TEXT         NOT NULL,
    category      VARCHAR(50)  NOT NULL,
    status        ENUM ('PENDING', 'IN_PROGRESS', 'RESOLVED', 'REJECTED') DEFAULT 'PENDING',
    priority      ENUM ('LOW', 'MEDIUM', 'HIGH')                          DEFAULT 'MEDIUM',
    submitted_by  INT          NOT NULL,
    assigned_to   INT          NULL,
    admin_remarks TEXT         NULL,
    created_at    TIMESTAMP                                               DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP                                               DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (submitted_by) REFERENCES users (id),
    FOREIGN KEY (assigned_to) REFERENCES users (id)
);

INSERT INTO users (username, password, full_name, email, role)
VALUES ('admin', 'admin123', 'System Administrator', 'admin@municipal.gov', 'ADMIN'),
       ('john.doe', 'password123', 'John Doe', 'john.doe@municipal.gov', 'EMPLOYEE'),
       ('jane.smith', 'password123', 'Jane Smith', 'jane.smith@municipal.gov', 'EMPLOYEE');

INSERT INTO complaints (title, description, category, submitted_by)
VALUES ('Street Light Not Working', 'The street light on Main Street has been out for 3 days', 'Infrastructure', 2),
       ('Pothole on Highway', 'Large pothole causing traffic issues on Highway 101', 'Roads', 3),
       ('Noise Complaint', 'Construction noise starting too early in residential area', 'Noise', 2);

INSERT INTO complaints (title, description, category, status, priority, submitted_by, assigned_to, admin_remarks)
VALUES
    ('Water Leakage', 'There is a continuous water leakage near the park entrance.', 'Water', 'IN_PROGRESS', 'HIGH', 3, 1, 'Plumbing team has been notified.'),
    ('Garbage Not Collected', 'Garbage has not been collected in my area for the past 4 days.', 'Sanitation', 'PENDING', 'MEDIUM', 2, NULL, NULL),
    ('Street Flooding', 'Even small rain is causing flooding in my street.', 'Drainage', 'RESOLVED', 'HIGH', 3, 1, 'Issue resolved by cleaning blocked drains.'),
    ('Stray Dogs', 'Large number of stray dogs seen in the neighborhood recently.', 'Animal Control', 'REJECTED', 'LOW', 2, 1, 'Outside jurisdiction. Contact animal welfare.'),
    ('Illegal Parking', 'Cars are being parked illegally in front of my house.', 'Traffic', 'IN_PROGRESS', 'MEDIUM', 3, NULL, NULL);
