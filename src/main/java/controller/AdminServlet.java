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

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin-dashboard", "/admin-delete", "/update-status", "/add-remarks"})
public class AdminServlet extends HttpServlet {

    ComplaintModel complaintModel;
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        complaintModel = new ComplaintModel(dataSource);
        if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        try {
            List<Complaint> complaints = complaintModel.getAllComplaints();
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
        String action = req.getParameter("action");

        if (session == null) {
            System.out.println("No session found, redirecting to login");
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp?msg=invalid_session");
            return;
        }
        switch (servletPath) {
            case "/admin-delete":
                handleDeleteComplaint(req, resp, session);
                break;
            case "/update-status":
                handleUpdateStatus(req, resp, session);
                break;
            case "/add-remarks":
                handleAddRemarks(req, resp, session);
                break;
            default:
                System.out.println("Unknown servlet path: " + servletPath);
                resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
                break;
        }
    }

    private void handleAddRemarks(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException {
        String complaintIdStr = req.getParameter("complaintId");
        String remarks = req.getParameter("remarks");

        System.out.println("Adding remarks for complaint ID: " + complaintIdStr);

        if (complaintIdStr == null || complaintIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid complaint ID");
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
            return;
        }

        if (remarks == null || remarks.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Remarks cannot be empty");
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
            return;
        }
        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            complaintModel = new ComplaintModel(dataSource);

            if (!complaintModel.complaintExists(complaintId)) {
                session.setAttribute("errorMessage", "Complaint not found");
                resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
                return;
            }

            boolean isUpdated = complaintModel.updateAdminRemarks(complaintId, remarks);

            if (isUpdated) {
                session.setAttribute("successMessage",
                        "Remarks added successfully to complaint CMP-" + complaintId);
                System.out.println("Remarks added successfully for complaint: " + complaintId);
            } else {
                session.setAttribute("errorMessage", "Failed to add remarks");
                System.out.println("Failed to add remarks for complaint: " + complaintId);
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error adding remarks: " + e.getMessage());
            System.err.println("Error adding remarks: " + e.getMessage());
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException {
        String status = req.getParameter("status");
        String complaintId = req.getParameter("complaintId");

        if (complaintId == null || complaintId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid complaint ID");
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
            return;
        }

        if (status == null || status.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Status cannot be empty");
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
            return;
        }
        try {
            int id = Integer.parseInt(complaintId);
            complaintModel = new ComplaintModel(dataSource);

            if (!complaintModel.complaintExists(id)) {
                session.setAttribute("errorMessage", "Complaint not found");
                resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
                return;
            }
            boolean isUpdated = complaintModel.updateComplaintStatus(id, status);
            if (isUpdated) {
                session.setAttribute("successMessage", "Status updated successfully for complaint CMP-" + id + " to " + status.replace("_", " "));
                System.out.println("Status updated successfully for complaint: " + id);
            } else {
                session.setAttribute("errorMessage", "Failed to update status");
                System.out.println("Failed to update status for complaint: " + id);
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error updating status: " + e.getMessage());
            System.err.println("Error updating status: " + e.getMessage());
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
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
