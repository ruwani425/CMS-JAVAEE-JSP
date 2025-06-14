<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Complaint Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="static/css/index.css">
</head>
<body>
<div class="particles">
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
</div>

<div class="container">
    <div class="login-container">
        <div class="card login-card">
            <div class="login-header">
                <i class="bi bi-shield-check system-icon"></i>
                <h3>Complaint Management System</h3>
                <p>Municipal IT Division</p>
            </div>
            <div class="login-body">
                <% if (session.getAttribute("message") != null) { %>
                <div class="alert alert-success d-flex align-items-center">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    <div>
                        <%= session.getAttribute("message") %>
                        <% session.removeAttribute("message"); %>
                    </div>
                </div>
                <% } %>

                <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger d-flex align-items-center">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <div>
                        <%= session.getAttribute("error") %>
                        <% session.removeAttribute("error"); %>
                    </div>
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/authServlet" method="post">
                    <input type="hidden" name="action" value="login"/>

                    <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-person-fill"></i>
                            </span>
                        <input type="text" class="form-control" name="username" placeholder="Enter your username"
                               required/>
                    </div>

                    <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-lock-fill"></i>
                            </span>
                        <input type="password" class="form-control" name="password" placeholder="Enter your password"
                               required/>
                    </div>

                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                        <label class="form-check-label" for="rememberMe">
                            Remember me
                        </label>
                    </div>

                    <button type="submit" class="btn btn-login w-100">
                        <i class="bi bi-box-arrow-in-right me-2"></i>
                        Sign In
                    </button>
                </form>

                <div class="signup-link">
                    <p class="mb-0">Don't have an account?
                        <a href="${pageContext.request.contextPath}/pages/signup.jsp">
                            <i class="bi bi-person-plus me-1"></i>Create Account
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
