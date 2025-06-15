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

@WebServlet(urlPatterns = {"/submit-complaint", "/view-complaint", "/edit-complaint", "/delete-complaint", "/my-complaints"})
public class EmployeeServlet extends HttpServlet {

    ComplaintModel model;
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        model = new ComplaintModel(dataSource);
        String servletPath = req.getServletPath();

        try {
            HttpSession session = req.getSession(false);
            if (session == null) {
                resp.sendRedirect("/pages/login.jsp?msg=session_expired");
                return;
            }

            Integer employeeId = (Integer) session.getAttribute("employeeId");

            if (employeeId == null) {
                resp.sendRedirect("/pages/login.jsp?msg=invalid_session");
                return;
            }

            switch (servletPath) {
                case "/view-complaint":
                    handleViewComplaint(req, resp, model, employeeId);
                    break;
                case "/my-complaints":
                    handleMyComplaints(req, resp, model, employeeId);
                    break;
                case "/edit-complaint":
                    handleEditComplaint(req, resp, model, employeeId);
                    break;
                default:
                    resp.sendRedirect("/pages/employeedashboard.jsp");
            }
        } catch (IOException e) {
            System.err.println("Error in EmployeeServlet GET: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect("/pages/employeedashboard.jsp?msg=error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String servletPath = req.getServletPath();

        try {
            HttpSession session = req.getSession(false);
            if (session == null) {
                resp.sendRedirect("/pages/login.jsp?msg=session_expired");
                return;
            }
            Integer employeeId = (Integer) session.getAttribute("employeeId");
            System.out.println("this is employee id: " + employeeId);
            String employeeName = (String) session.getAttribute("employeeName");

            if (employeeId == null || employeeName.isEmpty()) {
                resp.sendRedirect("/pages/login.jsp?msg=invalid_session");
                return;
            }

            ComplaintModel model = new ComplaintModel(dataSource);
            System.out.println(action);
            System.out.println(servletPath);
            switch (servletPath) {
                case "/submit-complaint":
                    handleSubmitComplaint(req, resp, model, employeeId, employeeName);
                    break;
                case "/delete-complaint":
                    handleDeleteComplaint(req, resp, model, employeeId);
                    break;
                default:
                    resp.sendRedirect("/pages/employeedashboard.jsp");
            }

        } catch (Exception e) {
            System.err.println("Error in EmployeeServlet POST: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect("/pages/employeedashboard.jsp?msg=error");
        }


    }

    private void handleSubmitComplaint(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId, String employeeName) throws ServletException {
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String category = req.getParameter("category");
        String priority = req.getParameter("priority");
        String status = "PENDING";

        Timestamp createdAt = new Timestamp(System.currentTimeMillis());
        HttpSession session = req.getSession(false);

        int submitterId = (int) session.getAttribute("employeeId");
        String submitterName = (String) session.getAttribute("employeeName");

        Complaint complaint = new Complaint();

        complaint.setTitle(title);
        complaint.setDescription(description);
        complaint.setCategory(category);
        complaint.setPriority(priority);
        complaint.setStatus(status);
        complaint.setCreatedAt(createdAt);
        complaint.setSubmitterName(submitterName);
        complaint.setSubmittedBy(employeeId);
        System.out.println(submitterId);
        System.out.println("Submitted complaint: " + complaint);
        try {
            boolean isSaved = model.saveComplaint(complaint);
            if (isSaved) {
                resp.sendRedirect("/cms/pages/employeedashboard.jsp");
            } else {
                resp.sendRedirect("/cms/pages/employeedashboard.jsp");
            }
        } catch (Exception e) {
            throw new ServletException("Error saving complaint", e);
        }
    }

    private void handleDeleteComplaint(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId) {
    }

    private void handleEditComplaint(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId) {

    }

    private void handleMyComplaints(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId) {
    }

    private void handleViewComplaint(HttpServletRequest req, HttpServletResponse resp, ComplaintModel model, Integer employeeId) {
    }
}
