package com.project.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ChatRoom implements Serializable {
    private int roomId;
    private String roomName;
    private String createdBy;
    private Timestamp createdAt;
    private String description;
    private int memberCount;

    public ChatRoom() {}

    public ChatRoom(String roomName, String createdBy, String description) {
        this.roomName = roomName;
        this.createdBy = createdBy;
        this.description = description;
    }

    // Getters and Setters
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getMemberCount() { return memberCount; }
    public void setMemberCount(int memberCount) { this.memberCount = memberCount; }
}
