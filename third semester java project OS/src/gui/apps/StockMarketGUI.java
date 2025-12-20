package gui.apps;

import model.User;
import model.Stock;
import gui.components.StockGraphPanel;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.text.DecimalFormat;
import java.util.*;
import java.util.Map;
import javax.swing.Timer;

public class StockMarketGUI extends JFrame {
    private final User currentUser;
    private final Map<String, Stock> stocks = new LinkedHashMap<>();
    private Stock selectedStock;

    // UI Colors (Dark Theme)
    private final Color BG_DARK = new Color(24, 24, 24);
    private final Color BG_PANEL = new Color(35, 35, 35);
    private final Color TEXT_PRI = new Color(230, 230, 230);
    private final Color TEXT_SEC = new Color(150, 150, 150);
    private final Color ACCENT_GREEN = new Color(0, 200, 100);
    private final Color ACCENT_RED = new Color(255, 60, 60);

    // Components
    private JPanel watchlistPanel;
    private StockGraphPanel graphPanel;
    private JLabel balanceLabel;
    private JTextArea portfolioArea;
    private JLabel lblName, lblSymbol, lblPrice, lblChange, lblHigh, lblLow, lblVol;
    private JTextField qtyField;

    private final DecimalFormat moneyFmt = new DecimalFormat("#,##0.00");
    private final DecimalFormat pctFmt = new DecimalFormat("0.00");
    private final Random random = new Random();

    public StockMarketGUI(User user) {
        this.currentUser = user;
        initDummyData();

        setTitle("TradePro - " + currentUser.getUsername());
        setSize(1200, 800);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);
        getContentPane().setBackground(BG_DARK);
        setLayout(new BorderLayout(0, 0));

        // --- 1. TOP BAR (Balance) ---
        JPanel topBar = new JPanel(new BorderLayout());
        topBar.setBackground(BG_PANEL);
        topBar.setBorder(new EmptyBorder(15, 20, 15, 20));

        JLabel appTitle = new JLabel("STOCK MARKET");
        appTitle.setFont(new Font("Segoe UI", Font.BOLD, 20));
        appTitle.setForeground(TEXT_PRI);

        balanceLabel = new JLabel("Funds: ₹" + moneyFmt.format(currentUser.getBalance()));
        balanceLabel.setFont(new Font("Monospaced", Font.BOLD, 18));
        balanceLabel.setForeground(ACCENT_GREEN);

        topBar.add(appTitle, BorderLayout.WEST);
        topBar.add(balanceLabel, BorderLayout.EAST);
        add(topBar, BorderLayout.NORTH);

        // --- 2. LEFT SIDE (Watchlist) ---
        watchlistPanel = new JPanel();
        watchlistPanel.setLayout(new BoxLayout(watchlistPanel, BoxLayout.Y_AXIS));
        watchlistPanel.setBackground(BG_PANEL);

        JScrollPane scrollPane = new JScrollPane(watchlistPanel);
        scrollPane.setPreferredSize(new Dimension(280, 0));
        scrollPane.setBorder(BorderFactory.createMatteBorder(0, 0, 0, 1, new Color(50, 50, 50)));
        scrollPane.getVerticalScrollBar().setUI(null); // minimal scrollbar
        add(scrollPane, BorderLayout.WEST);

        // --- 3. CENTER (Dashboard) ---
        JPanel centerPanel = new JPanel(new BorderLayout());
        centerPanel.setBackground(BG_DARK);
        centerPanel.setBorder(new EmptyBorder(20, 20, 20, 20));

        // Header (Stock Info)
        JPanel headerInfo = new JPanel(new GridLayout(1, 2));
        headerInfo.setOpaque(false);

        JPanel titleGroup = new JPanel(new GridLayout(2, 1));
        titleGroup.setOpaque(false);
        lblName = new JLabel("SELECT STOCK");
        lblName.setFont(new Font("Segoe UI", Font.BOLD, 28));
        lblName.setForeground(TEXT_PRI);
        lblSymbol = new JLabel("---");
        lblSymbol.setFont(new Font("Segoe UI", Font.PLAIN, 14));
        lblSymbol.setForeground(TEXT_SEC);
        titleGroup.add(lblName);
        titleGroup.add(lblSymbol);

        JPanel priceGroup = new JPanel(new GridLayout(2, 1));
        priceGroup.setOpaque(false);
        lblPrice = new JLabel("0.00");
        lblPrice.setFont(new Font("Segoe UI", Font.BOLD, 32));
        lblPrice.setForeground(TEXT_PRI);
        lblPrice.setHorizontalAlignment(SwingConstants.RIGHT);
        lblChange = new JLabel("0.00%");
        lblChange.setFont(new Font("Segoe UI", Font.BOLD, 16));
        lblChange.setHorizontalAlignment(SwingConstants.RIGHT);
        priceGroup.add(lblPrice);
        priceGroup.add(lblChange);

        headerInfo.add(titleGroup);
        headerInfo.add(priceGroup);
        centerPanel.add(headerInfo, BorderLayout.NORTH);

        // Graph
        Stock first = stocks.values().iterator().next();
        selectedStock = first; // Default
        graphPanel = new StockGraphPanel(first.getPriceHistory(), first.symbol);
        centerPanel.add(graphPanel, BorderLayout.CENTER);

        // Bottom Controls (Stats + Buy/Sell)
        JPanel bottomControls = new JPanel(new BorderLayout(15, 0));
        bottomControls.setOpaque(false);
        bottomControls.setBorder(new EmptyBorder(20, 0, 0, 0));

        // Stats Grid
        JPanel statsPanel = new JPanel(new GridLayout(1, 3, 10, 0));
        statsPanel.setOpaque(false);
        lblHigh = createStatLabel("Day High");
        lblLow = createStatLabel("Day Low");
        lblVol = createStatLabel("Volume");
        statsPanel.add(lblHigh);
        statsPanel.add(lblLow);
        statsPanel.add(lblVol);

        // Action Buttons
        JPanel actionPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        actionPanel.setOpaque(false);

        qtyField = new JTextField("1", 4);
        qtyField.setFont(new Font("Segoe UI", Font.BOLD, 16));
        qtyField.setHorizontalAlignment(SwingConstants.CENTER);

        JButton btnBuy = createActionButton("BUY", ACCENT_GREEN);
        JButton btnSell = createActionButton("SELL", ACCENT_RED);
        JCheckBox maCheck = new JCheckBox("Show MA");
        maCheck.setForeground(TEXT_SEC);
        maCheck.setOpaque(false);
        maCheck.addActionListener(e -> graphPanel.setShowMA(maCheck.isSelected()));

        btnBuy.addActionListener(e -> handleTransaction(true));
        btnSell.addActionListener(e -> handleTransaction(false));

        actionPanel.add(maCheck);
        actionPanel.add(new JLabel("  Qty: "));
        actionPanel.add(qtyField);
        actionPanel.add(btnBuy);
        actionPanel.add(btnSell);

        bottomControls.add(statsPanel, BorderLayout.WEST);
        bottomControls.add(actionPanel, BorderLayout.EAST);
        centerPanel.add(bottomControls, BorderLayout.SOUTH);

        add(centerPanel, BorderLayout.CENTER);

        // --- 4. BOTTOM (Portfolio) ---
        portfolioArea = new JTextArea();
        portfolioArea.setEditable(false);
        portfolioArea.setBackground(BG_PANEL);
        portfolioArea.setForeground(TEXT_SEC);
        portfolioArea.setFont(new Font("Monospaced", Font.PLAIN, 12));
        portfolioArea.setBorder(new EmptyBorder(10, 10, 10, 10));

        JScrollPane portScroll = new JScrollPane(portfolioArea);
        portScroll.setPreferredSize(new Dimension(0, 120));
        portScroll.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(new Color(50,50,50)),
                "My Portfolio", 0, 0, new Font("Segoe UI", Font.BOLD, 12), TEXT_SEC));
        portScroll.getViewport().setBackground(BG_PANEL); // Fix white background bug

        add(portScroll, BorderLayout.SOUTH);

        // Initialize Views
        refreshWatchlist();
        updateDetailView();
        updatePortfolioDisplay();

        // Timer
        Timer timer = new Timer(1000, e -> updateMarket());
        timer.start();

        setVisible(true);
    }

    private void initDummyData() {
        stocks.put("APPLE", new Stock("APPL", "Apple Inc.", 150.0));
        stocks.put("GOOGLE", new Stock("GOOGL", "Alphabet Inc.", 2700.0));
        stocks.put("MSFT", new Stock("MSFT", "Microsoft", 300.0));
        stocks.put("TESLA", new Stock("TSLA", "Tesla Inc", 200.0));
        stocks.put("AMZN", new Stock("AMZN", "Amazon", 180.0));
    }

    // --- UI HELPERS ---

    private JButton createActionButton(String text, Color bg) {
        JButton btn = new JButton(text);
        btn.setBackground(bg);
        btn.setForeground(Color.WHITE);
        btn.setFocusPainted(false);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 14));
        btn.setBorder(new EmptyBorder(8, 20, 8, 20));
        return btn;
    }

    private JLabel createStatLabel(String title) {
        return new JLabel("<html><div style='text-align:center; color:#888'>"+title+"<br><span style='color:#ccc; font-size:14px'>--</span></div></html>", SwingConstants.CENTER);
    }

    // --- LOGIC ---

    private void updateMarket() {
        for (Stock s : stocks.values()) {
            s.updatePrice(random);
        }

        // Refresh Watchlist values (without rebuilding panels for performance)
        refreshWatchlistValues();

        // Refresh Center View
        if (selectedStock != null) {
            updateDetailView();
            graphPanel.setPriceHistory(selectedStock.getPriceHistory());
        }
        updatePortfolioDisplay();
    }

    private void updateDetailView() {
        if (selectedStock == null) return;

        lblName.setText(selectedStock.name);
        lblSymbol.setText(selectedStock.symbol);
        lblPrice.setText(moneyFmt.format(selectedStock.price));

        double change = selectedStock.getChangePercent();
        String sign = change >= 0 ? "+" : "";
        lblChange.setText(sign + pctFmt.format(change) + "%");
        lblChange.setForeground(change >= 0 ? ACCENT_GREEN : ACCENT_RED);

        lblHigh.setText("<html><div style='text-align:center; color:#888'>High<br><span style='color:#ccc; font-size:14px'>" + moneyFmt.format(selectedStock.dayHigh) + "</span></div></html>");
        lblLow.setText("<html><div style='text-align:center; color:#888'>Low<br><span style='color:#ccc; font-size:14px'>" + moneyFmt.format(selectedStock.dayLow) + "</span></div></html>");
        lblVol.setText("<html><div style='text-align:center; color:#888'>Vol<br><span style='color:#ccc; font-size:14px'>" + selectedStock.volume + "</span></div></html>");
    }

    private void refreshWatchlist() {
        watchlistPanel.removeAll();
        for (Stock s : stocks.values()) {
            JPanel card = new JPanel(new BorderLayout());
            card.setBackground(s == selectedStock ? new Color(50, 50, 60) : BG_PANEL);
            card.setBorder(new EmptyBorder(10, 15, 10, 15));
            card.setMaximumSize(new Dimension(300, 50));
            card.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));

            JLabel sym = new JLabel(s.symbol);
            sym.setFont(new Font("Segoe UI", Font.BOLD, 14));
            sym.setForeground(TEXT_PRI);

            JLabel pr = new JLabel(moneyFmt.format(s.price));
            pr.setFont(new Font("Monospaced", Font.PLAIN, 14));
            pr.setForeground(TEXT_SEC);

            card.add(sym, BorderLayout.WEST);
            card.add(pr, BorderLayout.EAST);

            // Click to select
            card.addMouseListener(new MouseAdapter() {
                public void mouseClicked(MouseEvent e) {
                    selectedStock = s;
                    refreshWatchlist(); // Rebuild to update highlights
                    updateDetailView();
                    graphPanel.setSymbol(s.symbol);
                    graphPanel.setPriceHistory(s.getPriceHistory());
                }
            });

            watchlistPanel.add(card);
            watchlistPanel.add(Box.createVerticalStrut(1));
        }
        watchlistPanel.revalidate();
        watchlistPanel.repaint();
    }

    // Lightweight update for numbers only
    private void refreshWatchlistValues() {
        Component[] comps = watchlistPanel.getComponents();
        int stockIndex = 0;
        // We iterate components, skipping struts
        // This is a simple approximation. For production, keep a Map<Stock, JLabel>
        // Here we just rebuild entire watchlist occasionally or rely on full rebuild for simplicity if list is short.
        // Actually, let's just do full rebuild for simplicity in this demo (it's fast enough for <50 stocks)
        refreshWatchlist();
    }

    private void handleTransaction(boolean isBuy) {
        if (selectedStock == null) return;
        try {
            int qty = Integer.parseInt(qtyField.getText().trim());
            if (qty <= 0) throw new NumberFormatException();

            if (isBuy) {
                double cost = selectedStock.price * qty;
                if (currentUser.getBalance() >= cost) {
                    currentUser.setBalance(currentUser.getBalance() - cost);
                    currentUser.getPortfolio().put(selectedStock.symbol,
                            currentUser.getPortfolio().getOrDefault(selectedStock.symbol, 0) + qty);
                    JOptionPane.showMessageDialog(this, "Bought " + qty + " of " + selectedStock.symbol);
                } else {
                    JOptionPane.showMessageDialog(this, "Insufficient Funds!", "Error", JOptionPane.ERROR_MESSAGE);
                }
            } else {
                int owned = currentUser.getPortfolio().getOrDefault(selectedStock.symbol, 0);
                if (owned >= qty) {
                    currentUser.setBalance(currentUser.getBalance() + (selectedStock.price * qty));
                    int remaining = owned - qty;
                    if (remaining == 0) currentUser.getPortfolio().remove(selectedStock.symbol);
                    else currentUser.getPortfolio().put(selectedStock.symbol, remaining);
                    JOptionPane.showMessageDialog(this, "Sold " + qty + " of " + selectedStock.symbol);
                } else {
                    JOptionPane.showMessageDialog(this, "Not enough shares!", "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
            balanceLabel.setText("Funds: ₹" + moneyFmt.format(currentUser.getBalance()));
            updatePortfolioDisplay();
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "Invalid Quantity", "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void updatePortfolioDisplay() {
        StringBuilder sb = new StringBuilder();
        sb.append(String.format("%-10s %-10s %-15s %-15s\n", "Symbol", "Shares", "Price", "Value"));
        sb.append("------------------------------------------------------------\n");
        double totalValue = 0;
        for (Map.Entry<String, Integer> entry : currentUser.getPortfolio().entrySet()) {
            Stock s = stocks.get(entry.getKey());
            if (s != null) {
                double val = entry.getValue() * s.price;
                totalValue += val;
                sb.append(String.format("%-10s %-10d ₹%-14.2f ₹%-14.2f\n",
                        s.symbol, entry.getValue(), s.price, val));
            }
        }
        sb.append("------------------------------------------------------------\n");
        sb.append(String.format("Total Portfolio: ₹%.2f", totalValue));
        portfolioArea.setText(sb.toString());
    }
}