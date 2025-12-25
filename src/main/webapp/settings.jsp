<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("name");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String initial = username.substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Settings</title>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            /* Windows 11 Dark Mode Palette */
            --bg-base: #202020;
            --bg-sidebar: #1c1c1c;
            --bg-card: rgba(255, 255, 255, 0.05);
            --bg-card-hover: rgba(255, 255, 255, 0.08);
            --accent: #0078d4;
            --text-primary: #ffffff;
            --text-secondary: #a0a0a0;
            --border: rgba(255, 255, 255, 0.06);
            --radius: 8px;
        }

        body {
            margin: 0; padding: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: var(--bg-base);
            color: var(--text-primary);
            height: 100vh;
            display: flex;
            overflow: hidden;
            user-select: none;
        }

        /* --- Sidebar --- */
        .sidebar {
            width: 320px;
            background-color: var(--bg-sidebar);
            display: flex;
            flex-direction: column;
            padding: 20px 10px;
            border-right: 1px solid var(--border);
        }

        .back-btn {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 15px;
            color: var(--text-primary);
            text-decoration: none;
            font-size: 0.9rem;
            margin-bottom: 20px;
            border-radius: var(--radius);
        }
        .back-btn:hover { background: var(--bg-card); }

        .profile-card {
            display: flex; align-items: center; gap: 15px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .avatar {
            width: 60px; height: 60px;
            background: linear-gradient(135deg, #0078d4, #00bcf2);
            border-radius: 50%;
            display: grid; place-items: center;
            font-size: 1.5rem; font-weight: 600;
        }
        .user-info h3 { margin: 0; font-size: 1.1rem; font-weight: 600; }
        .user-info p { margin: 2px 0 0; color: var(--text-secondary); font-size: 0.85rem; }

        .search-box {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 4px;
            padding: 8px 12px;
            display: flex; align-items: center; gap: 10px;
            margin-bottom: 20px;
            color: var(--text-secondary);
        }
        .search-box input {
            background: transparent; border: none; outline: none;
            color: white; width: 100%;
        }

        .nav-item {
            display: flex; align-items: center; gap: 15px;
            padding: 12px 15px;
            border-radius: 4px;
            cursor: pointer;
            color: var(--text-primary);
            transition: 0.2s;
            position: relative;
        }
        .nav-item:hover { background: var(--bg-card); }
        .nav-item.active { background: var(--bg-card-hover); }
        .nav-item.active::before {
            content: ''; position: absolute; left: 0; top: 12px; bottom: 12px;
            width: 3px; background: var(--accent); border-radius: 2px;
        }
        .nav-icon { width: 20px; text-align: center; color: var(--text-secondary); }

        /* --- Main Content --- */
        .content {
            flex: 1;
            padding: 40px 60px;
            overflow-y: auto;
        }

        .page-header { margin-bottom: 30px; }
        .page-title { font-size: 2rem; font-weight: 600; margin: 0; }
        .breadcrumb { color: var(--text-secondary); font-size: 0.9rem; margin-top: 5px; }

        /* Settings Card Styling */
        .setting-group { margin-bottom: 30px; display: none; animation: fadeIn 0.3s ease; }
        .setting-group.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .group-title { margin-bottom: 15px; font-weight: 600; font-size: 1.1rem; }

        .card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 0;
            margin-bottom: 10px;
            overflow: hidden;
        }

        .card-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 20px;
            border-bottom: 1px solid var(--border);
        }
        .card-row:last-child { border-bottom: none; }

        .row-info { display: flex; align-items: center; gap: 15px; }
        .row-icon { font-size: 1.2rem; color: var(--text-secondary); }
        .row-text h4 { margin: 0; font-weight: 400; font-size: 1rem; }
        .row-text p { margin: 4px 0 0; color: var(--text-secondary); font-size: 0.85rem; }

        /* Controls */
        .select-box {
            background: #333; color: white; border: 1px solid var(--border);
            padding: 6px 12px; border-radius: 4px; outline: none; min-width: 120px;
        }

        /* Color Picker Grid */
        .color-grid { display: flex; gap: 10px; }
        .color-dot {
            width: 32px; height: 32px; border-radius: 50%; cursor: pointer;
            border: 2px solid transparent; transition: 0.2s;
        }
        .color-dot:hover { transform: scale(1.1); }
        .color-dot.selected { border-color: white; }

        /* Custom Radio Block (for Backgrounds) */
        .radio-grid { display: flex; gap: 10px; }
        .radio-card {
            width: 80px; height: 60px; border-radius: 6px;
            border: 2px solid var(--border); cursor: pointer;
            background-size: cover; position: relative;
        }
        .radio-card.selected { border-color: var(--accent); }

        /* Toggle Switch */
        .switch { position: relative; display: inline-block; width: 44px; height: 22px; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider {
            position: absolute; cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: #333; transition: .4s; border-radius: 22px; border: 1px solid #888;
        }
        .slider:before {
            position: absolute; content: "";
            height: 14px; width: 14px; left: 3px; bottom: 3px;
            background-color: white; transition: .4s; border-radius: 50%;
        }
        input:checked + .slider { background-color: var(--accent); border-color: var(--accent); }
        input:checked + .slider:before { transform: translateX(22px); }

        .btn-logout {
            background: #d13438; color: white; border: none;
            padding: 8px 20px; border-radius: 4px; cursor: pointer; font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <a href="index.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Desktop</a>

        <div class="profile-card">
            <div class="avatar"><%= initial %></div>
            <div class="user-info">
                <h3><%= username %></h3>
                <p>Local Account</p>
            </div>
        </div>

        <div class="search-box">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Find a setting">
        </div>

        <div class="nav-item active" onclick="showTab('personalization', this)">
            <div class="nav-icon"><i class="fas fa-paint-brush"></i></div>
            <span>Personalization</span>
        </div>
        <div class="nav-item" onclick="showTab('system', this)">
            <div class="nav-icon"><i class="fas fa-laptop"></i></div>
            <span>System</span>
        </div>
        <div class="nav-item" onclick="showTab('accounts', this)">
            <div class="nav-icon"><i class="fas fa-user-circle"></i></div>
            <span>Accounts</span>
        </div>
    </div>

    <div class="content">

        <div id="personalization" class="setting-group active">
            <div class="page-header">
                <h1 class="page-title">Personalization</h1>
                <div class="breadcrumb">Settings > Personalization</div>
            </div>

            <div class="group-title">Background</div>
            <div class="card">
                <div class="card-row">
                    <div class="row-info">
                        <div class="row-icon"><i class="fas fa-image"></i></div>
                        <div class="row-text">
                            <h4>Choose your wallpaper</h4>
                            <p>Select a background for your desktop</p>
                        </div>
                    </div>
                    <div class="radio-grid">
                        <div class="radio-card" style="background: linear-gradient(to right, #3a1c71, #d76d77);" onclick="setBg('aurora', this)" data-val="aurora"></div>
                        <div class="radio-card" style="background: linear-gradient(to right, #243949, #517fa4);" onclick="setBg('ocean', this)" data-val="ocean"></div>
                        <div class="radio-card" style="background: #202020;" onclick="setBg('default', this)" data-val="default"></div>
                    </div>
                </div>
            </div>

            <div class="group-title">Colors</div>
            <div class="card">
                <div class="card-row">
                    <div class="row-info">
                        <div class="row-icon"><i class="fas fa-palette"></i></div>
                        <div class="row-text">
                            <h4>Accent Color</h4>
                            <p>Choose a color to appear in windows and surfaces</p>
                        </div>
                    </div>
                    <div class="color-grid">
                        <div class="color-dot" style="background:#0078d4;" onclick="setAccent('#0078d4', this)"></div>
                        <div class="color-dot" style="background:#1abc9c;" onclick="setAccent('#1abc9c', this)"></div>
                        <div class="color-dot" style="background:#d13438;" onclick="setAccent('#d13438', this)"></div>
                        <div class="color-dot" style="background:#8e44ad;" onclick="setAccent('#8e44ad', this)"></div>
                    </div>
                </div>

                <div class="card-row">
                    <div class="row-info">
                        <div class="row-icon"><i class="fas fa-adjust"></i></div>
                        <div class="row-text">
                            <h4>App Mode</h4>
                            <p>Choose your default app mode</p>
                        </div>
                    </div>
                    <select class="select-box" id="themeSelect" onchange="setTheme(this.value)">
                        <option value="dark">Dark</option>
                        <option value="light">Light</option>
                    </select>
                </div>
            </div>
        </div>

        <div id="system" class="setting-group">
            <div class="page-header">
                <h1 class="page-title">System</h1>
                <div class="breadcrumb">Settings > System</div>
            </div>

            <div class="group-title">Display</div>
            <div class="card">
                <div class="card-row">
                    <div class="row-info">
                        <div class="row-icon"><i class="fas fa-font"></i></div>
                        <div class="row-text">
                            <h4>Scale and layout</h4>
                            <p>Change the size of text, apps, and other items</p>
                        </div>
                    </div>
                    <select class="select-box" id="scaleSelect" onchange="store.set('webos.fontSize', this.value)">
                        <option value="14px">100%</option>
                        <option value="16px">125% (Recommended)</option>
                        <option value="18px">150%</option>
                    </select>
                </div>

                <div class="card-row">
                    <div class="row-info">
                        <div class="row-icon"><i class="fas fa-th-large"></i></div>
                        <div class="row-text">
                            <h4>Density</h4>
                            <p>Adjust spacing between elements</p>
                        </div>
                    </div>
                    <select class="select-box" id="densitySelect" onchange="store.set('webos.density', this.value)">
                        <option value="compact">Compact</option>
                        <option value="cozy">Cozy</option>
                    </select>
                </div>
            </div>

            <div class="group-title">About</div>
            <div class="card">
                <div class="card-row">
                    <div class="row-info">
                        <div class="row-icon"><i class="fab fa-windows"></i></div>
                        <div class="row-text">
                            <h4>WebOS Specification</h4>
                            <p>Version 2.0 (Build 2025)</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="accounts" class="setting-group">
            <div class="page-header">
                <h1 class="page-title">Accounts</h1>
                <div class="breadcrumb">Settings > Accounts</div>
            </div>

            <div class="card">
                <div class="card-row">
                    <div class="row-info">
                        <div class="avatar" style="width:50px; height:50px; font-size:1.2rem;"><%= initial %></div>
                        <div class="row-text">
                            <h4><%= username %></h4>
                            <p>Administrator</p>
                        </div>
                    </div>
                    <button class="btn-logout" onclick="window.location.href='logout'">Sign out</button>
                </div>
            </div>
        </div>

    </div>

    <script>
        // Storage Helper
        const store = {
            get(k, d) { return localStorage.getItem(k) || d; },
            set(k, v) { localStorage.setItem(k, v); }
        };

        // 1. Navigation Logic
        function showTab(tabId, el) {
            document.querySelectorAll('.setting-group').forEach(d => d.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(d => d.classList.remove('active'));

            document.getElementById(tabId).classList.add('active');
            el.classList.add('active');
        }

        // 2. Logic: Background
        function setBg(val, el) {
            store.set('webos.background', val);
            document.querySelectorAll('.radio-card').forEach(d => d.classList.remove('selected'));
            el.classList.add('selected');
        }

        // 3. Logic: Accent Color
        function setAccent(color, el) {
            store.set('webos.accent', color);
            document.documentElement.style.setProperty('--accent', color);
            document.querySelectorAll('.color-dot').forEach(d => d.classList.remove('selected'));
            el.classList.add('selected');
        }

        // 4. Logic: Theme
        function setTheme(val) {
            store.set('webos.theme', val);
            // Just saving for index.jsp. In this settings page, we keep dark mode for the "Windows Settings" look.
        }

        // 5. Initialize State
        (function init() {
            // Restore Accent
            const accent = store.get('webos.accent', '#0078d4');
            document.documentElement.style.setProperty('--accent', accent);

            // Restore Font/Theme dropdowns
            document.getElementById('themeSelect').value = store.get('webos.theme', 'dark');
            document.getElementById('scaleSelect').value = store.get('webos.fontSize', '16px');
            document.getElementById('densitySelect').value = store.get('webos.density', 'cozy');

            // Visual checkmarks (Simplified for demo)
            const bg = store.get('webos.background', 'aurora');
            const activeBg = document.querySelector(`.radio-card[data-val="${bg}"]`);
            if(activeBg) activeBg.classList.add('selected');
        })();
    </script>
</body>
</html>