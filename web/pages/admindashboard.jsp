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

    <div class="card mb-4">
        <div class="card-header">
            <i class="bi bi-funnel me-2"></i>Filter Complaints
        </div>
        <div class="card-body">
            <form action="admin-dashboard" method="get" class="row g-3">
                <div class="col-md-3">
                    <label for="statusFilter" class="form-label">Filter by Status</label>
                    <select class="form-select" id="statusFilter" name="status">
                        <option value="">All Statuses</option>
                        <option value="PENDING">Pending</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="RESOLVED">Resolved</option>
                        <option value="REJECTED">Rejected</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="dateFilter" class="form-label">Date Range</label>
                    <input type="date" class="form-control" id="dateFilter" name="date">
                </div>
                <div class="col-md-4">
                    <label for="searchFilter" class="form-label">Search</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                        <input type="text" class="form-control" id="searchFilter" name="search"
                               placeholder="Search by ID, title, or employee">
                    </div>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-filter"></i> Apply
                    </button>
                </div>
            </form>
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
                                String statusClass = "";
                                String statusIcon = "";
                                String priorityClass = "";

                                switch (complaint.getStatus()) {
                                    case "RESOLVED":
                                        statusClass = "bg-success";
                                        statusIcon = "bi-check-circle-fill";
                                        break;
                                    case "PENDING":
                                        statusClass = "bg-warning";
                                        statusIcon = "bi-hourglass";
                                        break;
                                    case "IN_PROGRESS":
                                        statusClass = "bg-info";
                                        statusIcon = "bi-arrow-repeat";
                                        break;
                                    case "REJECTED":
                                        statusClass = "bg-danger";
                                        statusIcon = "bi-x-circle-fill";
                                        break;
                                    default:
                                        statusClass = "bg-secondary";
                                        statusIcon = "bi-question-circle";
                                }

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
                        <td><strong>CMP-<%= complaint.getId() %></strong></td>
                        <td>
                            <div class="complaint-title" title="<%= complaint.getDescription() != null ? complaint.getDescription() : complaint.getTitle() %>">
                                <%= complaint.getTitle() %>
                            </div>
                        </td>
                        <td><span class="badge bg-light text-dark"><%= complaint.getCategory() %></span></td>
                        <td><%= complaint.getSubmitterName() != null ? complaint.getSubmitterName() : "Unknown" %></td>
                        <td><span class="<%= priorityClass %>"><strong><%= complaint.getPriority() %></strong></span></td>
                        <td><%= complaint.getCreatedAt() != null ? dateFormat.format(complaint.getCreatedAt()) : "N/A" %></td>
                        <td>
                            <span class="badge <%= statusClass %> status-badge">
                                <i class="bi <%= statusIcon %>"></i> <%= complaint.getStatus().replace("_", " ") %>
                            </span>
                        </td>
                        <td>
                            <div class="btn-group">
                                <form action="view-complaint" method="get" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= complaint.getId() %>">
                                    <button type="submit" class="btn btn-sm btn-info action-btn" title="View">
                                        <i class="bi bi-eye-fill"></i>
                                    </button>
                                </form>
<%--                                <form action="update-status" method="get" style="display:inline;">--%>
<%--                                    <input type="hidden" name="id" value="<%= complaint.getId() %>">--%>
<%--                                    <button type="submit" class="btn btn-sm btn-primary action-btn" title="Edit">--%>
<%--                                        <i class="bi bi-pencil-fill"></i>--%>
<%--                                    </button>--%>
<%--                                </form>--%>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>