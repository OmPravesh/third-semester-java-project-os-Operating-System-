package gui.apps;

import games.DoomBrickEdition; // Ensure this matches your package structure
import util.ThemeManager;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionListener;
import java.util.Random;

public class GamesGUI extends JDialog {
    public GamesGUI(JFrame parent) {
        super(parent, "Arcade Menu", true);
        setSize(400, 650); // Adjusted height for better spacing
        setLocationRelativeTo(parent);

        // Using 6 rows to accommodate the new game and existing options
        setLayout(new GridLayout(6, 1, 15, 15));

        JPanel content = (JPanel) getContentPane();
        content.setBorder(new EmptyBorder(20, 20, 20, 20));

        // --- EXISTING GAMES ---
        // These rely on your existing classes in the games/gui.games packages
        add(createGameButton("⌨️ Typing Speed Test", new Color(100, 180, 255), e -> {
            dispose();
            // Assuming your TypingSpeedTestGUI class is available
            // new TypingSpeedTestGUI();
        }));

        add(createGameButton("🏰 Adventure Quest", new Color(255, 180, 100), e -> {
            dispose();
            // Assuming your AdventureQuestGUI class is available
            // new AdventureQuestGUI();
        }));

        add(createGameButton("🐍 Snake Game", new Color(100, 255, 100), e -> {
            dispose();
            // Assuming your GameFrame class is available
            // new GameFrame();
        }));

        // --- UPDATED DOOM BUTTON ---
        // This launches the version with working shooting and no flickering
        add(createGameButton("🔫 DOOM (Brick Edition)", new Color(180, 40, 40), e -> {
            dispose(); // Close the menu before launching
            SwingUtilities.invokeLater(() -> new DoomBrickEdition());
        }));

        // --- MINI GAMES ---
        add(createGameButton("✂️ Rock Paper Scissors", new Color(255, 100, 100), e -> runRockPaperScissorsGUI(this)));
        add(createGameButton("🔢 Number Guessing", new Color(200, 100, 255), e -> runNumberGuessingGUI(this)));

        ThemeManager.applyThemeToAll();
        setVisible(true);
    }

    /**
     * Helper to create styled buttons for the Arcade Menu
     */
    private JButton createGameButton(String text, Color bg, ActionListener action) {
        JButton btn = new JButton(text);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 18));
        btn.setBackground(bg);

        // Contrast check: if background is dark, make text white
        if (bg.getRed() < 120 && bg.getGreen() < 120 && bg.getBlue() < 120) {
            btn.setForeground(Color.WHITE);
        } else {
            btn.setForeground(Color.BLACK);
        }

        btn.setFocusPainted(false);
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btn.addActionListener(action);
        return btn;
    }

    private void runNumberGuessingGUI(Component parent) {
        int target = new Random().nextInt(100) + 1;
        int attempts = 0;
        JOptionPane.showMessageDialog(parent, "I'm thinking of a number between 1 and 100!");
        while (true) {
            String guessStr = JOptionPane.showInputDialog(parent, "Your guess:");
            if (guessStr == null) break;
            try {
                int guess = Integer.parseInt(guessStr);
                attempts++;
                if (guess == target) {
                    JOptionPane.showMessageDialog(parent, "Correct! You won in " + attempts + " attempts!", "You Won!", JOptionPane.INFORMATION_MESSAGE);
                    break;
                } else if (guess < target) {
                    JOptionPane.showMessageDialog(parent, "Higher!", "Try Again", JOptionPane.WARNING_MESSAGE);
                } else {
                    JOptionPane.showMessageDialog(parent, "Lower!", "Try Again", JOptionPane.WARNING_MESSAGE);
                }
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(parent, "Please enter a valid number.", "Invalid Input", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void runRockPaperScissorsGUI(Component parent) {
        String[] options = {"Rock 🪨", "Paper 📄", "Scissors ✂️"};
        int playerChoice = JOptionPane.showOptionDialog(parent, "Choose your move:", "Rock, Paper, Scissors",
                JOptionPane.DEFAULT_OPTION, JOptionPane.QUESTION_MESSAGE, null, options, options[0]);
        if (playerChoice == -1) return;

        int compChoice = new Random().nextInt(3);
        String result = (playerChoice == compChoice) ? "It's a tie!" :
                ((playerChoice == 0 && compChoice == 2) ||
                        (playerChoice == 1 && compChoice == 0) ||
                        (playerChoice == 2 && compChoice == 1)) ? "You win! 🎉" : "Computer wins! 🤖";

        JOptionPane.showMessageDialog(parent, "You chose: " + options[playerChoice] +
                "\nComputer chose: " + options[compChoice] + "\n\n" + result, "Result", JOptionPane.INFORMATION_MESSAGE);
    }
}