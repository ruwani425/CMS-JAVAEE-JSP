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
import java.sql.Timestamp;
import java.util.List;

@WebServlet(urlPatterns = {"/submit-complaint", "/view-complaint", "/update-complaint", "/delete-complaint", "/my-complaints", "/employee-dashboard"})
public class EmployeeServlet extends HttpServlet {

    ComplaintModel model;
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        model = new ComplaintModel(dataSource);

        HttpSession session = req.getSession(false);

        if (session == null || !"EMPLOYEE".equalsIgnoreCase((String) session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp?msg=session_expired");
            return;
        }

        Integer employeeId = (Integer) session.getAttribute("employeeId");
        if (employeeId == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/login.jsp?msg=invalid_session");
            return;
        }

        String servletPath = req.getServletPath();

        try {
            switch (servletPath) {
                case "/view-complaint":
                    handleViewComplaint(req, resp, model, employeeId);
                    break;
                case "/my-complaints":
                    handleMyComplaints(req, resp, model, employeeId);
                    break;
                case "/employee-dashboard":
                default:
                    handleDashboard(req, resp, model, employeeId, session);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request", e);
        }
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId, HttpSession session) throws ServletException, IOException {
        try {
            List<Complaint> complaints = model.getAllComplaintsById(employeeId);
            req.setAttribute("complaints", complaints);

            long totalComplaints = complaints.size();
            long pendingComplaints = complaints.stream().filter(c -> "PENDING".equals(c.getStatus())).count();
            long resolvedComplaints = complaints.stream().filter(c -> "RESOLVED".equals(c.getStatus())).count();
            long inProgressComplaints = complaints.stream().filter(c -> "IN_PROGRESS".equals(c.getStatus())).count();
            long rejectedComplaints = complaints.stream().filter(c -> "REJECTED".equals(c.getStatus())).count();

            req.setAttribute("totalComplaints", totalComplaints);
            req.setAttribute("pendingComplaints", pendingComplaints);
            req.setAttribute("resolvedComplaints", resolvedComplaints);
            req.setAttribute("inProgressComplaints", inProgressComplaints);
            req.setAttribute("rejectedComplaints", rejectedComplaints);

            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");

            if (successMessage != null) {
                req.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }

            if (errorMessage != null) {
                req.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("errorMessage");
            }

            req.getRequestDispatcher("/pages/employeedashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading dashboard data", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String servletPath = req.getServletPath();

        try {
            HttpSession session = req.getSession(false);
            if (session == null) {
                resp.sendRedirect(req.getContextPath() + "/pages/login.jsp?msg=session_expired");
                return;
            }

            Integer employeeId = (Integer) session.getAttribute("employeeId");
            String employeeName = (String) session.getAttribute("employeeName");

            if (employeeId == null || employeeName == null) {
                resp.sendRedirect(req.getContextPath() + "/pages/login.jsp?msg=invalid_session");
                return;
            }

            ComplaintModel model = new ComplaintModel(dataSource);

            switch (servletPath) {
                case "/submit-complaint":
                    handleSubmitComplaint(req, resp, model, employeeId, employeeName, session);
                    break;
                case "/delete-complaint":
                    handleDeleteComplaint(req, resp, model, employeeId, session);
                    break;
                case "/update-complaint":
                    handleUpdateComplaintPost(req, resp, model, employeeId, session);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/employee-dashboard");
            }

        } catch (Exception e) {
            System.err.println("Error in EmployeeServlet POST: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/employee-dashboard?msg=error");
        }
    }

    private void handleUpdateComplaintPost(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId, HttpSession session) throws IOException {
        try {
            String complaintIdStr = req.getParameter("id");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String category = req.getParameter("category");
            String priority = req.getParameter("priority");

            System.out.println("Updating complaint ID: " + complaintIdStr);
            System.out.println("New title: " + title);

            if (complaintIdStr == null || complaintIdStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Invalid complaint ID");
                resp.sendRedirect(req.getContextPath() + "/employee-dashboard");
                return;
            }

            int complaintId = Integer.parseInt(complaintIdStr);

            List<Complaint> userComplaints = model.getAllComplaintsById(employeeId);
            Complaint existingComplaint = userComplaints.stream()
                    .filter(c -> c.getId() == complaintId && "PENDING".equals(c.getStatus()))
                    .findFirst()
                    .orElse(null);

            if (existingComplaint == null) {
                session.setAttribute("errorMessage", "You can only update your own pending complaints");
                resp.sendRedirect(req.getContextPath() + "/employee-dashboard");
                return;
            }

            Complaint updatedComplaint = new Complaint();
            updatedComplaint.setId(complaintId);
            updatedComplaint.setTitle(title);
            updatedComplaint.setDescription(description);
            updatedComplaint.setCategory(category);
            updatedComplaint.setPriority(priority);

            boolean isUpdated = model.updateComplaint(updatedComplaint);

            if (isUpdated) {
                session.setAttribute("successMessage", "Complaint CMP-" + complaintId + " updated successfully!");
                System.out.println("Complaint updated successfully: " + complaintId);
            } else {
                session.setAttribute("errorMessage", "Failed to update complaint");
                System.out.println("Failed to update complaint: " + complaintId);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid complaint ID format");
            System.err.println("Invalid complaint ID format");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error updating complaint: " + e.getMessage());
            System.err.println("Error updating complaint: " + e.getMessage());
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/employee-dashboard");
    }

    private void handleSubmitComplaint(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId, String employeeName, HttpSession session) throws IOException {
        try {
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String category = req.getParameter("category");
            String priority = req.getParameter("priority");
            String status = "PENDING";

            Timestamp createdAt = new Timestamp(System.currentTimeMillis());

            Complaint complaint = new Complaint();
            complaint.setTitle(title);
            complaint.setDescription(description);
            complaint.setCategory(category);
            complaint.setPriority(priority);
            complaint.setStatus(status);
            complaint.setCreatedAt(createdAt);
            complaint.setSubmitterName(employeeName);
            complaint.setSubmittedBy(employeeId);

            boolean isSaved = model.saveComplaint(complaint);

            if (isSaved) {
                session.setAttribute("successMessage", "Complaint submitted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to submit complaint. Please try again.");
            }

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error submitting complaint: " + e.getMessage());
            System.err.println("Error submitting complaint: " + e.getMessage());
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/employee-dashboard");
    }

    private void handleDeleteComplaint(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId, HttpSession session) throws IOException {
        try {
            String complaintIdStr = req.getParameter("id");
            if (complaintIdStr == null || complaintIdStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Invalid complaint ID");
                resp.sendRedirect(req.getContextPath() + "/employee-dashboard");
                return;
            }

            int complaintId = Integer.parseInt(complaintIdStr);

            List<Complaint> userComplaints = model.getAllComplaintsById(employeeId);
            boolean isOwner = userComplaints.stream().anyMatch(c -> c.getId() == complaintId);

            if (!isOwner) {
                session.setAttribute("errorMessage", "You can only delete your own complaints");
                resp.sendRedirect(req.getContextPath() + "/employee-dashboard");
                return;
            }

            boolean isDeleted = model.deleteComplain(complaintId);

            if (isDeleted) {
                session.setAttribute("successMessage", "Complaint deleted successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to delete complaint");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid complaint ID format");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error deleting complaint: " + e.getMessage());
            System.err.println("Error deleting complaint: " + e.getMessage());
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/employee-dashboard");
    }

    private void handleMyComplaints(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId) throws ServletException, IOException {
        try {
            List<Complaint> complaints = model.getAllComplaintsById(employeeId);
            req.setAttribute("complaints", complaints);
            req.setAttribute("pageTitle", "My Complaints");
            req.getRequestDispatcher("/pages/my-complaints.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Error loading complaints", e);
        }
    }

    private void handleViewComplaint(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId) throws ServletException, IOException {
        String complaintIdStr = req.getParameter("id");
        if (complaintIdStr != null) {
            try {
                int complaintId = Integer.parseInt(complaintIdStr);
                List<Complaint> userComplaints = model.getAllComplaintsById(employeeId);
                Complaint complaint = userComplaints.stream()
                        .filter(c -> c.getId() == complaintId)
                        .findFirst()
                        .orElse(null);

                if (complaint != null) {
                    req.setAttribute("complaint", complaint);
                    req.getRequestDispatcher("/pages/view-complaint.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/employee-dashboard?msg=complaint_not_found");
                }
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/employee-dashboard?msg=invalid_id");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/employee-dashboard");
        }
    }
}
