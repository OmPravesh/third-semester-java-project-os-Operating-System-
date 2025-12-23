package com.project.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Logger;

public class DatabaseUtil {
    private static final Logger LOGGER = Logger.getLogger(DatabaseUtil.class.getName());
    private static final String DB_URL = System.getenv("DB_URL") != null ? System.getenv("DB_URL") : "jdbc:mysql://localhost:3306/project?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
    private static final String DB_PASS = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "gtaomp23";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver Registered!");
        } catch (ClassNotFoundException e) {
            LOGGER.severe("Failed to load MySQL driver: " + e.getMessage());
            throw new RuntimeException("Failed to load MySQL driver");
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    public static void initializeDatabase() {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {

            // Create users table
            String createUsers = "CREATE TABLE IF NOT EXISTS users ("
                    + "username VARCHAR(50) PRIMARY KEY,"
                    + "password VARCHAR(100) NOT NULL,"
                    + "balance DOUBLE DEFAULT 10000.00"
                    + ")";

            // Create transactions table
            String createTransactions = "CREATE TABLE IF NOT EXISTS transactions ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "sender VARCHAR(50) NOT NULL,"
                    + "recipient VARCHAR(50) NOT NULL,"
                    + "amount DOUBLE NOT NULL,"
                    + "timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "FOREIGN KEY (sender) REFERENCES users(username),"
                    + "FOREIGN KEY (recipient) REFERENCES users(username)"
                    + ")";

            // Create portfolio table
            String createPortfolio = "CREATE TABLE IF NOT EXISTS portfolio ("
                    + "username VARCHAR(50),"
                    + "stock_symbol VARCHAR(10),"
                    + "quantity INT DEFAULT 0,"
                    + "PRIMARY KEY (username, stock_symbol),"
                    + "FOREIGN KEY (username) REFERENCES users(username)"
                    + ")";

            // Create notes table
            String createNotes = "CREATE TABLE IF NOT EXISTS notes ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "username VARCHAR(50),"
                    + "title VARCHAR(100) NOT NULL,"
                    + "content TEXT,"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "FOREIGN KEY (username) REFERENCES users(username)"
                    + ")";

            // Create games table
            String createGames = "CREATE TABLE IF NOT EXISTS games ("
                    + "game_id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "username VARCHAR(50) NOT NULL,"
                    + "game_type VARCHAR(50) NOT NULL,"
                    + "score INT DEFAULT 0,"
                    + "time_spent INT DEFAULT 0,"
                    + "difficulty VARCHAR(20) DEFAULT 'Easy',"
                    + "status VARCHAR(20) DEFAULT 'In Progress',"
                    + "played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "FOREIGN KEY (username) REFERENCES users(username)"
                    + ")";

            // Create chat rooms table
            String createChatRooms = "CREATE TABLE IF NOT EXISTS chat_rooms ("
                    + "room_id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "room_name VARCHAR(100) NOT NULL UNIQUE,"
                    + "created_by VARCHAR(50) NOT NULL,"
                    + "description TEXT,"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "FOREIGN KEY (created_by) REFERENCES users(username)"
                    + ")";

            // Create messages table
            String createMessages = "CREATE TABLE IF NOT EXISTS messages ("
                    + "message_id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "room_id INT NOT NULL,"
                    + "sender_username VARCHAR(50) NOT NULL,"
                    + "message_content TEXT NOT NULL,"
                    + "message_type VARCHAR(20) DEFAULT 'Text',"
                    + "sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "FOREIGN KEY (room_id) REFERENCES chat_rooms(room_id),"
                    + "FOREIGN KEY (sender_username) REFERENCES users(username)"
                    + ")";

            // Create payment transactions table
            String createPaymentTransactions = "CREATE TABLE IF NOT EXISTS payment_transactions ("
                    + "transaction_id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "username VARCHAR(50) NOT NULL,"
                    + "transaction_type VARCHAR(50) NOT NULL,"
                    + "amount DOUBLE NOT NULL,"
                    + "payment_method VARCHAR(50) NOT NULL,"
                    + "status VARCHAR(20) DEFAULT 'Pending',"
                    + "description TEXT,"
                    + "transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "FOREIGN KEY (username) REFERENCES users(username)"
                    + ")";

            stmt.execute(createUsers);
            stmt.execute(createTransactions);
            stmt.execute(createPortfolio);
            stmt.execute(createNotes);
            stmt.execute(createGames);
            stmt.execute(createChatRooms);
            stmt.execute(createMessages);
            stmt.execute(createPaymentTransactions);

            // Insert default admin user if not exists
            String checkAdmin = "SELECT COUNT(*) FROM users WHERE username = 'admin'";
            ResultSet rs = stmt.executeQuery(checkAdmin);
            if (rs.next() && rs.getInt(1) == 0) {
                String insertAdmin = "INSERT INTO users (username, password, balance) VALUES ('admin', 'admin123', 50000.00)";
                stmt.execute(insertAdmin);
                System.out.println("Admin user created!");
            }

            System.out.println("Database initialized successfully!");

        } catch (SQLException e) {
            LOGGER.warning("Database initialization failed (this is OK if MySQL is not running): " + e.getMessage());
            System.out.println("⚠️  Database not available - app will run in demo mode");
        }
    }
}