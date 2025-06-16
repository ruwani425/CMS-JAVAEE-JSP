<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dto.Complaint" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Complaint - CMS Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/update-complaint.css">
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header">
                    <h4 class="mb-0">
                        <i class="bi bi-pencil-square me-2"></i>Update Complaint Status
                    </h4>
                </div>
                <div class="card-body p-4">
                    <div class="info-section">
                        <h5 class="section-title">
                            <i class="bi bi-info-circle me-2"></i>Complaint Information
                        </h5>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Complaint ID</div>
                                    <p class="info-value fw-bold">CMP-<%= complaint.getId() %>
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Submitted By</div>
                                    <p class="info-value">
                                        <%= complaint.getSubmitterName() != null ? complaint.getSubmitterName() : "Unknown Employee" %>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Title</div>
                            <p class="info-value fw-bold"><%= complaint.getTitle() %>
                            </p>
                        </div>

                        <div class="info-item">
                            <div class="info-label">Description</div>
                            <p class="info-value"><%= complaint.getDescription() %>
                            </p>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="info-item">
                                    <div class="info-label">Category</div>
                                    <p class="info-value">
                                        <span class="badge bg-secondary"><%= complaint.getCategory() %></span>
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-item">
                                    <div class="info-label">Priority</div>
                                    <p class="info-value">
                                            <span class="badge
                                                <% if("HIGH".equals(complaint.getPriority())) { %>bg-danger<% }
                                                   else if("MEDIUM".equals(complaint.getPriority())) { %>bg-warning text-dark<% }
                                                   else { %>bg-secondary<% } %>">
                                                <%= complaint.getPriority() %>
                                            </span>
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-item">
                                    <div class="info-label">Current Status</div>
                                    <span class="badge status-badge
                                            <% if("PENDING".equals(complaint.getStatus())) { %>bg-warning text-dark<% }
                                               else if("IN_PROGRESS".equals(complaint.getStatus())) { %>bg-info text-white<% }
                                               else if("RESOLVED".equals(complaint.getStatus())) { %>bg-success text-white<% }
                                               else { %>bg-danger text-white<% } %>">
                                            <% if ("PENDING".equals(complaint.getStatus())) { %>
                                                <i class="bi bi-hourglass me-1"></i>
                                            <% } else if ("IN_PROGRESS".equals(complaint.getStatus())) { %>
                                                <i class="bi bi-arrow-repeat me-1"></i>
                                            <% } else if ("RESOLVED".equals(complaint.getStatus())) { %>
                                                <i class="bi bi-check-circle-fill me-1"></i>
                                            <% } else { %>
                                                <i class="bi bi-x-circle-fill me-1"></i>
                                            <% } %>
                                            <%= complaint.getStatus().replace("_", " ") %>
                                        </span>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Submitted On</div>
                                    <p class="info-value">
                                        <i class="bi bi-calendar-plus me-1"></i>
                                        <%= dateFormat.format(complaint.getCreatedAt()) %>
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Last Updated</div>
                                    <p class="info-value">
                                        <i class="bi bi-calendar-check me-1"></i>
                                        <%= dateFormat.format(complaint.getUpdatedAt()) %>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="update-section">
                        <h5 class="section-title">
                            <i class="bi bi-gear me-2"></i>Update Status & Remarks
                        </h5>

                        <form action="update-complaint" method="post">
                            <input type="hidden" name="id" value="<%= complaint.getId() %>">

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="status" class="form-label">
                                        <i class="bi bi-flag me-1"></i>Update Status
                                    </label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="PENDING" <%= "PENDING".equals(complaint.getStatus()) ? "selected" : "" %>>
                                            🕐 Pending
                                        </option>
                                        <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(complaint.getStatus()) ? "selected" : "" %>>
                                            🔄 In Progress
                                        </option>
                                        <option value="RESOLVED" <%= "RESOLVED".equals(complaint.getStatus()) ? "selected" : "" %>>
                                            ✅ Resolved
                                        </option>
                                        <option value="REJECTED" <%= "REJECTED".equals(complaint.getStatus()) ? "selected" : "" %>>
                                            ❌ Rejected
                                        </option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">
                                        <i class="bi bi-person me-1"></i>Admin
                                    </label>
                                    <input type="text" class="form-control" value="Current Admin" readonly>
                                    <small class="text-muted">You are updating this complaint</small>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="adminRemarks" class="form-label">
                                    <i class="bi bi-chat-left-text me-1"></i>Admin Remarks
                                </label>
                                <textarea class="form-control" id="adminRemarks" name="adminRemarks" rows="5"
                                          placeholder="Add your remarks, notes, or resolution details here..."><%= complaint.getAdminRemarks() != null ? complaint.getAdminRemarks() : "" %></textarea>
                                <small class="text-muted">
                                    Provide detailed information about the status update, actions taken, or resolution
                                    steps.
                                </small>
                            </div>

                            <% if (complaint.getAdminRemarks() != null && !complaint.getAdminRemarks().trim().isEmpty()) { %>
                            <div class="mb-4">
                                <label class="form-label">
                                    <i class="bi bi-clock-history me-1"></i>Previous Remarks
                                </label>
                                <div class="alert alert-info">
                                    <strong>Previous Admin Notes:</strong><br>
                                    <%= complaint.getAdminRemarks() %>
                                </div>
                            </div>
                            <% } %>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle me-2"></i>Update Complaint
                                </button>
                                <a href="view-complaint?id=<%= complaint.getId() %>" class="btn btn-secondary">
                                    <i class="bi bi-eye me-2"></i>View Details
                                </a>
                                <a href="admin-dashboard" class="btn btn-secondary">
                                    <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>