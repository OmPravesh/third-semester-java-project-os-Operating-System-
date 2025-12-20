package games;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import javax.swing.*;

public class DoomBrickEdition extends JFrame implements Runnable {

    private static final int WIDTH = 640;
    private static final int HEIGHT = 480;
    private Thread thread;
    private boolean running;
    private BufferedImage image;
    private int[] pixels;

    private int[] brickTexture;
    private int[] enemyTexture;
    private static final int TEX_WIDTH = 64;
    private static final int TEX_HEIGHT = 64;

    public int mapWidth = 15;
    public int mapHeight = 15;
    public int[] worldMap = {
            1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
            1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
            1,0,1,1,1,0,0,0,0,1,1,1,0,0,1,
            1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
            1,1,1,0,0,0,1,1,0,0,0,1,1,1,1,
            1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
            1,0,1,0,0,0,0,0,0,1,0,0,0,0,1,
            1,0,1,0,0,0,0,0,0,1,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
            1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
            1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    };

    double posX = 7.5, posY = 7.5;
    double dirX = -1, dirY = 0;
    double planeX = 0, planeY = 0.66;
    double moveSpeed = 0.08;

    // --- COMBAT SYSTEM ---
    private int ammo = 50;
    private int health = 100;
    private boolean isShooting = false;
    private int shootTimer = 0;

    class Sprite implements Comparable<Sprite> {
        double x, y;
        double dist;
        boolean alive = true;
        public Sprite(double x, double y) { this.x = x; this.y = y; }
        @Override public int compareTo(Sprite s) { return Double.compare(s.dist, this.dist); }
    }

    ArrayList<Sprite> sprites = new ArrayList<>();
    double[] zBuffer = new double[WIDTH];

    boolean left, right, forward, backward;
    boolean mouseLocked = true;
    Robot robot;

    public DoomBrickEdition() {
        setTitle("DOOM - Brick Edition (Combat Fixed)");
        setSize(WIDTH, HEIGHT);
        setResizable(false);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        pixels = ((DataBufferInt) image.getRaster().getDataBuffer()).getData();

        generateTextures();

        // Populate enemies
        sprites.add(new Sprite(10.5, 10.5));
        sprites.add(new Sprite(4.5, 4.5));
        sprites.add(new Sprite(3.5, 12.5));

        addKeyListener(new KeyHandler());

        // --- MOUSE CLICK TO SHOOT ---
        addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                if (mouseLocked && ammo > 0 && !isShooting) {
                    shoot();
                }
            }
        });

        addMouseMotionListener(new MouseAdapter() {
            public void mouseMoved(MouseEvent e) {
                if(mouseLocked && hasFocus()) {
                    int centerX = getWidth() / 2;
                    int dx = e.getX() - centerX;
                    double rotation = -dx * 0.003;
                    double oldDirX = dirX;
                    dirX = dirX * Math.cos(rotation) - dirY * Math.sin(rotation);
                    dirY = oldDirX * Math.sin(rotation) + dirY * Math.cos(rotation);
                    double oldPlaneX = planeX;
                    planeX = planeX * Math.cos(rotation) - planeY * Math.sin(rotation);
                    planeY = oldPlaneX * Math.sin(rotation) + planeY * Math.cos(rotation);
                    try { robot.mouseMove(getLocationOnScreen().x + centerX, getLocationOnScreen().y + getHeight()/2); } catch(Exception ex) {}
                }
            }
        });

        try { robot = new Robot(); } catch (AWTException e) { e.printStackTrace(); }
        setVisible(true);
        thread = new Thread(this);
        thread.start();
    }

    private void shoot() {
        isShooting = true;
        shootTimer = 5; // Flash gun for 5 frames
        ammo--;

        // Check for hits
        for (Sprite s : sprites) {
            if (!s.alive) continue;

            // Vector to enemy
            double vecX = s.x - posX;
            double vecY = s.y - posY;
            double dist = Math.sqrt(vecX*vecX + vecY*vecY);

            // Normalized direction to enemy
            double normX = vecX / dist;
            double normY = vecY / dist;

            // Dot product to check if looking at enemy (Angle check)
            double dot = dirX * normX + dirY * normY;
            if (dot > 0.98) { // Tight cone for crosshair accuracy
                s.alive = false; // ENEMY DIES
            }
        }
    }

    private void generateTextures() {
        brickTexture = new int[TEX_WIDTH * TEX_HEIGHT];
        enemyTexture = new int[TEX_WIDTH * TEX_HEIGHT];
        for (int y = 0; y < TEX_HEIGHT; y++) {
            for (int x = 0; x < TEX_WIDTH; x++) {
                int col = (x % 32 == 0 || y % 16 == 0) ? 0xFF332211 : 0xFF884422;
                brickTexture[x + y * TEX_WIDTH] = col;

                int ex = x - 32; int ey = y - 32;
                boolean isBody = (Math.abs(ex) < 12 && y > 15);
                boolean isHead = (Math.abs(ex) < 8 && y < 15 && y > 5);
                if (isHead) enemyTexture[x + y * TEX_WIDTH] = 0xFFFFCCAA;
                else if (isBody) enemyTexture[x + y * TEX_WIDTH] = 0xFF550000;
                else enemyTexture[x + y * TEX_WIDTH] = 0x000000;
            }
        }
    }

    public void run() {
        running = true;
        while (running) {
            update();
            render();
            try { Thread.sleep(16); } catch (Exception e) {}
        }
    }

    public void update() {
        if (forward) {
            if(worldMap[(int)(posX + dirX * moveSpeed) + (int)posY * mapWidth] == 0) posX += dirX * moveSpeed;
            if(worldMap[(int)posX + (int)(posY + dirY * moveSpeed) * mapWidth] == 0) posY += dirY * moveSpeed;
        }
        if (backward) {
            if(worldMap[(int)(posX - dirX * moveSpeed) + (int)posY * mapWidth] == 0) posX -= dirX * moveSpeed;
            if(worldMap[(int)posX + (int)(posY - dirY * moveSpeed) * mapWidth] == 0) posY -= dirY * moveSpeed;
        }

        if (shootTimer > 0) shootTimer--;
        else isShooting = false;

        // Remove dead enemies
        sprites.removeIf(s -> !s.alive);
    }

    public void render() {
        BufferStrategy bs = getBufferStrategy();
        if (bs == null) { createBufferStrategy(3); return; }
        Graphics g = bs.getDrawGraphics();

        // Background
        for(int i=0; i<pixels.length/2; i++) pixels[i] = 0xFF151515;
        for(int i=pixels.length/2; i<pixels.length; i++) pixels[i] = 0xFF221100;

        // Walls
        for (int x = 0; x < WIDTH; x++) {
            double cameraX = 2 * x / (double)WIDTH - 1;
            double rayDirX = dirX + planeX * cameraX;
            double rayDirY = dirY + planeY * cameraX;
            int mapX = (int)posX, mapY = (int)posY;
            double deltaDistX = Math.abs(1 / rayDirX), deltaDistY = Math.abs(1 / rayDirY);
            double sideDistX, sideDistY, perpWallDist;
            int stepX, stepY, hit = 0, side = 0;

            if (rayDirX < 0) { stepX = -1; sideDistX = (posX - mapX) * deltaDistX; }
            else { stepX = 1; sideDistX = (mapX + 1.0 - posX) * deltaDistX; }
            if (rayDirY < 0) { stepY = -1; sideDistY = (posY - mapY) * deltaDistY; }
            else { stepY = 1; sideDistY = (mapY + 1.0 - posY) * deltaDistY; }

            while (hit == 0) {
                if (sideDistX < sideDistY) { sideDistX += deltaDistX; mapX += stepX; side = 0; }
                else { sideDistY += deltaDistY; mapY += stepY; side = 1; }
                if (worldMap[mapX + mapY * mapWidth] > 0) hit = 1;
            }
            perpWallDist = (side == 0) ? (mapX - posX + (1 - stepX) / 2) / rayDirX : (mapY - posY + (1 - stepY) / 2) / rayDirY;
            zBuffer[x] = perpWallDist;

            int lineHeight = (int)(HEIGHT / perpWallDist);
            int drawStart = Math.max(0, -lineHeight / 2 + HEIGHT / 2);
            int drawEnd = Math.min(HEIGHT - 1, lineHeight / 2 + HEIGHT / 2);

            double wallX = (side == 0) ? posY + perpWallDist * rayDirY : posX + perpWallDist * rayDirX;
            wallX -= Math.floor(wallX);
            int texX = (int)(wallX * TEX_WIDTH);

            for (int y = drawStart; y < drawEnd; y++) {
                int d = y * 256 - HEIGHT * 128 + lineHeight * 128;
                int texY = ((d * TEX_HEIGHT) / lineHeight) / 256;
                int color = brickTexture[Math.max(0, Math.min(TEX_WIDTH-1, texX)) + Math.max(0, Math.min(TEX_HEIGHT-1, texY)) * TEX_WIDTH];
                if(side == 1) color = (color >> 1) & 0x7F7F7F;
                pixels[x + y * WIDTH] = color;
            }
        }

        // Render Active Enemies
        Collections.sort(sprites);
        for(Sprite s : sprites) {
            double spriteX = s.x - posX, spriteY = s.y - posY;
            double invDet = 1.0 / (planeX * dirY - dirX * planeY);
            double trX = invDet * (dirY * spriteX - dirX * spriteY);
            double trY = invDet * (-planeY * spriteX + planeX * spriteY);
            if (trY <= 0) continue;

            int sScrX = (int)((WIDTH / 2) * (1 + trX / trY));
            int sHeight = Math.abs((int)(HEIGHT / trY)), sWidth = Math.abs((int)(HEIGHT / trY));
            int dSY = Math.max(0, -sHeight / 2 + HEIGHT / 2), dEY = Math.min(HEIGHT-1, sHeight / 2 + HEIGHT / 2);
            int dSX = Math.max(0, -sWidth / 2 + sScrX), dEX = Math.min(WIDTH-1, sWidth / 2 + sScrX);

            for(int stripe = dSX; stripe < dEX; stripe++) {
                int tX = (int)(256 * (stripe - (-sWidth / 2 + sScrX)) * TEX_WIDTH / sWidth) / 256;
                if(trY < zBuffer[stripe]) {
                    for(int y = dSY; y < dEY; y++) {
                        int d = y * 256 - HEIGHT * 128 + sHeight * 128;
                        int tY = ((d * TEX_HEIGHT) / sHeight) / 256;
                        int color = enemyTexture[tX + tY * TEX_WIDTH];
                        if((color & 0x00FFFFFF) != 0) pixels[stripe + y * WIDTH] = color;
                    }
                }
            }
        }

        g.drawImage(image, 0, 0, WIDTH, HEIGHT, null);

        // HUD Overlay
        g.setColor(isShooting ? Color.ORANGE : new Color(60, 60, 60));
        g.fillRect(WIDTH/2 - 25, HEIGHT - 140, 50, 140); // Gun

        g.setColor(Color.WHITE);
        g.setFont(new Font("Monospaced", Font.BOLD, 24));
        g.drawString("HP: " + health, 20, HEIGHT - 60);
        g.drawString("AMMO: " + ammo, 20, HEIGHT - 30);

        // Crosshair
        g.setColor(Color.RED);
        g.drawOval(WIDTH/2 - 5, HEIGHT/2 - 5, 10, 10);

        g.dispose();
        bs.show();
    }

    private class KeyHandler extends KeyAdapter {
        public void keyPressed(KeyEvent e) {
            if (e.getKeyCode() == KeyEvent.VK_W) forward = true;
            if (e.getKeyCode() == KeyEvent.VK_S) backward = true;
            if (e.getKeyCode() == KeyEvent.VK_ESCAPE) mouseLocked = !mouseLocked;
        }
        public void keyReleased(KeyEvent e) {
            if (e.getKeyCode() == KeyEvent.VK_W) forward = false;
            if (e.getKeyCode() == KeyEvent.VK_S) backward = false;
        }
    }
}