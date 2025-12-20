package gui.components;

import javax.swing.*;
import java.awt.*;
import java.awt.geom.Path2D;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class StockGraphPanel extends JPanel {
    private List<Double> priceHistory;
    private String symbol;
    private boolean showMA = false; // Moving Average toggle

    // Colors
    private final Color COLOR_BG = new Color(35, 35, 35);
    private final Color COLOR_GRID = new Color(50, 50, 50);
    private final Color COLOR_PROFIT = new Color(0, 200, 100);
    private final Color COLOR_LOSS = new Color(255, 60, 60);

    public StockGraphPanel(List<Double> data, String symbol) {
        this.priceHistory = data != null ? data : new ArrayList<>();
        this.symbol = symbol;
        setBackground(COLOR_BG);
        setBorder(BorderFactory.createLineBorder(new Color(60, 60, 60)));
    }

    public void setPriceHistory(List<Double> data) {
        this.priceHistory = new ArrayList<>(data);
        repaint();
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public void setShowMA(boolean show) {
        this.showMA = show;
        repaint();
    }

    // Compatibility stub for your old code
    public void setRange(String range) { /* Logic can be added here */ }
    public String getSymbol() { return symbol; }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        if (priceHistory == null || priceHistory.size() < 2) return;

        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        int w = getWidth();
        int h = getHeight();
        int pad = 30;

        // 1. Math: Find Range
        double min = Collections.min(priceHistory);
        double max = Collections.max(priceHistory);
        double range = max - min;
        if (range == 0) range = 1;

        // 2. Draw Grid
        g2.setColor(COLOR_GRID);
        for (int i = 0; i < 5; i++) {
            int y = h - pad - (i * (h - 2 * pad) / 4);
            g2.drawLine(pad, y, w - pad, y);
            // Draw price labels on Y-axis
            String priceLabel = String.format("%.1f", min + (i * range / 4.0));
            g2.drawString(priceLabel, 2, y + 4);
        }

        // 3. Draw Main Line
        double firstPrice = priceHistory.get(0);
        double lastPrice = priceHistory.get(priceHistory.size() - 1);
        Color trendColor = lastPrice >= firstPrice ? COLOR_PROFIT : COLOR_LOSS;

        Path2D.Double path = new Path2D.Double();
        double xStep = (double) (w - 2 * pad) / (priceHistory.size() - 1);

        // Start Point
        path.moveTo(pad, getY(priceHistory.get(0), min, range, h, pad));

        for (int i = 1; i < priceHistory.size(); i++) {
            path.lineTo(pad + i * xStep, getY(priceHistory.get(i), min, range, h, pad));
        }

        // Fill Area
        Path2D.Double fillPath = (Path2D.Double) path.clone();
        fillPath.lineTo(w - pad, h - pad);
        fillPath.lineTo(pad, h - pad);
        fillPath.closePath();

        GradientPaint gp = new GradientPaint(0, 0,
                new Color(trendColor.getRed(), trendColor.getGreen(), trendColor.getBlue(), 40),
                0, h, new Color(0, 0, 0, 0));
        g2.setPaint(gp);
        g2.fill(fillPath);

        // Stroke Line
        g2.setColor(trendColor);
        g2.setStroke(new BasicStroke(2f));
        g2.draw(path);

        // 4. Draw Moving Average (Simple 10-period) if enabled
        if (showMA && priceHistory.size() > 10) {
            g2.setColor(Color.CYAN);
            g2.setStroke(new BasicStroke(1f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND, 1f, new float[]{5f}, 0f));
            Path2D.Double maPath = new Path2D.Double();
            boolean first = true;
            for (int i = 9; i < priceHistory.size(); i++) {
                double sum = 0;
                for (int j = 0; j < 10; j++) sum += priceHistory.get(i - j);
                double avg = sum / 10.0;
                double x = pad + i * xStep;
                double y = getY(avg, min, range, h, pad);
                if (first) { maPath.moveTo(x, y); first = false; }
                else { maPath.lineTo(x, y); }
            }
            g2.draw(maPath);
        }
    }

    private double getY(double price, double min, double range, int h, int pad) {
        return h - pad - ((price - min) / range) * (h - 2 * pad);
    }
}