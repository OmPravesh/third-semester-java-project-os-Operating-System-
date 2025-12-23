<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.model.User, com.project.model.ChatRoom, com.project.model.Message" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    ChatRoom room = (ChatRoom) request.getAttribute("room");
    List<Message> messages = (List<Message>) request.getAttribute("messages");
    if (messages == null) messages = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat - <%= room.getRoomName() %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .chat-container {
            display: flex;
            flex-direction: column;
            height: calc(100vh - 100px);
            padding: 20px;
        }
        .chat-header {
            background: #667eea;
            color: white;
            padding: 15px;
            border-radius: 10px 10px 0 0;
            margin-bottom: -1px;
        }
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            background: #f9f9f9;
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 0;
        }
        .message {
            margin-bottom: 15px;
            padding: 10px 15px;
            background: white;
            border-radius: 5px;
            border-left: 4px solid #ddd;
        }
        .message.own {
            background: #e3f2fd;
            border-left-color: #667eea;
            margin-left: 40px;
        }
        .message-sender {
            font-weight: bold;
            font-size: 12px;
            color: #667eea;
            margin-bottom: 5px;
        }
        .message-content {
            word-wrap: break-word;
        }
        .message-time {
            font-size: 11px;
            color: #999;
            margin-top: 5px;
        }
        .chat-input-area {
            background: white;
            border: 1px solid #ddd;
            border-top: none;
            padding: 15px;
            border-radius: 0 0 10px 10px;
            display: flex;
            gap: 10px;
        }
        .chat-input-area input {
            flex: 1;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .chat-input-area button {
            padding: 12px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s;
        }
        .chat-input-area button:hover {
            background: #764ba2;
        }
        .back-btn {
            display: inline-block;
            margin-bottom: 10px;
            padding: 8px 15px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
        }
        .back-btn:hover {
            background: #764ba2;
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="navbar-container">
        <a href="dashboard" class="navbar-logo">Chat</a>
        <ul class="nav-menu">
            <li><a href="dashboard">Dashboard</a></li>
            <li><a href="games">Games</a></li>
            <li><a href="chat" class="active">Chat</a></li>
            <li><a href="digital-payment">Payments</a></li>
            <li><a href="stock">Stock Market</a></li>
            <li><a href="login" onclick="event.preventDefault(); fetch('login', {method: 'DELETE'}).then(() => window.location.href='login')">Logout</a></li>
        </ul>
    </div>
</div>

<div style="padding: 20px;">
    <a href="chat" class="back-btn">← Back to Chat Rooms</a>
    
    <div class="chat-container">
        <div class="chat-header">
            <h2 style="margin: 0;"><%= room.getRoomName() %></h2>
            <p style="margin: 5px 0 0 0; font-size: 14px;"><%= room.getDescription() %></p>
        </div>

        <div class="chat-messages" id="messagesContainer">
            <% if (messages.isEmpty()) { %>
                <p style="text-align: center; color: #999;">No messages yet. Start the conversation!</p>
            <% } else { %>
                <% for (Message msg : messages) { %>
                    <div class="message <%= msg.getSenderUsername().equals(user.getUsername()) ? "own" : "" %>">
                        <div class="message-sender"><%= msg.getSenderUsername() %></div>
                        <div class="message-content"><%= msg.getMessageContent() %></div>
                        <div class="message-time"><%= msg.getSentAt() %></div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <form method="POST" action="chat" class="chat-input-area" id="messageForm">
            <input type="hidden" name="action" value="sendMessage">
            <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">
            <input type="text" name="messageContent" id="messageInput" placeholder="Type your message..." required autofocus>
            <button type="submit">Send</button>
        </form>
    </div>
</div>

<script>
    // Auto-scroll to bottom
    const container = document.getElementById('messagesContainer');
    container.scrollTop = container.scrollHeight;
    
    // Auto-refresh messages every 2 seconds
    setInterval(() => {
        location.reload();
    }, 3000);
</script>
</body>
</html>
