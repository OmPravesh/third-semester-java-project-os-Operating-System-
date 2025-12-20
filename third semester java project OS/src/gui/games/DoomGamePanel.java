package gui.games;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class DoomGamePanel extends JPanel implements Runnable, KeyListener, MouseListener {

    // --- Constants ---
    private static final int WIDTH = 640;
    private static final int HEIGHT = 480;

    // --- Graphics & Threading ---
    private Thread thread;
    private boolean running;
    private BufferedImage image;
    private int[] pixels;
    private double[] zBuffer; // Required for proper sprite/wall sorting

    // --- Game Objects ---
    private Camera camera;
    private List<Enemy> enemies;
    private boolean isShooting = false;
    private int gunAnimFrame = 0; // 0 = idle, 1-5 = shooting

    // --- Map (1=Red, 2=Green, 3=Blue, 0=Empty) ---
    public static final int MAP_SIZE = 24;
    public static final int[][] worldMap = {
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
            {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
            {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1},
            {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1},
            {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
            {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    };

    // --- Inputs ---
    private boolean keyUp, keyDown, keyLeft, keyRight;

    public DoomGamePanel() {
        setPreferredSize(new Dimension(WIDTH, HEIGHT));
        setBackground(Color.BLACK);
        addKeyListener(this);
        addMouseListener(this);
        setFocusable(true);

        image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        pixels = ((DataBufferInt) image.getRaster().getDataBuffer()).getData();
        zBuffer = new double[WIDTH]; // Distance to wall for every vertical column

        camera = new Camera(3.5, 3.5, -1, 0, 0, 0.66);
        enemies = new ArrayList<>();

        // Spawn some enemies
        enemies.add(new Enemy(10.5, 10.5, 0xFF0000)); // Red Enemy
        enemies.add(new Enemy(7.5, 7.5, 0x00FF00));   // Green Enemy
        enemies.add(new Enemy(5.5, 5.5, 0x0000FF));   // Blue Enemy
    }

    public synchronized void start() {
        if (running) return;
        running = true;
        thread = new Thread(this);
        thread.start();
    }

    public synchronized void stop() {
        running = false;
        try { if(thread!=null) thread.join(); } catch (Exception e) { e.printStackTrace(); }
    }

    @Override
    public void run() {
        long lastTime = System.nanoTime();
        double ns = 1000000000.0 / 60.0;
        double delta = 0;

        while (running) {
            long now = System.nanoTime();
            delta += (now - lastTime) / ns;
            lastTime = now;

            while (delta >= 1) {
                update(); // Physics/Movement
                delta--;
            }
            render(); // Graphics

            // Draw directly to the component to avoid Swing buffering issues
            Graphics g = getGraphics();
            if(g != null) {
                g.drawImage(image, 0, 0, getWidth(), getHeight(), null);
                drawHUD(g);
                g.dispose();
            }
        }
    }

    private void update() {
        // 1. Movement Logic
        double moveSpeed = 0.05;
        double rotSpeed = 0.04;

        if (keyUp) {
            if(worldMap[(int)(camera.x + camera.dirX * moveSpeed)][(int)camera.y] == 0) camera.x += camera.dirX * moveSpeed;
            if(worldMap[(int)camera.x][(int)(camera.y + camera.dirY * moveSpeed)] == 0) camera.y += camera.dirY * moveSpeed;
        }
        if (keyDown) {
            if(worldMap[(int)(camera.x - camera.dirX * moveSpeed)][(int)camera.y] == 0) camera.x -= camera.dirX * moveSpeed;
            if(worldMap[(int)camera.x][(int)(camera.y - camera.dirY * moveSpeed)] == 0) camera.y -= camera.dirY * moveSpeed;
        }
        if (keyRight) {
            double oldDirX = camera.dirX;
            camera.dirX = camera.dirX * Math.cos(-rotSpeed) - camera.dirY * Math.sin(-rotSpeed);
            camera.dirY = oldDirX * Math.sin(-rotSpeed) + camera.dirY * Math.cos(-rotSpeed);
            double oldPlaneX = camera.planeX;
            camera.planeX = camera.planeX * Math.cos(-rotSpeed) - camera.planeY * Math.sin(-rotSpeed);
            camera.planeY = oldPlaneX * Math.sin(-rotSpeed) + camera.planeY * Math.cos(-rotSpeed);
        }
        if (keyLeft) {
            double oldDirX = camera.dirX;
            camera.dirX = camera.dirX * Math.cos(rotSpeed) - camera.dirY * Math.sin(rotSpeed);
            camera.dirY = oldDirX * Math.sin(rotSpeed) + camera.dirY * Math.cos(rotSpeed);
            double oldPlaneX = camera.planeX;
            camera.planeX = camera.planeX * Math.cos(rotSpeed) - camera.planeY * Math.sin(rotSpeed);
            camera.planeY = oldPlaneX * Math.sin(rotSpeed) + camera.planeY * Math.cos(rotSpeed);
        }

        // 2. Gun Animation Logic
        if (isShooting) {
            gunAnimFrame++;
            if (gunAnimFrame > 10) { // Animation duration
                gunAnimFrame = 0;
                isShooting = false;
            }
        }

        // 3. Enemy Cleanup
        enemies.removeIf(e -> e.health <= 0);
    }

    private void render() {
        // --- 1. Clear Screen (Ceiling & Floor) ---
        for(int i = 0; i < pixels.length / 2; i++) pixels[i] = 0x333333; // Dark Grey
        for(int i = pixels.length / 2; i < pixels.length; i++) pixels[i] = 0x554433; // Brown

        // --- 2. Wall Casting ---
        for (int x = 0; x < WIDTH; x++) {
            double cameraX = 2 * x / (double) WIDTH - 1;
            double rayDirX = camera.dirX + camera.planeX * cameraX;
            double rayDirY = camera.dirY + camera.planeY * cameraX;

            int mapX = (int) camera.x;
            int mapY = (int) camera.y;

            double sideDistX, sideDistY;
            double deltaDistX = (rayDirX == 0) ? 1e30 : Math.abs(1 / rayDirX);
            double deltaDistY = (rayDirY == 0) ? 1e30 : Math.abs(1 / rayDirY);
            double perpWallDist;

            int stepX, stepY;
            int hit = 0, side = 0;

            if (rayDirX < 0) { stepX = -1; sideDistX = (camera.x - mapX) * deltaDistX; }
            else { stepX = 1; sideDistX = (mapX + 1.0 - camera.x) * deltaDistX; }
            if (rayDirY < 0) { stepY = -1; sideDistY = (camera.y - mapY) * deltaDistY; }
            else { stepY = 1; sideDistY = (mapY + 1.0 - camera.y) * deltaDistY; }

            while (hit == 0) {
                if (sideDistX < sideDistY) { sideDistX += deltaDistX; mapX += stepX; side = 0; }
                else { sideDistY += deltaDistY; mapY += stepY; side = 1; }
                if (mapX >= 0 && mapX < MAP_SIZE && mapY >= 0 && mapY < MAP_SIZE && worldMap[mapX][mapY] > 0) hit = 1;
            }

            if (side == 0) perpWallDist = (sideDistX - deltaDistX);
            else           perpWallDist = (sideDistY - deltaDistY);

            // STORE ZBUFFER FOR SPRITES
            zBuffer[x] = perpWallDist;

            int lineHeight = (int) (HEIGHT / perpWallDist);
            int drawStart = -lineHeight / 2 + HEIGHT / 2;
            if (drawStart < 0) drawStart = 0;
            int drawEnd = lineHeight / 2 + HEIGHT / 2;
            if (drawEnd >= HEIGHT) drawEnd = HEIGHT - 1;

            int color = 0x888888;
            if (mapX >= 0 && mapX < MAP_SIZE && mapY >= 0 && mapY < MAP_SIZE) {
                switch(worldMap[mapX][mapY]) {
                    case 1: color = 0xFF0000; break;
                    case 2: color = 0x00FF00; break;
                    case 3: color = 0x0000FF; break;
                    case 4: color = 0xFFFFFF; break;
                }
            }
            if (side == 1) color = (color >> 1) & 8355711; // Darken sides

            for(int y = drawStart; y < drawEnd; y++) {
                pixels[x + y * WIDTH] = color;
            }
        }

        // --- 3. Sprite Casting (Enemies) ---
        // Sort enemies by distance (far ones first)
        for (Enemy e : enemies) {
            e.dist = ((camera.x - e.x) * (camera.x - e.x) + (camera.y - e.y) * (camera.y - e.y));
        }
        Collections.sort(enemies); // Uses compareTo based on dist

        for (Enemy e : enemies) {
            double spriteX = e.x - camera.x;
            double spriteY = e.y - camera.y;

            // Transform sprite with the inverse camera matrix
            double invDet = 1.0 / (camera.planeX * camera.dirY - camera.dirX * camera.planeY);
            double transformX = invDet * (camera.dirY * spriteX - camera.dirX * spriteY);
            double transformY = invDet * (-camera.planeY * spriteX + camera.planeX * spriteY);

            int spriteScreenX = (int)((WIDTH / 2) * (1 + transformX / transformY));

            // Calculate height of the sprite on screen
            int spriteHeight = Math.abs((int)(HEIGHT / (transformY)));
            int drawStartY = -spriteHeight / 2 + HEIGHT / 2;
            if (drawStartY < 0) drawStartY = 0;
            int drawEndY = spriteHeight / 2 + HEIGHT / 2;
            if (drawEndY >= HEIGHT) drawEndY = HEIGHT - 1;

            // Calculate width of the sprite
            int spriteWidth = Math.abs((int)(HEIGHT / (transformY)));
            int drawStartX = -spriteWidth / 2 + spriteScreenX;
            if (drawStartX < 0) drawStartX = 0;
            int drawEndX = spriteWidth / 2 + spriteScreenX;
            if (drawEndX >= WIDTH) drawEndX = WIDTH - 1;

            // Draw Sprite
            for (int stripe = drawStartX; stripe < drawEndX; stripe++) {
                int texX = (int)(256 * (stripe - (-spriteWidth / 2 + spriteScreenX)) * 64 / spriteWidth) / 256;
                // Condition: in front of camera, on screen, and closer than the wall
                if (transformY > 0 && stripe > 0 && stripe < WIDTH && transformY < zBuffer[stripe]) {
                    for (int y = drawStartY; y < drawEndY; y++) {
                        // Simple solid color for sprite
                        pixels[stripe + y * WIDTH] = e.color;
                    }
                }
            }
        }
    }

    // Separate method to draw HUD (Gun, Text, Crosshair)
    private void drawHUD(Graphics g) {
        // --- HUD & Weapon ---
        int cx = getWidth() / 2;
        int h = getHeight();

        // Crosshair
        g.setColor(Color.GREEN);
        g.drawLine(cx - 10, h/2, cx + 10, h/2);
        g.drawLine(cx, h/2 - 10, cx, h/2 + 10);

        // Gun Logic
        Color gunColor = Color.GRAY;
        int gunOffset = 0;
        int muzzleFlashSize = 0;

        if (isShooting) {
            gunColor = Color.DARK_GRAY; // Recoil color
            gunOffset = 20; // Kickback
            muzzleFlashSize = 50 + (int)(Math.random() * 20);
        }

        // Draw Muzzle Flash
        if (isShooting && gunAnimFrame < 5) {
            g.setColor(new Color(255, 200, 50, 200));
            g.fillOval(cx - muzzleFlashSize/2, h - 180 - muzzleFlashSize/2, muzzleFlashSize, muzzleFlashSize);
            g.setColor(Color.WHITE);
            g.fillOval(cx - muzzleFlashSize/4, h - 180 - muzzleFlashSize/4, muzzleFlashSize/2, muzzleFlashSize/2);
        }

        // Draw Gun Barrel
        g.setColor(gunColor);
        g.fillRect(cx - 20, h - 140 + gunOffset, 40, 140);
        g.setColor(Color.LIGHT_GRAY);
        g.fillRect(cx - 5, h - 140 + gunOffset, 10, 140);

        // Stats
        g.setColor(Color.RED);
        g.setFont(new Font("Impact", Font.BOLD, 24));
        g.drawString("HEALTH: 100%", 20, h - 20);
        g.drawString("AMMO: ∞", getWidth() - 120, h - 20);
        g.drawString("ENEMIES LEFT: " + enemies.size(), 20, 40);

        if (!running) {
            g.setColor(new Color(0,0,0,200));
            g.fillRect(0,0,getWidth(),getHeight());
            g.setColor(Color.WHITE);
            g.drawString("CLICK TO START", cx - 60, h/2);
        }
    }

    // --- Shooting Logic ---
    private void shoot() {
        if (isShooting) return; // Fire rate limit
        isShooting = true;
        gunAnimFrame = 0;

        // Simple Hitscan: Check if enemy is in center of screen and visible
        for (Enemy e : enemies) {
            double spriteX = e.x - camera.x;
            double spriteY = e.y - camera.y;

            double invDet = 1.0 / (camera.planeX * camera.dirY - camera.dirX * camera.planeY);
            double transformX = invDet * (camera.dirY * spriteX - camera.dirX * spriteY);
            double transformY = invDet * (-camera.planeY * spriteX + camera.planeX * spriteY);

            if (transformY > 0) {
                int spriteScreenX = (int)((WIDTH / 2) * (1 + transformX / transformY));
                int spriteWidth = Math.abs((int)(HEIGHT / (transformY)));

                // If center of screen (WIDTH/2) is within the sprite's width
                if (WIDTH/2 >= spriteScreenX - spriteWidth/2 && WIDTH/2 <= spriteScreenX + spriteWidth/2) {
                    // And checking if wall is blocking (using zBuffer at center)
                    if (transformY < zBuffer[WIDTH/2]) {
                        e.health -= 50; // Hit!
                    }
                }
            }
        }
    }

    // --- Swing Paint Method (Fallback) ---
    // We override this to ensure the component is valid, but the loop handles drawing
    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        // Only draw static "Click to Start" if thread isn't running
        if(!running) {
            g.setColor(Color.BLACK);
            g.fillRect(0,0,getWidth(), getHeight());
            g.setColor(Color.WHITE);
            g.drawString("CLICK TO START GAME", getWidth()/2 - 50, getHeight()/2);
        }
    }

    // --- Inputs ---
    @Override
    public void keyPressed(KeyEvent e) {
        int k = e.getKeyCode();
        if(k==KeyEvent.VK_W || k==KeyEvent.VK_UP) keyUp=true;
        if(k==KeyEvent.VK_S || k==KeyEvent.VK_DOWN) keyDown=true;
        if(k==KeyEvent.VK_A || k==KeyEvent.VK_LEFT) keyLeft=true;
        if(k==KeyEvent.VK_D || k==KeyEvent.VK_RIGHT) keyRight=true;
        if(k==KeyEvent.VK_SPACE) shoot();
    }

    @Override public void keyReleased(KeyEvent e) {
        int k = e.getKeyCode();
        if(k==KeyEvent.VK_W || k==KeyEvent.VK_UP) keyUp=false;
        if(k==KeyEvent.VK_S || k==KeyEvent.VK_DOWN) keyDown=false;
        if(k==KeyEvent.VK_A || k==KeyEvent.VK_LEFT) keyLeft=false;
        if(k==KeyEvent.VK_D || k==KeyEvent.VK_RIGHT) keyRight=false;
    }
    @Override public void keyTyped(KeyEvent e) {}
    @Override public void mousePressed(MouseEvent e) { requestFocusInWindow(); shoot(); }
    @Override public void mouseClicked(MouseEvent e) {}
    @Override public void mouseReleased(MouseEvent e) {}
    @Override public void mouseEntered(MouseEvent e) {}
    @Override public void mouseExited(MouseEvent e) {}

    // --- Helpers ---
    private static class Camera {
        double x, y, dirX, dirY, planeX, planeY;
        public Camera(double x, double y, double dirX, double dirY, double planeX, double planeY) {
            this.x=x; this.y=y; this.dirX=dirX; this.dirY=dirY; this.planeX=planeX; this.planeY=planeY;
        }
    }

    private static class Enemy implements Comparable<Enemy> {
        double x, y, dist;
        int color, health;
        public Enemy(double x, double y, int color) {
            this.x = x; this.y = y; this.color = color;
            this.health = 100;
        }
        @Override
        public int compareTo(Enemy o) {
            return Double.compare(o.dist, this.dist); // Sort descending (far to near)
        }
    }
}