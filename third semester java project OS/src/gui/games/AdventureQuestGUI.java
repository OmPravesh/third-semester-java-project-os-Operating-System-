package gui.games;

import util.ThemeManager;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class AdventureQuestGUI extends JFrame {
    private final JTextPane storyPane;
    private final JPanel choicePanel;
    private final JLabel healthLabel, goldLabel, itemsLabel;
    private int playerHealth;
    private int playerGold;
    private boolean hasSword;
    private boolean hasKey;

    public AdventureQuestGUI() {
        setTitle("Adventure Quest: The Cursed Castle");
        setSize(800, 600);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout());
        JPanel statusPanel = new JPanel(new GridLayout(1, 3, 10, 10));
        statusPanel.setBorder(new EmptyBorder(15, 20, 15, 20));
        statusPanel.setBackground(new Color(240, 240, 240));
        healthLabel = createStatusLabel("❤️ Health", Color.RED);
        goldLabel = createStatusLabel("💰 Gold", new Color(200, 150, 0));
        itemsLabel = createStatusLabel("🎒 Items", Color.BLUE);
        statusPanel.add(healthLabel);
        statusPanel.add(goldLabel);
        statusPanel.add(itemsLabel);
        storyPane = new JTextPane();
        storyPane.setEditable(false);
        storyPane.setContentType("text/html");
        storyPane.setBorder(new EmptyBorder(20, 20, 20, 20));
        choicePanel = new JPanel(new GridLayout(0, 1, 10, 10));
        choicePanel.setBorder(new EmptyBorder(20, 50, 20, 50));
        choicePanel.setBackground(Color.WHITE);
        add(statusPanel, BorderLayout.NORTH);
        add(new JScrollPane(storyPane), BorderLayout.CENTER);
        add(choicePanel, BorderLayout.SOUTH);
        startGame();
        ThemeManager.applyThemeToAll();
        setVisible(true);
    }

    private JLabel createStatusLabel(String title, Color color) {
        JLabel lbl = new JLabel(title);
        lbl.setFont(new Font("Segoe UI", Font.BOLD, 16));
        lbl.setForeground(color);
        return lbl;
    }

    private void updateStatus() {
        healthLabel.setText("❤️ Health: " + playerHealth);
        goldLabel.setText("💰 Gold: " + playerGold);
        String items = (hasSword ? "⚔️ Sword " : "") + (hasKey ? "🗝️ Key" : "");
        itemsLabel.setText("🎒 Items: " + (items.isEmpty() ? "None" : items.trim()));
        if (playerHealth <= 0) {
            javax.swing.Timer t = new javax.swing.Timer(500, e -> showScene("gameOver"));
            t.setRepeats(false);
            t.start();
        }
    }

    private void setStoryText(String text) {
        String html = "<html><body style='font-family: Segoe UI, sans-serif; font-size: 14px; padding: 10px;'>"
                + text + "</body></html>";
        storyPane.setText(html);
        storyPane.setCaretPosition(0);
    }

    private void startGame() {
        playerHealth = 100;
        playerGold = 10;
        hasSword = false;
        hasKey = false;
        updateStatus();
        showScene("start");
    }

    private void showScene(String sceneId) {
        choicePanel.removeAll();
        switch (sceneId) {
            case "start":
                setStoryText("<h2>The Crossroads</h2>You stand at a crossroads. A path leads to a dense <b>Forest</b>, another to a bustling <b>Village</b>.<br><br><i>Where does your destiny lie?</i>");
                addChoice("Enter the Forest 🌲", "forest");
                addChoice("Go to the Village 🏘️", "village");
                break;
            case "forest":
                setStoryText("<h2>The Forest</h2>The forest is dark and eerie. You see a glimmer in the mud.<br>It is a <span style='color:orange'>Rusty Key</span>!<br><br>Suddenly, you hear a menacing growl.");
                if (!hasKey) {
                    hasKey = true;
                    updateStatus();
                }
                addChoice("Go deeper into the forest 👣", "deepForest");
                addChoice("Return to crossroads ↩️", "start");
                break;
            case "deepForest":
                setStoryText("<h2>Ambush!</h2>A ferocious <b>Wolf</b> leaps from the bushes! Without a weapon, you struggle to defend yourself.<br><br><span style='color:red'>You lose 30 Health.</span>");
                playerHealth -= 30;
                updateStatus();
                if (playerHealth > 0) addChoice("Flee to the village 🏃", "village");
                break;
            case "village":
                setStoryText("<h2>Oakhaven Village</h2>The village is lively. A <b>Blacksmith</b> is hammering steel, and people are whispering about the old Castle.");
                if (playerGold >= 10 && !hasSword) {
                    addChoice("Buy Sword (10 Gold) ⚔️", "buySword");
                }
                addChoice("Talk to Villagers 🗣️", "talkVillagers");
                addChoice("Go to Castle Gate 🏰", "castleGate");
                addChoice("Return to crossroads ↩️", "start");
                break;
            case "buySword":
                playerGold -= 10;
                hasSword = true;
                updateStatus();
                setStoryText("<h2>Blacksmith</h2>You bought a <b>Steel Sword</b>! It feels heavy and sharp.<br>'Good luck,' the blacksmith grunts.");
                addChoice("Back to Village square", "village");
                break;
            case "talkVillagers":
                setStoryText("<h2>Rumors</h2>'A Dragon sleeps in the castle,' a woman whispers. 'It guards the <b style='color:gold'>Sunstone</b>.'");
                addChoice("Back", "village");
                break;
            case "castleGate":
                setStoryText("<h2>The Castle</h2>The iron gate is locked tight. It looks centuries old.");
                if (hasKey) addChoice("Use Rusty Key 🗝️", "castleInside");
                addChoice("Return to Village", "village");
                break;
            case "castleInside":
                setStoryText("<h2>The Grand Hall</h2>The gate creaks open. Inside, a massive <b style='color:red'>Red Dragon</b> sleeps atop a pile of gold.<br>The Sunstone is right there!");
                addChoice("ATTACK! ⚔️", "fightDragon");
                addChoice("Sneak... 🤫", "sneak");
                break;
            case "fightDragon":
                if (hasSword) {
                    setStoryText("<h2>Victory!</h2>You charge! The dragon wakes and breathes fire, but you dodge and strike!<br>With a mighty blow, the beast falls.<br><br><b style='color:green'>You found 100 Gold!</b>");
                    playerGold += 100;
                    showScene("victory");
                } else {
                    setStoryText("<h2>Defeat</h2>You attack with bare hands? The dragon wakes up and simply eats you.<br><br><b>GAME OVER</b>");
                    playerHealth = 0;
                    updateStatus();
                }
                break;
            case "sneak":
                setStoryText("<h2>Too Loud!</h2>You step on a coin. <i>CLINK!</i><br>The Dragon wakes up and smashes you with its tail.<br><span style='color:red'>-50 Health</span>");
                playerHealth -= 50;
                updateStatus();
                if (playerHealth > 0) addChoice("Fight for your life!", "fightDragon");
                break;
            case "victory":
                updateStatus();
                setStoryText("<h1 style='color:green'>You Win!</h1>You have the Sunstone and the glory. The village is saved!");
                addChoice("Play Again", "start");
                addChoice("Exit", "exit");
                break;
            case "gameOver":
                setStoryText("<h1 style='color:red'>Game Over</h1>Your journey ends here.");
                addChoice("Try Again", "start");
                addChoice("Exit", "exit");
                break;
        }
        choicePanel.revalidate();
        choicePanel.repaint();
    }

    private void addChoice(String text, String sceneId) {
        JButton button = new JButton(text);
        button.setFont(new Font("Segoe UI", Font.PLAIN, 14));
        button.setFocusPainted(false);
        button.setBackground(new Color(230, 240, 255));
        button.addActionListener(e -> {
            if ("start".equals(sceneId)) startGame();
            else if ("exit".equals(sceneId)) dispose();
            else showScene(sceneId);
        });
        choicePanel.add(button);
    }
}