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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource ds;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println(ds);
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ds.getConnection();

            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            rs = stmt.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();

                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getInt("id"));
                user.put("username", rs.getString("username"));
                user.put("fullName", rs.getString("full_name"));
                user.put("email", rs.getString("email"));
                user.put("role", rs.getString("role"));

                session.setAttribute("user", user);

                String role = rs.getString("role");
                if ("ADMIN".equals(role)) {
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

        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}