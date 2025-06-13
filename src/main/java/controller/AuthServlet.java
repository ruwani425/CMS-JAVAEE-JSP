package controller;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/authServlet")
public class AuthServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource ds;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("signup".equalsIgnoreCase(action)) {
            handleSignup(request, response);
        } else if ("login".equalsIgnoreCase(action)) {
            handleLogin(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (
                Connection conn = ds.getConnection();
                PreparedStatement stmt = conn.prepareStatement(
                        "INSERT INTO users (username, password, full_name, email, role) VALUES (?, ?, ?, ?, ?)")
        ) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, fullName);
            stmt.setString(4, email);
            stmt.setString(5, role);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                request.getSession().setAttribute("message", "Registration successful! Please login.");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                request.getSession().setAttribute("error", "Registration failed.");
                response.sendRedirect(request.getContextPath() + "/pages/signup.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getErrorCode() == 1062) {
                request.getSession().setAttribute("error", "Username already exists.");
            } else {
                request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/pages/signup.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (
                Connection conn = ds.getConnection();
                PreparedStatement stmt = conn.prepareStatement(
                        "SELECT * FROM users WHERE username = ? AND password = ?")
        ) {
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();

                // Store simple values
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("role", rs.getString("role"));

                String role = rs.getString("role");
                if ("ADMIN".equalsIgnoreCase(role)) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/employee/dashboard");
                }

            } else {
                request.getSession().setAttribute("error", "Invalid username or password");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
