package gui.apps;

import model.User;
import util.ThemeManager;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.util.Map;

public class OS_Dashboard extends JFrame {
    private final User currentUser;
    private final Map<String, User> users;

    public OS_Dashboard(User currentUser, Map<String, User> users) {
        this.currentUser = currentUser;
        this.users = users;

        setTitle("GUI OS Dashboard - Welcome " + currentUser.getUsername());
        setSize(1000, 720);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // Initial Theme Application
        ThemeManager.applyThemeToAll();

        JPanel mainPanel = new JPanel(new GridLayout(2, 5, 18, 18));
        mainPanel.setBorder(new EmptyBorder(18, 18, 18, 18));

        // Dashboard specific styling handled by ThemeManager now,
        // but we set initial generic background just in case
        mainPanel.setBackground(new Color(20, 22, 28));

        JButton btnCalculator = createAppButton("Calculator", "A simple calculator.");
        JButton btnGames = createAppButton("Games Arcade", "Play visually improved games.");
        JButton btnUtilities = createAppButton("Utilities", "Handy utility functions.");
        JButton btnChat = createAppButton("Chat System", "Peer-to-peer chat.");
        JButton btnPayment = createAppButton("Digital Payment", "Transfer money.");
        JButton btnStock = createAppButton("Stock Market", "Stock simulation with live graphs.");
        JButton btnNotes = createAppButton("Notes", "Create and manage your notes.");
        JButton btnHowItWorks = createAppButton("How It Works", "Learn about the OS architecture.");
        JButton btnSettings = createAppButton("Settings", "Change application preferences.");
        JButton btnExit = createAppButton("Exit", "Close the operating system.");
        btnExit.setBackground(new Color(255, 80, 80));

        btnCalculator.addActionListener(e -> new CalculatorGUI());
        btnGames.addActionListener(e -> new GamesGUI(this));
        btnNotes.addActionListener(e -> new NotesGUI(currentUser));
        btnChat.addActionListener(e -> new ChatSystemGUI(currentUser));
        btnPayment.addActionListener(e -> new PaymentSystemGUI(currentUser));
        btnStock.addActionListener(e -> new StockMarketGUI(currentUser));
        btnUtilities.addActionListener(e -> new UtilitiesGUI());
        btnHowItWorks.addActionListener(e -> new HowItWorksGUI(this));
        btnSettings.addActionListener(e -> new SettingsGUI(this));
        btnExit.addActionListener(e -> System.exit(0));

        mainPanel.add(btnCalculator);
        mainPanel.add(btnGames);
        mainPanel.add(btnUtilities);
        mainPanel.add(btnChat);
        mainPanel.add(btnPayment);
        mainPanel.add(btnStock);
        mainPanel.add(btnNotes);
        mainPanel.add(btnHowItWorks);
        mainPanel.add(btnSettings);
        mainPanel.add(btnExit);

        add(mainPanel);
        setVisible(true);

        // Ensure theme applies immediately
        ThemeManager.applyThemeToAll();
    }

    private JButton createAppButton(String title, String tooltip) {
        JButton button = new JButton(title);
        button.setToolTipText(tooltip);
        button.setFont(new Font("Segoe UI", Font.BOLD, 18));
        button.setFocusPainted(false);
        button.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(90, 100, 110)),
                BorderFactory.createEmptyBorder(12, 12, 12, 12)));
        return button;
    }
}