<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container">
  <div class="row justify-content-center mt-5">
    <div class="col-md-4">
      <div class="card shadow">
        <div class="card-body">
          <h4 class="text-center mb-4">Login</h4>

          <% if (session.getAttribute("message") != null) { %>
          <div class="alert alert-success">
            <%= session.getAttribute("message") %>
            <% session.removeAttribute("message"); %>
          </div>
          <% } %>

          <% if (session.getAttribute("error") != null) { %>
          <div class="alert alert-danger">
            <%= session.getAttribute("error") %>
            <% session.removeAttribute("error"); %>
          </div>
          <% } %>

          <form action="${pageContext.request.contextPath}/authServlet" method="post">
            <input type="hidden" name="action" value="login" />
            <div class="mb-3">
              <label class="form-label">Username</label>
              <input type="text" class="form-control" name="username" required />
            </div>
            <div class="mb-3">
              <label class="form-label">Password</label>
              <input type="password" class="form-control" name="password" required />
            </div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
          </form>

          <div class="text-center mt-3">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/pages/signup.jsp">Sign up</a></p>
          </div>

        </div>
      </div>
    </div>
  </div>
</div>

</body>
</html>
