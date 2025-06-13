<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container">
    <div class="row justify-content-center mt-5">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-body">
                    <h4 class="text-center mb-4">Employee Registration</h4>

                    <% if (session.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= session.getAttribute("error") %>
                        <% session.removeAttribute("error"); %>
                    </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/authServlet" method="post">
                        <input type="hidden" name="action" value="signup" />
                        <div class="mb-3">
                            <label class="form-label">Full Name</label>
                            <input type="text" class="form-control" name="full_name" required/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" name="email" required/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" class="form-control" name="username" required/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-control" name="password" required/>
                        </div>

                        <input type="hidden" name="role" value="EMPLOYEE"/>

                        <button type="submit" class="btn btn-success w-100">Register</button>
                    </form>

                    <div class="text-center mt-3">
                        <p>Already have an account? <a href="${pageContext.request.contextPath}/index.jsp">Login</a></p>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
