package dao;

import model.User;
import util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO implements DataAccessor<User> {
    private static UserDAO instance;
    private UserDAO() {}

    public static UserDAO getInstance() {
        if (instance == null) instance = new UserDAO();
        return instance;
    }

    public User create(User user) throws SQLException {
        String sql = "INSERT INTO users (username, password, balance) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setDouble(3, user.getBalance());
            stmt.executeUpdate();
            return user;
        }
    }

    @Override
    public User read(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getDouble("balance")
                    );
                }
            }
        }
        return null;
    }

    @Override
    public User update(User user) throws SQLException {
        String sql = "UPDATE users SET password = ?, balance = ? WHERE username = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getPassword());
            stmt.setDouble(2, user.getBalance());
            stmt.setString(3, user.getUsername());
            if (stmt.executeUpdate() == 0) {
                throw new SQLException("User not found for update: " + user.getUsername());
            }
            return user;
        }
    }

    @Override
    public List<User> findAll() throws SQLException {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                userList.add(new User(
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getDouble("balance")
                ));
            }
        }
        return userList;
    }
}