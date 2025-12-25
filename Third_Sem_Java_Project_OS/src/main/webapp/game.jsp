<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("name");
    if (username == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>WebOS Arcade</title>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-dark: #0f172a;
            --text-white: #ffffff;
            --glass-bg: rgba(20, 25, 40, 0.7);
            --glass-border: rgba(255, 255, 255, 0.1);
        }
        body {
            margin: 0; padding: 0;
            font-family: 'Inter', sans-serif;
            height: 100vh;
            background: radial-gradient(circle at 50% 10%, #4a1c40 0%, #1a1a2e 100%);
            color: white;
            display: flex;
            flex-direction: column;
        }
        .header {
            padding: 20px 40px;
            display: flex;
            align-items: center;
            gap: 15px;
            background: rgba(0,0,0,0.2);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--glass-border);
        }
        .back-btn {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            font-weight: 600;
            display: flex; align-items: center; gap: 8px;
            transition: 0.2s;
            cursor: pointer;
        }
        .back-btn:hover { color: #fff; transform: translateX(-3px); }

        .container {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .title-hero {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 40px;
            background: linear-gradient(to right, #ff9966, #ff5e62);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
        }

        .game-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            width: 100%;
            max-width: 1000px;
        }

        .game-card {
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .game-card:hover {
            transform: translateY(-10px);
            background: rgba(255,255,255,0.1);
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
            border-color: rgba(255,255,255,0.3);
        }

        .icon-box {
            width: 60px; height: 60px;
            border-radius: 15px;
            display: grid; place-items: center;
            font-size: 1.8rem;
            margin-bottom: 20px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }

        /* Game Colors */
        .g-snake { background: linear-gradient(135deg, #11998e, #38ef7d); }
        .g-doom { background: linear-gradient(135deg, #eb3349, #f45c43); }
        .g-type { background: linear-gradient(135deg, #667eea, #764ba2); }
        .g-hill { background: linear-gradient(135deg, #f7971e, #ffd200); } /* New Gradient */
        .g-add { background: linear-gradient(135deg, #434343, #000000); border: 1px solid rgba(255,255,255,0.2); }

        .game-title { font-size: 1.5rem; font-weight: 700; margin-bottom: 5px; }
        .game-desc { color: rgba(255,255,255,0.6); font-size: 0.9rem; line-height: 1.4; }

        .play-btn {
            margin-top: 20px;
            padding: 8px 20px;
            background: white;
            color: black;
            border-radius: 30px;
            font-weight: 700;
            font-size: 0.9rem;
            opacity: 0;
            transform: translateY(10px);
            transition: all 0.3s;
        }

        .game-card:hover .play-btn { opacity: 1; transform: translateY(0); }
    </style>
</head>
<body>
    <div class="header">
        <a href="index.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Desktop</a>
    </div>

    <div class="container">
        <div class="title-hero">GAME CENTER</div>

        <div class="game-grid">

            <div class="game-card" onclick="window.location.href='hillclimb.jsp'">
                <div class="icon-box g-hill"><i class="fas fa-car-side"></i></div>
                <div class="game-title">Hill Racer</div>
                <div class="game-desc">Physics-based driving game. Climb endless hills, manage fuel, and keep your balance.</div>
                <div class="play-btn">PLAY NOW</div>
            </div>

            <div class="game-card" onclick="window.location.href='snake.jsp'">
                <div class="icon-box g-snake"><i class="fas fa-staff-snake"></i></div>
                <div class="game-title">Neon Snake</div>
                <div class="game-desc">Classic arcade action with a modern neon twist. Collect food, grow longer, don't crash.</div>
                <div class="play-btn">PLAY NOW</div>
            </div>

            <div class="game-card" onclick="window.location.href='doom.jsp'">
                <div class="icon-box g-doom"><i class="fas fa-biohazard"></i></div>
                <div class="game-title">Doom Arena</div>
                <div class="game-desc">Survive the zombie horde in this 3D First Person Shooter. Use Blasters and Shotguns.</div>
                <div class="play-btn">PLAY NOW</div>
            </div>

            <div class="game-card" onclick="window.location.href='typing.jsp'">
                <div class="icon-box g-type"><i class="fas fa-keyboard"></i></div>
                <div class="game-title">Hyper Type</div>
                <div class="game-desc">Test your WPM in this neon speed challenge. Race against the clock to type code and quotes.</div>
                <div class="play-btn">PLAY NOW</div>
            </div>

            <div class="game-card" style="opacity: 0.5; cursor: default;">
                <div class="icon-box g-add"><i class="fas fa-plus"></i></div>
                <div class="game-title">Coming Soon</div>
                <div class="game-desc">More games are currently in development. Check back later for updates.</div>
            </div>
        </div>
    </div>
</body>
</html>