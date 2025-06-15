package controller;

import dto.Complaint;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ComplaintModel;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin-dashboard","/admin-delete"})
public class AdminServlet extends HttpServlet {

    ComplaintModel complaintModel;
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("admin servlet " + dataSource);
        HttpSession session = request.getSession(false);
        System.out.println("admin session"+session);
        complaintModel = new ComplaintModel(dataSource);

        try {
            List<Complaint> complaints = complaintModel.getAllComplaints();
            System.out.println(complaints);
            request.setAttribute("complaints", complaints);

            long totalComplaints = complaints.size();
            long pendingComplaints = complaints.stream().filter(c -> "PENDING".equals(c.getStatus())).count();
            long resolvedComplaints = complaints.stream().filter(c -> "RESOLVED".equals(c.getStatus())).count();
            long rejectedComplaints = complaints.stream().filter(c -> "REJECTED".equals(c.getStatus())).count();

            request.setAttribute("totalComplaints", totalComplaints);
            request.setAttribute("pendingComplaints", pendingComplaints);
            request.setAttribute("resolvedComplaints", resolvedComplaints);
            request.setAttribute("rejectedComplaints", rejectedComplaints);

            if (session != null) {
                String successMessage = (String) session.getAttribute("successMessage");
                String errorMessage = (String) session.getAttribute("errorMessage");

                if (successMessage != null) {
                    request.setAttribute("successMessage", successMessage);
                    session.removeAttribute("successMessage");
                }

                if (errorMessage != null) {
                    request.setAttribute("errorMessage", errorMessage);
                    session.removeAttribute("errorMessage");
                }
            }

            request.getRequestDispatcher("/pages/admindashboard.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Error retrieving complaints", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        HttpSession session = req.getSession(false);
        System.out.println("admin session"+session);
        String action = req.getParameter("action");

        System.out.println("POST request received with action: " + action);
        System.out.println("admin session"+session);
        if (session == null) {
            System.out.println("No session found, redirecting to login");
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp?msg=invalid_session");
            return;
        }
        System.out.println("servletpath: " + servletPath);
        if ("/admin-delete".equals(servletPath)) {
            handleDeleteComplaint(req, resp, session);
        } else {
            System.out.println("Unknown action: " + action);
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
        }

        System.out.println(servletPath);
    }

    private void handleDeleteComplaint(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException {
        String id = req.getParameter("id");
        System.out.println("Attempting to delete complaint with ID: " + id);

        if (id == null || id.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid complaint ID");
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
            return;
        }

        try {
            int complaintId = Integer.parseInt(id);
            complaintModel = new ComplaintModel(dataSource);

            if (!complaintModel.complaintExists(complaintId)) {
                session.setAttribute("errorMessage", "Complaint not found");
                resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
                return;
            }

            boolean isDeleted = complaintModel.deleteComplain(complaintId);

            if (isDeleted) {
                session.setAttribute("successMessage", "Complaint CMP-" + complaintId + " deleted successfully");
                System.out.println("Complaint with ID " + complaintId + " deleted successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to delete complaint");
                System.out.println("Failed to delete complaint with ID " + complaintId);
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid complaint ID format");
            System.err.println("Invalid complaint ID format: " + id);
        } catch (Exception e) {
            session.setAttribute("errorMessage", "An error occurred while deleting the complaint: " + e.getMessage());
            System.err.println("Error deleting complaint: " + e.getMessage());
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
    }
}
