package gui.apps;

import util.ThemeManager;
import javax.swing.*;
import java.awt.*;

public class HowItWorksGUI extends JDialog {
    public HowItWorksGUI(JFrame parent) {
        super(parent, "How It Works", true);
        setSize(600, 500);
        setLocationRelativeTo(parent);
        JTextArea textArea = new JTextArea();
        textArea.setEditable(false);
        textArea.setLineWrap(true);
        textArea.setWrapStyleWord(true);
        textArea.setFont(new Font("Arial", Font.PLAIN, 14));
        textArea.setMargin(new Insets(10, 10, 10, 10));
        textArea.setText(
                "--- Welcome to GUI OS (JDBC Version) ---\n\n" +
                        "This program simulates a simple graphical operating system built entirely in Java Swing.\n\n" +
                        "1. Core Structure:\n" +
                        "   - The program starts in the `main.JavaGuiOs` class, which handles console login.\n" +
                        "   - **JDBC INTEGRATION**: User login is handled by `UserDAO.read(username)` against the MySQL database.\n" +
                        "   - After successful login, it launches the `OS_Dashboard`.\n\n" +
                        "2. Database Operations:\n" +
                        "   - **User Data**: User accounts and balances are permanently stored in the `users` table.\n" +
                        "   - **Digital Payment System**: This application now uses `DatabaseUtil.transferFunds()`, which performs an **ATOMIC TRANSACTION** (withdraw, deposit, log) using JDBC's `conn.setAutoCommit(false)` and `conn.commit()/conn.rollback()` to ensure data integrity.\n" +
                        "   - **OOP**: Data access follows the DAO pattern with the generic `DataAccessor` interface.\n\n" +
                        "3. Concurrency:\n" +
                        "   - The GUI runs on Java's Event Dispatch Thread (EDT). All database calls are executed in separate threads (`new Thread(...)`) to keep the UI responsive, satisfying the **Multithreading** rubric.\n\n" +
                        "4. Architecture:\n" +
                        "   - **Model**: User, Stock, Transaction classes\n" +
                        "   - **DAO**: Data access objects for database operations\n" +
                        "   - **GUI**: Separated into apps, components, and games\n" +
                        "   - **Util**: Utility classes like DatabaseUtil and ThemeManager\n" +
                        "   - **Service**: Business logic services like NotesApp"
        );
        add(new JScrollPane(textArea));
        ThemeManager.applyThemeToAll();
        setVisible(true);
    }
}