package controller;

import dto.User;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserModel;

import javax.sql.DataSource;
import java.io.IOException;

@WebServlet("/authServlet")
public class AuthServlet extends HttpServlet {

    UserModel userModel;
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource ds;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        userModel = new UserModel(ds);

        if ("signup".equalsIgnoreCase(action)) {
            handleSignup(request, response);
        } else if ("login".equalsIgnoreCase(action)) {
            handleLogin(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullname = request.getParameter("full_name");
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        User user = new User(username, password, fullname, email, role);

        boolean register = userModel.register(user);
        if (register) {
            request.getSession().setAttribute("message", "Registration successful! Please login.");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            request.getSession().setAttribute("error", "Registration failed.");
            response.sendRedirect(request.getContextPath() + "/pages/signup.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userModel.login(username, password);
        if (user != null) {
            String role = user.getRole();
            if ("ADMIN".equalsIgnoreCase(role)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole());
                response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("employeeId", user.getId());
                session.setAttribute("employeeName", user.getUsername());
                session.setAttribute("role", user.getRole());
                response.sendRedirect(request.getContextPath() + "/employee-dashboard");
            }
        } else {
            request.getSession().setAttribute("error", "Invalid username or password");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
