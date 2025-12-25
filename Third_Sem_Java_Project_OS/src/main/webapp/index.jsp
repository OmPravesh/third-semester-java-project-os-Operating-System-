<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. Session Safety Check
    String username = (String) session.getAttribute("name");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Format name (e.g., "john" -> "John")
    String displayName = username.substring(0, 1).toUpperCase() + username.substring(1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>WebOS • Desktop</title>

    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            /* Palette */
            --bg-dark: #0f172a;
            --text-white: #ffffff;
            --text-muted: rgba(255, 255, 255, 0.8);

            /* Glass Effects */
            --glass-bg: rgba(20, 25, 40, 0.4);
            --glass-border: rgba(255, 255, 255, 0.1);
            --dock-bg: rgba(255, 255, 255, 0.15);

            /* Icon Gradients */
            --g-wallet: linear-gradient(135deg, #11998e, #38ef7d);
            --g-calc: linear-gradient(135deg, #FF9966, #FF5E62);
            --g-game: linear-gradient(135deg, #833ab4, #fd1d1d, #fcb045);
            --g-chat: linear-gradient(135deg, #2193b0, #6dd5ed);
            --g-stock: linear-gradient(135deg, #4facfe, #00f2fe);
            --g-note: linear-gradient(135deg, #f09819, #edde5d);
            --g-set: linear-gradient(135deg, #434343, #000000);
            --g-logout: linear-gradient(135deg, #cb2d3e, #ef473a);
            /* NEW BROWSER GRADIENT */
            --g-browser: linear-gradient(135deg, #2980b9, #6dd5fa);
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            height: 100vh;
            width: 100vw;
            overflow: hidden;
            color: var(--text-white);
            background: radial-gradient(circle at 0% 0%, #3a1c71 0%, #d76d77 50%, #ffaf7b 100%);
            background-size: 200% 200%;
            display: flex;
            flex-direction: column;
        }

        /* --- Top Bar (Status Bar) --- */
        .topbar {
            height: 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            background: rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-bottom: 1px solid var(--glass-border);
            z-index: 100;
        }

        .brand {
            font-weight: 700;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-box {
            position: relative;
            width: 250px;
            display: flex;
            align-items: center;
        }
        .search-box i {
            position: absolute;
            left: 12px;
            color: rgba(255,255,255,0.6);
            font-size: 0.8rem;
        }
        .search-input {
            width: 100%;
            background: rgba(255,255,255,0.1);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 6px 12px 6px 35px;
            color: white;
            font-size: 0.85rem;
            outline: none;
            transition: 0.3s;
        }
        .search-input:focus {
            background: rgba(255,255,255,0.2);
            border-color: rgba(255,255,255,0.3);
        }

        .profile-pill {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255,255,255,0.1);
            padding: 4px 12px 4px 4px;
            border-radius: 30px;
            cursor: pointer;
            border: 1px solid transparent;
            transition: 0.2s;
        }
        .profile-pill:hover { background: rgba(255,255,255,0.2); border-color: rgba(255,255,255,0.2); }
        .avatar {
            width: 28px; height: 28px;
            border-radius: 50%;
            background: linear-gradient(to right, #6a11cb, #2575fc);
            display: grid; place-items: center;
            font-weight: bold; font-size: 0.8rem;
        }

        /* --- Desktop Content --- */
        .desktop {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            overflow-y: auto;
            scrollbar-width: none;
        }
        .desktop::-webkit-scrollbar { display: none; }

        .widget-clock {
            text-align: center;
            margin-bottom: 40px;
            text-shadow: 0 4px 20px rgba(0,0,0,0.3);
            animation: slideDown 0.8s ease-out;
        }
        .time { font-size: 4.5rem; font-weight: 200; line-height: 1; letter-spacing: -2px; }
        .date { font-size: 1.2rem; font-weight: 400; opacity: 0.8; margin-top: 5px; }

        /* App Grid */
        .app-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 30px;
            width: 100%;
            max-width: 900px;
            justify-items: center;
            padding-bottom: 100px;
        }

        .app-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: transform 0.2s;
            width: 100px;
            animation: popIn 0.5s ease-out backwards;
        }

        .app-item:nth-child(1) { animation-delay: 0.1s; }
        .app-item:nth-child(2) { animation-delay: 0.15s; }
        .app-item:nth-child(3) { animation-delay: 0.2s; }
        .app-item:nth-child(4) { animation-delay: 0.25s; }
        .app-item:nth-child(5) { animation-delay: 0.3s; }
        .app-item:nth-child(6) { animation-delay: 0.35s; }
        .app-item:nth-child(7) { animation-delay: 0.4s; }
        .app-item:nth-child(8) { animation-delay: 0.45s; }

        .app-item:hover { transform: translateY(-5px); }

        .app-icon {
            width: 64px; height: 64px;
            border-radius: 16px;
            display: grid; place-items: center;
            font-size: 1.8rem; color: white;
            box-shadow: 0 10px 25px rgba(0,0,0,0.25);
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .app-icon::before {
            content: ''; position: absolute;
            top: 0; left: 0; right: 0; height: 50%;
            background: linear-gradient(to bottom, rgba(255,255,255,0.25), transparent);
            pointer-events: none;
        }

        .app-label {
            font-size: 0.85rem; font-weight: 500;
            text-shadow: 0 2px 4px rgba(0,0,0,0.8);
        }

        /* Specific Gradients */
        .bg-wallet { background: var(--g-wallet); }
        .bg-calc { background: var(--g-calc); }
        .bg-game { background: var(--g-game); }
        .bg-chat { background: var(--g-chat); }
        .bg-stock { background: var(--g-stock); }
        .bg-note { background: var(--g-note); }
        .bg-set { background: var(--g-set); }
        .bg-logout { background: var(--g-logout); }
        /* Browser Gradient Class */
        .bg-browser { background: var(--g-browser); }

        /* --- Floating Dock --- */
        .dock-container {
            position: fixed;
            bottom: 20px;
            left: 0; right: 0;
            display: flex;
            justify-content: center;
            z-index: 200;
        }

        .dock {
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.2);
            padding: 8px 15px;
            border-radius: 20px;
            display: flex;
            gap: 12px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
            transition: transform 0.2s;
        }
        .dock:hover { transform: scale(1.02); }

        .dock-icon {
            width: 42px; height: 42px;
            border-radius: 10px;
            display: grid; place-items: center;
            color: white; font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.25, 1, 0.5, 1);
            position: relative;
        }
        .dock-icon:hover {
            transform: translateY(-10px) scale(1.15);
            background: rgba(255,255,255,0.2);
        }

        .dock-icon.active::after {
            content: ''; position: absolute;
            bottom: -5px; width: 4px; height: 4px;
            background: white; border-radius: 50%;
        }

        @keyframes slideDown { from { opacity: 0; transform: translateY(-30px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes popIn { from { opacity: 0; transform: scale(0.8); } to { opacity: 1; transform: scale(1); } }

        @media (max-width: 600px) {
            .search-box { display: none; }
            .time { font-size: 3rem; }
            .app-grid { grid-template-columns: repeat(3, 1fr); gap: 15px; }
            .dock { width: 100%; bottom: 0; border-radius: 0; border: none; justify-content: space-around; }
            .dock-container { bottom: 0; }
        }
    </style>
</head>
<body>

    <div class="topbar">
        <div class="brand"><i class="fab fa-windows"></i> WebOS</div>

        <div class="search-box">
            <i class="fas fa-search"></i>
            <input type="text" id="appSearch" class="search-input" placeholder="Search apps..." autocomplete="off">
        </div>

        <div class="profile-pill" onclick="window.location.href='settings.jsp'">
            <span><%= displayName %></span>
            <div class="avatar"><%= displayName.substring(0,1) %></div>
        </div>
    </div>

    <div class="desktop">

        <div class="widget-clock">
            <div class="time" id="clock">12:00</div>
            <div class="date" id="greeting">Welcome Back</div>
        </div>

        <div class="app-grid" id="appGrid">

            <div class="app-item" onclick="window.location.href='browser.jsp'">
                <div class="app-icon bg-browser"><i class="fab fa-chrome"></i></div>
                <div class="app-label">Browser</div>
            </div>

            <div class="app-item" onclick="window.location.href='wallet.jsp'">
                <div class="app-icon bg-wallet"><i class="fas fa-wallet"></i></div>
                <div class="app-label">Wallet</div>
            </div>

            <div class="app-item" onclick="window.location.href='calculator.jsp'">
                <div class="app-icon bg-calc"><i class="fas fa-calculator"></i></div>
                <div class="app-label">Calculator</div>
            </div>

            <div class="app-item" onclick="window.location.href='game.jsp'">
                <div class="app-icon bg-game"><i class="fas fa-gamepad"></i></div>
                <div class="app-label">Games</div>
            </div>

            <div class="app-item" onclick="window.location.href='chat.jsp'">
                <div class="app-icon bg-chat"><i class="fas fa-comments"></i></div>
                <div class="app-label">Chat</div>
            </div>

            <div class="app-item" onclick="window.location.href='stock.jsp'">
                <div class="app-icon bg-stock"><i class="fas fa-chart-line"></i></div>
                <div class="app-label">Stocks</div>
            </div>

            <div class="app-item" onclick="window.location.href='notepad.jsp'">
                <div class="app-icon bg-note"><i class="fas fa-sticky-note"></i></div>
                <div class="app-label">Notes</div>
            </div>

            <div class="app-item" onclick="window.location.href='settings.jsp'">
                <div class="app-icon bg-set"><i class="fas fa-cog"></i></div>
                <div class="app-label">Settings</div>
            </div>

            <div class="app-item" onclick="window.location.href='logout'">
                <div class="app-icon bg-logout"><i class="fas fa-power-off"></i></div>
                <div class="app-label">Logout</div>
            </div>

        </div>
    </div>

    <div class="dock-container">
        <div class="dock">
            <div class="dock-icon active" title="Desktop"><i class="fas fa-desktop"></i></div>

            <div class="dock-icon" title="Browser" onclick="window.location.href='browser.jsp'"><i class="fab fa-chrome"></i></div>

            <div class="dock-icon" title="Files" onclick="alert('File Manager coming soon!')"><i class="fas fa-folder"></i></div>
            <div class="dock-icon" title="Terminal" onclick="alert('Terminal coming soon!')"><i class="fas fa-terminal"></i></div>
            <div style="width:1px; background:rgba(255,255,255,0.3); margin:0 5px;"></div>
            <div class="dock-icon" title="Settings" onclick="window.location.href='settings.jsp'"><i class="fas fa-sliders-h"></i></div>
        </div>
    </div>

    <script>
        function updateClock() {
            const now = new Date();
            const hours = now.getHours();
            const mins = String(now.getMinutes()).padStart(2, '0');
            document.getElementById('clock').innerText = `${hours}:${mins}`;

            let greet = "Good Evening";
            if(hours < 12) greet = "Good Morning";
            else if(hours < 18) greet = "Good Afternoon";

            document.getElementById('greeting').innerText = `${greet}, <%= displayName %>`;
        }
        setInterval(updateClock, 1000);
        updateClock();

        document.getElementById('appSearch').addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            const apps = document.querySelectorAll('.app-item');

            apps.forEach(app => {
                const label = app.querySelector('.app-label').innerText.toLowerCase();
                app.style.display = label.includes(term) ? 'flex' : 'none';
            });
        });

        (function loadPrefs(){
            try {
                const bg = localStorage.getItem('webos.background');
                if(bg === 'ocean') document.body.style.background = 'linear-gradient(to right, #243949 0%, #517fa4 100%)';
            } catch(e){}
        })();
    </script>
</body>
</html>