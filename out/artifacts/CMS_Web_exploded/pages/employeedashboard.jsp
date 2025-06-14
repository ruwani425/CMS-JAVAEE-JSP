<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Dashboard - Complaint Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #34495e;
            --accent-color: #3498db;
            --success-color: #27ae60;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --info-color: #17a2b8;
            --light-color: #ecf0f1;
            --dark-color: #2c3e50;
            --text-color: #2c3e50;
            --text-light: #7f8c8d;
            --card-shadow: 0 8px 25px rgba(44, 62, 80, 0.1);
            --card-hover-shadow: 0 12px 35px rgba(44, 62, 80, 0.15);
        }

        body {
            color: var(--text-color);
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .top-navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 4px 20px rgba(44, 62, 80, 0.3);
            padding: 15px 0;
            backdrop-filter: blur(10px);
        }

        .navbar-brand {
            font-size: 1.6rem;
            font-weight: 700;
            color: white !important;
            letter-spacing: 1px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .navbar-nav .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            margin: 0 3px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .navbar-nav .nav-link:hover {
            color: #fff !important;
            background-color: rgba(255, 255, 255, 0.15);
            transform: translateY(-1px);
        }

        .navbar-nav .nav-link.active {
            color: #fff !important;
            background: linear-gradient(135deg, var(--accent-color) 0%, #2980b9 100%);
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .logout-btn {
            background: linear-gradient(135deg, var(--danger-color) 0%, #c0392b 100%);
            border: none;
            color: white;
            border-radius: 8px;
            padding: 0.6rem 1.2rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }

        .logout-btn:hover {
            background: linear-gradient(135deg, #c0392b 0%, #a93226 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(231, 76, 60, 0.4);
            color: white;
        }

        .main-content {
            padding: 30px 20px;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            margin-bottom: 25px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: var(--card-hover-shadow);
        }

        .card-header {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%, rgba(248, 249, 250, 0.9) 100%);
            border-bottom: 2px solid rgba(52, 152, 219, 0.1);
            padding: 18px 25px;
            font-weight: 600;
            color: var(--primary-color);
            border-radius: 15px 15px 0 0 !important;
        }

        .summary-card {
            text-align: center;
            padding: 30px 20px;
            border-radius: 15px;
            position: relative;
            overflow: hidden;
        }

        .summary-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
            pointer-events: none;
        }

        .summary-card .dashboard-icon {
            font-size: 3rem;
            margin-bottom: 15px;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .summary-card h2 {
            font-size: 2.8rem;
            font-weight: 700;
            margin: 15px 0 10px;
            position: relative;
            z-index: 1;
        }

        .summary-card h5 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .bg-primary-gradient {
            background: linear-gradient(135deg, var(--accent-color) 0%, #2980b9 100%) !important;
        }

        .bg-success-gradient {
            background: linear-gradient(135deg, var(--success-color) 0%, #229954 100%) !important;
        }

        .bg-warning-gradient {
            background: linear-gradient(135deg, var(--warning-color) 0%, #e67e22 100%) !important;
        }

        .btn {
            border-radius: 8px;
            padding: 0.5rem 1.2rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--accent-color) 0%, #2980b9 100%);
            border: none;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #2980b9 0%, #21618c 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(52, 152, 219, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-color) 0%, #229954 100%);
            border: none;
            box-shadow: 0 4px 15px rgba(39, 174, 96, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger-color) 0%, #c0392b 100%);
            border: none;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }

        .btn-info {
            background: linear-gradient(135deg, var(--info-color) 0%, #138496 100%);
            border: none;
            box-shadow: 0 4px 15px rgba(23, 162, 184, 0.3);
        }

        .table {
            border-collapse: separate;
            border-spacing: 0;
        }

        .table th {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            font-weight: 600;
            color: var(--primary-color);
            border: none;
            padding: 15px;
        }

        .table td {
            padding: 15px;
            border-top: 1px solid rgba(52, 152, 219, 0.1);
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background-color: rgba(52, 152, 219, 0.05);
        }

        .status-badge {
            font-size: 0.85rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-weight: 500;
        }

        .action-btn {
            width: 35px;
            height: 35px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            margin: 0 2px;
        }

        .page-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 25px 30px;
            margin-bottom: 30px;
            box-shadow: var(--card-shadow);
        }

        .page-header h1 {
            color: var(--primary-color);
            font-weight: 700;
            margin: 0;
        }

        .form-control, .form-select, .form-control:focus, .form-select:focus {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 0.6rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.25rem rgba(52, 152, 219, 0.15);
        }

        .input-group-text {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px solid #e9ecef;
            border-right: none;
            color: var(--primary-color);
            border-radius: 8px 0 0 8px;
        }

        .input-group .form-control {
            border-left: none;
            border-radius: 0 8px 8px 0;
        }

        .input-group:focus-within .input-group-text {
            border-color: var(--accent-color);
            background: linear-gradient(135deg, rgba(52, 152, 219, 0.1) 0%, rgba(52, 152, 219, 0.05) 100%);
        }

        /* New Complaint Button Styles */
        .new-complaint-btn {
            background: linear-gradient(135deg, var(--success-color) 0%, #229954 100%);
            border: none;
            color: white;
            border-radius: 12px;
            padding: 12px 25px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(39, 174, 96, 0.3);
        }

        .new-complaint-btn:hover {
            background: linear-gradient(135deg, #229954 0%, #1e8449 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(39, 174, 96, 0.4);
            color: white;
        }

        /* Modal Styles */
        .modal-content {
            border: none;
            border-radius: 15px;
            box-shadow: 0 15px 50px rgba(44, 62, 80, 0.3);
        }

        .modal-header {
            background: linear-gradient(135deg, var(--accent-color) 0%, #2980b9 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 20px 25px;
        }

        .modal-title {
            font-weight: 700;
            font-size: 1.3rem;
        }

        .btn-close {
            filter: invert(1);
        }

        .modal-body {
            padding: 25px;
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 20px 15px;
            }

            .summary-card {
                padding: 20px 15px;
            }

            .summary-card h2 {
                font-size: 2.2rem;
            }
        }
    </style>
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
            <button type="button" class="btn new-complaint-btn" data-bs-toggle="modal" data-bs-target="#newComplaintModal">
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
                                <form action="delete-complaint" method="post" style="display:inline;"
                                      onsubmit="return confirm('Are you sure you want to delete this complaint?');">
                                    <input type="hidden" name="id" value="<%= complaintId %>">
                                    <button type="submit" class="btn btn-sm btn-danger action-btn" title="Delete">
                                        <i class="bi bi-trash-fill"></i>
                                    </button>
                                </form>
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
<div class="modal fade" id="newComplaintModal" tabindex="-1" aria-labelledby="newComplaintModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="newComplaintModalLabel">
                    <i class="bi bi-plus-circle me-2"></i>Submit New Complaint
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="submit-complaint" method="post" id="complaintForm">
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