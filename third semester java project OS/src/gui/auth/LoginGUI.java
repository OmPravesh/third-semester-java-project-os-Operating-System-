package gui.auth;

import dao.UserDAO;
import model.User;
import main.JavaGuiOs;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.sql.SQLException;
import java.util.Map;

public class LoginGUI extends JFrame {
    private final JTextField userField;
    private final JPasswordField passField;
    private final Map<String, User> activeUsers;
    private final UserDAO userDAO = UserDAO.getInstance();

    // Google-style Colors
    private final Color GOOGLE_BLUE = new Color(26, 115, 232);
    private final Color TEXT_DARK = new Color(32, 33, 36);
    private final Color BORDER_LIGHT = new Color(218, 220, 224);
    private final Color BG_WHITE = Color.WHITE;

    public LoginGUI(Map<String, User> activeUsers) {
        this.activeUsers = activeUsers;

        setTitle("Sign in - Google Accounts");
        setSize(450, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        getContentPane().setBackground(BG_WHITE);
        setLayout(new GridBagLayout()); // Used to center the "Card"

        // 1. THE MAIN CARD
        JPanel card = new JPanel();
        card.setLayout(new BoxLayout(card, BoxLayout.Y_AXIS));
        card.setBackground(BG_WHITE);
        card.setPreferredSize(new Dimension(400, 500));
        card.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(BORDER_LIGHT, 1),
                new EmptyBorder(40, 40, 40, 40)
        ));

        // 2. LOGO & HEADER
        JLabel logo = new JLabel("GUI OS");
        logo.setFont(new Font("Product Sans", Font.BOLD, 24)); // Use Product Sans if available, else Segoe UI
        logo.setForeground(TEXT_DARK);
        logo.setAlignmentX(Component.CENTER_ALIGNMENT);

        JLabel signInLabel = new JLabel("Sign in");
        signInLabel.setFont(new Font("Segoe UI", Font.PLAIN, 24));
        signInLabel.setForeground(TEXT_DARK);
        signInLabel.setAlignmentX(Component.CENTER_ALIGNMENT);

        JLabel subLabel = new JLabel("Use your GUI OS Account");
        subLabel.setFont(new Font("Segoe UI", Font.PLAIN, 15));
        subLabel.setForeground(TEXT_DARK);
        subLabel.setAlignmentX(Component.CENTER_ALIGNMENT);

        // 3. INPUT FIELDS
        userField = createGoogleTextField("Email or phone");
        passField = createGooglePasswordField();

        // 4. BUTTONS PANEL
        JPanel buttonPanel = new JPanel(new BorderLayout());
        buttonPanel.setOpaque(false);
        buttonPanel.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));

        JLabel createAccount = new JLabel("Create account");
        createAccount.setForeground(GOOGLE_BLUE);
        createAccount.setFont(new Font("Segoe UI", Font.BOLD, 14));
        createAccount.setCursor(new Cursor(Cursor.HAND_CURSOR));

        JButton nextBtn = new JButton("Next") {
            @Override
            protected void paintComponent(Graphics g) {
                Graphics2D g2 = (Graphics2D) g.create();
                g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                g2.setColor(GOOGLE_BLUE);
                g2.fillRoundRect(0, 0, getWidth(), getHeight(), 8, 8);
                g2.dispose();
                super.paintComponent(g);
            }
        };
        nextBtn.setForeground(Color.WHITE);
        nextBtn.setFont(new Font("Segoe UI", Font.BOLD, 14));
        nextBtn.setPreferredSize(new Dimension(80, 40));
        nextBtn.setContentAreaFilled(false);
        nextBtn.setBorderPainted(false);
        nextBtn.setFocusPainted(false);
        nextBtn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        nextBtn.addActionListener(this::performLogin);

        buttonPanel.add(createAccount, BorderLayout.WEST);
        buttonPanel.add(nextBtn, BorderLayout.EAST);

        // ASSEMBLY
        card.add(logo);
        card.add(Box.createVerticalStrut(10));
        card.add(signInLabel);
        card.add(Box.createVerticalStrut(8));
        card.add(subLabel);
        card.add(Box.createVerticalStrut(40));
        card.add(userField);
        card.add(Box.createVerticalStrut(25));
        card.add(passField);
        card.add(Box.createVerticalStrut(40));
        card.add(buttonPanel);

        add(card);
        setVisible(true);
    }

    private JTextField createGoogleTextField(String placeholder) {
        JTextField field = new JTextField();
        field.setMaximumSize(new Dimension(Integer.MAX_VALUE, 55));
        field.setFont(new Font("Segoe UI", Font.PLAIN, 16));
        field.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(BORDER_LIGHT, 1),
                BorderFactory.createEmptyBorder(10, 15, 10, 15)
        ));
        // Simple placeholder simulation
        field.setText(placeholder);
        field.setForeground(Color.GRAY);
        field.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                if (field.getText().equals(placeholder)) {
                    field.setText("");
                    field.setForeground(TEXT_DARK);
                }
                field.setBorder(BorderFactory.createCompoundBorder(
                        BorderFactory.createLineBorder(GOOGLE_BLUE, 2),
                        BorderFactory.createEmptyBorder(9, 14, 9, 14)
                ));
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                if (field.getText().isEmpty()) {
                    field.setText(placeholder);
                    field.setForeground(Color.GRAY);
                }
                field.setBorder(BorderFactory.createCompoundBorder(
                        BorderFactory.createLineBorder(BORDER_LIGHT, 1),
                        BorderFactory.createEmptyBorder(10, 15, 10, 15)
                ));
            }
        });
        return field;
    }

    private JPasswordField createGooglePasswordField() {
        JPasswordField field = new JPasswordField();
        field.setMaximumSize(new Dimension(Integer.MAX_VALUE, 55));
        field.setFont(new Font("Segoe UI", Font.PLAIN, 16));
        field.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(BORDER_LIGHT, 1),
                BorderFactory.createEmptyBorder(10, 15, 10, 15)
        ));
        field.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                field.setBorder(BorderFactory.createCompoundBorder(
                        BorderFactory.createLineBorder(GOOGLE_BLUE, 2),
                        BorderFactory.createEmptyBorder(9, 14, 9, 14)
                ));
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                field.setBorder(BorderFactory.createCompoundBorder(
                        BorderFactory.createLineBorder(BORDER_LIGHT, 1),
                        BorderFactory.createEmptyBorder(10, 15, 10, 15)
                ));
            }
        });
        return field;
    }

    private void performLogin(ActionEvent e) {
        String username = userField.getText().trim();
        String password = new String(passField.getPassword());

        try {
            User user = userDAO.read(username);
            if (user != null && user.getPassword().equals(password)) {
                activeUsers.put(username, user);
                this.dispose();
                JavaGuiOs.launchDashboard(user, activeUsers);
            } else {
                JOptionPane.showMessageDialog(this, "Check your username or password", "Sign in error", JOptionPane.ERROR_MESSAGE);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}