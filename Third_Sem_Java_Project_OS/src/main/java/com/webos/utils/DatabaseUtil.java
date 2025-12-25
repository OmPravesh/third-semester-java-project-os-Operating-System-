package com.webos.utils;

import java.sql.*;

public class DatabaseUtil {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/project";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "gtaomp23"; // Your password

    static {
        try {
            // This is required for Web Apps to find the driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    // Adapted transfer method from your source
    public static boolean transferFunds(String sender, String recipient, double amount) {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            // 1. Withdraw
            try (PreparedStatement withdraw = conn.prepareStatement("UPDATE users SET balance = balance - ? WHERE username = ? AND balance >= ?")) {
                withdraw.setDouble(1, amount);
                withdraw.setString(2, sender);
                withdraw.setDouble(3, amount);
                if (withdraw.executeUpdate() == 0) return false; // Fail if no money
            }

            // 2. Deposit
            try (PreparedStatement deposit = conn.prepareStatement("UPDATE users SET balance = balance + ? WHERE username = ?")) {
                deposit.setDouble(1, amount);
                deposit.setString(2, recipient);
                if (deposit.executeUpdate() == 0) {
                    conn.rollback();
                    return false; // Fail if user doesn't exist
                }
            }

            // 3. Log
            try (PreparedStatement log = conn.prepareStatement("INSERT INTO transactions (sender, recipient, amount) VALUES (?, ?, ?)")) {
                log.setString(1, sender);
                log.setString(2, recipient);
                log.setDouble(3, amount);
                log.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}