package gui.apps;

import model.User;
import model.Transaction;
import dao.TransactionDAO;
import dao.UserDAO;
import util.DatabaseUtil;
import util.ThemeManager;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;

public class PaymentSystemGUI extends JFrame {
    private final User currentUser;
    private final JLabel balanceLabel;
    private final JPanel historyContainer;
    private final TransactionDAO transactionDAO = new TransactionDAO();

    // PayPal Palette
    private final Color PAYPAL_BLUE = new Color(0, 112, 186);
    private final Color NAV_DARK = new Color(36, 58, 115);
    private final Color BG_OFF_WHITE = new Color(245, 247, 250);
    private final Color TEXT_COLOR = new Color(44, 46, 47);

    public PaymentSystemGUI(User user) {
        this.currentUser = user;
        setTitle("PayPal Desktop - " + currentUser.getUsername());
        setSize(1100, 800);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);
        getContentPane().setBackground(BG_OFF_WHITE);
        setLayout(new BorderLayout());

        // 1. TOP NAV BAR
        add(createTopNavBar(), BorderLayout.NORTH);

        // 2. MAIN DASHBOARD
        JPanel mainWrapper = new JPanel(new BorderLayout());
        mainWrapper.setOpaque(false);
        mainWrapper.setBorder(new EmptyBorder(30, 60, 30, 60));

        JPanel dashboard = new JPanel(new BorderLayout());
        dashboard.setBackground(Color.WHITE);
        dashboard.setBorder(BorderFactory.createLineBorder(new Color(220, 225, 230)));

        // Balance Section
        JPanel balancePanel = createBalanceSection();
        dashboard.add(balancePanel, BorderLayout.NORTH);

        // EXPANDED Activity Section
        JPanel activityPanel = new JPanel(new BorderLayout());
        activityPanel.setOpaque(false);

        JLabel historyTitle = new JLabel("Recent Activity");
        historyTitle.setFont(new Font("Segoe UI", Font.BOLD, 22));
        historyTitle.setBorder(new EmptyBorder(25, 35, 15, 35));
        activityPanel.add(historyTitle, BorderLayout.NORTH);

        historyContainer = new JPanel();
        historyContainer.setLayout(new BoxLayout(historyContainer, BoxLayout.Y_AXIS));
        historyContainer.setBackground(Color.WHITE);

        JScrollPane scrollPane = new JScrollPane(historyContainer);
        scrollPane.setBorder(null);
        scrollPane.getViewport().setBackground(Color.WHITE);
        scrollPane.getVerticalScrollBar().setUnitIncrement(16);
        activityPanel.add(scrollPane, BorderLayout.CENTER);

        dashboard.add(activityPanel, BorderLayout.CENTER);
        mainWrapper.add(dashboard, BorderLayout.CENTER);
        add(mainWrapper, BorderLayout.CENTER);

        balanceLabel = (JLabel) balancePanel.getClientProperty("balanceLabel");
        refreshHistory();
        setVisible(true);
    }

    private JPanel createTopNavBar() {
        JPanel navBar = new JPanel(new BorderLayout()) {
            @Override
            protected void paintComponent(Graphics g) {
                g.setColor(NAV_DARK);
                g.fillRect(0, 0, getWidth(), getHeight());
                super.paintComponent(g);
            }
        };
        navBar.setOpaque(false);
        navBar.setPreferredSize(new Dimension(getWidth(), 75));
        navBar.setBorder(new EmptyBorder(0, 40, 0, 40));

        JLabel logo = new JLabel("PayPal");
        logo.setForeground(Color.WHITE);
        logo.setFont(new Font("Segoe UI", Font.BOLD, 24));
        navBar.add(logo, BorderLayout.WEST);

        JPanel tabs = new JPanel(new FlowLayout(FlowLayout.LEFT, 5, 0));
        tabs.setOpaque(false);
        tabs.setBorder(new EmptyBorder(12, 20, 0, 0));

        tabs.add(createTabButton("Dashboard", true));
        tabs.add(createTabButton("Send & Request", false));
        tabs.add(createTabButton("Wallet", false));
        tabs.add(createTabButton("Activity", false));

        navBar.add(tabs, BorderLayout.CENTER);
        return navBar;
    }

    private JButton createTabButton(String text, boolean isActive) {
        JButton btn = new JButton(text) {
            @Override
            protected void paintComponent(Graphics g) {
                // This custom painting fixes the "text over text" glitch
                if (isActive || getModel().isRollover()) {
                    Graphics2D g2 = (Graphics2D) g.create();
                    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                    g2.setColor(new Color(255, 255, 255, isActive ? 40 : 20));
                    g2.fillRoundRect(0, 5, getWidth(), getHeight() - 10, 10, 10);
                    g2.dispose();
                }
                super.paintComponent(g);
            }
        };
        btn.setFont(new Font("Segoe UI", Font.BOLD, 14));
        btn.setForeground(Color.WHITE);
        btn.setPreferredSize(new Dimension(140, 50));
        btn.setContentAreaFilled(false);
        btn.setBorderPainted(false);
        btn.setFocusPainted(false);
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));

        // Repaint fixes the hover artifacts
        btn.addMouseListener(new MouseAdapter() {
            public void mouseEntered(MouseEvent e) { btn.repaint(); }
            public void mouseExited(MouseEvent e) { btn.repaint(); }
        });

        return btn;
    }

    private JPanel createBalanceSection() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(Color.WHITE);
        panel.setBorder(new EmptyBorder(40, 35, 30, 35));

        JPanel left = new JPanel(new GridLayout(2, 1));
        left.setOpaque(false);
        JLabel label = new JLabel("PayPal balance");
        label.setFont(new Font("Segoe UI", Font.PLAIN, 16));
        label.setForeground(Color.GRAY);
        JLabel balance = new JLabel(String.format("₹ %.2f", currentUser.getBalance()));
        balance.setFont(new Font("Segoe UI", Font.BOLD, 42));
        panel.putClientProperty("balanceLabel", balance);
        left.add(label);
        left.add(balance);

        JButton sendBtn = createPillButton("Transfer Money", PAYPAL_BLUE);
        sendBtn.addActionListener(e -> showTransferDialog());
        JPanel right = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        right.setOpaque(false);
        right.add(sendBtn);

        panel.add(left, BorderLayout.WEST);
        panel.add(right, BorderLayout.EAST);
        return panel;
    }

    private JButton createPillButton(String text, Color bg) {
        JButton btn = new JButton(text) {
            @Override
            protected void paintComponent(Graphics g) {
                Graphics2D g2 = (Graphics2D) g.create();
                g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                g2.setColor(bg);
                g2.fillRoundRect(0, 0, getWidth(), getHeight(), 40, 40);
                g2.dispose();
                super.paintComponent(g);
            }
        };
        btn.setForeground(Color.WHITE);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 15));
        btn.setPreferredSize(new Dimension(180, 50));
        btn.setContentAreaFilled(false);
        btn.setBorderPainted(false);
        btn.setFocusPainted(false);
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        return btn;
    }

    private void refreshHistory() {
        historyContainer.removeAll();
        new Thread(() -> {
            try {
                List<Transaction> transactions = transactionDAO.findTransactionsForUser(currentUser.getUsername());
                SwingUtilities.invokeLater(() -> {
                    for (Transaction t : transactions) {
                        historyContainer.add(createTransactionRow(t));
                    }
                    historyContainer.revalidate();
                    historyContainer.repaint();
                });
            } catch (SQLException ex) { ex.printStackTrace(); }
        }).start();
    }

    private JPanel createTransactionRow(Transaction t) {
        JPanel row = new JPanel(new BorderLayout());
        row.setBackground(Color.WHITE);
        row.setMaximumSize(new Dimension(1200, 90));
        row.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createMatteBorder(0, 0, 1, 0, new Color(240, 240, 240)),
                new EmptyBorder(20, 35, 20, 35)
        ));

        boolean isSent = t.sender.equals(currentUser.getUsername());
        JLabel name = new JLabel(isSent ? "Payment to " + t.recipient : "Payment from " + t.sender);
        name.setFont(new Font("Segoe UI", Font.BOLD, 16));
        JLabel date = new JLabel(new SimpleDateFormat("MMMM dd, yyyy").format(t.timestamp));
        date.setForeground(Color.GRAY);

        JPanel info = new JPanel(new GridLayout(2, 1));
        info.setOpaque(false);
        info.add(name);
        info.add(date);

        JLabel amount = new JLabel((isSent ? "- " : "+ ") + String.format("₹ %.2f", t.amount));
        amount.setFont(new Font("Segoe UI", Font.BOLD, 18));
        amount.setForeground(isSent ? TEXT_COLOR : new Color(40, 167, 69));

        row.add(info, BorderLayout.WEST);
        row.add(amount, BorderLayout.EAST);
        return row;
    }

    private void showTransferDialog() {
        JPanel panel = new JPanel(new GridLayout(2, 2, 10, 10));
        JTextField recipientField = new JTextField();
        JTextField amountField = new JTextField();
        panel.add(new JLabel("Recipient:"));
        panel.add(recipientField);
        panel.add(new JLabel("Amount:"));
        panel.add(amountField);
        int res = JOptionPane.showConfirmDialog(this, panel, "Send Money", JOptionPane.OK_CANCEL_OPTION);
        if (res == JOptionPane.OK_OPTION) {
            executeTransfer(recipientField.getText().trim(), Double.parseDouble(amountField.getText()));
        }
    }

    private void executeTransfer(String recipient, double amount) {
        new Thread(() -> {
            try {
                DatabaseUtil.transferFunds(currentUser.getUsername(), recipient, amount);
                User updatedUser = UserDAO.getInstance().read(currentUser.getUsername());
                SwingUtilities.invokeLater(() -> {
                    currentUser.setBalance(updatedUser.getBalance());
                    balanceLabel.setText(String.format("₹ %.2f", currentUser.getBalance()));
                    refreshHistory();
                });
            } catch (Exception ex) {
                SwingUtilities.invokeLater(() -> JOptionPane.showMessageDialog(this, "Failed."));
            }
        }).start();
    }
}