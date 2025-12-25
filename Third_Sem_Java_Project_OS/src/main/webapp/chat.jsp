<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security check
    String username = (String) session.getAttribute("name");
    if (username == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebOS Chat | WhatsApp Style</title>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            /* WhatsApp Dark Theme Palette */
            --bg-app: #0b141a;       /* Main app background */
            --bg-panel: #111b21;     /* Sidebar/Chat list background */
            --bg-header: #202c33;    /* Headers */
            --border-color: #2f3b43; /* Dividers */
            --incoming-bubble: #202c33;
            --outgoing-bubble: #005c4b;
            --primary-green: #00a884;
            --text-primary: #e9edef;
            --text-secondary: #8696a0;
            --compose-bg: #202c33;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0; padding: 0;
            font-family: 'Segoe UI', 'Helvetica Neue', sans-serif;
            background-color: var(--bg-app);
            color: var(--text-primary);
            height: 100vh;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Desktop Container Limit */
        .app-container {
            display: flex;
            width: 100%;
            height: 100%;
            max-width: 1600px;
            background: var(--bg-panel);
            box-shadow: 0 0 20px rgba(0,0,0,0.5);
            overflow: hidden;
        }

        /* --- Left Sidebar (Contact List) --- */
        .sidebar {
            width: 30%;
            min-width: 300px;
            max-width: 450px;
            display: flex;
            flex-direction: column;
            border-right: 1px solid var(--border-color);
            background: var(--bg-panel);
        }

        .header {
            height: 60px;
            background: var(--bg-header);
            padding: 10px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .user-avatar {
            width: 40px; height: 40px;
            border-radius: 50%;
            background: #6a7f8a; /* Default grey avatar */
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; color: #fff;
            overflow: hidden;
        }

        .header-icons {
            display: flex; gap: 20px;
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        .header-icons i { cursor: pointer; transition: 0.2s; }
        .header-icons i:hover { color: var(--text-primary); }

        .search-bar {
            padding: 8px 12px;
            border-bottom: 1px solid var(--border-color);
            background: var(--bg-panel);
        }

        .search-input-wrapper {
            background: var(--bg-header);
            border-radius: 8px;
            display: flex; align-items: center;
            padding: 6px 12px;
        }

        .search-input-wrapper input {
            background: transparent; border: none; outline: none;
            color: var(--text-primary); width: 100%; margin-left: 10px;
        }

        .contact-list {
            flex: 1;
            overflow-y: auto;
        }

        .contact-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            cursor: pointer;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            transition: background 0.2s;
        }

        .contact-item:hover { background: var(--bg-header); }
        .contact-item.active { background: var(--bg-header); }

        .contact-info {
            margin-left: 15px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .contact-top { display: flex; justify-content: space-between; margin-bottom: 3px; }
        .contact-name { font-size: 1rem; font-weight: 500; color: var(--text-primary); }
        .contact-time { font-size: 0.75rem; color: var(--text-secondary); }
        .contact-preview { font-size: 0.85rem; color: var(--text-secondary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 200px;}

        /* --- Right Side (Chat Area) --- */
        .chat-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            background-color: var(--bg-app);
            /* WhatsApp Background Pattern Effect */
            background-image: linear-gradient(rgba(11, 20, 26, 0.95), rgba(11, 20, 26, 0.95)), url("https://user-images.githubusercontent.com/15075759/28719144-86dc0f70-73b1-11e7-911d-60d70fcded21.png");
            background-repeat: repeat;
            position: relative;
        }

        /* Default Welcome Screen */
        .welcome-screen {
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            height: 100%; text-align: center;
            color: var(--text-secondary);
            border-bottom: 6px solid var(--primary-green);
        }
        .welcome-screen h1 { color: var(--text-primary); margin-top: 20px; font-weight: 300; }

        .chat-content { display: none; flex-direction: column; height: 100%; }
        .chat-content.active { display: flex; }

        .messages-list {
            flex: 1;
            overflow-y: auto;
            padding: 20px 40px;
            display: flex;
            flex-direction: column;
        }

        .message-bubble {
            max-width: 65%;
            padding: 6px 10px 8px 12px;
            border-radius: 8px;
            font-size: 0.9rem;
            line-height: 1.3;
            position: relative;
            margin-bottom: 8px;
            box-shadow: 0 1px 0.5px rgba(0,0,0,0.13);
            word-wrap: break-word;
        }

        .message-bubble.incoming {
            background: var(--incoming-bubble);
            align-self: flex-start;
            border-top-left-radius: 0;
        }

        .message-bubble.outgoing {
            background: var(--outgoing-bubble);
            align-self: flex-end;
            border-top-right-radius: 0;
        }

        .msg-meta {
            float: right;
            margin-left: 10px;
            margin-top: 4px;
            font-size: 0.65rem;
            color: rgba(255,255,255,0.6);
            display: flex; align-items: center; gap: 4px;
        }

        .chat-footer {
            min-height: 62px;
            background: var(--bg-header);
            padding: 10px 16px;
            display: flex;
            align-items: center;
            gap: 15px;
            z-index: 2;
        }

        .chat-input {
            flex: 1;
            background: #2a3942;
            border-radius: 8px;
            padding: 12px;
            color: var(--text-primary);
            border: none; outline: none;
            font-size: 0.95rem;
        }

        .icon-btn {
            color: var(--text-secondary);
            font-size: 1.3rem;
            background: none; border: none; cursor: pointer;
        }
        .icon-btn:hover { color: var(--text-primary); }

        /* Scrollbar Styling */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }
    </style>
</head>
<body>

    <div class="app-container">

        <div class="sidebar">
            <div class="header">
                <div class="user-avatar" title="My Profile">
                   <%= username.substring(0, 1).toUpperCase() %>
                </div>
                <div class="header-icons">
                    <i class="fas fa-circle-notch" title="Status"></i>
                    <i class="fas fa-comment-alt" title="New Chat"></i>
                    <a href="index.jsp" style="color: inherit; text-decoration: none;"><i class="fas fa-sign-out-alt" title="Back to Desktop"></i></a>
                </div>
            </div>

            <div class="search-bar">
                <div class="search-input-wrapper">
                    <i class="fas fa-search" style="color: var(--text-secondary)"></i>
                    <input type="text" placeholder="Search or start new chat">
                </div>
            </div>

            <div class="contact-list" id="contactList">
                </div>
        </div>

        <div class="chat-area">

            <div class="welcome-screen" id="welcomeScreen">
                <div style="font-size: 4rem; margin-bottom: 20px; color: #354650;"><i class="fab fa-whatsapp"></i></div>
                <h1>WebOS Chat</h1>
                <p>Send and receive messages to users in the database.</p>
                <div style="margin-top: 20px; font-size: 0.8rem; color: #354650;"><i class="fas fa-lock"></i> End-to-end encrypted</div>
            </div>

            <div class="chat-content" id="chatContent">

                <div class="header">
                    <div style="display:flex; align-items:center; gap:15px;">
                        <div class="user-avatar" id="currentAvatar"></div>
                        <div>
                            <div class="contact-name" id="currentName">User Name</div>
                            <div class="contact-time" id="currentStatus">online</div>
                        </div>
                    </div>
                    <div class="header-icons">
                        <i class="fas fa-search"></i>
                        <i class="fas fa-ellipsis-v"></i>
                    </div>
                </div>

                <div class="messages-list" id="msgList">
                    </div>

                <div class="chat-footer">
                    <button class="icon-btn"><i class="far fa-smile"></i></button>
                    <button class="icon-btn"><i class="fas fa-paperclip"></i></button>
                    <input type="text" class="chat-input" id="messageInput" placeholder="Type a message" autocomplete="off">
                    <button class="icon-btn" id="sendBtn"><i class="fas fa-paper-plane"></i></button>
                </div>

            </div>
        </div>

    </div>

    <script>
        const myName = "<%= username %>";

        // DOM Elements
        const contactListEl = document.getElementById('contactList');
        const welcomeScreen = document.getElementById('welcomeScreen');
        const chatContent = document.getElementById('chatContent');
        const msgList = document.getElementById('msgList');
        const currentNameEl = document.getElementById('currentName');
        const currentAvatarEl = document.getElementById('currentAvatar');
        const messageInput = document.getElementById('messageInput');
        const sendBtn = document.getElementById('sendBtn');

        let activeChatUser = null;
        let lastMsgCount = 0;

        // --- 1. MOCK USERS (Replace this with a fetch to your database) ---
        // Since we don't have a backend endpoint for 'users' yet, I'm simulating it.
        // In production, you should fetch this from: 'chat?action=getUsers'
        const mockUsers = [
            { id: 'public', name: 'Public Chat', lastMsg: 'Join the community discussion', time: '12:00' },
            { id: 'admin', name: 'Admin', lastMsg: 'System updates pending...', time: '10:30' },
            { id: 'john', name: 'John Doe', lastMsg: 'Hey, are you there?', time: 'Yesterday' },
            { id: 'sarah', name: 'Sarah Smith', lastMsg: 'See you tomorrow!', time: 'Monday' }
        ];

        // --- 2. RENDER USERS ---
        function renderContacts() {
            contactListEl.innerHTML = '';
            mockUsers.forEach(user => {
                const div = document.createElement('div');
                div.className = 'contact-item' + (activeChatUser === user.id ? ' active' : '');
                div.onclick = () => openChat(user);

                // FIXED: Using string concatenation instead of template literals
                div.innerHTML = [
                    '<div class="user-avatar">' + user.name.charAt(0) + '</div>',
                    '<div class="contact-info">',
                    '<div class="contact-top">',
                    '<span class="contact-name">' + user.name + '</span>',
                    '<span class="contact-time">' + user.time + '</span>',
                    '</div>',
                    '<div class="contact-preview">' + user.lastMsg + '</div>',
                    '</div>'
                ].join('');
                contactListEl.appendChild(div);
            });
        }

        // --- 3. SWITCH CHAT ---
        function openChat(user) {
            activeChatUser = user.id;

            // UI Updates
            welcomeScreen.style.display = 'none';
            chatContent.classList.add('active');

            currentNameEl.innerText = user.name;
            currentAvatarEl.innerText = user.name.charAt(0);

            renderContacts(); // Re-render to highlight active

            // Clear current messages and fetch new ones
            msgList.innerHTML = '';
            lastMsgCount = 0;
            fetchMessages();
        }

        // --- 4. FETCH MESSAGES ---
        async function fetchMessages() {
            if (!activeChatUser) return;

            // In real app, pass the user ID: fetch('chat?json=1&withUser=' + activeChatUser)
            // For now, we fetch the global list as per previous code
            try {
                const res = await fetch('chat?json=1', {
                    headers: {'Accept':'application/json'}
                });
                const data = await res.json();
                renderMessages(data);
            } catch(e) { console.log("Polling error", e); }
        }

        function formatTime(ts) {
            if(!ts) return '';
            const d = new Date(Number(ts));
            return d.getHours().toString().padStart(2,'0') + ':' + d.getMinutes().toString().padStart(2,'0');
        }

        function renderMessages(items) {
            if (!Array.isArray(items)) return;
            if (items.length === lastMsgCount) return; // No new messages

            msgList.innerHTML = ''; // Simplistic re-render (better to append in production)

            items.forEach(it => {
                const mine = it.username === myName;
                const div = document.createElement('div');
                // FIXED: Using string concatenation
                div.className = 'message-bubble ' + (mine ? 'outgoing' : 'incoming');

                // Double check icon logic
                const checkIcon = mine ? '<i class="fas fa-check-double" style="color: #53bdeb;"></i>' : '';

                // FIXED: Using string concatenation instead of template literals
                div.innerHTML = [
                    it.message,
                    '<div class="msg-meta">',
                    formatTime(it.timestamp),
                    checkIcon,
                    '</div>'
                ].join('');
                msgList.appendChild(div);
            });

            msgList.scrollTop = msgList.scrollHeight;
            lastMsgCount = items.length;
        }

        // --- 5. SEND MESSAGE ---
        async function sendMessage() {
            const text = messageInput.value.trim();
            if (!text || !activeChatUser) return;

            messageInput.value = ''; // Clear input

            // IMPORTANT: Sending 'recipient' to backend so it knows who the private msg is for
            await fetch('chat', {
                method: 'POST',
                headers: {
                    'Content-Type':'application/x-www-form-urlencoded',
                    'X-Requested-With':'XMLHttpRequest'
                },
                body: 'message=' + encodeURIComponent(text) + '&recipient=' + encodeURIComponent(activeChatUser)
            });

            fetchMessages(); // Refresh immediately
        }

        // Listeners
        sendBtn.addEventListener('click', sendMessage);
        messageInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                sendMessage();
            }
        });

        // Initialize
        renderContacts();
        setInterval(fetchMessages, 2000); // Poll every 2 seconds

    </script>
</body>
</html>