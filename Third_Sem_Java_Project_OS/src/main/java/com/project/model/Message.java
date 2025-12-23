package com.project.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Message implements Serializable {
    private int messageId;
    private int roomId;
    private String senderUsername;
    private String messageContent;
    private Timestamp sentAt;
    private String messageType; // "Text", "Image", "File"

    public Message() {}

    public Message(int roomId, String senderUsername, String messageContent) {
        this.roomId = roomId;
        this.senderUsername = senderUsername;
        this.messageContent = messageContent;
        this.messageType = "Text";
    }

    // Getters and Setters
    public int getMessageId() { return messageId; }
    public void setMessageId(int messageId) { this.messageId = messageId; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getSenderUsername() { return senderUsername; }
    public void setSenderUsername(String senderUsername) { this.senderUsername = senderUsername; }

    public String getMessageContent() { return messageContent; }
    public void setMessageContent(String messageContent) { this.messageContent = messageContent; }

    public Timestamp getSentAt() { return sentAt; }
    public void setSentAt(Timestamp sentAt) { this.sentAt = sentAt; }

    public String getMessageType() { return messageType; }
    public void setMessageType(String messageType) { this.messageType = messageType; }

    @Override
    public String toString() {
        return "Message{" +
                "messageId=" + messageId +
                ", roomId=" + roomId +
                ", senderUsername='" + senderUsername + '\'' +
                ", messageContent='" + messageContent + '\'' +
                ", sentAt=" + sentAt +
                ", messageType='" + messageType + '\'' +
                '}';
    }
}
