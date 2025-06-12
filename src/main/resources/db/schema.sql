CREATE DATABASE IF NOT EXISTS complaint_management;
USE complaint_management;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role ENUM('EMPLOYEE', 'ADMIN') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    status ENUM('PENDING', 'IN_PROGRESS', 'RESOLVED', 'REJECTED') DEFAULT 'PENDING',
    priority ENUM('LOW', 'MEDIUM', 'HIGH') DEFAULT 'MEDIUM',
    submitted_by INT NOT NULL,
    assigned_to INT NULL,
    admin_remarks TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (submitted_by) REFERENCES users(id),
    FOREIGN KEY (assigned_to) REFERENCES users(id)
);

INSERT INTO users (username, password, full_name, email, role) VALUES
('admin', 'admin123', 'System Administrator', 'admin@municipal.gov', 'ADMIN'),
('john.doe', 'password123', 'John Doe', 'john.doe@municipal.gov', 'EMPLOYEE'),
('jane.smith', 'password123', 'Jane Smith', 'jane.smith@municipal.gov', 'EMPLOYEE');

INSERT INTO complaints (title, description, category, submitted_by) VALUES
('Street Light Not Working', 'The street light on Main Street has been out for 3 days', 'Infrastructure', 2),
('Pothole on Highway', 'Large pothole causing traffic issues on Highway 101', 'Roads', 3),
('Noise Complaint', 'Construction noise starting too early in residential area', 'Noise', 2);
