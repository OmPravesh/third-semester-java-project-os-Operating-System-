package com.project.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.project.model.PaymentTransaction;
import com.project.util.DatabaseUtil;

public class PaymentTransactionDAO {
    private static final Logger LOGGER = Logger.getLogger(PaymentTransactionDAO.class.getName());
    private static PaymentTransactionDAO instance;

    private PaymentTransactionDAO() {}

    public static synchronized PaymentTransactionDAO getInstance() {
        if (instance == null) {
            instance = new PaymentTransactionDAO();
        }
        return instance;
    }

    public void addTransaction(PaymentTransaction transaction) {
        String sql = "INSERT INTO payment_transactions (username, transaction_type, amount, payment_method, status, description) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, transaction.getUsername());
            pstmt.setString(2, transaction.getTransactionType());
            pstmt.setDouble(3, transaction.getAmount());
            pstmt.setString(4, transaction.getPaymentMethod());
            pstmt.setString(5, transaction.getStatus());
            pstmt.setString(6, transaction.getDescription());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error adding transaction: " + e.getMessage());
        }
    }

    public List<PaymentTransaction> getTransactionsByUsername(String username) {
        List<PaymentTransaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM payment_transactions WHERE username = ? ORDER BY transaction_date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                PaymentTransaction trans = new PaymentTransaction();
                trans.setTransactionId(rs.getInt("transaction_id"));
                trans.setUsername(rs.getString("username"));
                trans.setTransactionType(rs.getString("transaction_type"));
                trans.setAmount(rs.getDouble("amount"));
                trans.setPaymentMethod(rs.getString("payment_method"));
                trans.setStatus(rs.getString("status"));
                trans.setDescription(rs.getString("description"));
                trans.setTransactionDate(rs.getTimestamp("transaction_date"));
                transactions.add(trans);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving transactions: " + e.getMessage());
        }
        return transactions;
    }

    public PaymentTransaction getTransactionById(int transactionId) {
        String sql = "SELECT * FROM payment_transactions WHERE transaction_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, transactionId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                PaymentTransaction trans = new PaymentTransaction();
                trans.setTransactionId(rs.getInt("transaction_id"));
                trans.setUsername(rs.getString("username"));
                trans.setTransactionType(rs.getString("transaction_type"));
                trans.setAmount(rs.getDouble("amount"));
                trans.setPaymentMethod(rs.getString("payment_method"));
                trans.setStatus(rs.getString("status"));
                trans.setDescription(rs.getString("description"));
                trans.setTransactionDate(rs.getTimestamp("transaction_date"));
                return trans;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving transaction: " + e.getMessage());
        }
        return null;
    }

    public void updateTransactionStatus(int transactionId, String status) {
        String sql = "UPDATE payment_transactions SET status = ? WHERE transaction_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, transactionId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error updating transaction status: " + e.getMessage());
        }
    }
}
