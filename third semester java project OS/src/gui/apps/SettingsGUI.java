package gui.apps;

import util.ThemeManager;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import javax.swing.UIManager;

public class SettingsGUI extends JDialog {
    public SettingsGUI(JFrame parent) {
        super(parent, "Settings", true);
        setSize(500, 450);
        setLocationRelativeTo(parent);
        setLayout(new BorderLayout(10, 10));

        // Main Tabbed Pane for Settings
        JTabbedPane tabs = new JTabbedPane();

        // 1. Theme Settings
        tabs.addTab("Appearance", createAppearancePanel());

        // 2. Additional Settings (Font, Data)
        tabs.addTab("System & Data", createSystemPanel());

        add(tabs, BorderLayout.CENTER);

        // Button Panel
        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        JButton closeBtn = new JButton("Close");
        closeBtn.addActionListener(e -> dispose());
        btnPanel.add(closeBtn);
        add(btnPanel, BorderLayout.SOUTH);

        ThemeManager.applyThemeToAll(); // Apply current theme to this dialog
        setVisible(true);
    }

    private JPanel createAppearancePanel() {
        JPanel panel = new JPanel(new GridLayout(0, 1, 10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        // --- Look and Feel Section ---
        JPanel lafPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        lafPanel.setBorder(BorderFactory.createTitledBorder("Window Style (Look & Feel)"));

        // Removed "Windows" and "Windows Classic" as requested
        String[] styles = {"Metal", "Nimbus", "CDE/Motif"};
        JComboBox<String> styleCombo = new JComboBox<>(styles);
        JButton applyStyleBtn = new JButton("Apply Style");

        applyStyleBtn.addActionListener(e -> {
            String selected = (String) styleCombo.getSelectedItem();
            String className = "javax.swing.plaf.metal.MetalLookAndFeel"; // Default

            if ("Nimbus".equals(selected)) className = "javax.swing.plaf.nimbus.NimbusLookAndFeel";
            else if ("CDE/Motif".equals(selected)) className = "com.sun.java.swing.plaf.motif.MotifLookAndFeel";

            try {
                UIManager.setLookAndFeel(className);
                ThemeManager.applyThemeToAll();
                JOptionPane.showMessageDialog(this, "Window style updated!");
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        });

        lafPanel.add(new JLabel("Style:"));
        lafPanel.add(styleCombo);
        lafPanel.add(applyStyleBtn);
        panel.add(lafPanel);

        // --- Color Scheme Section ---
        JPanel colorPanel = new JPanel(new GridLayout(2, 2, 10, 10));
        colorPanel.setBorder(BorderFactory.createTitledBorder("Color Scheme"));

        JButton btnDark = new JButton("Dark Mode (Default)");
        JButton btnLight = new JButton("Light Mode");
        JButton btnCyber = new JButton("Cyberpunk Green");
        JButton btnOcean = new JButton("Ocean Blue");

        btnDark.addActionListener(e -> updateScheme(ThemeManager.ColorScheme.DARK));
        btnLight.addActionListener(e -> updateScheme(ThemeManager.ColorScheme.LIGHT));
        btnCyber.addActionListener(e -> updateScheme(ThemeManager.ColorScheme.CYBER));
        btnOcean.addActionListener(e -> updateScheme(ThemeManager.ColorScheme.OCEAN));

        colorPanel.add(btnDark);
        colorPanel.add(btnLight);
        colorPanel.add(btnCyber);
        colorPanel.add(btnOcean);
        panel.add(colorPanel);

        return panel;
    }

    private JPanel createSystemPanel() {
        JPanel panel = new JPanel(new GridLayout(0, 1, 10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        // --- Font Settings ---
        JPanel fontPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        fontPanel.setBorder(BorderFactory.createTitledBorder("Accessibility"));

        JSlider fontSlider = new JSlider(80, 150, 100);
        fontSlider.setMajorTickSpacing(10);
        fontSlider.setPaintTicks(true);
        JButton applyFontBtn = new JButton("Set Font Scale");

        applyFontBtn.addActionListener(e -> {
            float scale = fontSlider.getValue() / 100f;
            ThemeManager.setFontScale(scale);
        });

        fontPanel.add(new JLabel("Text Size %:"));
        fontPanel.add(fontSlider);
        fontPanel.add(applyFontBtn);
        panel.add(fontPanel);

        // --- Data Settings ---
        JPanel dataPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        dataPanel.setBorder(BorderFactory.createTitledBorder("Data Management"));
        JButton clearCacheBtn = new JButton("Clear Local Cache");
        clearCacheBtn.addActionListener(e -> {
            int choice = JOptionPane.showConfirmDialog(this, "This will reset local UI preferences. Continue?");
            if(choice == JOptionPane.YES_OPTION) {
                JOptionPane.showMessageDialog(this, "Cache cleared (Simulated).");
            }
        });
        dataPanel.add(clearCacheBtn);
        panel.add(dataPanel);

        return panel;
    }

    private void updateScheme(ThemeManager.ColorScheme scheme) {
        ThemeManager.currentScheme = scheme;
        ThemeManager.applyThemeToAll();
    }
}