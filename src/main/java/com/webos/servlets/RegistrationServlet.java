package com.webos.servlets;

import com.webos.utils.DatabaseUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Capture fields using the names from your JSP template
        String username = request.getParameter("name");     // JSP name="name"
        String email    = request.getParameter("email");    // JSP name="email"
        String phone    = request.getParameter("contact");  // JSP name="contact"
        String password = request.getParameter("pass");     // JSP name="pass"
        String confirm  = request.getParameter("re_pass");  // JSP name="re_pass"

        // 2. Validate Password Match
        if (password == null || !password.equals(confirm)) {
            // "status" attribute is used by your JSP's JavaScript to show alerts
            request.setAttribute("status", "failed");
            request.getRequestDispatcher("registration.jsp").forward(request, response);
            return;
        }

        // 3. Insert into Database
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "INSERT INTO users (username, password, balance, email, phone) VALUES (?, ?, ?, ?, ?)";

            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, password);
            pst.setDouble(3, 1000.00); // Default Balance
            pst.setString(4, email);
            pst.setString(5, phone);

            int rowCount = pst.executeUpdate();
            if (rowCount > 0) {
                // Success: Set status to success for SweetAlert
                request.setAttribute("status", "success");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
            } else {
                request.setAttribute("status", "failed");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace(); // Check console for detailed errors
            request.setAttribute("status", "failed");
            request.getRequestDispatcher("registration.jsp").forward(request, response);
        }
    }
}
