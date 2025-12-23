package com.project.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

public class SnakeGameServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SnakeGameServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        LOGGER.info("Accessing Snake Game");
        req.getRequestDispatcher("/views/games/snake.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("save_score".equals(action)) {
            try {
                String username = (String) req.getSession().getAttribute("username");
                int score = Integer.parseInt(req.getParameter("score"));
                LOGGER.info("Snake game score saved for user: " + username + " (Score: " + score + ")");
                resp.sendRedirect(req.getContextPath() + "/games");
            } catch (NumberFormatException e) {
                LOGGER.severe("Invalid score format: " + e.getMessage());
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }
}
