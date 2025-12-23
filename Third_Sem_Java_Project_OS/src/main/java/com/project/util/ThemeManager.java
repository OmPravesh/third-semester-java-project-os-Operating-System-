package com.project.util;

import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.Font;
import java.awt.Window;
import java.util.Enumeration;

import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.border.TitledBorder;
import javax.swing.plaf.FontUIResource;

public class ThemeManager {
    public enum ColorScheme {
        DARK(new Color(20, 22, 28), Color.WHITE, new Color(60, 68, 79)),
        LIGHT(new Color(245, 245, 245), Color.BLACK, new Color(200, 200, 200)),
        CYBER(new Color(10, 10, 10), new Color(0, 255, 0), new Color(20, 40, 20)),
        OCEAN(new Color(10, 30, 60), new Color(200, 230, 255), new Color(30, 60, 90));

        // Made these private to encourage using getters, though package-private is default
        private final Color bg;
        private final Color fg;
        private final Color accent;

        ColorScheme(Color bg, Color fg, Color accent) {
            this.bg = bg;
            this.fg = fg;
            this.accent = accent;
        }

        // --- ADDED GETTERS HERE ---
        public Color getBg() { return bg; }
        public Color getFg() { return fg; }
        public Color getAccent() { return accent; }
    }

    public static ColorScheme currentScheme = ColorScheme.DARK;
    public static float fontScale = 1.0f;

    public static void applyThemeToAll() {
        for (Window window : Window.getWindows()) {
            updateComponentRecursively(window);
            SwingUtilities.updateComponentTreeUI(window);
            window.validate();
            window.repaint();
        }
    }

    private static void updateComponentRecursively(Component c) {
        if (c instanceof JPanel) {
            // Don't overwrite custom drawn panels like stock graph or game
            String className = c.getClass().getName();
            if (!className.contains("StockGraphPanel") && !className.contains("GamePanel")) {
                c.setBackground(currentScheme.bg);
            }
        }

        if (c instanceof JComponent) {
            JComponent jc = (JComponent) c;
            // Handle specific components
            if (c instanceof JTextArea || c instanceof JTextField || c instanceof JList) {
                c.setBackground(currentScheme == ColorScheme.LIGHT ? Color.WHITE : currentScheme.accent);
                c.setForeground(currentScheme.fg);
            } else if (c instanceof JButton) {
                c.setBackground(currentScheme.accent);
                c.setForeground(currentScheme.fg);
            } else if (c instanceof JLabel || c instanceof JCheckBox || c instanceof JRadioButton) {
                c.setForeground(currentScheme.fg);
            }

            // Recursively update borders if they are TitledBorders
            if (jc.getBorder() instanceof TitledBorder) {
                ((TitledBorder) jc.getBorder()).setTitleColor(currentScheme.fg);
            }
        }

        if (c instanceof Container) {
            for (Component child : ((Container) c).getComponents()) {
                updateComponentRecursively(child);
            }
        }
    }

    public static void setFontScale(float scale) {
        fontScale = scale;
        Enumeration<Object> keys = UIManager.getDefaults().keys();
        while (keys.hasMoreElements()) {
            Object key = keys.nextElement();
            Object value = UIManager.get(key);
            if (value instanceof FontUIResource) {
                FontUIResource orig = (FontUIResource) value;
                Font font = new Font(orig.getName(), orig.getStyle(), (int)(orig.getSize() * scale));
                UIManager.put(key, new FontUIResource(font));
            }
        }
        applyThemeToAll();
    }
}