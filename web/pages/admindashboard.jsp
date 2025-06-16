<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Complaint" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Complaint Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admindashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/simple-validation.css">
</head>
<body>
<nav class="navbar navbar-expand-lg top-navbar">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <i class="bi bi-shield-check me-2"></i>CMS Admin
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="#">
                        <i class="bi bi-speedometer2"></i>Dashboard
                    </a>
                </li>
            </ul>

            <div class="d-flex">
                <form action="logout" method="post">
                    <button type="submit" class="btn logout-btn">
                        <i class="bi bi-box-arrow-right"></i> Logout
                    </button>
                </form>
            </div>
        </div>
    </div>
</nav>

<div class="container-fluid main-content">
    <div class="page-header">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="h2"><i class="bi bi-grid-1x2 me-2"></i>Admin Dashboard</h1>
            <div class="text-muted">
                <i class="bi bi-calendar3"></i> <%= new SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %>
            </div>
        </div>
    </div>

    <%
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (successMessage != null) {
    %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i><%= successMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <% if (errorMessage != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i><%= errorMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="row mb-4">
        <div class="col-lg-3 col-md-6 mb-3">
            <div class="card text-white bg-primary-gradient">
                <div class="card-body summary-card">
                    <i class="bi bi-clipboard-data dashboard-icon"></i>
                    <h5 class="card-title">Total Complaints</h5>
                    <h2 class="card-text">${totalComplaints != null ? totalComplaints : 0}</h2>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-3">
            <div class="card text-white bg-warning-gradient">
                <div class="card-body summary-card">
                    <i class="bi bi-hourglass-split dashboard-icon"></i>
                    <h5 class="card-title">Pending</h5>
                    <h2 class="card-text">${pendingComplaints != null ? pendingComplaints : 0}</h2>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-3">
            <div class="card text-white bg-success-gradient">
                <div class="card-body summary-card">
                    <i class="bi bi-check-circle dashboard-icon"></i>
                    <h5 class="card-title">Resolved</h5>
                    <h2 class="card-text">${resolvedComplaints != null ? resolvedComplaints : 0}</h2>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-3">
            <div class="card text-white bg-danger-gradient">
                <div class="card-body summary-card">
                    <i class="bi bi-x-circle dashboard-icon"></i>
                    <h5 class="card-title">Rejected</h5>
                    <h2 class="card-text">${rejectedComplaints != null ? rejectedComplaints : 0}</h2>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <div>
                <i class="bi bi-table me-2"></i>All Complaints
            </div>
            <div>
                <%
                    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
                    int complaintCount = complaints != null ? complaints.size() : 0;
                %>
                <span class="badge bg-secondary">Showing <%= complaintCount %> complaints</span>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Employee</th>
                        <th>Priority</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (complaints != null && !complaints.isEmpty()) {
                            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                            for (Complaint complaint : complaints) {
                                String priorityClass = "";

                                switch (complaint.getPriority()) {
                                    case "HIGH":
                                        priorityClass = "text-danger";
                                        break;
                                    case "MEDIUM":
                                        priorityClass = "text-warning";
                                        break;
                                    case "LOW":
                                        priorityClass = "text-success";
                                        break;
                                }
                    %>
                    <tr>
                        <td><strong>CMP-<%= complaint.getId() %>
                        </strong></td>
                        <td>
                            <div class="complaint-title"
                                 title="<%= complaint.getDescription() != null ? complaint.getDescription() : complaint.getTitle() %>">
                                <%= complaint.getTitle() %>
                            </div>
                        </td>
                        <td><span class="badge bg-light text-dark"><%= complaint.getCategory() %></span></td>
                        <td><%= complaint.getSubmitterName() != null ? complaint.getSubmitterName() : "Unknown" %>
                        </td>
                        <td><span class="<%= priorityClass %>"><strong><%= complaint.getPriority() %></strong></span>
                        </td>
                        <td><%= complaint.getCreatedAt() != null ? dateFormat.format(complaint.getCreatedAt()) : "N/A" %>
                        </td>
                        <td>
                            <form action="update-status" method="post" class="status-form">
                                <input type="hidden" name="complaintId" value="<%= complaint.getId() %>">
                                <div class="d-flex align-items-center">
                                    <select name="status" class="status-dropdown status-<%= complaint.getStatus() %>">
                                        <option value="PENDING" <%= "PENDING".equals(complaint.getStatus()) ? "selected" : "" %>>
                                            Pending
                                        </option>
                                        <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(complaint.getStatus()) ? "selected" : "" %>>
                                            In Progress
                                        </option>
                                        <option value="RESOLVED" <%= "RESOLVED".equals(complaint.getStatus()) ? "selected" : "" %>>
                                            Resolved
                                        </option>
                                        <option value="REJECTED" <%= "REJECTED".equals(complaint.getStatus()) ? "selected" : "" %>>
                                            Rejected
                                        </option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-primary update-btn"
                                            title="Update Status">
                                        <i class="bi bi-check"></i>
                                    </button>
                                </div>
                            </form>
                        </td>
                        <td>
                            <div class="btn-group">
                                <!-- View Button -->
                                <button type="button" class="btn btn-sm btn-info action-btn" title="View"
                                        data-bs-toggle="modal" data-bs-target="#viewModal<%= complaint.getId() %>">
                                    <i class="bi bi-eye-fill"></i>
                                </button>

                                <button type="button" class="btn btn-sm btn-warning action-btn"
                                        title="Add Remarks"
                                        data-bs-toggle="modal"
                                        data-bs-target="#remarksModal<%= complaint.getId() %>">
                                    <i class="bi bi-chat-left-text-fill"></i>
                                </button>

                                <form action="admin-delete" method="post" style="display:inline;"
                                      onsubmit="return confirm('Are you sure you want to delete this complaint?');">
                                    <input type="hidden" name="id" value="<%= complaint.getId() %>">
                                    <button type="submit" class="btn btn-sm btn-danger action-btn" title="Delete">
                                        <i class="bi bi-trash-fill"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="8" class="text-center py-4">
                            <div class="text-muted">
                                <i class="bi bi-inbox display-4"></i>
                                <p class="mt-2">No complaints found</p>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer bg-transparent">
            <nav>
                <ul class="pagination justify-content-center mb-0">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" tabindex="-1">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>

<%
    if (complaints != null && !complaints.isEmpty()) {
        for (Complaint complaint : complaints) {
%>
<div class="modal fade" id="remarksModal<%= complaint.getId() %>" tabindex="-1"
     aria-labelledby="remarksModalLabel<%= complaint.getId() %>" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning text-dark">
                <h5 class="modal-title" id="remarksModalLabel<%= complaint.getId() %>">
                    <i class="bi bi-chat-left-text-fill me-2"></i>Add Remarks - CMP-<%= complaint.getId() %>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <p><strong>Complaint:</strong> <%= complaint.getTitle() %>
                    </p>
                    <p>
                        <strong>Employee:</strong> <%= complaint.getSubmitterName() != null ? complaint.getSubmitterName() : "Unknown" %>
                    </p>
                    <p><strong>Status:</strong>
                        <span class="badge status-<%= complaint.getStatus() %>">
                            <%= complaint.getStatus().replace("_", " ") %>
                        </span>
                    </p>
                </div>

                <form action="${pageContext.request.contextPath}/add-remarks" method="post"
                      id="remarksForm<%= complaint.getId() %>">
                    <input type="hidden" name="complaintId" value="<%= complaint.getId() %>">

                    <div class="mb-3">
                        <label for="remarks<%= complaint.getId() %>" class="form-label">
                            Admin Remarks: <span class="text-danger">*</span>
                        </label>
                        <textarea class="form-control" id="remarks<%= complaint.getId() %>" name="remarks"
                                  rows="4" placeholder="Enter your remarks here..."
                                  maxlength="500" required></textarea>

                        <span class="form-text text-muted" id="charCounter<%= complaint.getId() %>">
                            0/500 characters
                        </span>

                        <span class="error-message" id="remarksError<%= complaint.getId() %>"></span>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle"></i> Cancel
                </button>
                <button type="button" onclick="submitRemarksForm('<%= complaint.getId() %>')" class="btn btn-warning">
                    <i class="bi bi-check-circle"></i> Add Remarks
                </button>
            </div>
        </div>
    </div>
</div>
<%
        }
    }
%>

<%
    if (complaints != null && !complaints.isEmpty()) {
        for (Complaint complaint : complaints) {
%>
<div class="modal fade" id="viewModal<%= complaint.getId() %>" tabindex="-1"
     aria-labelledby="viewModalLabel<%= complaint.getId() %>" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title" id="viewModalLabel<%= complaint.getId() %>">
                    <i class="bi bi-eye-fill me-2"></i>View Complaint - CMP-<%= complaint.getId() %>
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Complaint ID:</label>
                            <p class="form-control-plaintext">CMP-<%= complaint.getId() %>
                            </p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Status:</label>
                            <p class="form-control-plaintext">
                                <span class="badge status-<%= complaint.getStatus() %>">
                                    <%= complaint.getStatus().replace("_", " ") %>
                                </span>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Title:</label>
                    <p class="form-control-plaintext"><%= complaint.getTitle() %>
                    </p>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Category:</label>
                            <p class="form-control-plaintext">
                                <span class="badge bg-light text-dark"><%= complaint.getCategory() %></span>
                            </p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Priority:</label>
                            <p class="form-control-plaintext">
                                <span class="<%=
                                    "HIGH".equals(complaint.getPriority()) ? "text-danger" :
                                    "MEDIUM".equals(complaint.getPriority()) ? "text-warning" : "text-success"
                                %>">
                                    <strong><%= complaint.getPriority() %></strong>
                                </span>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Employee:</label>
                            <p class="form-control-plaintext"><%= complaint.getSubmitterName() != null ? complaint.getSubmitterName() : "Unknown" %>
                            </p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Date Created:</label>
                            <p class="form-control-plaintext">
                                <%= complaint.getCreatedAt() != null ? new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a").format(complaint.getCreatedAt()) : "N/A" %>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Description:</label>
                    <div class="border rounded p-3 bg-light">
                        <p class="mb-0"><%= complaint.getDescription() != null ? complaint.getDescription() : "No description provided" %>
                        </p>
                    </div>
                </div>

                <% if (complaint.getAdminRemarks() != null && !complaint.getAdminRemarks().trim().isEmpty()) { %>
                <div class="mb-3">
                    <label class="form-label fw-bold">Admin Remarks:</label>
                    <div class="border rounded p-3 bg-warning bg-opacity-10">
                        <p class="mb-0"><%= complaint.getAdminRemarks() %>
                        </p>
                    </div>
                </div>
                <% } %>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle"></i> Close
                </button>
            </div>
        </div>
    </div>
</div>
<%
        }
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/remarks-validation.js"></script>
</body>
</html>
