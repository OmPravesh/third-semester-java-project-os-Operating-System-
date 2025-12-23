package com.project.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.project.model.Message;
import com.project.util.DatabaseUtil;

public class MessageDAO {
    private static final Logger LOGGER = Logger.getLogger(MessageDAO.class.getName());
    private static MessageDAO instance;

    private MessageDAO() {}

    public static synchronized MessageDAO getInstance() {
        if (instance == null) {
            instance = new MessageDAO();
        }
        return instance;
    }

    public void addMessage(Message message) {
        String sql = "INSERT INTO messages (room_id, sender_username, message_content, message_type) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, message.getRoomId());
            pstmt.setString(2, message.getSenderUsername());
            pstmt.setString(3, message.getMessageContent());
            pstmt.setString(4, message.getMessageType());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error adding message: " + e.getMessage());
        }
    }

    public List<Message> getMessagesByRoomId(int roomId) {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT * FROM messages WHERE room_id = ? ORDER BY sent_at ASC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Message msg = new Message();
                msg.setMessageId(rs.getInt("message_id"));
                msg.setRoomId(rs.getInt("room_id"));
                msg.setSenderUsername(rs.getString("sender_username"));
                msg.setMessageContent(rs.getString("message_content"));
                msg.setSentAt(rs.getTimestamp("sent_at"));
                msg.setMessageType(rs.getString("message_type"));
                messages.add(msg);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving messages by room ID: " + e.getMessage());
        }
        return messages;
    }

    public List<Message> getRecentMessages(int roomId, int limit) {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT * FROM messages WHERE room_id = ? ORDER BY sent_at DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Message msg = new Message();
                msg.setMessageId(rs.getInt("message_id"));
                msg.setRoomId(rs.getInt("room_id"));
                msg.setSenderUsername(rs.getString("sender_username"));
                msg.setMessageContent(rs.getString("message_content"));
                msg.setSentAt(rs.getTimestamp("sent_at"));
                msg.setMessageType(rs.getString("message_type"));
                messages.add(msg);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving recent messages: " + e.getMessage());
        }
        return messages;
    }

    public void deleteMessage(int messageId) {
        String sql = "DELETE FROM messages WHERE message_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, messageId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error deleting message: " + e.getMessage());
        }
    }
}
