package com.project.servlet;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/games/adventure")
public class AdventureGameServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdventureGameServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        LOGGER.info("Accessing Adventure Game");
        req.getRequestDispatcher("/views/games/adventure.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("save_progress".equals(action)) {
            try {
                String username = (String) req.getSession().getAttribute("username");
                int level = Integer.parseInt(req.getParameter("level"));
                int progress = Integer.parseInt(req.getParameter("progress"));
                LOGGER.info("Adventure progress saved for user: " + username + " (Level: " + level + ", Progress: " + progress + "%)");
                resp.sendRedirect(req.getContextPath() + "/games");
            } catch (NumberFormatException e) {
                LOGGER.severe("Invalid progress format: " + e.getMessage());
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }
}

