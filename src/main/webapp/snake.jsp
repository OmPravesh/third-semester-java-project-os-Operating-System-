<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("name") == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <title>Neon Snake</title>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        :root {
            --bg-color: #050505;
            --accent: #00d2d3;
            --text-white: #ffffff;
            --btn-bg: rgba(255, 255, 255, 0.1);
            --btn-border: rgba(255, 255, 255, 0.2);
        }

        body {
            margin: 0;
            padding: 0;
            background-color: var(--bg-color);
            color: var(--text-white);
            font-family: 'Segoe UI', sans-serif;
            overflow: hidden;
            width: 100vw;
            height: 100vh;
            user-select: none;
            -webkit-user-select: none;
        }

        /* Canvas Layer */
        canvas {
            display: block;
            position: absolute;
            top: 0;
            left: 0;
            z-index: 1;
        }

        /* UI Overlay */
        .ui-layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 10;
            pointer-events: none;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        /* Top Bar */
        .top-bar {
            pointer-events: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 25px;
            background: linear-gradient(to bottom, rgba(0,0,0,0.8), transparent);
        }

        .back-btn {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: color 0.2s;
        }
        .back-btn:hover { color: #fff; }

        .stats-container {
            display: flex;
            gap: 15px;
        }

        .stat-badge {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(5px);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            border: 1px solid rgba(255,255,255,0.1);
            white-space: nowrap;
        }
        .stat-value { font-weight: 700; color: var(--accent); margin-left: 5px; }

        /* Bottom Controls */
        .bottom-controls {
            pointer-events: auto;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            padding-bottom: 30px; /* Safe area for mobile */
        }

        .game-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            background: var(--btn-bg);
            border: 1px solid var(--btn-border);
            color: white;
            padding: 10px 18px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.95rem;
            backdrop-filter: blur(4px);
            transition: background 0.2s;
            display: flex;
            align-items: center;
            gap: 6px;
            min-width: 90px;
            justify-content: center;
        }
        .btn:hover { background: rgba(255,255,255,0.2); }
        .btn:active { transform: translateY(1px); }
        .btn-primary {
            background: var(--accent);
            color: #000;
            font-weight: 700;
            border: none;
            box-shadow: 0 0 15px rgba(0, 210, 211, 0.3);
        }

        /* D-Pad */
        .dpad {
            display: grid;
            grid-template-columns: 60px 60px 60px;
            grid-template-rows: 60px 60px;
            gap: 6px;
        }
        .dpad-btn {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            color: rgba(255,255,255,0.8);
            font-size: 1.2rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .dpad-btn:active { background: rgba(255,255,255,0.25); }

        .btn-up { grid-column: 2; grid-row: 1; }
        .btn-left { grid-column: 1; grid-row: 2; }
        .btn-down { grid-column: 2; grid-row: 2; }
        .btn-right { grid-column: 3; grid-row: 2; }

        @media (max-width: 600px) {
            .stats-container { gap: 8px; }
            .stat-badge { padding: 6px 10px; font-size: 0.8rem; }
            .game-actions { flex-direction: column-reverse; }
            .dpad { transform: scale(0.9); transform-origin: bottom right; }
        }
    </style>
</head>
<body>

    <canvas id="gameCanvas"></canvas>

    <div class="ui-layer">
        <div class="top-bar">
            <a href="game.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Exit</a>
            <div class="stats-container">
                <div class="stat-badge">SCORE <span class="stat-value" id="score">0</span></div>
                <div class="stat-badge">HIGH <span class="stat-value" id="high">0</span></div>
                <div class="stat-badge">SPEED <span class="stat-value" id="speed">1.0</span>x</div>
            </div>
        </div>

        <div class="bottom-controls">
            <div class="game-actions">
                <button class="btn" id="wrapBtn">Walls: <span id="wrapText" style="color:#ff5555; margin-left:4px;">Solid</span></button>
                <button class="btn" id="pauseBtn"><i class="fas fa-pause"></i> Pause</button>
                <button class="btn btn-primary" id="restartBtn"><i class="fas fa-redo"></i> Restart</button>
            </div>

            <div class="dpad">
                <button class="dpad-btn btn-up" data-dir="up"><i class="fas fa-chevron-up"></i></button>
                <button class="dpad-btn btn-left" data-dir="left"><i class="fas fa-chevron-left"></i></button>
                <button class="dpad-btn btn-down" data-dir="down"><i class="fas fa-chevron-down"></i></button>
                <button class="dpad-btn btn-right" data-dir="right"><i class="fas fa-chevron-right"></i></button>
            </div>
        </div>
    </div>

    <script>
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        const tileSize = 25;

        let cols, rows;
        let snake = [];
        let food = {};
        let direction = {x: 1, y: 0};
        let nextDirection = {x: 1, y: 0};

        let score = 0;
        let highScore = parseInt(localStorage.getItem('snake_highscore')) || 0;
        let speedMultiplier = 1;
        let isPaused = false;
        let isGameOver = false;
        let wrapWalls = false;

        let lastTime = 0;
        let tickRate = 120;
        let timeSinceLastTick = 0;

        function resize() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            cols = Math.floor(canvas.width / tileSize);
            rows = Math.floor(canvas.height / tileSize);
        }

        function initGame() {
            resize();
            snake = [
                {x: Math.floor(cols/2), y: Math.floor(rows/2)},
                {x: Math.floor(cols/2)-1, y: Math.floor(rows/2)},
                {x: Math.floor(cols/2)-2, y: Math.floor(rows/2)}
            ];
            direction = {x: 1, y: 0};
            nextDirection = {x: 1, y: 0};
            score = 0;
            speedMultiplier = 1;
            tickRate = 120;
            isPaused = false;
            isGameOver = false;

            spawnFood();
            updateStatsUI();
            updateButtonUI();
        }

        function spawnFood() {
            let valid = false;
            while(!valid) {
                food = {
                    x: Math.floor(Math.random() * cols),
                    y: Math.floor(Math.random() * rows)
                };
                valid = !snake.some(seg => seg.x === food.x && seg.y === food.y);
            }
        }

        function update(dt) {
            if(isPaused || isGameOver) return;

            timeSinceLastTick += dt;

            if (timeSinceLastTick > tickRate) {
                timeSinceLastTick = 0;

                direction = nextDirection;
                let head = {x: snake[0].x + direction.x, y: snake[0].y + direction.y};

                // Walls
                if(wrapWalls) {
                    if(head.x < 0) head.x = cols - 1;
                    if(head.x >= cols) head.x = 0;
                    if(head.y < 0) head.y = rows - 1;
                    if(head.y >= rows) head.y = 0;
                } else {
                    if(head.x < 0 || head.x >= cols || head.y < 0 || head.y >= rows) {
                        gameOver();
                        return;
                    }
                }

                // Self Collision
                if(snake.some(seg => seg.x === head.x && seg.y === head.y)) {
                    gameOver();
                    return;
                }

                snake.unshift(head);

                // Eat Food
                if(head.x === food.x && head.y === food.y) {
                    score += 10;
                    if(tickRate > 50) {
                        tickRate -= 2;
                        speedMultiplier += 0.05;
                    }
                    updateStatsUI();
                    spawnFood();
                } else {
                    snake.pop();
                }
            }
        }

        function gameOver() {
            isGameOver = true;
            if(score > highScore) {
                highScore = score;
                localStorage.setItem('snake_highscore', highScore);
            }
            updateStatsUI();
        }

        function draw() {
            ctx.fillStyle = "#050505";
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Grid
            ctx.strokeStyle = "rgba(255, 255, 255, 0.03)";
            ctx.lineWidth = 1;
            ctx.beginPath();
            for (let x = 0; x <= cols; x++) { ctx.moveTo(x * tileSize, 0); ctx.lineTo(x * tileSize, canvas.height); }
            for (let y = 0; y <= rows; y++) { ctx.moveTo(0, y * tileSize); ctx.lineTo(canvas.width, y * tileSize); }
            ctx.stroke();

            // Food
            const fx = food.x * tileSize + tileSize/2;
            const fy = food.y * tileSize + tileSize/2;
            ctx.shadowBlur = 15;
            ctx.shadowColor = "#ff0055";
            ctx.fillStyle = "#ff0055";
            ctx.beginPath();
            ctx.arc(fx, fy, tileSize/2 - 3, 0, Math.PI*2);
            ctx.fill();
            ctx.shadowBlur = 0;

            // Snake
            ctx.shadowBlur = 10;
            ctx.shadowColor = "#00ff88";
            snake.forEach((seg, index) => {
                const sx = seg.x * tileSize;
                const sy = seg.y * tileSize;
                ctx.fillStyle = index === 0 ? "#ccffdd" : "#00ff88";
                ctx.beginPath();
                ctx.roundRect(sx + 1, sy + 1, tileSize - 2, tileSize - 2, 6);
                ctx.fill();

                if(index === 0) {
                    ctx.fillStyle = "#000";
                    ctx.shadowBlur = 0;
                    ctx.beginPath();
                    ctx.arc(sx + 8, sy + 8, 2, 0, Math.PI*2);
                    ctx.arc(sx + tileSize - 8, sy + 8, 2, 0, Math.PI*2);
                    ctx.fill();
                }
            });
            ctx.shadowBlur = 0;

            // Game Over Overlay
            if(isGameOver) {
                ctx.fillStyle = "rgba(0,0,0,0.7)";
                ctx.fillRect(0,0,canvas.width, canvas.height);
                ctx.fillStyle = "#fff";
                ctx.font = "bold 40px sans-serif";
                ctx.textAlign = "center";
                ctx.fillText("GAME OVER", canvas.width/2, canvas.height/2 - 10);
                ctx.font = "20px sans-serif";
                ctx.fillStyle = "#aaa";
                ctx.fillText("Score: " + score, canvas.width/2, canvas.height/2 + 30);
            }
        }

        // --- UI Updates ---
        function updateStatsUI() {
            document.getElementById('score').innerText = score;
            document.getElementById('high').innerText = highScore;
            document.getElementById('speed').innerText = speedMultiplier.toFixed(1);
        }

        function updateButtonUI() {
            const pauseBtn = document.getElementById('pauseBtn');
            if(isPaused) {
                pauseBtn.innerHTML = '<i class="fas fa-play"></i> Resume';
                pauseBtn.style.backgroundColor = 'rgba(255, 255, 0, 0.2)';
            } else {
                pauseBtn.innerHTML = '<i class="fas fa-pause"></i> Pause';
                pauseBtn.style.backgroundColor = '';
            }

            const wrapText = document.getElementById('wrapText');
            if(wrapWalls) {
                wrapText.innerText = "Wrap";
                wrapText.style.color = "#00ff88";
            } else {
                wrapText.innerText = "Solid";
                wrapText.style.color = "#ff5555";
            }
        }

        // --- Inputs ---
        document.getElementById('pauseBtn').addEventListener('click', () => {
            if(isGameOver) return;
            isPaused = !isPaused;
            updateButtonUI();
        });

        document.getElementById('wrapBtn').addEventListener('click', () => {
            wrapWalls = !wrapWalls;
            updateButtonUI();
            document.getElementById('wrapBtn').blur();
        });

        document.getElementById('restartBtn').addEventListener('click', () => {
            initGame();
            document.getElementById('restartBtn').blur();
        });

        document.addEventListener('keydown', (e) => {
            if([37, 38, 39, 40, 32].indexOf(e.keyCode) > -1) e.preventDefault();
            switch(e.key) {
                case 'ArrowUp': if(direction.y === 0) nextDirection = {x:0, y:-1}; break;
                case 'ArrowDown': if(direction.y === 0) nextDirection = {x:0, y:1}; break;
                case 'ArrowLeft': if(direction.x === 0) nextDirection = {x:-1, y:0}; break;
                case 'ArrowRight': if(direction.x === 0) nextDirection = {x:1, y:0}; break;
                case ' ': if(!isGameOver) { isPaused = !isPaused; updateButtonUI(); } break;
            }
        });

        document.querySelectorAll('.dpad-btn').forEach(btn => {
            const handleDir = (e) => {
                e.preventDefault();
                const d = btn.getAttribute('data-dir');
                if(d === 'up' && direction.y === 0) nextDirection = {x:0, y:-1};
                if(d === 'down' && direction.y === 0) nextDirection = {x:0, y:1};
                if(d === 'left' && direction.x === 0) nextDirection = {x:-1, y:0};
                if(d === 'right' && direction.x === 0) nextDirection = {x:1, y:0};
            };
            btn.addEventListener('touchstart', handleDir);
            btn.addEventListener('click', handleDir);
        });

        window.addEventListener('resize', resize);

        function gameLoop(timestamp) {
            const dt = timestamp - lastTime;
            lastTime = timestamp;
            update(dt);
            draw();
            requestAnimationFrame(gameLoop);
        }

        initGame();
        requestAnimationFrame(gameLoop);

    </script>
</body>
</html>