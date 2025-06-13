package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// Change mapping to /index.jsp or /customers
@WebServlet("/customers")
public class TestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Customer> customers = new ArrayList<>();
        customers.add(new Customer("Alice", "alice@example.com"));
        customers.add(new Customer("Bob", "bob@example.com"));
        customers.add(new Customer("Charlie", "charlie@example.com"));

        // Set the list as a request attribute
        req.setAttribute("customers", customers);

        // Forward to JSP
        //customersla tika pennanne me jsp eka atule
        req.getRequestDispatcher("/pages/dashboard.jsp").forward(req, resp);
    }
}