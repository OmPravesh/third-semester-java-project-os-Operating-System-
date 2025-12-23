<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Doom 3D - Web Edition</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .game-window { width: 640px; height: 480px; background: #000; margin: 0 auto; position: relative; }
        #canvas { width: 100%; height: 100%; image-rendering: pixelated; }
        .hud { position: absolute; bottom: 0; width: 100%; color: var(--google-red); font-family: monospace; font-size: 24px; padding: 10px; box-sizing: border-box; display: flex; justify-content: space-between; text-shadow: 2px 2px 0 #000; }
    </style>
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp" />
    
    <div class="container text-center">
        <h2>DOOM: Brick Edition</h2>
        <p class="text-secondary">Use WASD to move, Left/Right Arrows to turn. Space to shoot.</p>
        
        <div class="game-window">
            <canvas id="canvas" width="320" height="240"></canvas>
            <div class="hud">
                <span>HEALTH: <span id="health">100</span>%</span>
                <span>AMMO: <span id="ammo">50</span></span>
            </div>
        </div>
        <button class="btn btn-primary mt-2" onclick="initGame()">Restart Game</button>
    </div>

<script>
    // Raycasting Engine Ported to JS
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    const width = 320, height = 240;
    
    // Map: 1=Wall, 0=Empty
    const mapWidth = 16, mapHeight = 16;
    const map = [
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
        1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
        1,0,0,0,1,1,0,1,1,0,0,0,0,0,0,1,
        1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,
        1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,
        1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
        1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,1,
        1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,1,
        1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    ];

    let player = { x: 3.5, y: 3.5, dir: 0, rot: 0, speed: 0 };
    const fov = Math.PI / 3;

    function initGame() {
        player = { x: 3.5, y: 3.5, dir: 0 };
        requestAnimationFrame(gameLoop);
    }

    function castRays() {
        ctx.fillStyle = "#333"; ctx.fillRect(0,0,width,height/2); // Ceiling
        ctx.fillStyle = "#554433"; ctx.fillRect(0,height/2,width,height/2); // Floor

        for(let x=0; x<width; x++) {
            let rayAngle = (player.dir - fov/2.0) + (x/width) * fov;
            let distToWall = 0;
            let hitWall = false;
            let eyeX = Math.cos(rayAngle);
            let eyeY = Math.sin(rayAngle);
            
            let testX = player.x;
            let testY = player.y;
            
            while(!hitWall && distToWall < 16) {
                distToWall += 0.1;
                testX = Math.floor(player.x + eyeX * distToWall);
                testY = Math.floor(player.y + eyeY * distToWall);
                
                if(testX < 0 || testX >= mapWidth || testY < 0 || testY >= mapHeight) {
                    hitWall = true; distToWall = 16;
                } else if(map[testY * mapWidth + testX] == 1) {
                    hitWall = true;
                }
            }

            let ceiling = height/2.0 - height/distToWall;
            let floor = height - ceiling;
            let wallHeight = floor - ceiling;

            // Simple shading
            let color = 255 - (distToWall * 15);
            if(color < 0) color = 0;
            ctx.fillStyle = `rgb(${color}, ${color/2}, ${color/4})`;
            ctx.fillRect(x, ceiling, 1, wallHeight);
        }
    }

    function gameLoop() {
        // Simple movement logic
        if(keys['w']) { player.x += Math.cos(player.dir)*0.05; player.y += Math.sin(player.dir)*0.05; }
        if(keys['s']) { player.x -= Math.cos(player.dir)*0.05; player.y -= Math.sin(player.dir)*0.05; }
        if(keys['a']) { player.dir -= 0.05; }
        if(keys['d']) { player.dir += 0.05; }

        castRays();
        requestAnimationFrame(gameLoop);
    }

    let keys = {};
    window.addEventListener('keydown', e => keys[e.key] = true);
    window.addEventListener('keyup', e => keys[e.key] = false);

    initGame();
</script>
</body>
</html>