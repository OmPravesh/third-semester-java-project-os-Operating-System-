package gui.apps;

import util.ThemeManager;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class UtilitiesGUI extends JFrame {
    public UtilitiesGUI() {
        setTitle("Utility Functions");
        setSize(600, 500);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout(10, 10));

        JTabbedPane tabbedPane = new JTabbedPane();
        tabbedPane.addTab("String Reverser", createStringReverserPanel());
        tabbedPane.addTab("Word Counter", createCharCounterPanel());
        tabbedPane.addTab("Case Converter", createCaseConverterPanel());
        tabbedPane.addTab("Palindrome Checker", createPalindromePanel());

        add(tabbedPane, BorderLayout.CENTER);
        ThemeManager.applyThemeToAll();
        setVisible(true);
    }

    private JPanel createStringReverserPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(10, 10, 10, 10));
        JTextArea inputArea = new JTextArea(5, 40);
        JTextArea outputArea = new JTextArea(5, 40);
        outputArea.setEditable(false);
        JButton reverseBtn = new JButton("Reverse String");
        reverseBtn.addActionListener(e -> {
            String input = inputArea.getText();
            String reversed = new StringBuilder(input).reverse().toString();
            outputArea.setText(reversed);
        });
        panel.add(new JLabel("Enter text to reverse:"), BorderLayout.NORTH);
        panel.add(new JScrollPane(inputArea), BorderLayout.CENTER);
        JPanel btnPanel = new JPanel();
        btnPanel.add(reverseBtn);
        panel.add(btnPanel, BorderLayout.SOUTH);
        JPanel resultPanel = new JPanel(new BorderLayout());
        resultPanel.add(new JLabel("Reversed text:"), BorderLayout.NORTH);
        resultPanel.add(new JScrollPane(outputArea), BorderLayout.CENTER);
        JSplitPane splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT, panel, resultPanel);
        splitPane.setDividerLocation(200);
        JPanel wrapper = new JPanel(new BorderLayout());
        wrapper.add(splitPane, BorderLayout.CENTER);
        return wrapper;
    }

    private JPanel createCharCounterPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(10, 10, 10, 10));
        JTextArea inputArea = new JTextArea(10, 40);
        JTextArea outputArea = new JTextArea(10, 40);
        outputArea.setEditable(false);
        JButton countBtn = new JButton("Count Characters");
        countBtn.addActionListener(e -> {
            String input = inputArea.getText();
            int chars = input.length();
            int words = input.trim().isEmpty() ? 0 : input.trim().split("\\s+").length;
            int lines = input.isEmpty() ? 0 : input.split("\n").length;
            outputArea.setText("Characters: " + chars + "\nWords: " + words + "\nLines: " + lines);
        });
        panel.add(new JLabel("Enter text:"), BorderLayout.NORTH);
        panel.add(new JScrollPane(inputArea), BorderLayout.CENTER);
        JPanel bottomPanel = new JPanel(new BorderLayout());
        bottomPanel.add(countBtn, BorderLayout.NORTH);
        bottomPanel.add(new JScrollPane(outputArea), BorderLayout.CENTER);
        panel.add(bottomPanel, BorderLayout.SOUTH);
        return panel;
    }

    private JPanel createCaseConverterPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(10, 10, 10, 10));
        JTextArea inputArea = new JTextArea(5, 40);
        JTextArea outputArea = new JTextArea(5, 40);
        outputArea.setEditable(false);
        JPanel btnPanel = new JPanel();
        JButton upperBtn = new JButton("UPPERCASE");
        JButton lowerBtn = new JButton("lowercase");
        JButton titleBtn = new JButton("Title Case");
        upperBtn.addActionListener(e -> outputArea.setText(inputArea.getText().toUpperCase()));
        lowerBtn.addActionListener(e -> outputArea.setText(inputArea.getText().toLowerCase()));
        titleBtn.addActionListener(e -> {
            String[] words = inputArea.getText().split(" ");
            StringBuilder result = new StringBuilder();
            for (String word : words) {
                if (!word.isEmpty()) {
                    result.append(Character.toUpperCase(word.charAt(0)))
                            .append(word.substring(1).toLowerCase())
                            .append(" ");
                }
            }
            outputArea.setText(result.toString().trim());
        });
        btnPanel.add(upperBtn);
        btnPanel.add(lowerBtn);
        btnPanel.add(titleBtn);
        panel.add(new JLabel("Enter text:"), BorderLayout.NORTH);
        panel.add(new JScrollPane(inputArea), BorderLayout.CENTER);
        JPanel bottomPanel = new JPanel(new BorderLayout());
        bottomPanel.add(btnPanel, BorderLayout.NORTH);
        bottomPanel.add(new JScrollPane(outputArea), BorderLayout.CENTER);
        panel.add(bottomPanel, BorderLayout.SOUTH);
        return panel;
    }

    private JPanel createPalindromePanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(10, 10, 10, 10));
        JTextField inputField = new JTextField(30);
        JLabel resultLabel = new JLabel("Enter a word or phrase above");
        resultLabel.setHorizontalAlignment(JLabel.CENTER);
        resultLabel.setFont(new Font("Arial", Font.BOLD, 16));
        JButton checkBtn = new JButton("Check Palindrome");
        checkBtn.addActionListener(e -> {
            String input = inputField.getText().replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
            String reversed = new StringBuilder(input).reverse().toString();
            if (input.equals(reversed) && !input.isEmpty()) {
                resultLabel.setText("✓ Yes, it's a palindrome!");
                resultLabel.setForeground(new Color(0, 150, 0));
            } else {
                resultLabel.setText("✗ No, it's not a palindrome");
                resultLabel.setForeground(Color.RED);
            }
        });
        JPanel topPanel = new JPanel();
        topPanel.add(new JLabel("Enter text: "));
        topPanel.add(inputField);
        topPanel.add(checkBtn);
        panel.add(topPanel, BorderLayout.NORTH);
        panel.add(resultLabel, BorderLayout.CENTER);
        return panel;
    }
}