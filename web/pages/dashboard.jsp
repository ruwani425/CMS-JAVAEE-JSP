<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Customer" %>
<%@ page import="java.util.List" %>

<html>
<head>
  <title>Customer List</title>
  <style>
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; }
  </style>
</head>
<body>
<h1>Customer List</h1>

<%
  List<Customer> customers = (List<Customer>) request.getAttribute("customers");
  if (customers != null && !customers.isEmpty()) {
%>
<table>
  <thead>
  <tr>
    <th>Name</th>
    <th>Email</th>
  </tr>
  </thead>
  <tbody>
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
  </tbody>
</table>
<%
} else {
%>
<p>No customers found.</p>
<%
  }
%>
</body>
</html>