<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Registration - Complaint Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/signup.css">
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
    <div class="signup-container">
        <div class="card signup-card">
            <div class="signup-header">
                <i class="bi bi-person-plus-fill system-icon"></i>
                <h3>Employee Registration</h3>
                <p>Join the Complaint Management System</p>
            </div>
            <div class="signup-body">
                <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger d-flex align-items-center">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <div>
                        <%= session.getAttribute("error") %>
                        <% session.removeAttribute("error"); %>
                    </div>
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/authServlet" id="signupForm" method="post">
                    <input type="hidden" name="action" value="signup"/>
                    <input type="hidden" name="role" value="EMPLOYEE"/>

                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-person-fill"></i>
                        </span>
                        <input type="text" class="form-control" id="fullName" name="full_name"
                               placeholder="Enter your full name" onblur="validateField('fullName')"
                               required/>
                    </div>
                    <span id="fullNameError" class="error-message"></span>

                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-envelope-fill"></i>
                        </span>
                        <input type="email" class="form-control" id="email" name="email"
                               placeholder="Enter your email address" onblur="validateField('email')"
                               required/>
                    </div>
                    <span id="emailError" class="error-message"></span>

                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-person-badge-fill"></i>
                        </span>
                        <input type="text" class="form-control" id="username" name="username"
                               placeholder="Choose a username" onblur="validateField('username')"
                               required/>
                    </div>
                    <span id="usernameError" class="error-message"></span>

                    <div class="input-group">
    <span class="input-group-text">
        <i class="bi bi-lock-fill"></i>
    </span>

                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="Create a strong password"
                               onblur="validateField('password')"
                               oninput="showPasswordStrength()" required/>

                        <span class="input-group-text" onclick="togglePasswordVisibility()" style="cursor: pointer;">
        <i id="togglePasswordIcon" class="bi bi-eye-slash"></i>
    </span>
                    </div>

                    <div id="passwordStrength" class="password-strength"></div>
                    <span id="passwordError" class="error-message"></span>

                    <button type="button" onclick="validateForm()" id="btnCreateAccount"
                            class="btn btn-signup w-100 mt-3">
                        <i class="bi bi-person-plus me-2"></i>
                        Create Account
                    </button>

                </form>

                <div class="login-link">
                    <p class="mb-0">Already have an account?
                        <a href="${pageContext.request.contextPath}/index.jsp">
                            <i class="bi bi-box-arrow-in-right me-1"></i>Sign In
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/signup.js"></script>
</body>
</html>
