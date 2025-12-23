package com.project.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.project.model.Transaction;
import com.project.util.DatabaseUtil;

public class TransactionDAO {
    private static final Logger LOGGER = Logger.getLogger(TransactionDAO.class.getName());

    public boolean createTransaction(String sender, String recipient, double amount) {
        String sql = "INSERT INTO transactions (sender, recipient, amount) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, sender);
            stmt.setString(2, recipient);
            stmt.setDouble(3, amount);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            LOGGER.severe("Error creating transaction: " + e.getMessage());
            return false;
        }
    }

    public List<Transaction> getTransactionsByUser(String username) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE sender = ? OR recipient = ? ORDER BY timestamp DESC LIMIT 20";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, username);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setId(rs.getInt("id"));
                transaction.setSender(rs.getString("sender"));
                transaction.setRecipient(rs.getString("recipient"));
                transaction.setAmount(rs.getDouble("amount"));
                transaction.setTimestamp(rs.getTimestamp("timestamp"));
                transactions.add(transaction);
            }

        } catch (SQLException e) {
            LOGGER.severe("Error retrieving transactions: " + e.getMessage());
        }
        return transactions;
    }
}