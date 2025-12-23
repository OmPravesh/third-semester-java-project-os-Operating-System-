package com.project.servlet;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/games/doom3d")
public class Doom3DGameServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(Doom3DGameServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        LOGGER.info("Accessing Doom 3D Game");
        req.getRequestDispatcher("/views/games/doom.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("save_score".equals(action)) {
            try {
                String username = (String) req.getSession().getAttribute("username");
                int score = Integer.parseInt(req.getParameter("score"));
                LOGGER.info("Doom 3D score saved for user: " + username + " (Score: " + score + ")");
                resp.sendRedirect(req.getContextPath() + "/games");
            } catch (NumberFormatException e) {
                LOGGER.severe("Invalid score format: " + e.getMessage());
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }
}

