package com.project.servlet;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/games/typing-speed")
public class TypingSpeedGameServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TypingSpeedGameServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        LOGGER.info("Accessing Typing Speed Game");
        req.getRequestDispatcher("/views/games/typing.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("save_score".equals(action)) {
            try {
                String username = (String) req.getSession().getAttribute("username");
                int wpm = Integer.parseInt(req.getParameter("wpm"));
                int accuracy = Integer.parseInt(req.getParameter("accuracy"));
                LOGGER.info("Typing Speed recorded for user: " + username + " (WPM: " + wpm + ", Accuracy: " + accuracy + "%)");
                resp.sendRedirect(req.getContextPath() + "/games");
            } catch (NumberFormatException e) {
                LOGGER.severe("Invalid score format: " + e.getMessage());
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }
}

