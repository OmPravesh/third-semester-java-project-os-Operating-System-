package util;

import java.sql.*;

public class DatabaseUtil {
    // UPDATE YOUR DATABASE CREDENTIALS HERE
    private static final String DB_URL = "jdbc:mysql://localhost:3306/project";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "gtaomp23";

    private static final String CREATE_USERS_TABLE = "CREATE TABLE IF NOT EXISTS users ("
            + "username VARCHAR(50) PRIMARY KEY,"
            + "password VARCHAR(100) NOT NULL,"
            + "balance DOUBLE NOT NULL"
            + ")";

    private static final String CREATE_TRANSACTIONS_TABLE = "CREATE TABLE IF NOT EXISTS transactions ("
            + "id INT AUTO_INCREMENT PRIMARY KEY,"
            + "sender VARCHAR(50) NOT NULL,"
            + "recipient VARCHAR(50) NOT NULL,"
            + "amount DOUBLE NOT NULL,"
            + "timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
            + ")";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found. Ensure JDBC connector is in classpath or you are offline.");
        }
    }

    public static void initializeDatabase() {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(CREATE_USERS_TABLE);
            stmt.execute(CREATE_TRANSACTIONS_TABLE);
            System.out.println("Database tables initialized successfully.");
        } catch (SQLException e) {
            System.err.println("Database initialization failed: " + e.getMessage());
        }
    }

    public static void transferFunds(String senderUsername, String recipientUsername, double amount) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            String withdrawSQL = "UPDATE users SET balance = balance - ? WHERE username = ? AND balance >= ?";
            try (PreparedStatement withdrawStmt = conn.prepareStatement(withdrawSQL)) {
                withdrawStmt.setDouble(1, amount);
                withdrawStmt.setString(2, senderUsername);
                withdrawStmt.setDouble(3, amount);
                if (withdrawStmt.executeUpdate() != 1) {
                    throw new SQLException("Sender update failed (Insufficient balance or user not found).");
                }
            }

            String depositSQL = "UPDATE users SET balance = balance + ? WHERE username = ?";
            try (PreparedStatement depositStmt = conn.prepareStatement(depositSQL)) {
                depositStmt.setDouble(1, amount);
                depositStmt.setString(2, recipientUsername);
                if (depositStmt.executeUpdate() != 1) {
                    throw new SQLException("Recipient update failed (User not found).");
                }
            }

            String logSQL = "INSERT INTO transactions (sender, recipient, amount) VALUES (?, ?, ?)";
            try (PreparedStatement logStmt = conn.prepareStatement(logSQL)) {
                logStmt.setString(1, senderUsername);
                logStmt.setString(2, recipientUsername);
                logStmt.setDouble(3, amount);
                logStmt.executeUpdate();
            }

            conn.commit();

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw new SQLException("Transaction failed and was rolled back: " + e.getMessage());
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
}