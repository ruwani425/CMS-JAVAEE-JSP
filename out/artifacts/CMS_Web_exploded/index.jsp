<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Customer" %>
<%@ page import="java.util.List" %>

<html>
<head>
  <title>Customer List</title>
  <style>
    table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; }
    .btn {
      padding: 10px 20px;
      background-color: #4CAF50;
      color: white;
      border: none;
      text-decoration: none;
      border-radius: 5px;
      cursor: pointer;
    }
    .btn:hover {
      background-color: #45a049;
    }
  </style>
</head>
<body>

<h1>Customer List</h1>

<%
  List<Customer> customers = (List<Customer>) request.getAttribute("customers");
  if (customers != null && !customers.isEmpty()) {
%>
<table>
  <tr>
    <th>Name</th>
    <th>Email</th>
  </tr>
  <%
    for (Customer customer : customers) {
  %>
  <tr>
    <td><%= customer.getName() %></td>
    <td><%= customer.getEmail() %></td>
  </tr>
  <%
    }
  %>
</table>
<%
} else {
%>
<p>No customers found.</p>
<%
  }
%>

<!-- Button to go to dashboard.jsp -->
<%--data retrive karagnna ona tana,customersla tika ganna widiya--%>
<a href="<%= request.getContextPath() %>/customers" class="btn">Go to Dashboard</a>

</body>
</html>
