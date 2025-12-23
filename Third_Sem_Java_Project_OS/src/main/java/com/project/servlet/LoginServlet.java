package com.project.servlet;

import com.project.dao.UserDAO;
import com.project.model.User;
import com.project.util.DatabaseUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        // Initialize database when servlet starts
        DatabaseUtil.initializeDatabase();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("dashboard");
            return;
        }

        // Forward to login page
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = UserDAO.getInstance();
        User user = userDAO.getUserByUsername(username);

        if (user != null && user.getPassword().equals(password)) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            response.sendRedirect("dashboard");
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Logout functionality
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login");
    }
}