package com.project.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Transaction implements Serializable {
    private int id;
    private String sender;
    private String recipient;
    private double amount;
    private Timestamp timestamp;

    public Transaction() {}

    public Transaction(String sender, String recipient, double amount, Timestamp timestamp) {
        this.sender = sender;
        this.recipient = recipient;
        this.amount = amount;
        this.timestamp = timestamp;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSender() { return sender; }
    public void setSender(String sender) { this.sender = sender; }

    public String getRecipient() { return recipient; }
    public void setRecipient(String recipient) { this.recipient = recipient; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public Timestamp getTimestamp() { return timestamp; }
    public void setTimestamp(Timestamp timestamp) { this.timestamp = timestamp; }
}