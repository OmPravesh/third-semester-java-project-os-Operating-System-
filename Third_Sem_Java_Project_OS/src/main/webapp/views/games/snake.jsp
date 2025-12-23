<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Google Snake</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .game-area { 
            background-color: #f8f9fa; 
            border: 2px solid #e0e0e0; 
            margin: 0 auto; 
            display: block; 
            box-shadow: var(--shadow-1);
            border-radius: 8px;
        }
        .score-board {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: var(--text-secondary);
        }
    </style>
</head>
<body>
    <jsp:include page="/views/common/navbar.jsp" />
    
    <div class="container text-center">
        <div class="card" style="display: inline-block; padding: 40px;">
            <div class="score-board">
                Score: <span id="score" style="color: var(--google-blue); font-weight: bold;">0</span>
            </div>
            <canvas id="gameCanvas" width="400" height="400" class="game-area"></canvas>
            <div class="mt-2 text-secondary">Use <b>Arrow Keys</b> to move</div>
            <button class="btn btn-primary mt-2" onclick="resetGame()">New Game</button>
        </div>
    </div>

<script>
    const canvas = document.getElementById("gameCanvas");
    const ctx = canvas.getContext("2d");
    const box = 20;
    
    // Google Colors
    const colors = ["#4285f4", "#ea4335", "#fbbc04", "#34a853"];
    
    let snake = [];
    let food = {};
    let score = 0;
    let d;
    let game;

    function init() {
        snake = [];
        snake[0] = { x: 9 * box, y: 10 * box };
        score = 0;
        d = null; // Wait for input
        createFood();
        document.getElementById("score").innerText = score;
        if(game) clearInterval(game);
        game = setInterval(draw, 100);
    }

    document.addEventListener("keydown", direction);

    function direction(event) {
        let key = event.keyCode;
        if( key == 37 && d != "RIGHT") d = "LEFT";
        else if(key == 38 && d != "DOWN") d = "UP";
        else if(key == 39 && d != "LEFT") d = "RIGHT";
        else if(key == 40 && d != "UP") d = "DOWN";
    }

    function createFood() {
        food = {
            x: Math.floor(Math.random() * 19 + 1) * box,
            y: Math.floor(Math.random() * 19 + 1) * box,
            color: colors[Math.floor(Math.random() * colors.length)]
        };
    }

    function collision(head, array) {
        for(let i = 0; i < array.length; i++) {
            if(head.x == array[i].x && head.y == array[i].y) return true;
        }
        return false;
    }

    function draw() {
        ctx.fillStyle = "#f8f9fa";
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        for(let i = 0; i < snake.length; i++) {
            ctx.fillStyle = (i == 0) ? "#202124" : "#5f6368";
            ctx.fillRect(snake[i].x, snake[i].y, box, box);
            
            ctx.strokeStyle = "#f8f9fa";
            ctx.strokeRect(snake[i].x, snake[i].y, box, box);
        }

        ctx.fillStyle = food.color;
        ctx.fillRect(food.x, food.y, box, box);

        let snakeX = snake[0].x;
        let snakeY = snake[0].y;

        if( d == "LEFT") snakeX -= box;
        if( d == "UP") snakeY -= box;
        if( d == "RIGHT") snakeX += box;
        if( d == "DOWN") snakeY += box;

        if(snakeX == food.x && snakeY == food.y) {
            score++;
            document.getElementById("score").innerText = score;
            createFood();
        } else {
            snake.pop();
        }

        let newHead = { x: snakeX, y: snakeY };

        if(snakeX < 0 || snakeX >= canvas.width || snakeY < 0 || snakeY >= canvas.height || collision(newHead, snake)) {
            clearInterval(game);
            alert("Game Over! Score: " + score);
        }

        snake.unshift(newHead);
    }

    init();
    function resetGame() { init(); }
</script>
</body>
</html>