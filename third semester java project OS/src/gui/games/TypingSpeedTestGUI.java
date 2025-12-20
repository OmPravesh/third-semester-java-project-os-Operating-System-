package gui.games;

import util.ThemeManager;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import java.awt.*;
import java.util.Random;

public class TypingSpeedTestGUI extends JFrame {
    private final JLabel sentenceLabel = new JLabel("Click 'Start' to begin.");
    private final JTextArea typingArea = new JTextArea(5, 30);
    private final JButton startButton = new JButton("Start Test");
    private final JLabel timerLabel = new JLabel("Time: 0s");
    private final JLabel wpmLabel = new JLabel("WPM: 0");
    private final JLabel accuracyLabel = new JLabel("Acc: 100%");
    private javax.swing.Timer timer;
    private long startTime;
    private final String[] sentences = {
            "The quick brown fox jumps over the lazy dog.",
            "Java is a versatile and powerful programming language.",
            "Technology changes fast but logic remains the same.",
            "A smooth sea never made a skilled sailor."
    };

    public TypingSpeedTestGUI() {
        setTitle("Typing Speed Test");
        setSize(700, 450);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout(15, 15));
        JPanel headerPanel = new JPanel(new BorderLayout());
        headerPanel.setBorder(new EmptyBorder(20, 20, 10, 20));
        sentenceLabel.setFont(new Font("Serif", Font.BOLD, 20));
        sentenceLabel.setForeground(new Color(50, 50, 150));
        headerPanel.add(new JLabel("Type this sentence:"), BorderLayout.NORTH);
        headerPanel.add(sentenceLabel, BorderLayout.CENTER);
        typingArea.setEnabled(false);
        typingArea.setLineWrap(true);
        typingArea.setWrapStyleWord(true);
        typingArea.setFont(new Font("Monospaced", Font.PLAIN, 18));
        typingArea.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(Color.GRAY),
                BorderFactory.createEmptyBorder(10, 10, 10, 10)
        ));
        JPanel statsPanel = new JPanel(new GridLayout(1, 3, 20, 0));
        statsPanel.setBorder(new EmptyBorder(15, 15, 15, 15));
        styleStatLabel(timerLabel);
        styleStatLabel(wpmLabel);
        styleStatLabel(accuracyLabel);
        statsPanel.add(timerLabel);
        statsPanel.add(wpmLabel);
        statsPanel.add(accuracyLabel);
        JPanel bottomPanel = new JPanel(new BorderLayout());
        bottomPanel.add(statsPanel, BorderLayout.CENTER);
        startButton.setFont(new Font("Segoe UI", Font.BOLD, 14));
        bottomPanel.add(startButton, BorderLayout.EAST);
        add(headerPanel, BorderLayout.NORTH);
        add(new JScrollPane(typingArea), BorderLayout.CENTER);
        add(bottomPanel, BorderLayout.SOUTH);
        startButton.addActionListener(e -> startGame());
        typingArea.getDocument().addDocumentListener(new DocumentListener() {
            public void insertUpdate(DocumentEvent e) { checkTyping(); }
            public void removeUpdate(DocumentEvent e) { checkTyping(); }
            public void changedUpdate(DocumentEvent e) { checkTyping(); }
        });

        ThemeManager.applyThemeToAll();
        setVisible(true);
    }

    private void styleStatLabel(JLabel lbl) {
        lbl.setForeground(Color.CYAN);
        lbl.setFont(new Font("Monospaced", Font.BOLD, 16));
        lbl.setHorizontalAlignment(SwingConstants.CENTER);
        lbl.setBorder(BorderFactory.createLineBorder(Color.DARK_GRAY));
    }

    private void startGame() {
        sentenceLabel.setText(sentences[new Random().nextInt(sentences.length)]);
        typingArea.setText("");
        typingArea.setEnabled(true);
        typingArea.requestFocus();
        typingArea.setBackground(Color.WHITE);
        startButton.setEnabled(false);
        startTime = System.currentTimeMillis();
        timer = new javax.swing.Timer(100, e -> updateStats());
        timer.start();
    }

    private void updateStats() {
        long elapsed = System.currentTimeMillis() - startTime;
        timerLabel.setText(String.format("Time: %.1fs", elapsed / 1000.0));
        calculateWPM(elapsed);
        calculateAccuracy();
    }

    private void checkTyping() {
        String target = sentenceLabel.getText();
        String current = typingArea.getText();
        if (!target.startsWith(current)) {
            typingArea.setBackground(new Color(255, 230, 230));
        } else {
            typingArea.setBackground(Color.WHITE);
        }
        if (current.equals(target)) {
            timer.stop();
            typingArea.setEnabled(false);
            typingArea.setBackground(new Color(230, 255, 230));
            startButton.setEnabled(true);
            startButton.setText("Play Again");
            JOptionPane.showMessageDialog(this, "Test Finished!\n" + wpmLabel.getText(), "Complete", JOptionPane.INFORMATION_MESSAGE);
        }
    }

    private void calculateWPM(long elapsedMillis) {
        if (elapsedMillis == 0) return;
        double minutes = elapsedMillis / 60000.0;
        String[] wordsTyped = typingArea.getText().trim().split("\\s+");
        int numWords = wordsTyped[0].isEmpty() ? 0 : wordsTyped.length;
        int wpm = (int) (numWords / minutes);
        wpmLabel.setText("WPM: " + wpm);
    }

    private void calculateAccuracy() {
        String target = sentenceLabel.getText();
        String typed = typingArea.getText();
        int correctChars = 0;
        for (int i = 0; i < Math.min(target.length(), typed.length()); i++) {
            if (target.charAt(i) == typed.charAt(i)) correctChars++;
        }
        double accuracy = (target.isEmpty()) ? 100.0 : ((double) correctChars / target.length()) * 100;
        accuracyLabel.setText(String.format("Acc: %.1f%%", accuracy));
    }
}