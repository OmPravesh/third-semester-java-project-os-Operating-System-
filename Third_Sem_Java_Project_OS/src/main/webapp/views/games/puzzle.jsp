<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.project.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Puzzle Game</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .game-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: calc(100vh - 100px);
            flex-direction: column;
            padding: 20px;
        }
        .puzzle-board {
            display: grid;
            grid-template-columns: repeat(4, 100px);
            gap: 10px;
            margin: 20px 0;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .puzzle-tile {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-size: 24px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border-radius: 5px;
            transition: transform 0.2s;
            user-select: none;
        }
        .puzzle-tile:hover {
            transform: scale(1.05);
        }
        .puzzle-tile.matched {
            background: #10b981;
            cursor: default;
        }
        .puzzle-tile.active {
            transform: scale(0.95);
            box-shadow: inset 0 0 10px rgba(0,0,0,0.2);
        }
        .game-info {
            display: flex;
            gap: 30px;
            margin-bottom: 20px;
            font-size: 18px;
        }
        .game-controls {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            background: #667eea;
            color: white;
            transition: background 0.3s;
        }
        .btn:hover {
            background: #764ba2;
        }
        .instructions {
            background: white;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            max-width: 600px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="navbar-container">
        <a href="../games" class="navbar-logo">Puzzle Game</a>
        <ul class="nav-menu">
            <li><a href="../games">Back to Games</a></li>
            <li><a href="../dashboard">Dashboard</a></li>
            <li><a href="../login" onclick="event.preventDefault(); fetch('../login', {method: 'DELETE'}).then(() => window.location.href='../login')">Logout</a></li>
        </ul>
    </div>
</div>

<div class="game-container">
    <div class="instructions">
        <h3>How to Play:</h3>
        <p>Click on tiles to find matching pairs. Match all pairs to win the game!</p>
        <p>Try to complete it in the fewest moves possible.</p>
    </div>

    <div class="game-info">
        <div>Moves: <span id="moves">0</span></div>
        <div>Matches: <span id="matches">0</span>/8</div>
        <div>Difficulty: <span id="difficulty">Easy</span></div>
    </div>

    <div class="puzzle-board" id="puzzleBoard"></div>

    <div class="game-controls">
        <button class="btn" onclick="initGame()">New Game</button>
        <button class="btn" onclick="changeDifficulty()">Change Difficulty</button>
        <button class="btn" onclick="goBack()">Back to Games</button>
    </div>
</div>

<script>
    const symbols = ['🌟', '🎨', '🎭', '🎪', '🎯', '🎲', '🎸', '🎺'];
    let gameBoard = [];
    let flipped = [];
    let matched = 0;
    let moves = 0;
    let difficulty = 'Easy';
    let canClick = true;

    function initGame() {
        gameBoard = [];
        flipped = [];
        matched = 0;
        moves = 0;
        canClick = true;
        
        // Create pairs
        const pairs = [...symbols, ...symbols];
        pairs.sort(() => Math.random() - 0.5);
        gameBoard = pairs;
        
        renderBoard();
        updateUI();
    }

    function renderBoard() {
        const board = document.getElementById('puzzleBoard');
        board.innerHTML = '';
        
        gameBoard.forEach((symbol, index) => {
            const tile = document.createElement('div');
            tile.className = 'puzzle-tile';
            tile.textContent = flipped.includes(index) || matched === symbols.length ? symbol : '?';
            tile.onclick = () => flipTile(index);
            if (matched === symbols.length) tile.classList.add('matched');
            board.appendChild(tile);
        });
    }

    function flipTile(index) {
        if (!canClick || flipped.includes(index) || matched === symbols.length) return;
        
        flipped.push(index);
        moves++;
        renderBoard();
        
        if (flipped.length === 2) {
            canClick = false;
            setTimeout(checkMatch, 800);
        }
    }

    function checkMatch() {
        const [first, second] = flipped;
        
        if (gameBoard[first] === gameBoard[second]) {
            matched++;
            flipped = [];
            canClick = true;
            
            if (matched === symbols.length) {
                setTimeout(() => endGame(), 500);
            }
        } else {
            flipped = [];
            canClick = true;
        }
        
        updateUI();
        renderBoard();
    }

    function updateUI() {
        document.getElementById('moves').textContent = moves;
        document.getElementById('matches').textContent = matched;
    }

    function changeDifficulty() {
        if (difficulty === 'Easy') {
            difficulty = 'Medium';
        } else if (difficulty === 'Medium') {
            difficulty = 'Hard';
        } else {
            difficulty = 'Easy';
        }
        document.getElementById('difficulty').textContent = difficulty;
        initGame();
    }

    function endGame() {
        alert(`Puzzle Completed!\nMoves: ${moves}\nDifficulty: ${difficulty}`);
        saveGameResult();
    }

    function saveGameResult() {
        fetch('../games', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'gameType=Puzzle&score=' + (1000 - moves * 10) + '&timeSpent=0&difficulty=' + difficulty + '&status=Won'
        });
    }

    function goBack() {
        window.location.href = '../games';
    }

    initGame();
</script>
</body>
</html>
