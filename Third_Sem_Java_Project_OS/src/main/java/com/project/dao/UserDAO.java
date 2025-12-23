package com.project.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Logger;

import com.project.model.User;
import com.project.util.DatabaseUtil;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());
    private static UserDAO instance;

    private UserDAO() {}

    public static synchronized UserDAO getInstance() {
        if (instance == null) {
            instance = new UserDAO();
        }
        return instance;
    }

    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setBalance(rs.getDouble("balance"));
                return user;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving user: " + e.getMessage());
        }
        return null;
    }

    public boolean updateUserBalance(String username, double newBalance) {
        String sql = "UPDATE users SET balance = ? WHERE username = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDouble(1, newBalance);
            stmt.setString(2, username);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            LOGGER.severe("Error updating user balance: " + e.getMessage());
            return false;
        }
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET balance = ?, password = ? WHERE username = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDouble(1, user.getBalance());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getUsername());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            LOGGER.severe("Error updating user: " + e.getMessage());
            return false;
        }
    }

    public boolean createUser(User user) {
        String sql = "INSERT INTO users (username, password, balance) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setDouble(3, user.getBalance());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            LOGGER.severe("Error creating user: " + e.getMessage());
            return false;
        }
    }
}