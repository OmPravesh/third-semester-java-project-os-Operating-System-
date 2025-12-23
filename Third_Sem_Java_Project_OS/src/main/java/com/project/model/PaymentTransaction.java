package com.project.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class PaymentTransaction implements Serializable {
    private int transactionId;
    private String username;
    private String transactionType; // "Deposit", "Withdrawal", "Transfer", "Purchase"
    private double amount;
    private String paymentMethod; // "Credit Card", "Debit Card", "Digital Wallet", "Bank Transfer"
    private String status; // "Pending", "Completed", "Failed"
    private String description;
    private Timestamp transactionDate;

    public PaymentTransaction() {}

    public PaymentTransaction(String username, String transactionType, double amount, String paymentMethod, String status) {
        this.username = username;
        this.transactionType = transactionType;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = status;
    }

    // Getters and Setters
    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getTransactionType() { return transactionType; }
    public void setTransactionType(String transactionType) { this.transactionType = transactionType; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Timestamp transactionDate) { this.transactionDate = transactionDate; }

    @Override
    public String toString() {
        return "PaymentTransaction{" +
                "transactionId=" + transactionId +
                ", username='" + username + '\'' +
                ", transactionType='" + transactionType + '\'' +
                ", amount=" + amount +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", status='" + status + '\'' +
                ", transactionDate=" + transactionDate +
                '}';
    }
}
