package com.project.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.project.util.DatabaseUtil;

public class NotesDAO {
    private static final Logger LOGGER = Logger.getLogger(NotesDAO.class.getName());
    private static NotesDAO instance;

    private NotesDAO() {}

    public static synchronized NotesDAO getInstance() {
        if (instance == null) {
            instance = new NotesDAO();
        }
        return instance;
    }

    public static class Note {
        private int id;
        private String username;
        private String title;
        private String content;
        private java.sql.Timestamp createdAt;

        // Getters and Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
        public java.sql.Timestamp getCreatedAt() { return createdAt; }
        public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
    }

    public void addNote(String username, String title, String content) {
        String sql = "INSERT INTO notes (username, title, content) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, title);
            pstmt.setString(3, content);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error adding note: " + e.getMessage());
        }
    }

    public List<Note> getNotesByUsername(String username) {
        List<Note> notes = new ArrayList<>();
        String sql = "SELECT * FROM notes WHERE username = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Note note = new Note();
                note.setId(rs.getInt("id"));
                note.setUsername(rs.getString("username"));
                note.setTitle(rs.getString("title"));
                note.setContent(rs.getString("content"));
                note.setCreatedAt(rs.getTimestamp("created_at"));
                notes.add(note);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving notes: " + e.getMessage());
        }
        return notes;
    }

    public void deleteNote(int id, String username) {
        String sql = "DELETE FROM notes WHERE id = ? AND username = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.setString(2, username);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error deleting note: " + e.getMessage());
        }
    }
}
