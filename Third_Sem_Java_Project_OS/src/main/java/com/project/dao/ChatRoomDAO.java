package com.project.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.project.model.ChatRoom;
import com.project.util.DatabaseUtil;

public class ChatRoomDAO {
    private static final Logger LOGGER = Logger.getLogger(ChatRoomDAO.class.getName());
    private static ChatRoomDAO instance;

    private ChatRoomDAO() {}

    public static synchronized ChatRoomDAO getInstance() {
        if (instance == null) {
            instance = new ChatRoomDAO();
        }
        return instance;
    }

    public void createChatRoom(ChatRoom room) {
        String sql = "INSERT INTO chat_rooms (room_name, created_by, description) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, room.getRoomName());
            pstmt.setString(2, room.getCreatedBy());
            pstmt.setString(3, room.getDescription());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error creating chat room: " + e.getMessage());
        }
    }

    public List<ChatRoom> getAllChatRooms() {
        List<ChatRoom> rooms = new ArrayList<>();
        String sql = "SELECT * FROM chat_rooms ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                ChatRoom room = new ChatRoom();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomName(rs.getString("room_name"));
                room.setCreatedBy(rs.getString("created_by"));
                room.setCreatedAt(rs.getTimestamp("created_at"));
                room.setDescription(rs.getString("description"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving all chat rooms: " + e.getMessage());
        }
        return rooms;
    }

    public ChatRoom getChatRoomById(int roomId) {
        String sql = "SELECT * FROM chat_rooms WHERE room_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                ChatRoom room = new ChatRoom();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomName(rs.getString("room_name"));
                room.setCreatedBy(rs.getString("created_by"));
                room.setCreatedAt(rs.getTimestamp("created_at"));
                room.setDescription(rs.getString("description"));
                return room;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving chat room by ID: " + e.getMessage());
        }
        return null;
    }

    public void deleteChatRoom(int roomId) {
        String sql = "DELETE FROM chat_rooms WHERE room_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error deleting chat room: " + e.getMessage());
        }
    }
}
