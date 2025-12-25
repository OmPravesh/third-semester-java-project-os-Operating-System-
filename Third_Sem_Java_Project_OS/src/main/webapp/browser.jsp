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
    <title>WebOS Browser</title>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0; padding: 0;
            font-family: 'Inter', sans-serif;
            background: #202124;
            height: 100vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* --- Browser Toolbar --- */
        .toolbar {
            background: #35363a;
            padding: 8px 15px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid #000;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .controls {
            display: flex; gap: 8px;
        }
        .circle {
            width: 12px; height: 12px; border-radius: 50%;
        }
        .c-red { background: #ff5f56; cursor: pointer; }
        .c-yellow { background: #ffbd2e; }
        .c-green { background: #27c93f; }

        .nav-btns {
            display: flex; gap: 15px; color: #9aa0a6; font-size: 1rem;
        }
        .nav-btns i { cursor: pointer; transition: 0.2s; }
        .nav-btns i:hover { color: #fff; }

        /* --- Address Bar --- */
        .address-bar {
            flex: 1;
            background: #202124;
            border-radius: 20px;
            padding: 6px 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            border: 1px solid #5f6368;
        }

        .address-bar input {
            background: transparent;
            border: none; outline: none;
            color: #fff;
            width: 100%;
            font-size: 0.9rem;
        }

        /* --- Content Area --- */
        .viewport {
            flex: 1;
            background: white;
            position: relative;
        }

        iframe {
            width: 100%;
            height: 100%;
            border: none;
            display: block;
        }

        /* Loading Overlay */
        .loader {
            position: absolute; top:0; left:0; width:100%; height:100%;
            background: #202124;
            display: none;
            place-items: center;
            color: white;
            z-index: 10;
        }
    </style>
</head>
<body>

    <div class="toolbar">
        <div class="controls">
            <div class="circle c-red" onclick="window.location.href='index.jsp'" title="Close"></div>
            <div class="circle c-yellow"></div>
            <div class="circle c-green"></div>
        </div>

        <div class="nav-btns">
            <i class="fas fa-arrow-left" onclick="goBack()"></i>
            <i class="fas fa-arrow-right" onclick="goForward()"></i>
            <i class="fas fa-rotate-right" onclick="reload()"></i>
        </div>

        <div class="address-bar">
            <i class="fas fa-lock" style="color:#27c93f; font-size:0.8rem;"></i>
            <input type="text" id="urlInput" placeholder="Search Google or type a URL" autocomplete="off" value="https://www.wikipedia.org">
        </div>

        <div class="nav-btns">
             <i class="fas fa-bars"></i>
        </div>
    </div>

    <div class="viewport">
        <div class="loader" id="loader"><i class="fas fa-circle-notch fa-spin fa-2x"></i></div>
        <iframe id="browserFrame" src="https://www.wikipedia.org" sandbox="allow-same-origin allow-scripts allow-forms allow-popups"></iframe>
    </div>

    <script>
        const frame = document.getElementById('browserFrame');
        const input = document.getElementById('urlInput');
        const loader = document.getElementById('loader');

        // Handle Enter Key
        input.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                navigate(input.value);
            }
        });

        function navigate(query) {
            loader.style.display = "grid";
            let url = query.trim();

            // Simple logic: If it has no spaces and contains a dot, treat as URL. Otherwise Google Search.
            if (url.indexOf(' ') === -1 && url.indexOf('.') !== -1) {
                if (!url.startsWith('http')) {
                    url = 'https://' + url;
                }
            } else {
                // Google Search (using igu=1 to allow iframe embedding)
                url = 'https://www.google.com/search?igu=1&q=' + encodeURIComponent(query);
            }

            frame.src = url;
            input.value = url;

            // Hide loader after a short delay (simulated)
            setTimeout(() => { loader.style.display = "none"; }, 1500);
        }

        // Navigation Controls
        function goBack() { history.back(); } // This controls the main window, iframes can't be controlled easily this way due to security
        function goForward() { history.forward(); }
        function reload() { frame.src = frame.src; }
    </script>
</body>
</html>