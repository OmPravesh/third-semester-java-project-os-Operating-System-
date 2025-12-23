package com.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.dao.GameDAO;
import com.project.model.Game;

@WebServlet(name = "GameServlet", value = "/games")
public class GameServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String gameType = request.getParameter("gameType");

        if ("snake".equalsIgnoreCase(gameType)) {
            request.getRequestDispatcher("/views/games/snake.jsp").forward(request, response);
        } else if ("puzzle".equalsIgnoreCase(gameType)) {
            request.getRequestDispatcher("/views/games/puzzle.jsp").forward(request, response);
        } else if ("leaderboard".equalsIgnoreCase(action)) {
            String type = request.getParameter("type");
            GameDAO gameDAO = GameDAO.getInstance();
            List<Game> leaderboard = gameDAO.getLeaderboard(type != null ? type : "Snake", 10);
            request.setAttribute("leaderboard", leaderboard);
            request.setAttribute("gameType", type);
            request.getRequestDispatcher("/views/games/leaderboard.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/views/games.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String username = ((com.project.model.User) session.getAttribute("user")).getUsername();
        String gameType = request.getParameter("gameType");
        int score = Integer.parseInt(request.getParameter("score"));
        int timeSpent = Integer.parseInt(request.getParameter("timeSpent"));
        String difficulty = request.getParameter("difficulty");
        String status = request.getParameter("status");

        Game game = new Game(username, gameType, score, timeSpent, difficulty, status);
        GameDAO gameDAO = GameDAO.getInstance();
        gameDAO.addGame(game);

        response.setContentType("application/json");
        response.getWriter().write("{\"status\": \"success\", \"message\": \"Game saved successfully\"}");
    }
}
