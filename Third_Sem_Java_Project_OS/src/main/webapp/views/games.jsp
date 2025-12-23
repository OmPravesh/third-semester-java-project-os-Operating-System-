<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
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
    <title>Games - Third Semester Project</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .games-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .game-card {
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }
        .game-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        .game-card h3 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        .game-card p {
            font-size: 14px;
            margin-bottom: 15px;
        }
        .game-card button {
            background: white;
            color: #667eea;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s;
        }
        .game-card button:hover {
            background: #f0f0f0;
        }
        .leaderboard-btn {
            background: rgba(255,255,255,0.3);
            color: white;
            margin-top: 10px;
            width: 100%;
        }
        .leaderboard-btn:hover {
            background: rgba(255,255,255,0.5);
            color: white;
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="navbar-container">
        <a href="dashboard" class="navbar-logo">Game Hub</a>
        <ul class="nav-menu">
            <li><a href="dashboard">Dashboard</a></li>
            <li><a href="games" class="active">Games</a></li>
            <li><a href="chat">Chat</a></li>
            <li><a href="digital-payment">Payments</a></li>
            <li><a href="stock">Stock Market</a></li>
            <li><a href="login" onclick="event.preventDefault(); fetch('login', {method: 'DELETE'}).then(() => window.location.href='login')">Logout</a></li>
        </ul>
    </div>
</div>

<div class="container">
    <h1>Game Center</h1>
    <p class="subtitle">Welcome <%= user.getUsername() %>! Play exciting games and compete on leaderboards.</p>

    <div class="games-container">
        <div class="game-card">
            <h3>🐍 Snake Game</h3>
            <p>Classic snake game. Eat food and grow! But don't hit the walls or yourself.</p>
            <button onclick="window.location.href='games?gameType=snake'">Play Now</button>
            <button class="leaderboard-btn" onclick="window.location.href='games?action=leaderboard&type=Snake'">Leaderboard</button>
        </div>

        <div class="game-card">
            <h3>🧩 Puzzle Game</h3>
            <p>Test your memory and logic. Match patterns and solve challenging puzzles.</p>
            <button onclick="window.location.href='games?gameType=puzzle'">Play Now</button>
            <button class="leaderboard-btn" onclick="window.location.href='games?action=leaderboard&type=Puzzle'">Leaderboard</button>
        </div>

        <div class="game-card">
            <h3>🎮 More Games</h3>
            <p>Additional exciting games coming soon! Stay tuned for updates.</p>
            <button disabled style="opacity: 0.5;">Coming Soon</button>
            <button class="leaderboard-btn" disabled style="opacity: 0.5;">Coming Soon</button>
        </div>
    </div>
</div>

<footer>
    <p>&copy; 2025 Third Semester Java Project. All rights reserved.</p>
</footer>

<script src="js/main.js"></script>
</body>
</html>
