package com.project.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.project.model.Game;
import com.project.util.DatabaseUtil;

public class GameDAO {
    private static final Logger LOGGER = Logger.getLogger(GameDAO.class.getName());
    private static GameDAO instance;

    private GameDAO() {}

    public static synchronized GameDAO getInstance() {
        if (instance == null) {
            instance = new GameDAO();
        }
        return instance;
    }

    public void addGame(Game game) {
        String sql = "INSERT INTO games (username, game_type, score, time_spent, difficulty, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, game.getUsername());
            pstmt.setString(2, game.getGameType());
            pstmt.setInt(3, game.getScore());
            pstmt.setInt(4, game.getTimeSpent());
            pstmt.setString(5, game.getDifficulty());
            pstmt.setString(6, game.getStatus());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error adding game: " + e.getMessage());
        }
    }

    public List<Game> getGamesByUsername(String username) {
        List<Game> games = new ArrayList<>();
        String sql = "SELECT * FROM games WHERE username = ? ORDER BY played_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Game game = new Game();
                game.setGameId(rs.getInt("game_id"));
                game.setUsername(rs.getString("username"));
                game.setGameType(rs.getString("game_type"));
                game.setScore(rs.getInt("score"));
                game.setTimeSpent(rs.getInt("time_spent"));
                game.setDifficulty(rs.getString("difficulty"));
                game.setPlayedAt(rs.getTimestamp("played_at"));
                game.setStatus(rs.getString("status"));
                games.add(game);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving games by username: " + e.getMessage());
        }
        return games;
    }

    public List<Game> getLeaderboard(String gameType, int limit) {
        List<Game> games = new ArrayList<>();
        String sql = "SELECT * FROM games WHERE game_type = ? ORDER BY score DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, gameType);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Game game = new Game();
                game.setGameId(rs.getInt("game_id"));
                game.setUsername(rs.getString("username"));
                game.setGameType(rs.getString("game_type"));
                game.setScore(rs.getInt("score"));
                game.setTimeSpent(rs.getInt("time_spent"));
                game.setDifficulty(rs.getString("difficulty"));
                game.setPlayedAt(rs.getTimestamp("played_at"));
                game.setStatus(rs.getString("status"));
                games.add(game);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving leaderboard: " + e.getMessage());
        }
        return games;
    }

    public Game getGameById(int gameId) {
        String sql = "SELECT * FROM games WHERE game_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, gameId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Game game = new Game();
                game.setGameId(rs.getInt("game_id"));
                game.setUsername(rs.getString("username"));
                game.setGameType(rs.getString("game_type"));
                game.setScore(rs.getInt("score"));
                game.setTimeSpent(rs.getInt("time_spent"));
                game.setDifficulty(rs.getString("difficulty"));
                game.setPlayedAt(rs.getTimestamp("played_at"));
                game.setStatus(rs.getString("status"));
                return game;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving game by ID: " + e.getMessage());
        }
        return null;
    }
}
