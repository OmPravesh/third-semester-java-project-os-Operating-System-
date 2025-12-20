package gui.games;

import javax.swing.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class DoomGameFrame extends JFrame {
    private DoomGamePanel gamePanel;

    public DoomGameFrame() {
        setTitle("DOOM - Java Raycaster Edition");
        setResizable(false);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        // Initialize the engine
        gamePanel = new DoomGamePanel();
        add(gamePanel);
        pack(); // Adjusts frame size to fit the panel (640x480)
        setLocationRelativeTo(null); // Center on screen

        // IMPORTANT: Add listener to stop thread when closing
        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                gamePanel.stop();
            }
        });

        setVisible(true);

        // CRITICAL FIX: Request focus AFTER the window is visible
        // This ensures the KeyListener works immediately.
        gamePanel.start();
        gamePanel.requestFocusInWindow();
    }
}