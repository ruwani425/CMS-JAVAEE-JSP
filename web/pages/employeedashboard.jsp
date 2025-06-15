<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Dashboard - Complaint Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/employeedashboard.css">
</head>
<body>
<!-- Top Navigation -->
<nav class="navbar navbar-expand-lg top-navbar">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <i class="bi bi-shield-check me-2"></i>CMS Employee
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

<!-- Main Content -->
<div class="container-fluid main-content">
    <!-- Page Header -->
    <div class="page-header">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="h2"><i class="bi bi-grid-1x2 me-2"></i>Employee Dashboard</h1>
            <button type="button" class="btn new-complaint-btn" data-bs-toggle="modal"
                    data-bs-target="#newComplaintModal">
                <i class="bi bi-plus-circle me-2"></i>New Complaint
            </button>
        </div>
    </div>

    <!-- Summary Cards -->
    <div class="row mb-4">
        <div class="col-lg-4 col-md-6 mb-3">
            <div class="card text-white bg-primary-gradient">
                <div class="card-body summary-card">
                    <i class="bi bi-clipboard-data dashboard-icon"></i>
                    <h5 class="card-title">My Complaints</h5>
                    <h2 class="card-text">12</h2>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-6 mb-3">
            <div class="card text-white bg-warning-gradient">
                <div class="card-body summary-card">
                    <i class="bi bi-hourglass-split dashboard-icon"></i>
                    <h5 class="card-title">Pending</h5>
                    <h2 class="card-text">5</h2>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-6 mb-3">
            <div class="card text-white bg-success-gradient">
                <div class="card-body summary-card">
                    <i class="bi bi-check-circle dashboard-icon"></i>
                    <h5 class="card-title">Resolved</h5>
                    <h2 class="card-text">7</h2>
                </div>
            </div>
        </div>
    </div>

    <!-- My Complaints Table -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <div>
                <i class="bi bi-list-ul me-2"></i>My Recent Complaints
            </div>
            <form action="my-complaints" method="get">
                <button type="submit" class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-eye"></i> View All
                </button>
            </form>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (int i = 1; i <= 5; i++) {
                            String complaintId = "CMP-" + (2000 + i);
                            String date = "2025-06-" + (i + 10);
                            int statusCode = i % 3;
                            String statusClass = "";
                            String statusIcon = "";
                            String statusText = "";
                            String title = "";
                            String category = "";

                            if (statusCode == 0) {
                                statusClass = "bg-success";
                                statusIcon = "bi-check-circle-fill";
                                statusText = "Resolved";
                                title = "Software license expired";
                                category = "Software";
                            } else if (statusCode == 1) {
                                statusClass = "bg-warning";
                                statusIcon = "bi-hourglass";
                                statusText = "Pending";
                                title = "Printer not working";
                                category = "Hardware";
                            } else {
                                statusClass = "bg-info";
                                statusIcon = "bi-arrow-repeat";
                                statusText = "In Progress";
                                title = "Network connectivity issue";
                                category = "Network";
                            }
                    %>
                    <tr>
                        <td><strong><%= complaintId %>
                        </strong></td>
                        <td><%= title %>
                        </td>
                        <td>
                            <span class="badge bg-secondary"><%= category %></span>
                        </td>
                        <td><%= date %>
                        </td>
                        <td>
                            <span class="badge <%= statusClass %> status-badge">
                                <i class="bi <%= statusIcon %>"></i> <%= statusText %>
                            </span>
                        </td>
                        <td>
                            <div class="btn-group">
                                <form action="view-complaint" method="get" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= complaintId %>">
                                    <button type="submit" class="btn btn-sm btn-info action-btn" title="View">
                                        <i class="bi bi-eye-fill"></i>
                                    </button>
                                </form>
                                <% if (statusCode == 1) { %>
                                <form action="edit-complaint" method="get" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= complaintId %>">
                                    <button type="submit" class="btn btn-sm btn-primary action-btn" title="Edit">
                                        <i class="bi bi-pencil-fill"></i>
                                    </button>
                                </form>
<%--                                <form action="delete-complaint" method="post" style="display:inline;"--%>
<%--                                      onsubmit="return confirm('Are you sure you want to delete this complaint?');">--%>
<%--                                    <input type="hidden" name="id" value="<%= complaintId %>">--%>
<%--                                    <button type="submit" class="btn btn-sm btn-danger action-btn" title="Delete">--%>
<%--                                        <i class="bi bi-trash-fill"></i>--%>
<%--                                    </button>--%>
<%--                                </form>--%>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- New Complaint Modal -->
<div class="modal fade" id="newComplaintModal" tabindex="-1" aria-labelledby="newComplaintModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="newComplaintModalLabel">
                    <i class="bi bi-plus-circle me-2"></i>Submit New Complaint
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/submit-complaint" method="post" id="complaintForm">
                    <div class="mb-3">
                        <label for="complaintTitle" class="form-label">Complaint Title</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-tag"></i></span>
                            <input type="text" class="form-control" id="complaintTitle" name="title"
                                   placeholder="Brief title of your complaint" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="complaintCategory" class="form-label">Category</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-folder"></i></span>
                                <select class="form-select" id="complaintCategory" name="category" required>
                                    <option value="">Select Category</option>
                                    <option value="hardware">Hardware Issue</option>
                                    <option value="software">Software Issue</option>
                                    <option value="network">Network Issue</option>
                                    <option value="facility">Facility Issue</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="complaintPriority" class="form-label">Priority</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-exclamation-triangle"></i></span>
                                <select class="form-select" id="complaintPriority" name="priority" required>
                                    <option value="low">Low</option>
                                    <option value="medium">Medium</option>
                                    <option value="high">High</option>
                                    <option value="urgent">Urgent</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="complaintDescription" class="form-label">Description</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-chat-left-text"></i></span>
                            <textarea class="form-control" id="complaintDescription" name="description" rows="4"
                                      placeholder="Please provide detailed information about your complaint"
                                      required></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle"></i> Cancel
                </button>
                <button type="submit" form="complaintForm" class="btn btn-primary">
                    <i class="bi bi-send"></i> Submit Complaint
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>