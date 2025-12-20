package gui.games;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.util.Random;

public class GamePanel extends JPanel implements ActionListener {
    static final int SCREEN_WIDTH = 600;
    static final int SCREEN_HEIGHT = 600;
    static final int UNIT_SIZE = 25;
    static final int GAME_UNITS = (SCREEN_WIDTH * SCREEN_HEIGHT) / UNIT_SIZE;
    static final int DELAY = 80;
    final int[] x = new int[GAME_UNITS];
    final int[] y = new int[GAME_UNITS];
    int bodyParts = 6;
    int applesEaten;
    int appleX;
    int appleY;
    char direction = 'R';
    boolean running = false;
    boolean paused = false;
    javax.swing.Timer timer;
    Random random;

    public GamePanel() {
        random = new Random();
        this.setPreferredSize(new Dimension(SCREEN_WIDTH, SCREEN_HEIGHT));
        // Game panel uses specific color, not theme color
        this.setBackground(new Color(20, 20, 20));
        this.setFocusable(true);
        this.addKeyListener(new MyKeyAdapter());
        startGame();
    }

    public void startGame() {
        bodyParts = 6;
        applesEaten = 0;
        direction = 'R';
        for (int i = 0; i < bodyParts; i++) {
            x[i] = 100 - (i * UNIT_SIZE);
            y[i] = 100;
        }
        newApple();
        running = true;
        paused = false;
        if (timer == null) {
            timer = new javax.swing.Timer(DELAY, this);
            timer.start();
        } else {
            timer.restart();
        }
        repaint();
    }

    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        draw(g);
    }

    public void draw(Graphics g) {
        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        if (running) {
            g2d.setColor(new Color(30, 30, 30));
            for (int i = 0; i < SCREEN_HEIGHT / UNIT_SIZE; i++) {
                g2d.drawLine(i * UNIT_SIZE, 0, i * UNIT_SIZE, SCREEN_HEIGHT);
                g2d.drawLine(0, i * UNIT_SIZE, SCREEN_WIDTH, i * UNIT_SIZE);
            }
            GradientPaint appleGradient = new GradientPaint(appleX, appleY, Color.RED,
                    appleX + UNIT_SIZE, appleY + UNIT_SIZE, new Color(150, 0, 0));
            g2d.setPaint(appleGradient);
            g2d.fillOval(appleX + 2, appleY + 2, UNIT_SIZE - 4, UNIT_SIZE - 4);
            g2d.setColor(new Color(0, 200, 0));
            g2d.fillOval(appleX + 8, appleY - 2, 8, 8);
            for (int i = 0; i < bodyParts; i++) {
                if (i == 0) {
                    g2d.setColor(new Color(0, 255, 100));
                    g2d.fillRoundRect(x[i], y[i], UNIT_SIZE, UNIT_SIZE, 10, 10);
                    g2d.setColor(Color.BLACK);
                    int eyeSize = 4;
                    if(direction == 'R') {
                        g2d.fillOval(x[i] + 15, y[i] + 5, eyeSize, eyeSize);
                        g2d.fillOval(x[i] + 15, y[i] + 15, eyeSize, eyeSize);
                    } else if (direction == 'L') {
                        g2d.fillOval(x[i] + 5, y[i] + 5, eyeSize, eyeSize);
                        g2d.fillOval(x[i] + 5, y[i] + 15, eyeSize, eyeSize);
                    } else if (direction == 'U') {
                        g2d.fillOval(x[i] + 5, y[i] + 5, eyeSize, eyeSize);
                        g2d.fillOval(x[i] + 15, y[i] + 5, eyeSize, eyeSize);
                    } else {
                        g2d.fillOval(x[i] + 5, y[i] + 15, eyeSize, eyeSize);
                        g2d.fillOval(x[i] + 15, y[i] + 15, eyeSize, eyeSize);
                    }
                } else {
                    g2d.setColor(new Color(45, 180, 0));
                    g2d.fillRoundRect(x[i], y[i], UNIT_SIZE, UNIT_SIZE, 8, 8);
                }
            }
            g2d.setColor(Color.WHITE);
            g2d.setFont(new Font("Segoe UI", Font.BOLD, 20));
            g2d.drawString("Score: " + applesEaten, 20, 30);
            g2d.setFont(new Font("Segoe UI", Font.PLAIN, 14));
            g2d.setColor(Color.GRAY);
            g2d.drawString("[P] Pause", SCREEN_WIDTH - 80, 30);
            if (paused) {
                drawCenteredString(g2d, "PAUSED", SCREEN_WIDTH, SCREEN_HEIGHT,
                        new Font("Segoe UI", Font.BOLD, 60), Color.YELLOW);
            }
        } else {
            gameOver(g);
        }
    }

    private void drawCenteredString(Graphics2D g, String text, int width, int height, Font font, Color color) {
        g.setFont(font);
        g.setColor(color);
        FontMetrics metrics = g.getFontMetrics(font);
        int x = (width - metrics.stringWidth(text)) / 2;
        int y = ((height - metrics.getHeight()) / 2) + metrics.getAscent();
        g.drawString(text, x, y);
    }

    public void newApple() {
        appleX = random.nextInt(SCREEN_WIDTH / UNIT_SIZE) * UNIT_SIZE;
        appleY = random.nextInt(SCREEN_HEIGHT / UNIT_SIZE) * UNIT_SIZE;
    }

    public void move() {
        for (int i = bodyParts; i > 0; i--) {
            x[i] = x[i - 1];
            y[i] = y[i - 1];
        }
        switch (direction) {
            case 'U': y[0] -= UNIT_SIZE; break;
            case 'D': y[0] += UNIT_SIZE; break;
            case 'L': x[0] -= UNIT_SIZE; break;
            case 'R': x[0] += UNIT_SIZE; break;
        }
    }

    public void checkApple() {
        if (x[0] == appleX && y[0] == appleY) {
            bodyParts++;
            applesEaten++;
            newApple();
        }
    }

    public void checkCollisions() {
        for (int i = bodyParts; i > 0; i--) {
            if (x[0] == x[i] && y[0] == y[i]) {
                running = false;
                break;
            }
        }
        if (x[0] < 0 || x[0] >= SCREEN_WIDTH || y[0] < 0 || y[0] >= SCREEN_HEIGHT) {
            running = false;
        }
        if (!running) {
            timer.stop();
        }
    }

    public void gameOver(Graphics g) {
        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setColor(new Color(0,0,0, 200));
        g2d.fillRect(0,0,SCREEN_WIDTH, SCREEN_HEIGHT);
        g2d.setColor(Color.RED);
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 40));
        FontMetrics metrics1 = getFontMetrics(g.getFont());
        g2d.drawString("Score: " + applesEaten, (SCREEN_WIDTH - metrics1.stringWidth("Score: " + applesEaten)) / 2, g.getFont().getSize());
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 75));
        FontMetrics metrics2 = getFontMetrics(g.getFont());
        g2d.drawString("Game Over", (SCREEN_WIDTH - metrics2.stringWidth("Game Over")) / 2, SCREEN_HEIGHT / 2);
        g2d.setColor(Color.WHITE);
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 20));
        FontMetrics metrics3 = getFontMetrics(g.getFont());
        g2d.drawString("Press 'R' to Restart", (SCREEN_WIDTH - metrics3.stringWidth("Press 'R' to Restart")) / 2, SCREEN_HEIGHT / 2 + 60);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (running && !paused) {
            move();
            checkApple();
            checkCollisions();
        }
        repaint();
    }

    public class MyKeyAdapter extends KeyAdapter {
        @Override
        public void keyPressed(KeyEvent e) {
            int key = e.getKeyCode();
            if (running && !paused) {
                if (key == KeyEvent.VK_LEFT && direction != 'R') direction = 'L';
                else if (key == KeyEvent.VK_RIGHT && direction != 'L') direction = 'R';
                else if (key == KeyEvent.VK_UP && direction != 'D') direction = 'U';
                else if (key == KeyEvent.VK_DOWN && direction != 'U') direction = 'D';
            }
            if (key == KeyEvent.VK_P && running) {
                paused = !paused;
            }
            if (!running && key == KeyEvent.VK_R) {
                startGame();
            }
            if (key == KeyEvent.VK_ESCAPE) {
                Window win = SwingUtilities.getWindowAncestor(GamePanel.this);
                if(win != null) win.dispose();
            }
        }
    }
}