package model;

import dao.UserDAO;
import java.util.Map;
import java.util.HashMap;

public class User {
    private String username;
    private String password;
    private double balance;
    private Map<String, Integer> portfolio;

    public User(String username, String password, double balance) {
        this.username = username;
        this.password = password;
        this.balance = balance;
        this.portfolio = new HashMap<>();
    }

    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public double getBalance() { return balance; }
    public void setBalance(double balance) {
        this.balance = balance;
        try {
            UserDAO.getInstance().update(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Map<String, Integer> getPortfolio() { return portfolio; }
    public void setPortfolio(Map<String, Integer> portfolio) {
        this.portfolio = portfolio;
    }

    @Override
    public String toString() {
        return "User: " + username + " (Balance: " + balance + ")";
    }
}