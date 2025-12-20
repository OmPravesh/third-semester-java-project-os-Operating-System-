package dao;

import model.Transaction;
import util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {
    public List<Transaction> findTransactionsForUser(String username) throws SQLException {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE sender = ? OR recipient = ? ORDER BY timestamp DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, username);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    transactions.add(new Transaction(
                            rs.getString("sender"),
                            rs.getString("recipient"),
                            rs.getDouble("amount"),
                            rs.getTimestamp("timestamp")
                    ));
                }
            }
        }
        return transactions;
    }
}