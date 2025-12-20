package model;

import java.sql.Timestamp;

public class Transaction {
    public final String sender, recipient;
    public final double amount;
    public final Timestamp timestamp;

    public Transaction(String sender, String recipient, double amount, Timestamp timestamp) {
        this.sender = sender;
        this.recipient = recipient;
        this.amount = amount;
        this.timestamp = timestamp;
    }
}