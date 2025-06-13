package controller;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/signupServlet")
public class SignUpServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource ds;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = ds.getConnection();

            String sql = "INSERT INTO users (username, password, full_name, email, role) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, fullName);
            stmt.setString(4, email);
            stmt.setString(5, role);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                // Registration successful - redirect to login page
                request.getSession().setAttribute("message", "Registration successful! Please login.");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                // Registration failed
                request.getSession().setAttribute("error", "Registration failed. Please try again.");
                response.sendRedirect(request.getContextPath() + "/pages/signup.jsp");
            }

        } catch (SQLException e) {
            // Handle database errors
            e.printStackTrace();

            // Check for duplicate username (SQL error code 1062 is for duplicate entry)
            if (e.getErrorCode() == 1062) {
                request.getSession().setAttribute("error", "Username already exists. Please choose another username.");
            } else {
                request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            }

            response.sendRedirect(request.getContextPath() + "/pages/signup.jsp");

        } finally {
            // Close resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}