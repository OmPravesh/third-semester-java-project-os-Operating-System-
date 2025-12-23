<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.model.User" %>
<%@ page import="com.project.model.ChatRoom" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    List<ChatRoom> rooms = (List<ChatRoom>) request.getAttribute("rooms");
    if (rooms == null) rooms = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .chat-container {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 20px;
            height: calc(100vh - 100px);
            padding: 20px;
        }
        .chat-sidebar {
            background: #f5f5f5;
            border-radius: 10px;
            padding: 15px;
            overflow-y: auto;
        }
        .chat-sidebar h3 {
            margin-top: 0;
            margin-bottom: 15px;
        }
        .chat-room-item {
            padding: 10px;
            margin-bottom: 10px;
            background: white;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .chat-room-item:hover {
            background: #e8e8e8;
        }
        .chat-main {
            background: white;
            border-radius: 10px;
            padding: 20px;
            display: flex;
            flex-direction: column;
        }
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        .message {
            margin-bottom: 10px;
            padding: 10px;
            background: #f0f0f0;
            border-radius: 5px;
        }
        .message.own {
            background: #667eea;
            color: white;
            text-align: right;
        }
        .message-sender {
            font-weight: bold;
            font-size: 12px;
            margin-bottom: 5px;
        }
        .chat-input-area {
            display: flex;
            gap: 10px;
        }
        .chat-input-area input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .chat-input-area button {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-new-room {
            width: 100%;
            padding: 10px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 15px;
        }
        @media (max-width: 768px) {
            .chat-container {
                grid-template-columns: 1fr;
            }
            .chat-sidebar {
                max-height: 200px;
            }
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="navbar-container">
        <a href="dashboard" class="navbar-logo">Chat System</a>
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

<div class="chat-container">
    <div class="chat-sidebar">
        <h3>Chat Rooms</h3>
        <button class="btn-new-room" onclick="showCreateRoomModal()">Create Room</button>
        
        <% if (rooms.isEmpty()) { %>
            <p style="color: #999; text-align: center;">No rooms available. Create one!</p>
        <% } else { %>
            <% for (ChatRoom room : rooms) { %>
                <div class="chat-room-item" onclick="window.location.href='chat?action=room&roomId=<%= room.getRoomId() %>'">
                    <strong><%= room.getRoomName() %></strong>
                    <p style="font-size: 12px; color: #666; margin: 5px 0 0 0;">Created by: <%= room.getCreatedBy() %></p>
                </div>
            <% } %>
        <% } %>
    </div>

    <div class="chat-main">
        <h2>Welcome to Chat System</h2>
        <p>Select a chat room from the list or create a new one to get started!</p>
    </div>
</div>

<script>
function showCreateRoomModal() {
    const roomName = prompt('Enter chat room name:');
    if (roomName && roomName.trim()) {
        const description = prompt('Enter room description (optional):');
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'chat';
        form.innerHTML = '<input type="hidden" name="action" value="createRoom">' +
                         '<input type="hidden" name="roomName" value="' + roomName + '">' +
                         '<input type="hidden" name="description" value="' + (description || '') + '">';
        document.body.appendChild(form);
        form.submit();
    }
}
</script>
</body>
</html>
