<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.model.Game" %>
<%@ page import="com.project.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    List<Game> leaderboard = (List<Game>) request.getAttribute("leaderboard");
    if (leaderboard == null) leaderboard = new ArrayList<>();
    String gameType = (String) request.getAttribute("gameType");
    if (gameType == null) gameType = "Snake";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaderboard - <%= gameType %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .leaderboard-container {
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        .leaderboard-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .leaderboard-header h1 {
            font-size: 36px;
            margin-bottom: 10px;
        }
        .back-btn {
            display: inline-block;
            margin-bottom: 20px;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
        }
        .leaderboard-table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .rank-item {
            display: grid;
            grid-template-columns: 80px 1fr 150px 150px;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            transition: background 0.3s;
        }
        .rank-item:hover {
            background: #f9f9f9;
        }
        .rank-item.header {
            background: #667eea;
            color: white;
            font-weight: bold;
            border-bottom: none;
        }
        .rank-position {
            font-size: 24px;
            font-weight: bold;
            color: #667eea;
        }
        .rank-position.top {
            color: #ffd700;
            font-size: 28px;
        }
        .rank-position.second {
            color: #c0c0c0;
        }
        .rank-position.third {
            color: #cd7f32;
        }
        .rank-info {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .player-name {
            font-weight: bold;
            font-size: 16px;
        }
        .difficulty-badge {
            display: inline-block;
            width: fit-content;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
        }
        .difficulty-easy {
            background: #d4edda;
            color: #155724;
        }
        .difficulty-medium {
            background: #fff3cd;
            color: #856404;
        }
        .difficulty-hard {
            background: #f8d7da;
            color: #721c24;
        }
        .score {
            font-size: 20px;
            font-weight: bold;
            color: #667eea;
            text-align: right;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .medal {
            display: inline-block;
            margin-right: 10px;
            font-size: 24px;
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="navbar-container">
        <a href="games" class="navbar-logo">Leaderboard</a>
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

<div class="leaderboard-container">
    <a href="games" class="back-btn">← Back to Games</a>
    
    <div class="leaderboard-header">
        <h1>🏆 <%= gameType %> Leaderboard</h1>
        <p>Top scores from our community</p>
    </div>

    <% if (leaderboard.isEmpty()) { %>
        <div class="leaderboard-table">
            <div class="no-data">
                <p>No scores available yet. Be the first to play!</p>
            </div>
        </div>
    <% } else { %>
        <div class="leaderboard-table">
            <div class="rank-item header">
                <div>Rank</div>
                <div>Player</div>
                <div>Difficulty</div>
                <div>Score</div>
            </div>
            
            <% int rank = 1; %>
            <% for (Game game : leaderboard) { %>
                <div class="rank-item">
                    <div class="rank-position <%= rank == 1 ? "top" : rank == 2 ? "second" : rank == 3 ? "third" : "" %>">
                        <% if (rank == 1) { %>
                            <span class="medal">🥇</span><%= rank %>
                        <% } else if (rank == 2) { %>
                            <span class="medal">🥈</span><%= rank %>
                        <% } else if (rank == 3) { %>
                            <span class="medal">🥉</span><%= rank %>
                        <% } else { %>
                            <%= rank %>
                        <% } %>
                    </div>
                    <div class="rank-info">
                        <div class="player-name"><%= game.getUsername() %></div>
                    </div>
                    <div>
                        <span class="difficulty-badge difficulty-<%= game.getDifficulty().toLowerCase() %>">
                            <%= game.getDifficulty() %>
                        </span>
                    </div>
                    <div class="score"><%= game.getScore() %></div>
                </div>
                <% rank++; %>
            <% } %>
        </div>
    <% } %>
</div>

<footer>
    <p>&copy; 2025 Third Semester Java Project. All rights reserved.</p>
</footer>

<script src="js/main.js"></script>
</body>
</html>
