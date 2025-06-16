# 🛠️ Complaint Management System (CMS)

A simple and elegant **Complaint Management System** built with **Jakarta EE**, **Tomcat**, **MySQL**, **JSP**, **Servlets**, **Bootstrap**, and **JavaScript**. It supports both Admin and Employee functionalities.

---

## 🚀 Technologies Used

- **Jakarta EE** (`jakarta.servlet-api`, `jakarta.annotation`)
- **Apache Tomcat** (11+)
- **MySQL** (via `mysql-connector-j`)
- **Apache Commons DBCP2** (Tomcat built-in connection pooling)
- **Bootstrap 5**
- **JSP + Servlets**
- **Java 21**
- **Maven**
- **Lombok** (for model simplification)

---

## 📚 Features

### 🔒 Admin Panel
- 👀 View all complaints submitted by all employees
- 📝 Add remarks and update complaint status
- 🟢/🔴 View live status of each complaint
- 🧠 Session handling for secure admin-only access

### 🧑‍💼 Employee Panel
- 📝 Submit new complaints
- 📋 View **only their own submitted complaints**
- 📨 Get real-time status updates and admin remarks
- ✅ Form validations with JavaScript

---

## 📂 Project Structure

```
CMS/
├── src/
│   └── main/
│       ├── java/
│       │   ├── controller/
│       │   │   ├── AdminServlet.java
│       │   │   ├── AuthServlet.java
│       │   │   └── EmployeeServlet.java
│       │   ├── dto/
│       │   │   ├── Complaint.java
│       │   │   └── User.java
│       │   ├── listeners/
│       │   │   └── AppContextListener.java
│       │   └── model/
│       │       ├── ComplaintModel.java
│       │       └── UserModel.java
│       └── resources/
│           └── db/
│               └── schema.sql
├── web/
│   ├── META-INF/
│   │   └── context.xml
│   ├── WEB-INF/
│   │   └── web.xml
│   ├── pages/
│   │   ├── admindashboard.jsp
│   │   ├── employeedashboard.jsp
│   │   ├── signup.jsp
│   │   └── update-complaint.jsp
│   └── static/
│       ├── css/
│       │   └── style.css
│       └── js/
│           └── complaint.js
├── pom.xml
└── README.md
```

---

## ⚙️ Setup Instructions

1. **Clone the repo**:
   ```bash
   git clone https://github.com/yourusername/CMS.git
   ```

2. **Import into IntelliJ IDEA** or any Java IDE with Maven support.

3. **Database Setup**:
   - Run the SQL script in `resources/db/schema.sql` on your MySQL server.
   - Create a DB named `cms` or update `context.xml` accordingly.

4. **Configure Connection Pool** (`context.xml`):
   ```xml
   <Resource name="jdbc/cms"
             auth="Container"
             type="javax.sql.DataSource"
             maxTotal="20"
             maxIdle="10"
             maxWaitMillis="-1"
             username="root"
             password="yourpassword"
             driverClassName="com.mysql.cj.jdbc.Driver"
             url="jdbc:mysql://localhost:3306/cms"/>
   ```

5. **Deploy on Tomcat**:
   - Use Tomcat 11+ and deploy the `CMS` project.
   - Visit `http://localhost:8080/CMS/signup.jsp` to start.

---

## 🧑‍💼 Employee Panel

Employees can:

- 📝 Submit new complaints through a clean and validated form
- 📋 View a list of **only their own complaints**
- 📬 See the status (`Pending`, `In Progress`, `Resolved`, `Rejected`)
- 💬 Read admin remarks related to their complaints

Files involved:

- `employeedashboard.jsp`
- `EmployeeServlet.java`
- `ComplaintModel.java`
- `complaint.js`

---

## 🛠️ Admin Panel

Admins can:

- View **all employee complaints**
- Update status and remarks
- Session-protected access

Files involved:

- `admindashboard.jsp`
- `update-complaint.jsp`
- `AdminServlet.java`

---

## 📸 Screenshots

### 🧑‍💼 Employee Panel - Dashboard
<img width="1512" alt="Screenshot 2025-06-16 at 3 06 20 PM" src="https://github.com/user-attachments/assets/d23321bc-8d8f-443a-93bb-892c648f4325" />


### 🛠️ Admin Panel - Dashboard

<img width="1512" alt="Screenshot 2025-06-16 at 3 07 05 PM" src="https://github.com/user-attachments/assets/7c257fc4-20af-4765-b3da-cfc391870ac6" />

---

## 🤝 Contributions

Feel free to fork and submit pull requests or raise issues. ❤️

---

## 📄 License

MIT License. See `LICENSE` file for more info.
