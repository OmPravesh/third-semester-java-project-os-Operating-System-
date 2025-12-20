package main;

import dao.UserDAO;
import gui.apps.OS_Dashboard;
import gui.auth.LoginGUI; // This will be your new class
import model.User;
import util.DatabaseUtil;

import javax.swing.*;
import java.util.HashMap;
import java.util.Map;

public class JavaGuiOs {
    // Keep your activeUsers map to track sessions
    private static final Map<String, User> activeUsers = new HashMap<>();

    public static void main(String[] args) {
        // 1. Initialize DB first
        DatabaseUtil.initializeDatabase();

        // 2. Launch the Login GUI on the Event Dispatch Thread
        SwingUtilities.invokeLater(() -> new LoginGUI(activeUsers));
    }

    // Helper method for the LoginGUI to call upon successful login
    public static void launchDashboard(User user, Map<String, User> activeUsers) {
        new OS_Dashboard(user, activeUsers);
    }
}
